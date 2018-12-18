function set_permissions {
  chmod 600 /etc/crontab
  chmod 600 /etc/cron.hourly
  chmod 600 /etc/cron.daily
  chmod 600 /etc/cron.weekly
  chmod 600 /etc/cron.monthly
  chmod 600 /etc/cron.d 
}

function allow_deny {
  touch /etc/cron.allow
  touch /etc/at.allow

  chmod og-rwx /etc/cron.allow
  chmod og-rwx /etc/at.allow

  chown root.root /etc/cron.allow
  chown root.root /etc/at.allow
  ls -l /var/spool/cron/crontabs/ | grep -v total |awk '{print $9}' > /etc/cron.allow
  log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n" 
}

function c_6_1 {
  log_info "Started hardening section 6.1: Configure cron"
  set_permissions
  allow_deny
  
  systemctl restart cron.service
}
