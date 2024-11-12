# SystemD Service Manager

A Perl-based interactive CLI tool for managing SystemD services with ease. This tool provides a user-friendly interface for common SystemD service operations including listing, monitoring, and controlling services.

## Features

- Interactive service selection with regex filtering
- Real-time service status monitoring
- Common SystemD operations (start, stop, restart, status)
- Colorized output with typewriter effect
- Journalctl log viewing options

## Requirements

- Perl 5.x
- SystemD
- Required Perl modules:
  - Term::ANSIColor
  - FindBin
  - Data::Dumper
  - Standard modules: strict, warnings, autodie, utf8

## Installation

Clone this repository:

```
git clone https://github.com/16BitMiker/debian-service-manager
```

Make the script executable:

```
chmod +x service-manager.pl
```

## Usage

Run the script with sudo privileges:

```
sudo ./service-manager.pl
```

### Interactive Workflow

1. **Service Filter**
   - Enter a regex pattern to filter services
   - Press Enter to show all services
2. **Service Selection**
   - Choose a service by name
   - Type 'B' or 'Bye' to exit
   - Type 'R' or 'Redo' to start over
3. **Command Menu**
   - Choose from available operations:
     1. View today's logs
     2. Follow logs in real-time
     3. View all logs
     4. Start service
     5. Stop service
     6. Restart service
     7. View service status

### Commands Reference

The tool supports the following SystemD commands:

- List services: `systemctl list-unit-files --type=service --all`
- View today's logs: `journalctl -u SERVICE --since today`
- Follow logs: `journalctl -u SERVICE -f`
- View all logs: `journalctl -u SERVICE`
- Service control:
  - Start: `systemctl start SERVICE`
  - Stop: `systemctl stop SERVICE`
  - Restart: `systemctl restart SERVICE`
  - Status: `systemctl status SERVICE`
