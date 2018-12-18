function disable_net {
  local NET
  
  NET="dccp sctp rds tipc"
  for disable in $NET; do
    if [[ "$(modprobe -n -v $disable 2>/dev/null)" =~ install./bin/true && "$(lsmod | grep $disable)" = "" ]]
    then
        log_info "Ensure $disable  is disabled (Scored)"
        log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n" 
    else
        log_info "Ensure $disable  is disabled (Scored)"
        log_info "$(tput setaf 1)Failed!$(tput sgr 0)\n" 
        log_info "$(tput setaf 3)Applying the fixes!!$(tput sgr 0)\n"
    	echo "install $disable /bin/true" >> "/etc/modprobe.d/CIS.conf"
        log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n" 
   fi
  done
}

function c_4_3 {
  log_info "Started hardening section 4.3: Uncommon network protocols"
  disable_net
}

