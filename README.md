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

## Usage

1. **Install requirements** (first time only):
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

2. **Run the playbook**:
   ```bash
   ansible-playbook -i inventory.ini playbook.yml -K
   ```
