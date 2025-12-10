#!/usr/bin/env bash
# --------------------------------------------
# BC‑250‑Setup (customised version)
# --------------------------------------------
# Steps:
# 1. Enable the COPR repo filippor/bazzite (skip if already enabled)
# 2. Install cyan‑skillfish‑governor‑tt via rpm‑ostree (skip if already present)
# 3. Stop & disable oberon‑governor (if running)
# 4. Append mitigations=off to kernel args (skip if already set)
# 5. Create custom zRAM configuration (4 GB)
# 6. Reload systemd daemon
# 7. Set vm.swappiness to 90
# 8. Reboot the system (only a reminder – the script will NOT reboot)
# --------------------------------------------
set -uo pipefail

# ---------- Checks ------------------------------------
repo_enabled() {
  grep -qE '^filippor-bazzite' /etc/yum.repos.d/* 2>/dev/null
}
package_installed() {
  rpm-ostree status | grep -qE "^${1}"
}
zram_config_present() {
  [[ -f /etc/systemd/zram-generator.conf ]] &&
  grep -qE '^max-zram-size=4096' /etc/systemd/zram-generator.conf &&
  grep -qE '^compression-algorithm=lzo-rle' /etc/systemd/zram-generator.conf
}
swappiness_set() {
  sysctl -n vm.swappiness | grep -q '^90$'
}

# ---------- Steps ------------------------------------
steps=(
  "Enable COPR repo filippor/bazzite"
  "Install cyan-skillfish-governor-tt via rpm-ostree"
  "Stop & disable oberon-governor (if running)"
  "Append mitigations=off to kernel args"
  "Create custom zRAM configuration"
  "Reload systemd daemon"
  "Set vm.swappiness to 90"
  "Reboot system"
)
total=${#steps[@]}
step=1

# ---------- Helper functions ------------------------------------
run_step() {
  local cmd="$1" msg="$2"
  echo "[${step}/${total}] $msg ..."
  eval "$cmd"
  ((step++))
}

# ---------- Main routine ------------------------------------
# 5️⃣ Create custom zRAM configuration (4 GB)
if zram_config_present; then
  echo "[${step}/${total}] Create custom zRAM configuration ... ✓ (file already correct)"
else
  run_step "${steps[4]}" '
sudo bash -c "cat > /etc/systemd/zram-generator.conf <<EOF
[zram0]
max-zram-size=4096          # 4 GB (original was 8192 → 8 GB)
compression-algorithm=lzo-rle
EOF
"' "$step" "$total"
fi
((step++))

# 6️⃣ Reload systemd daemon
run_step "${steps[5]}" "sudo systemctl daemon-reload" "$step" "$total"
((step++))

# 7️⃣ Set vm.swappiness to 90
if swappiness_set; then
  echo "[${step}/${total}] Set vm.swappiness to 90 ... ✓ (already 90)"
else
  run_step "${steps[6]}" "sudo sysctl -w vm.swappiness=90" "$step" "$total"
fi
((step++))

# 8️⃣ Reboot system – the script just prints a reminder
echo "[${step}/${total}] Reboot system ... ⚠️  (please run -> systemctl reboot <- when ready)"
# --------------------------------------------------------------------
echo
echo "All done, and happy gaming from NexGen-3D"
echo "Remember: to make the above changes take effect, please run the following command:"
echo "systemctl reboot"
