# Bash Scripts for Laravel Development

A collection of bash scripts to automate Laravel project setup and management with Docker and Laravel Sail.

## 🚀 Scripts

### rootpi-setup.sh

Creates a new Laravel project with a complete development environment including:

- Laravel Jetstream (Inertia)
- Laravel Pulse
- Laravel Horizon
- Laravel Scout
- PostgreSQL
- Redis
- MeiliSearch
- Docker via Laravel Sail

#### Usage

bash
./rootpi-setup.sh

You'll be prompted to enter your project name, and the script will handle everything else automatically.

### rootpi-clone.sh

Clones and sets up an existing Laravel project with Docker environment. The script:

- Clones the repository
- Sets up environment file
- Installs dependencies
- Configures Docker environment
- Runs database migrations
- Sets up Laravel Sail

#### Usage

bash
./rootpi-clone.sh

You'll be prompted to enter the GitHub repository URL.

## 🔧 Prerequisites

- macOS operating system
- Git installed
- Docker Desktop for Mac
- Cursor Editor (optional, but recommended)

## 🛠 Features

- Interactive ASCII art display
- Fun loading messages
- Automatic Docker installation if missing
- Environment configuration
- Development tools setup
- Automatic PATH configuration
- PostgreSQL database setup
- Redis configuration
- MeiliSearch integration
- Supervisor configuration for background processes

## 📝 Environment Setup

The scripts automatically configure common environment variables for:

- Database connections (PostgreSQL)
- Redis
- MeiliSearch
- Queue system
- Session management
- Broadcasting

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📜 License

This project is open-sourced software licensed under the MIT license.
