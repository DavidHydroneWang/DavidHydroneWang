#!/bin/bash
# gitlab_complete_restore.sh
#
# 使用方法: 
#   sudo ./gitlab_complete_restore.sh [备份目录路径]
# 示例:
#   sudo ./gitlab_complete_restore.sh /backup/gitlab/gitlab_complete_20241210_120000
#   sudo ./gitlab_complete_restore.sh /mnt/nas/gitlab_backups/gitlab_complete_20241210_120000

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
    echo "GitLab 完整数据还原脚本"
    echo "使用方法: $0 [备份目录路径]"
    echo "示例: $0 /backup/gitlab/gitlab_complete_20241210_120000"
    echo "       $0 /mnt/nas/gitlab_backups/gitlab_complete_20241210_120000"
    echo ""
    echo "注意: 此脚本将停止 GitLab 服务并还原所有数据，请谨慎操作！"
}

# 参数处理
RESTORE_DIR="$1"
LOG_FILE="/tmp/gitlab_restore_$$.log"

# 验证参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -ne 1 ]; then
    show_usage
    exit 0
fi

# 验证备份目录
validate_restore_dir() {
    log "验证备份目录..."
    
    if [ ! -d "$RESTORE_DIR" ]; then
        error "备份目录不存在: $RESTORE_DIR"
    fi
    
    # 检查必要的备份文件
    local app_backup_file=$(find "$RESTORE_DIR" -maxdepth 1 -name "*_app_backup_gitlab_backup.tar" -print -quit 2>/dev/null)
    if [ -z "$app_backup_file" ]; then
        error "未找到应用数据备份文件 (*_app_backup_gitlab_backup.tar)"
    fi
    
    if [ ! -f "$RESTORE_DIR/config.tar.gz" ]; then
        error "未找到配置文件备份: config.tar.gz"
    fi
    
    log "备份目录验证通过: $RESTORE_DIR"
    
    # 显示备份信息
    if [ -f "$RESTORE_DIR/backup_metadata.txt" ]; then
        log "备份信息:"
        grep -E "备份时间:|备份名称:|GitLab" "$RESTORE_DIR/backup_metadata.txt" | head -10
    fi
}

# 检查系统兼容性
check_system_compatibility() {
    log "检查系统兼容性..."
    
    # 检查磁盘空间
    local available_space=$(df / | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 5242880 ]; then  # 5GB
        warn "系统磁盘空间不足 (当前: $((available_space / 1024))MB)"
        read -p "是否继续? (y/N): " continue_restore
        if [[ ! $continue_restore =~ ^[Yy]$ ]]; then
            error "用户取消还原"
        fi
    fi
    
    # 检查当前 GitLab 版本
    if command -v gitlab-rake > /dev/null; then
        local current_version=$(sudo gitlab-rake gitlab:env:info 2>/dev/null | grep -i "version:" | head -1)
        log "当前 GitLab 版本: $current_version"
    else
        warn "未检测到 GitLab 安装，将进行全新还原"
    fi
}

# 停止 GitLab 服务
stop_gitlab_services() {
    log "停止 GitLab 服务..."
    
    if systemctl is-active --quiet gitlab-runsvdir; then
        sudo gitlab-ctl stop
        log "GitLab 服务已停止"
    else
        warn "GitLab 服务未运行或未使用 systemd"
    fi
    
    # 确保相关服务停止
    sudo pkill -f sidekiq 2>/dev/null || true
    sudo pkill -f unicorn 2>/dev/null || true
}

# 还原应用数据
restore_application_data() {
    log "开始还原 GitLab 应用数据..."
    
    local start_time=$(date +%s)
    local app_backup_file=$(find "$RESTORE_DIR" -maxdepth 1 -name "*_app_backup_gitlab_backup.tar" -print -quit)
    
    if [ -n "$app_backup_file" ]; then
        log "找到应用数据备份文件: $(basename "$app_backup_file")"
        
        # 设置备份文件权限
        sudo chmod 600 "$app_backup_file"
        
        # 执行还原
        if sudo gitlab-backup restore BACKUP="$(basename "$app_backup_file" | sed 's/_gitlab_backup.tar//' | sed 's/.*_app_backup/app_backup/')" force=yes; then
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            log "应用数据还原完成 (耗时: ${duration}秒)"
        else
            error "应用数据还原失败"
        fi
    else
        error "未找到应用数据备份文件"
    fi
}

