#!/bin/bash
# gitlab_complete_backup.sh
#
# 使用方法: 
#   sudo ./gitlab_complete_backup.sh [备份路径]
# 示例:
#   sudo ./gitlab_complete_backup.sh /backup/gitlab
#   sudo ./gitlab_complete_backup.sh /mnt/nas/gitlab_backups

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN:${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

# 显示使用说明
show_usage() {
    echo "GitLab 完整数据备份脚本"
    echo "使用方法: $0 [备份基础路径]"
    echo "示例: $0 /backup/gitlab"
    echo "       $0 /mnt/nas/gitlab_backups"
    echo ""
    echo "如果不指定路径，默认使用: /backup/gitlab"
}

# 参数处理
BACKUP_BASE="${1:-/backup/gitlab}"
BACKUP_NAME="gitlab_complete_$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$BACKUP_NAME"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# 注意：LOG_FILE 必须在创建 $BACKUP_DIR 之前定义，以便日志函数可以正常使用
LOG_FILE="/tmp/gitlab_backup_$$.log" # 临时日志文件，稍后会移动到 $BACKUP_DIR

# 验证参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# 初始化备份环境
initialize_backup() {
    log "初始化备份环境..."
    
    # 检查备份路径父目录是否存在且有写权限
    # dirname "$BACKUP_BASE" 可能是 / 或 /backup
    if [ ! -w "$BACKUP_BASE" ] && [ ! -w "$(dirname "$BACKUP_BASE")" ]; then
        error "备份路径没有写权限或父目录不存在。请手动创建或检查权限: $BACKUP_BASE"
    fi
    
    # 创建备份目录
    sudo mkdir -p "$BACKUP_DIR" || error "无法创建备份目录: $BACKUP_DIR"
    
    # 移动临时日志文件到最终目录
    sudo mv "$LOG_FILE" "$BACKUP_DIR/"
    LOG_FILE="$BACKUP_DIR/$(basename $LOG_FILE)"
    
    log "备份目录: $BACKUP_DIR"
    log "日志文件: $LOG_FILE"
}

# 检查系统资源
check_system_resources() {
    log "检查系统资源..."
    
    # 检查磁盘空间 (10GB)
    available_space=$(df "$BACKUP_BASE" | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 10485760 ]; then  
        warn "可用磁盘空间不足 (当前: $((available_space / 1024))MB)"
        read -p "是否继续? (y/N): " continue_backup
        if [[ ! $continue_backup =~ ^[Yy]$ ]]; then
            error "用户取消备份"
        fi
    fi
    
    # 检查内存使用
    memory_usage=$(free | awk 'NR==2{printf "%.1f", $3/$2 * 100}')
    if (( $(echo "$memory_usage > 90" | bc -l) )); then
        warn "系统内存使用率较高: ${memory_usage}%"
    fi
}

# 备份 GitLab 应用数据 (BUG FIX)
backup_application_data() {
    log "开始备份 GitLab 应用数据..."
    
    local start_time=$(date +%s)
    local BACKUP_NAME_PREFIX="app_backup"

    # BUG FIX 1: 移除 SKIP=tar，让 gitlab-backup 完成压缩。
    # BUG FIX 2: 使用 GITLAB_BACKUP_DIR 环境变量确保备份文件输出到指定路径。
    # BACKUP 参数在这里是文件名的后缀。
    if sudo GITLAB_BACKUP_DIR="$BACKUP_DIR" gitlab-backup create BACKUP="$TIMESTAMP"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log "应用数据备份完成 (耗时: ${duration}秒)"
    else
        error "应用数据备份失败 (请检查 GitLab 服务是否运行和权限)"
    fi
    # 移动备份数据到目标文件夹
    sudo mv /home/backup/*gitlab_backup.tar "$BACKUP_DIR/"
    
    # BUG FIX 3: 验证备份文件，使用 find 模糊匹配来应对时间戳前缀
    if find "$BACKUP_DIR" -maxdepth 1 -name "*_${TIMESTAMP}_gitlab_backup.tar" -print -quit 2>/dev/null; then
        log "应用数据备份文件验证通过。"
    else
        error "应用数据备份文件未找到。请检查 GitLab 命名规则和 BACKUP_DIR 权限。"
    fi
}

# 备份配置文件
backup_configuration_files() {
    log "开始备份配置文件..."
    
    # 备份主配置文件
    sudo tar -czf "$BACKUP_DIR/config.tar.gz" -C / etc/gitlab/ 2>/dev/null || warn "配置文件备份可能不完整"
    
    # 备份 SSL 证书（如果存在）
    if [ -d "/etc/gitlab/ssl" ]; then
        sudo tar -czf "$BACKUP_DIR/ssl.tar.gz" -C / etc/gitlab/ssl/ 2>/dev/null && log "SSL 证书备份完成"
    fi
    
    # 备份 SSH 密钥
    if [ -d "/var/opt/gitlab/.ssh" ]; then
        sudo tar -czf "$BACKUP_DIR/ssh_keys.tar.gz" -C /var/opt/gitlab .ssh/ 2>/dev/null && log "SSH 密钥备份完成"
    fi
}

# 备份数据目录 (优化：合并目录列表)
backup_data_directories() {
    log "开始备份数据目录..."
    
    # 默认 Omnibus 目录
    local omnibus_dirs=(
        "gitlab-rails"
        "postgresql"
        "redis"
    )
    
    for dir in "${omnibus_dirs[@]}"; do
        local full_path="/var/opt/gitlab/$dir"
        if [ -d "$full_path" ]; then
            log "备份 Omnibus 数据目录: $dir"
            # -C /var/opt/gitlab 确保 tar 文件中路径是相对的
            sudo tar -czf "$BACKUP_DIR/data_omnibus_${dir}.tar.gz" -C /var/opt/gitlab "$dir/" 2>/dev/null || warn "目录 $dir 备份可能不完整"
        fi
    done
    
    # 自定义目录 (/home/data/gitlab/gitlab-data)
    local custom_base_path="/home/data/gitlab"
    local custom_dirs=(
        "gitlab-data" # 假设这是您的自定义数据目录名
    )
    
    for dir in "${custom_dirs[@]}"; do
        local full_path="$custom_base_path/$dir"
        if [ -d "$full_path" ]; then
            log "备份自定义数据目录: $dir"
            # -C /home/data/gitlab 确保 tar 文件中路径是相对的
            sudo tar -czf "$BACKUP_DIR/data_custom_${dir}.tar.gz" -C "$custom_base_path" "$dir/" 2>/dev/null || warn "目录 $dir 备份可能不完整"
        fi
    done
}

# 备份日志文件（可选）
backup_log_files() {
    log "开始备份日志文件..."
    
    if [ -d "/var/log/gitlab" ]; then
        sudo tar -czf "$BACKUP_DIR/logs.tar.gz" -C /var/log gitlab/ 2>/dev/null && log "日志文件备份完成"
    fi
}

# 创建备份元数据
create_backup_metadata() {
    log "创建备份元数据..."
    
    # GitLab 版本信息
    local GITLAB_ENV_INFO=$(sudo gitlab-rake gitlab:env:info 2>/dev/null)
    
    # 系统信息
    cat > "$BACKUP_DIR/backup_metadata.txt" << EOF
备份时间: $(date)
备份名称: $BACKUP_NAME
备份路径: $BACKUP_DIR

GitLab 信息:
${GITLAB_ENV_INFO}

系统信息:
操作系统: $(lsb_release -d 2>/dev/null | cut -f2 || uname -a)
内核版本: $(uname -r)
磁盘空间: $(df -h $BACKUP_BASE | awk 'NR==2{print $4 " 可用 / " $2 " 总量"}')

备份内容:
- 应用数据 (gitlab-backup)
- 配置文件 (/etc/gitlab)
- 数据目录 (/var/opt/gitlab)
- 自定义数据目录 (${custom_base_path})
- SSL 证书
- SSH 密钥
- 日志文件

恢复说明:
使用 gitlab_complete_restore.sh 脚本进行恢复:
sudo ./gitlab_complete_restore.sh $BACKUP_DIR
EOF

    # 设置文件权限
    sudo chmod 644 "$BACKUP_DIR"/*.txt
}

# 验证备份完整性 (BUG FIX)
verify_backup_integrity() {
    log "验证备份完整性..."
    
    local missing_files=0
    
    # BUG FIX 4: 检查应用数据备份文件 (模糊匹配)
    if ! find "$BACKUP_DIR" -maxdepth 1 -name "*_app_backup_gitlab_backup.tar" -print -quit 2>/dev/null; then
        error "关键备份文件缺失: 应用数据备份文件 (*_app_backup_gitlab_backup.tar)"
    fi
    
    # 检查配置文件
    if [ ! -f "$BACKUP_DIR/config.tar.gz" ]; then
        error "关键备份文件缺失: config.tar.gz"
    fi
    
    if [ $missing_files -eq 0 ]; then
        log "备份完整性验证通过"
    else
        warn "部分备份文件缺失，但备份继续"
    fi
    
    # 计算备份大小
    local backup_size=$(sudo du -sh "$BACKUP_DIR" | cut -f1)
    log "备份总大小: $backup_size"
}

# 清理旧备份（可选）
cleanup_old_backups() {
    local retention_days=7
    
    log "清理 $retention_days 天前的旧备份..."
    
    sudo find "$BACKUP_BASE" -name "gitlab_complete_*" -type d -mtime +$retention_days -exec rm -rf {} \; 2>/dev/null && \
    log "旧备份清理完成"
}

# 主备份流程
main() {
    # 在主函数开始时设置临时日志文件
    touch "$LOG_FILE" || error "无法创建临时日志文件"
    
    log "=== 开始 GitLab 完整数据备份 ==="
    log "备份目标: $BACKUP_DIR"
    
    # 执行备份步骤
    initialize_backup
    check_system_resources
    backup_application_data
    backup_configuration_files
    backup_data_directories
    backup_log_files
    create_backup_metadata
    verify_backup_integrity
    cleanup_old_backups
    
    log "=== GitLab 完整数据备份完成 ==="
    log "备份位置: $BACKUP_DIR"
    log "备份大小: $(sudo du -sh "$BACKUP_DIR" | cut -f1)"
    
    # 显示备份文件列表
    echo
    log "备份文件列表:"
    sudo ls -la "$BACKUP_DIR"
}

# 执行主函数
main
