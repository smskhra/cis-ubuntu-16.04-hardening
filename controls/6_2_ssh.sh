function set_permission {
  mkdir -p ~/hardening-$(hostname)-$(date +%Y"-"%m"-"%d)
  cp -a $SSHDFILE ~/hardening-$(hostname)-$(date +%Y"-"%m"-"%d)/sshd-hardening-$(hostname)-$(date +%Y"-"%m"-"%d)
  chmod 600 $SSHDFILE
}

function set_confs {
  sed -i 's/.*X11Forwarding.*/X11Forwarding no/g' "$SSHDFILE"
  sed -i 's/.*PermitRootLogin.*/PermitRootLogin no/g' "$SSHDFILE"
  
  if ! grep -q "^MaxAuthTries" "$SSHDFILE" 2> /dev/null; then
    echo "MaxAuthTries 4" >> "$SSHDFILE"
  fi
  
  if ! grep -q "^PermitUserEnvironment" "$SSHDFILE" 2> /dev/null; then
    echo "PermitUserEnvironment no" >> "$SSHDFILE"
  fi
  
  if ! grep -q "^Macs\|^MACs" "$SSHDFILE" 2> /dev/null; then
    echo 'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com' >> "$SSHDFILE"
  fi

  if ! grep -q "^ClientAliveInterval" "$SSHDFILE" 2> /dev/null; then
    echo "ClientAliveInterval 900" >> "$SSHDFILE"
  fi

  if ! grep -q "^ClientAliveCountMax" "$SSHDFILE" 2> /dev/null; then
    echo "ClientAliveCountMax 0" >> "$SSHDFILE"
  fi


  sed -i 's/.*LoginGraceTime.*/LoginGraceTime 120/g' "$SSHDFILE"
  log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n" 

}
 
function c_6_2 {
  log_info "Started hardening section 5.2: SSH server configuration"
  set_permission
  set_confs

  systemctl restart sshd.service &>/dev/null
}
