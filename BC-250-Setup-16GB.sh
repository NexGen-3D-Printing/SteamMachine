#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────
#  BC-250-Setup (Bazzite) – NexGen3D v1.1
#
#  Created By:  NexGen3D for the BC‑250
#
#  What this script does (in order):
#    1 Enable the filippor‑bazzite COPR repo
#    2 If cyan‑skillfish-governor is installed, uninstall it; then install cyan‑skillfish‑governor‑tt via rpm‑ostree
#    3 Stop & disable oberon‑governor
#    4 Add ‘mitigations=off’ to GRUB (performance‑only)
#    5 Reload systemd daemon
#    6 Create /var/swap sub‑volume (BTRFS)
#    7 Make a 16 GiB swapfile inside that sub‑volume
#    8 Add the swapfile to /etc/fstab for persistence
#    9 Enable rpm‑ostree initramfs features (lz4 + drivers)
#    10 Set vm.swappiness = 180 (prefers swap over ram)
#    11 Re‑create empty zram‑generator.conf if it’s missing; delete first if present
#
# ────────────────────────────────────────────────────────────────

set -uo pipefail
had_error=false          # initialise flag used by run_step

# ---------- Spinner -----------------------------------------------
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\\'
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

# ---------- Helper -----------------------------------------------
run_step() {
  local step_desc=$1   # what we’re doing
  local cmd=$2
  local step_num=$3
  local total_steps=$4
  echo -ne "[${step_num}/${total_steps}] ${step_desc} ... "
  bash -c "$cmd" &
  local pid=$!
  spinner "$pid"
  wait "$pid" 2>/dev/null
  local exit_status=$?
  if [[ $exit_status -ne 0 ]]; then
    echo "❌ (exit $exit_status)"
    had_error=true          # keep running, just note the failure
  else
    echo "✅"
  fi
}

# ---------- Status‑check functions ----------------------------------
repo_enabled() { grep -qE '^\[baseos\]' /etc/yum.repos.d/*.repo 2>/dev/null; }
package_installed() { rpm -q "$1" &>/dev/null; }

# ---------- Step descriptions ------------------------------------
steps=(
  "Enable the filippor‑bazzite COPR repo"
  "If cyan‑skillfish-governor is installed, uninstall it; then install cyan‑skillfish‑governor‑tt via rpm‑ostree"
  "Stop & disable oberon‑governor"
  "Add ‘mitigations=off’ to GRUB"
  "Reload systemd daemon"
  "Create /var/swap sub‑volume"
  "Create swapfile in /var/swap"
  "Add swapfile entry to /etc/fstab"
  "Enable rpm‑ostree initramfs features"
  "Set vm.swappiness = 180"
  "Re‑create empty zram‑generator.conf if it’s missing; delete first if present"
)

# ---------- Step counters -----------------------------------------
step=1
total=${#steps[@]}   # automatically matches the array length (11)

# ---------- Step 1 – Enable COPR repo --------------------------------
if repo_enabled; then
  echo "[${step}/${total}] ${steps[0]} ... ✅ (already enabled)"
else
  run_step "${steps[0]}" "sudo copr enable filippor/bazzite" "$step" "$total"
fi
((step++))

# ---------- Step 2 – Uninstall & install cyan‑skillfish‑governor‑tt --------------------
if package_installed cyan-skillfish-governor; then
  echo "[${step}/${total}] ${steps[1]} … uninstalling existing governor..."
  run_step "${steps[1]}" \
    "sudo rpm-ostree uninstall cyan‑skillfish-governor && sudo rpm-ostree install cyan‑skillfish‑governor‑tt" "$step" "$total"
else
  echo "[${step}/${total}] ${steps[1]} ... ✅ (cyan‑skillfish‑governor not found, installing tt)"
  run_step "${steps[1]}" "sudo rpm-ostree install cyan‑skillfish‑governor‑tt" "$step" "$total"
fi
((step++))

# ---------- Step 3 – Stop & disable oberon‑governor -----------------
if systemctl is-active --quiet oberon‑governor.service; then
  echo "[${step}/${total}] ${steps[2]} ... ✅ (already stopped)"
else
  run_step "${steps[2]}" "sudo systemctl stop oberon‑governor && sudo systemctl disable oberon‑governor" "$step" "$total"
fi
((step++))

# ---------- Step 4 – Append mitigations=off ------------------------
if grep -qE 'mitigations=off' /etc/default/grub; then
  echo "[${step}/${total}] ${steps[3]} ... ✅ (already present)"
else
  run_step "${steps[3]}" \
    "sudo rpm-ostree kargs --append-if-missing="mitigations=off zswap.enabled=1"" "$step" "$total"
fi
((step++))

# ---------- Step 5 – Reload systemd daemon -------------------------
run_step "${steps[4]}" "sudo systemctl daemon-reload" "$step" "$total"

# ---------- Step 6 – Create /var/swap sub‑volume ------------------------------------
if [[ -d /var/swap ]]; then
  echo "[${step}/${total}] ${steps[5]} ... ✅"
else
  run_step "${steps[5]}" \
    "sudo btrfs subvolume create /var/swap && \\
     sudo semanage fcontext -a -t var_t /var/swap && \\
     sudo restorecon /var/swap" "$step" "$total"
fi
((step++))

# ---------- Step 7 – Create swapfile in /var/swap ------------------------------------
SIZE=16G   # tweak if you need a different size
if [[ -f /var/swap/swapfile ]]; then
  echo "[${step}/${total}] ${steps[6]} ... ✅"
else
  run_step "${steps[6]}" \
    "sudo btrfs filesystem mkswapfile --size $SIZE /var/swap/swapfile && \\
     sudo semanage fcontext -a -t swapfile_t /var/swap/swapfile && \\
     sudo restorecon /var/swap/swapfile" "$step" "$total"
fi
((step++))

# ---------- Step 8 – Add swapfile entry to /etc/fstab ------------------------------------
if grep -qF '/var/swap/swapfile none swap defaults,nofail 0 0' /etc/fstab; then
  echo "[${step}/${total}] ${steps[7]} ... ✅ (already present)"
else
  run_step "${steps[7]}" \
    "sudo bash -c 'echo \"/var/swap/swapfile none swap defaults,nofail 0 0\" >> /etc/fstab'" "$step" "$total"
fi
((step++))

# ---------- Step 9 – Enable rpm‑ostree initramfs features ---------------------------------
run_step "${steps[8]}" \
  "sudo rpm-ostree initramfs --enable \\
       --arg=--add-drivers \\
       --arg=lz4 \\
       --arg=--add‑drivers \\
       --arg=lz4_compress" "$step" "$total"

# ---------- Step 10 – Set vm.swappiness to 180 ------------------------
run_step "${steps[9]}" \
  "sudo bash -c 'echo \"vm.swappiness = 180\" > /etc/sysctl.d/99‑swappiness.conf'" "$step" "$total"
((step++))

# ---------- Step 11 – Re‑create empty zram‑generator.conf if missing --------------------
if [[ -f /etc/systemd/zram‑generator.conf ]]; then
  echo "[${step}/${total}] ${steps[10]} ... ⏳ deleting existing file…"
  run_step "${steps[10]}" \
    "sudo rm -f /etc/systemd/zram‑generator.conf && sudo tee /dev/null > /etc/systemd/zram‑generator.conf" "$step" "$total"
else
  echo "[${step}/${total}] ${steps[10]} ... ✅ (already absent, created empty)"
fi
((step++))

# ---------- Final status ------------------------------------------
echo "Setup complete, please reboot your system using the following command: systemctl reboot"
