#!/usr/bin/env bash
# --------------------------------------------------------------------
# BC-250-Setup
#
# Steps:
# 1. Enable the COPR repo filippor/bazzite (skip if already enabled)
# 2. Install cyan-skillfish-governor-tt via rpm‑ostree (skip if already present)
# 3. Stop & disable oberon-governor (if running)
# 4. Append mitigations=off to kernel args (skip if already set)
# 5. Create custom zRAM configuration (skip if file already correct)
# 6. Reload systemd daemon
# 7. Set vm.swappiness to 180
# 8. Reboot the system (only a reminder – the script will NOT reboot)
# --------------------------------------------------------------------
set -uo pipefail

# ---------- Spinner -----------------------------------------------
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  tput civis
  while kill -0 "$pid" 2>/dev/null; do
    local temp=${spinstr#?}
    printf " %s\r" "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep "$delay"
  done
  tput cnorm
  printf ' \n'
}

# ---------- Helper -------------------------------------------------
run_step() {
  local step_desc=$1
  local cmd=$2
  local step_num=$3
  local total_steps=$4

  echo -ne "[${step_num}/${total_steps}] ${step_desc} ... "
  bash -c "$cmd" &
  local pid=$!
  spinner "$pid"
  local exit_status=$?
  wait "$pid" 2>/dev/null
  if [[ $exit_status -ne 0 ]]; then
    echo "❌ Error (exit $exit_status)"
  else
    echo "✓"
  fi
}

# ---------- Checks -------------------------------------------------
repo_enabled() {
  grep -qE '^filippor-bazzite' /etc/yum.repos.d/* 2>/dev/null
}
package_installed() {
  rpm-ostree status | grep -qE "^${1}"
}
zram_config_present() {
  [[ -f /etc/systemd/zram-generator.conf ]] &&
  grep -qE '^max-zram-size=8192' /etc/systemd/zram-generator.conf &&
  grep -qE '^compression-algorithm=lzo-rle' /etc/systemd/zram-generator.conf
}
swappiness_set() {
  sysctl -n vm.swappiness | grep -q '^180$'
}

# ---------- Steps --------------------------------------------------
steps=(
  "Enable COPR repo filippor/bazzite"
  "Install cyan-skillfish-governor-tt via rpm-ostree"
  "Stop & disable oberon-governor (if running)"
  "Append mitigations=off to kernel args"
  "Create custom zRAM configuration"
  "Reload systemd daemon"
  "Set vm.swappiness to 180"
  "Reboot system"
)
total=${#steps[@]}
step=1

# 1️⃣ Enable COPR repo
if repo_enabled; then
  echo "[${step}/${total}] Enable COPR repo filippor/bazzite ... ✓ (already enabled)"
else
  run_step "${steps[0]}" "sudo copr enable filippor/bazzite" "$step" "$total"
fi
((step++))

# 2️⃣ Install cyan‑skillfish‑governor‑tt
if package_installed cyan-skillfish-governor-tt; then
  echo "[${step}/${total}] Install cyan-skillfish-governor-tt via rpm-ostree ... ✓ (already installed)"
else
  run_step "${steps[1]}" "sudo rpm-ostree install cyan-skillfish-governor-tt" "$step" "$total"
fi
((step++))

# 3️⃣ Stop & disable oberon‑governor
run_step "${steps[2]}" '
if systemctl list-unit-files | grep -q "^oberon-governor.service"; then
  if systemctl is-active --quiet oberon-governor.service; then
    echo "oberon-governor.service is active – stopping & disabling it."
    sudo systemctl stop oberon-governor
    sudo systemctl disable oberon-governor
  else
    echo "oberon-governor.service is installed but not active – no action taken."
  fi
else
  echo "oberon-governor.service not found – skipping."
fi
' "$step" "$total"
((step++))

# 4️⃣ Append mitigations=off to kernel args
if rpm-ostree status | grep -qE 'kargs=.*mitigations=off'; then
  echo "[${step}/${total}] Append mitigations=off to kernel args ... ✓ (already set)"
else
  run_step "${steps[3]}" "sudo rpm-ostree kargs --append-if-missing=\"mitigations=off\"" "$step" "$total"
fi
((step++))

# 5️⃣ Create custom zRAM configuration
if zram_config_present; then
  echo "[${step}/${total}] Create custom zRAM configuration ... ✓ (file already correct)"
else
  run_step "${steps[4]}" '
sudo bash -c "cat > /etc/systemd/zram-generator.conf <<EOF
[zram0]
max-zram-size=8192
compression-algorithm=lzo-rle
EOF
"' "$step" "$total"
fi
((step++))

# 6️⃣ Reload systemd daemon
run_step "${steps[5]}" "sudo systemctl daemon-reload" "$step" "$total"
((step++))

# 7️⃣ Set vm.swappiness to 180
if swappiness_set; then
  echo "[${step}/${total}] Set vm.swappiness to 180 ... ✓ (already 180)"
else
  run_step "${steps[6]}" "sudo sysctl -w vm.swappiness=180" "$step" "$total"
fi
((step++))

# 7️⃣ Reboot system – the script just prints a reminder
echo "[${step}/${total}] Reboot system ... ⚠️  (please run -> systemctl reboot <- when ready)"

# --------------------------------------------------------------------
echo
echo "All done, and happy gaming from NexGen-3D"
echo "Remember: to make the above changes take effect, please run the following command:"
echo "systemctl reboot"
