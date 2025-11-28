#!/bin/bash
set -e
BACKUP_DIR="/home/backup"
BACKUP_TIMESTAMP="$1"

if [ -z "$BACKUP_TIMESTAMP" ]; then
    echo "使用方法: sudo ./gitlab_restore_full.sh <timestamp>"
        echo "示例: sudo ./gitlab_restore_full.sh 20251110_123456"
            exit 1
            fi

            echo "===> 停止相关服务..."
            sudo gitlab-ctl stop puma
            sudo gitlab-ctl stop sidekiq

            echo "===> 复制备份文件..."
            sudo cp $BACKUP_DIR/${BACKUP_TIMESTAMP}_gitlab_backup.tar /var/opt/gitlab/backups/${BACKUP_TIMESTAMP}_gitlab_backup.tar
            sudo chown git:git /var/opt/gitlab/backups/*.tar

            echo "===> 开始还原..."
            sudo gitlab-backup restore BACKUP=$BACKUP_TIMESTAMP

            echo "===> 还原配置文件..."
            sudo tar -xzf $BACKUP_DIR/config.tar.gz -C /
            [ -f $BACKUP_DIR/ssl_${BACKUP_TIMESTAMP}.tar.gz ] && sudo tar -xzf $BACKUP_DIR/ssl_${BACKUP_TIMESTAMP}.tar.gz -C /

            echo "===> 重启 GitLab..."
            sudo gitlab-ctl reconfigure
            sudo gitlab-ctl restart

            echo "===> 还原完成。"