# 还原配置文件
restore_configuration_files() {
    log "开始还原配置文件..."
    
    # 备份当前配置（以防万一）
    local current_config_backup="/tmp/gitlab_config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    sudo tar -czf "$current_config_backup" -C / etc/gitlab/ 2>/dev/null && log "当前配置已备份到: $current_config_backup"
    
    # 还原配置文件
    if [ -f "$RESTORE_DIR/config.tar.gz" ]; then
        log "还原主配置文件..."
        sudo tar -xzf "$RESTORE_DIR/config.tar.gz" -C / && log "主配置文件还原完成"
    else
        warn "未找到主配置文件备份"
    fi
    
    # 还原 SSL 证书
    if [ -f "$RESTORE_DIR/ssl.tar.gz" ]; then
        log "还原 SSL 证书..."
        sudo tar -xzf "$RESTORE_DIR/ssl.tar.gz" -C / && log "SSL 证书还原完成"
    else
        warn "未找到 SSL 证书备份"
    fi
    
    # 还原 SSH 密钥
    if [ -f "$RESTORE_DIR/ssh_keys.tar.gz" ]; then
        log "还原 SSH 密钥..."
        sudo tar -xzf "$RESTORE_DIR/ssh_keys.tar.gz" -C / && log "SSH 密钥还原完成"
    else
        warn "未找到 SSH 密钥备份"
    fi
}

# 还原数据目录
restore_data_directories() {
    log "开始还原数据目录..."
    
    # 还原 Omnibus 数据目录
    for tar_file in "$RESTORE_DIR"/data_omnibus_*.tar.gz; do
        if [ -f "$tar_file" ]; then
            local dir_name=$(basename "$tar_file" | sed 's/data_omnibus_//' | sed 's/.tar.gz//')
            log "还原 Omnibus 数据目录: $dir_name"
            sudo tar -xzf "$tar_file" -C /var/opt/gitlab/ && log "目录 $dir_name 还原完成"
        fi
    done
    
    # 还原自定义数据目录
    for tar_file in "$RESTORE_DIR"/data_custom_*.tar.gz; do
        if [ -f "$tar_file" ]; then
            local dir_name=$(basename "$tar_file" | sed 's/data_custom_//' | sed 's/.tar.gz//')
            local custom_base_path="/home/data/gitlab"
            
            log "还原自定义数据目录: $dir_name"
            sudo mkdir -p "$custom_base_path"
            sudo tar -xzf "$tar_file" -C "$custom_base_path"/ && log "自定义目录 $dir_name 还原完成"
        fi
    done
}

# 还原日志文件（可选）
restore_log_files() {
    log "开始还原日志文件..."
    
    if [ -f "$RESTORE_DIR/logs.tar.gz" ]; then
        # 备份当前日志
        sudo mv /var/log/gitlab /var/log/gitlab.backup_$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
        
        # 还原日志文件
        sudo tar -xzf "$RESTORE_DIR/logs.tar.gz" -C /var/log/ && log "日志文件还原完成"
    else
        warn "未找到日志文件备份，跳过还原"
    fi
}

# 设置文件权限
set_permissions() {
    log "设置文件权限..."
    
    # 设置 GitLab 目录权限
    sudo chown -R git:git /var/opt/gitlab/
    sudo chown -R git:git /var/log/gitlab/
    sudo chown -R git:git /etc/gitlab/
    
    # 设置自定义目录权限
    if [ -d "/home/data/gitlab" ]; then
        sudo chown -R git:git /home/data/gitlab/
    fi
    
    log "文件权限设置完成"
}

# 重新配置 GitLab
reconfigure_gitlab() {
    log "重新配置 GitLab..."
    
    if sudo gitlab-ctl reconfigure; then
        log "GitLab 重新配置完成"
    else
        error "GitLab 重新配置失败"
    fi
}

