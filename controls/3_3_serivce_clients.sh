function disable_service_clients {
  local PKGS
  PKGS="nis rsh-client rsh-redone-client talk telnet ldap-utils"
  for disable in $PKGS; do
      if [[ "$(dpkg -s $disable 2>/dev/null | grep Status)" = "" || "$(dpkg -s $disable 2>/dev/null | grep Status)" =~ ^Status:.deinstall ]] 
        then
         log_info "Ensure $disable Client is not installed (Scored)"
         log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
      else
         log_info "Ensure $disable Client is not installed (Scored)"
         log_info "$(tput setaf 1)Failed!$(tput sgr 0)\n"
         log_info "$(tput setaf 3)Removing $disable package$(tput sgr 0)\n"
         $APT remove $disable
         log_info "$(tput setaf 5)$disable package successfully removed$(tput sgr 0)\n"
         log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
      fi
    done
}

function c_3_3 {
   log_info "Started hardening section 2.3 Service Clients\n"
   disable_service_clients
}
