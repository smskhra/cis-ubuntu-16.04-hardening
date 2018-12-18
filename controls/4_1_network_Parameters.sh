
function set_conf_sysctl {
  mkdir -p ~/hardening-$(hostname)-$(date +%Y"-"%m"-"%d)
  cp -a $SYSCTL ~/hardening-$(hostname)-$(date +%Y"-"%m"-"%d)/sysctl-hardening-$(hostname)-$(date +%Y"-"%m"-"%d).conf
  cp ./confs/sysctl.def $SYSCTL
  sed -e '/et.ipv4.conf.all.send_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.send_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.all.accept_source_route/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.accept_source_route/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.all.accept_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.accept_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.all.secure_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.secure_redirects/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.all.log_martians/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.log_martians/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.icmp_echo_ignore_broadcasts/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.icmp_ignore_bogus_error_responses/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.all.rp_filter/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.conf.default.rp_filter/ s/^#*/#/' -i $SYSCTL 
  sed -e '/net.ipv4.tcp_syncookies/ s/^#*/#/' -i $SYSCTL 
}

function add_rules_sysctl {
  cat ./confs/sysctl.conf >> $SYSCTL
  log_info "$(tput setaf 2)Passed!$(tput sgr 0)\n"
}

function c_4_1 {
  log_info "Started hardening section 4.1 Network Parameters"
  set_conf_sysctl
  add_rules_sysctl

  sysctl -w net.ipv4.route.flush=1 &>/dev/null
  sysctl -p &>/dev/null  
}
