function install_auditd {
  $APT install auditd
}

function ensure_auditing_for_processes_that_start_prior_to_auditd_is_enabled {
  if [[ "$(grep GRUB_CMDLINE_LINUX /etc/default/grub 2>/dev/null)" =~ GRUB_CMDLINE_LINUX.+audit=1 ]]; then
  log_info "Ensure auditing for processes that start prior to auditd is enabled (Scored)\n"
  log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
  else
   log_info "Ensure auditing for processes that start prior to auditd is enabled (Scored)\n"
   log_info "$(tput setaf 1)Failed!$(tput sgr 0)\n"
   log_info "$(tput setaf 3)Applying the fixes!!$(tput sgr 0)\n"
   sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="audit=1"/g' /etc/default/grub              	
   /usr/sbin/update-grub &> /dev/null
   log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
  fi

}

function set_conf {
  if [[ "$(grep -w space_left_action /etc/audit/auditd.conf 2>/dev/null)" = "space_left_action = SYSLOG" && "$(grep -w action_mail_acct /etc/audit/auditd.conf 2>/dev/null)" = "action_mail_acct = root" && "$(grep -w admin_space_left_action /etc/audit/auditd.conf 2>/dev/null)" = "admin_space_left_action = IGNORE" ]];then 
    log_info "Ensure system is disabled when audit logs are full\n"
    log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
 else
    log_info "Ensure system is disabled when audit logs are full\n"
    log_info "$(tput setaf 1)Failed!$(tput sgr 0)\n"
    log_info "$(tput setaf 3)Applying the fixes!!$(tput sgr 0)\n" 
    
    sed -i 's/^action_mail_acct =.*/action_mail_acct = root/' "$AUDITDCONF"
    sed -i 's/^admin_space_left_action = .*/admin_space_left_action = IGNORE/' "$AUDITDCONF"
    sed -i 's/^space_left_action =.*/space_left_action = SYSLOG/' "$AUDITDCONF"
    log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
fi
  if [[ "$(grep ^max_log_file_action /etc/audit/auditd.conf 2>/dev/null)" = "max_log_file_action = ROTATE" ]]; then
    log_info "Ensure audit logs are not automatically deleted \n"
    log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
  else
    log_info "Ensure audit logs are not automatically deleted \n"
    log_info "$(tput setaf 1)Failed!$(tput sgr 0)\n"
    log_info "$(tput setaf 3)Applying the fixes!!$(tput sgr 0)\n" 
    sed -i 's/^max_log_file_action =.*/max_log_file_action = ROTATE/' "$AUDITDCONF"
    log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
fi
}


function add_rules {
  log_info "Adding audit rules as per CIS Guidelines \n"
  cp ./confs/audit.header $AUDITRULES
  for l in `ls ./confs/*.rules`; do
    cat "$l" >> $AUDITRULES
  done
  cp $AUDITRULES $AUDITHARDENRULES
}

function c_5_1 {
  log_info "Started hardening section 5.1: Configure system accounting(auditd)\n"
  install_auditd
  ensure_auditing_for_processes_that_start_prior_to_auditd_is_enabled 
  set_conf
  add_rules

  systemctl enable auditd.service &>/dev/null
  systemctl restart auditd.service &>/dev/null
}
