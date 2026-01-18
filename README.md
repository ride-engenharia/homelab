# Ridbe Lab

Automated homelab setup using Ansible and Podman.

## Dependencies

### Ansible Collections
Install the required Ansible collections:
```bash
ansible-galaxy collection install -r requirements.yml
```

### Python Dependencies
The PostgreSQL roles automatically handle the installation of `python3-pip` and `python3-psycopg2` on the server using the `dnf` module.

### Bitwarden Secrets Manager CLI
This project uses the `community.general.bitwarden_secrets_manager` lookup plugin to securely retrieve secrets. This requires the **Bitwarden Secrets Manager CLI (`bws`)** to be installed on the system running Ansible.

#### Installation Options:

**Install Script (Recommended for Linux/macOS)**
```bash
cd /tmp
curl -LO "https://github.com/bitwarden/sdk/releases/download/bws-v1.0.0/bws-x86_64-unknown-linux-gnu-1.0.0.zip"
unzip bws-*.zip
chmod +x bws
sudo mv bws /usr/local/bin/
```

**Verify Installation:**
```bash
bws --version
```

**Authentication:**
Set the `BWS_ACCESS_TOKEN` environment variable with your Bitwarden Secrets Manager access token:
```bash
export BWS_ACCESS_TOKEN="your_access_token_here"
```

## Usage

1. **Install requirements** (first time only):
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

2. **Run the playbook**:
   ```bash
   ansible-playbook -i inventory.ini playbook.yml -K
   ```
