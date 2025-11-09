#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
LAST_IP_FILE="last-ip"
SCRIPT_PATH="/usr/local/bin/sync-ip.sh"
CRON_INTERVAL="0 */6 * * *" # Every 6 hours
LOG_FILE="/var/log/sync-ip.log"


setup_last_ip_file() {
  if [[ -z $LAST_IP_FILE ]]; then
    cp ./last-ip.example $LAST_IP_FILE
    echo "✅ Created $LAST_IP_FILE from example file."
  fi
}

install_script() {
  local src_script="sync-ip.sh"

  if [[ ! -f "$src_script" ]]; then
    echo "❌ $src_script not found in current directory."
    exit 1
  fi

  echo "🔗 Linking $src_script to $SCRIPT_PATH..."
  sudo ln -sf "$(realpath "$src_script")" "$SCRIPT_PATH"
  sudo chmod +x "$src_script"
}

setup_cron() {
  local tmp_cron
  tmp_cron=$(mktemp)

  echo "🕓 Setting up cron job..."

  # Get current crontab (if any)
  crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > "$tmp_cron" || true

  # Add new job
  echo "$CRON_INTERVAL $SCRIPT_PATH >> $LOG_FILE 2>&1" >> "$tmp_cron"

  # Install updated crontab
  crontab "$tmp_cron"
  rm -f "$tmp_cron"
}

setup_last_ip_file
install_script
setup_cron

echo "✅ Sync IP cron setup complete."
echo "⏱️  Cron will run every $CRON_INTERVAL"
echo "🧾 Logs will be written to $LOG_FILE"
