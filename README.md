# Frappe Setup Wizard

An interactive, modular CLI tool that automates installing dependencies, creating benches/sites, installing apps, and maintaining Frappe/ERPNext environments on Ubuntu.

Instead of one giant script, this project is broken into clean modules so it's easy to read, extend, and debug.

## Features

- Interactive menu-driven installer
- Multi-version support (Frappe v14 / v15 / v16, matching Node.js version auto-selected)
- Dynamic app installation (official apps or any Git URL), space separated
- Auto-detects an existing bench in the current directory
- `doctor` command to check your environment (Python, Node, Redis, MariaDB, Bench, Yarn, wkhtmltopdf, Git, npm, pip, curl)
- Update command: update bench framework, a single app, or everything at once
- Cleanup command: delete sites/benches/apps, clear cache, remove logs — for recovering from failed installs
- Centralized config file (`configs/apps.conf`) instead of editing multiple scripts
- Per-day logging under `logs/`
- Colored, readable CLI output

## Project Structure

```
frappe-setup/
├── install.sh              # Main entry point (menu)
├── config.sh                # Colors, paths, defaults
├── functions.sh              # Shared helper functions
├── scripts/
│   ├── 01_dependencies.sh
│   ├── 02_create_bench.sh
│   ├── 03_create_site.sh
│   ├── 04_install_apps.sh
│   ├── 05_start_bench.sh
│   ├── doctor.sh
│   ├── update.sh
│   └── cleanup.sh
├── configs/
│   └── apps.conf
├── logs/
├── README.md
├── LICENSE
└── .gitignore
```

## Requirements

- Ubuntu 20.04+ (tested on 22.04 / 24.04)
- `sudo` privileges
- Internet access

## Usage

```bash
git clone https://github.com/<your-username>/frappe-setup-wizard.git
cd frappe-setup-wizard
chmod +x install.sh scripts/*.sh
./install.sh
```

Then follow the on-screen menu:

```
1. Install Dependencies
2. Create New Bench
3. Create New Site
4. Install Apps
5. Start Bench
6. Update Existing Bench
7. Doctor (Check Environment)
8. Cleanup
9. Exit
```

## Configuration

Edit `configs/apps.conf` to change defaults instead of touching the scripts:

```bash
DEFAULT_VERSION=version-15
DEFAULT_NODE=18
DEFAULT_APPS="erpnext hrms"
WORKSPACE=$HOME/Projects
```

## Installing Custom Apps

When prompted for apps, you can mix official app names and Git URLs:

```
Apps: erpnext hrms payments https://github.com/my-org/custom_app.git
```

## Logs

Every run writes to `logs/YYYY-MM-DD-install.log` so failures are easy to debug.

## Roadmap

- [ ] Docker mode
- [ ] Production setup (`bench setup production`) with Nginx + SSL
- [ ] Automated backups / restore from SQL dump
- [ ] Interactive TUI using `gum` or `dialog`
- [ ] Frappe Cloud compatibility checks

## Contributing

Issues and PRs welcome. If you build a Frappe/ERPNext dev environment often, this is meant to save you the repetitive setup steps.

## License

MIT — see [LICENSE](LICENSE).
