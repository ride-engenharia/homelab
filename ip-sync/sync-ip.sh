#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
DOMAIN="tosh.io"
RECORD_NAME="@"
IP_FILE="./last-ip"

# === FUNCTIONS ===
get_public_ip() {
  curl -s https://api.ipify.org
}

get_record_id() {
  curl -s -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DIGITAL_OCEAN_TOKEN" \
    "https://api.digitalocean.com/v2/domains/$DOMAIN/records" |
    jq -r ".domain_records[] | select(.type==\"A\" and .name==\"$RECORD_NAME\") | .id"
}

update_dns_record() {
  local record_id="$1"
  local new_ip="$2"

  curl -s -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DIGITAL_OCEAN_TOKEN" \
    -d "{\"data\":\"$new_ip\"}" \
    "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$record_id" > /dev/null
}

# === MAIN ===
current_ip=$(get_public_ip)
if [[ -z "$current_ip" ]]; then
  echo "❌ Failed to get current public IP"
  exit 1
fi

# Check if IP changed
if [[ -f "$IP_FILE" ]]; then
  last_ip=$(<"$IP_FILE")
  if [[ "$current_ip" == "$last_ip" ]]; then
    echo "✅ IP unchanged ($current_ip)"
    exit 0
  fi
fi

echo "🌐 IP changed to $current_ip — updating DigitalOcean DNS…"

record_id=$(get_record_id)
if [[ -z "$record_id" ]]; then
  echo "❌ Could not find A record for $RECORD_NAME.$DOMAIN"
  exit 1
fi

update_dns_record "$record_id" "$current_ip"
echo "$current_ip" > "$IP_FILE"
echo "✅ DNS record updated successfully to $current_ip"
