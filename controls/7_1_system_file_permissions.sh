function passwd_files {
  chown root.root /etc/passwd
  chmod 644 /etc/passwd

  chown root.shadow /etc/shadow
  chmod 640 /etc/shadow

  chown root.root /etc/group
  chmod 644 /etc/group

  chown root.shadow /etc/gshadow
  chmod 640 /etc/gshadow

  chown root.root /etc/passwd-
  chmod 600 /etc/passwd-

  chown root.root /etc/shadow-
  chmod 600 /etc/shadow-

  chown root.root /etc/gshadow-
  chmod 600 /etc/gshadow-
  log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
}

  


function c_7_1 {
  log_info "Started hardening section 7.1: System file permissions"
  passwd_files

}