# 启动 GitLab 服务
start_gitlab_services() {
    log "启动 GitLab 服务..."
    
    if sudo gitlab-ctl start; then
        log "GitLab 服务启动完成"
    else
        error "GitLab 服务启动失败"
    fi
    
    # 等待服务完全启动
    log "等待服务完全启动..."
    sleep 30
}

# 检查服务状态
check_service_status() {
    log "检查 GitLab 服务状态..."
    
    if sudo gitlab-ctl status; then
        log "✅ GitLab 服务运行正常"
    else
        warn "⚠️ GitLab 服务状态异常，请手动检查"
    fi
    
    # 检查 Web 服务可达性
    log "检查 GitLab Web 服务..."
    if curl -s -f http://localhost:80 > /dev/null 2>&1; then
        log "✅ GitLab Web 服务可达"
    else
        warn "⚠️ GitLab Web 服务不可达，请手动检查"
    fi
}

# 验证还原结果
verify_restore() {
    log "验证还原结果..."
    
    # 检查数据库连接
    if sudo gitlab-rake gitlab:check SANITIZE=true 2>/dev/null | grep -q "error"; then
        warn "GitLab 检查发现一些问题，请查看详细日志"
    else
        log "✅ GitLab 基础检查通过"
    fi
    
    # 显示还原后的版本信息
    local restored_version=$(sudo gitlab-rake gitlab:env:info 2>/dev/null | grep -i "version:" | head -1)
    log "还原后的 GitLab 版本: $restored_version"
    
    # 显示项目数量统计
    local project_count=$(sudo gitlab-rails runner "puts Project.count" 2>/dev/null || echo "未知")
    log "还原后的项目数量: $project_count"
}

# 清理临时文件
cleanup_temp_files() {
    log "清理临时文件..."
    
    # 移动日志文件到还原目录
    if [ -f "$LOG_FILE" ]; then
        sudo mv "$LOG_FILE" "$RESTORE_DIR/restore.log"
        LOG_FILE="$RESTORE_DIR/restore.log"
    fi
    
    # 清理临时锁文件等
    sudo rm -f /var/opt/gitlab/*.lock 2>/dev/null || true
    
    log "清理完成"
}

# 显示还原总结
show_restore_summary() {
    log "=== GitLab 完整数据还原完成 ==="
    log "还原目录: $RESTORE_DIR"
    log "还原日志: $LOG_FILE"
    
    echo
    echo "══════════════════════════════════════"
    echo "🎉 GitLab 还原完成！"
    echo "══════════════════════════════════════"
    echo "📋 下一步操作建议:"
    echo "1. 访问 GitLab Web 界面验证功能"
    echo "2. 检查项目、用户和数据完整性"
    echo "3. 运行: sudo gitlab-rake gitlab:check SANITIZE=true"
    echo "4. 查看日志: $LOG_FILE"
    echo "5. 如有问题，检查: sudo gitlab-ctl tail"
    echo "══════════════════════════════════════"
}

# 主还原流程
main() {
    # 在主函数开始时设置临时日志文件
    touch "$LOG_FILE" || error "无法创建临时日志文件"
    
    log "=== 开始 GitLab 完整数据还原 ==="
    log "还原源: $RESTORE_DIR"
    
    # 确认操作（危险操作需要确认）
    echo -e "${YELLOW}警告: 此操作将覆盖当前 GitLab 数据！${NC}"
    read -p "确定要继续还原吗? (输入 'YES' 确认): " confirmation
    
    if [ "$confirmation" != "YES" ]; then
        error "用户取消还原操作"
    fi
    
    # 执行还原步骤
    validate_restore_dir
    check_system_compatibility
    stop_gitlab_services
    restore_application_data
    restore_configuration_files
    restore_data_directories
    restore_log_files
    set_permissions
    reconfigure_gitlab
    start_gitlab_services
    check_service_status
    verify_restore
    cleanup_temp_files
    show_restore_summary
}

# 执行主函数
main