#!/usr/bin/env bash
readonly SCRIPT_NAME="$(basename "$0")"

# Configuration files
readonly AUDITDCONF='/etc/audit/auditd.conf'
readonly AUDITHARDENRULES='/etc/audit/rules.d/hardening.rules'
readonly AUDITRULES='/etc/audit/audit.rules'
readonly SSHDFILE='/etc/ssh/sshd_config'
readonly HOSTALLOW='/etc/hosts.allow'
readonly HOSTDENY='/etc/hosts.deny'
readonly SYSCTL='/etc/sysctl.conf'

function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local readonly message="$1"
  log "INFO" "$message"
}

function log_warn {
  local readonly message="$1"
  log "WARN" "$message"
}

function log_error {
  local readonly message="$1"
  log "ERROR" "$message"
}


function f_apt {
  export TERM=linux
  export DEBIAN_FRONTEND=noninteractive

  if [[ $VERBOSE == "Y" ]]; then
    APTFLAGS='--assume-yes'
  else
    APTFLAGS='-qq --assume-yes'
  fi

  APT="apt-get $APTFLAGS"

  readonly APTFLAGS
  readonly APT

}



function main() {
  if [ $EUID -ne 0 ]; then
    log_error "Not root or not enough privileges. Exiting."
    exit 1
  fi

  if ! lsb_release -i | grep 'Ubuntu'; then
    log_error "Ubuntu only. Exiting."
    exit 1
  fi



  for s in ./controls/*; do
    [[ -e $s ]] || break

    source "$s"
  done

  f_apt

  c_3_3
  c_4_3
  c_5_1
  c_7_1
  c_4_1
  c_6_1
  c_6_2
}






LOGFILE="hardening-$(hostname)-$(date +%Y"-"%m"-"%d).log"
echo "[HARDENING LOG - $(hostname --fqdn) - $(LANG=C date)]" >> "$LOGFILE"

main "$@" | tee -a "$LOGFILE"
