#!/bin/bash

set -e  # Exit on error

# Function to clear screen and print ASCII Art at the top
print_rootpi() {
  clear  # Clear the screen
  echo -e "\033[0;0H"  # Move cursor to top
  echo -e "\033[1;34m"
  cat << "EOF"
  ██████╗                           ██████╗ 
  ██╔══██╗                     ██╗  ██╔══██╗██╗
  ██████╔╝ ██████╗  ██████╗  ██████╗██║████║╚═╝
  ██╔══██╗██║   ██║██║   ██║ ╚═██╔═╝██║════╝██║
  ██║  ██║╚██████╔╝╚██████╔╝   ██║  ██║     ██║
  ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝  ╚═╝     ╚═╝
  █╗██╗ █╗█╗█████╗         ████████████████╗
  █║█║█╗█║█║╚═█╔═╝        ███║═════════███║
  █║█║╚██║█║  █║   ███╗ ███║ ███╗███╗ ███║
  ╚╝╚╝ ╚═╝╚╝  ╚╝   ╚██████║ ███║███║  ╚═╝
                    ╚════╝  ╚══╝╚══╝
EOF
  echo -e "\033[0m"
}

# Function to show fun messages in the middle of the screen
show_fun_message() {
    # Get terminal height and calculate position below ASCII art
    local term_height=$(tput lines)
    local ascii_art_height=12  # Height of the ASCII art
    local message_row=$((ascii_art_height + 2))  # Position 2 lines below ASCII art
    
    messages=(
        "🧹 Cleaning up your bedroom..."
        "🦠 Installing virus... just kidding!"
        "🚀 Preparing for warp speed..."
        "🤖 Teaching AI to make coffee..."
        "🎮 Defeating final boss..."
        "🧙‍♂️ Casting installation spells..."
        "🎲 Rolling for initiative..."
        "🎵 Playing elevator music..."
        "🔍 Looking for my keys..."
        "🌈 Adding more RGB (makes it faster)"
    )
    random_index=$((RANDOM % ${#messages[@]}))
    
    # Clear the message line and display centered message
    echo -e "\033[${message_row};0H\033[K"  # Move to message row and clear line
    echo -e "\033[${message_row};$(($(tput cols) / 2 - ${#messages[$random_index]} / 2))H${messages[$random_index]}"
    
    # Move cursor to bottom for command output
    echo -e "\033[${term_height};0H"
    sleep 1
}

# Function to show command output at the bottom
show_command_output() {
    local output="$1"
    local term_height=$(tput lines)
    local output_row=$((term_height - 4))  # Leave some space at bottom
    
    # Move to output position and show last 3 lines
    echo -e "\033[${output_row};0H\033[K"  # Clear output area
    echo "$output" | tail -n 3
}

# Print RootPi ASCII Art
print_rootpi

# Ask for project name
read -p "Enter the Laravel project name: " PROJECT_NAME

# Check if Docker is installed, if not, install it
if ! command -v docker &> /dev/null; then
    echo "🚀 Installing Docker..."
    curl -o Docker.dmg "https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-arm64"
    sudo hdiutil attach Docker.dmg
    sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
    sudo hdiutil detach /Volumes/Docker
    echo "✅ Docker installed. Please restart your terminal and rerun the script."
    exit 0
fi

# Ensure Docker is running
if (! docker stats --no-stream &> /dev/null); then
    echo "⚠️  Docker is installed but not running. Please start Docker and rerun the script."
    exit 1
fi

# Create a temporary script with our functions
cat << 'EOFSCRIPT' > /tmp/helper_functions.sh
export TERM=xterm-256color

print_rootpi() {
  clear
  echo -e "\033[0;0H"
  echo -e "\033[1;34m"
  cat << "EOF"
  ██████╗                           ██████╗ 
  ██╔══██╗                     ██╗  ██╔══██╗██╗
  ██████╔╝ ██████╗  ██████╗  ██████╗██║████║╚═╝
  ██╔══██╗██║   ██║██║   ██║ ╚═██╔═╝██║════╝██║
  ██║  ██║╚██████╔╝╚██████╔╝   ██║  ██║     ██║
  ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝  ╚═╝     ╚═╝
  █╗██╗ █╗█╗█████╗         ████████████████╗
  █║█║█╗█║█║╚═█╔═╝        ███║═════════███║
  █║█║╚██║█║  █║   ███╗ ███║ ███╗███╗ ███║
  ╚╝╚╝ ╚═╝╚╝  ╚╝   ╚██████║ ███║███║  ╚═╝
                    ╚════╝  ╚══╝╚══╝
EOF
  echo -e "\033[0m"
}

show_fun_message() {
    local ascii_art_height=12  # Height of the ASCII art
    local message_row=$((ascii_art_height + 2))  # Position 2 lines below ASCII art
    
    messages=(
        "🧹 Cleaning up your bedroom..."
        "🦠 Installing virus... just kidding!"
        "🚀 Preparing for warp speed..."
        "🤖 Teaching AI to make coffee..."
        "🎮 Defeating final boss..."
        "🧙‍♂️ Casting installation spells..."
        "🎲 Rolling for initiative..."
        "🎵 Playing elevator music..."
        "🔍 Looking for my keys..."
        "🌈 Adding more RGB (makes it faster)"
    )
    random_index=$((RANDOM % ${#messages[@]}))
    message="${messages[$random_index]}"
    
    # Move to position below ASCII art and align center
    echo -e "\033[${message_row};0H\033[K"  # Move to message row and clear line
    echo -e "\033[${message_row};4H${message}"  # 4 spaces indent from left
}

show_command_output() {
    local output="$1"
    # Use fixed position near bottom of screen
    echo -e "\033[20;0H\033[K"  # Move to line 20 and clear line
    echo "$output" | tail -n 3
}
EOFSCRIPT

# Modify commands to use the helper functions
echo "🚀 Creating Laravel project inside a temporary PHP container..."
docker run --rm -e TERM=xterm-256color -v $(pwd):/app -v /tmp/helper_functions.sh:/helper_functions.sh -w /app laravelsail/php83-composer:latest bash -c "
    source /helper_functions.sh &&
    composer create-project --prefer-dist laravel/laravel $PROJECT_NAME 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    cd $PROJECT_NAME &&
    composer require laravel/jetstream 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan jetstream:install inertia 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done
"

# Change into project directory
cd "$PROJECT_NAME"

# Install Laravel Packages with limited output
echo "🚀 Installing Laravel packages..."
docker run --rm -e TERM=xterm-256color -v $(pwd):/app -v /tmp/helper_functions.sh:/helper_functions.sh -w /app laravelsail/php83-composer:latest bash -c "
    source /helper_functions.sh &&
    composer require laravel/pulse 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan vendor:publish --provider=\"Laravel\\Pulse\\PulseServiceProvider\" 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    composer require laravel/horizon 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan horizon:install 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    composer require laravel/scout 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan vendor:publish --provider=\"Laravel\\Scout\\ScoutServiceProvider\" 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    composer require laravel/sail --dev 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan sail:install --no-interaction --with=pgsql,redis,meilisearch 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done &&
    php artisan sail:publish 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done
"

# Modify Supervisord Config inside Docker
SUPERVISOR_CONF="docker/8.4/supervisord.conf"

if [ -f "$SUPERVISOR_CONF" ]; then
    echo "Updating supervisord.conf..."
    cat <<EOF >> "$SUPERVISOR_CONF"

[program:yarn-dev]
command=/bin/sh -c "yarn install && yarn dev"
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0

[program:horizon]
command=php artisan horizon
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF
else
    echo "⚠️  Warning: Supervisord config file not found!"
fi

# Update Environment Variables
echo "🔧 Updating environment variables..."
sed -i '' 's/QUEUE_CONNECTION=.*/QUEUE_CONNECTION=redis/' .env .env.example
sed -i '' 's/SESSION_DRIVER=.*/SESSION_DRIVER=redis/' .env .env.example
sed -i '' 's/CACHE_STORE=.*/CACHE_STORE=redis/' .env .env.example
sed -i '' 's/BROADCAST_CONNECTION=.*/BROADCAST_CONNECTION=redis/' .env .env.example

sed -i '' 's/DB_USERNAME=.*/DB_USERNAME=sail/' .env .env.example
sed -i '' 's/DB_PASSWORD=.*/DB_PASSWORD=password/' .env .env.example
sed -i '' 's/DB_HOST=.*/DB_HOST=pgsql/' .env .env.example
sed -i '' 's/REDIS_HOST=.*/REDIS_HOST=redis/' .env .env.example

sed -i '' 's/SCOUT_DRIVER=.*/SCOUT_DRIVER=meilisearch/' .env .env.example
sed -i '' 's/SCOUT_QUEUE=.*/SCOUT_QUEUE=true/' .env .env.example
sed -i '' 's|MEILISEARCH_HOST=.*|MEILISEARCH_HOST=http://meilisearch:7700|' .env .env.example
sed -i '' 's|MEILISEARCH_KEY=.*|MEILISEARCH_KEY=JNbflBxjxX9GjI8lzjJn0o-ip-r-_Kn1YjEufMPxnY4|' .env .env.example

# Modify the final Sail commands
echo "🚀 Building and starting Laravel Sail..."
# Check if vendor/bin PATH entry exists in .zshrc
if ! grep -q 'export PATH="$PATH:./vendor/bin"' ~/.zshrc; then
    echo "📝 Adding vendor/bin to PATH..."
    echo 'export PATH="$PATH:./vendor/bin"' >> ~/.zshrc
fi

./vendor/bin/sail build 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Add these new commands
echo "🔧 Installing dependencies inside container..."
./vendor/bin/sail composer install --no-interaction 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Then continue with the existing commands
./vendor/bin/sail up -d 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

./vendor/bin/sail artisan migrate 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Open Project in Cursor Editor
if command -v cursor &> /dev/null; then
    echo "🚀 Opening project in Cursor (VS Code)..."
    cursor .
else
    echo "⚠️  Cursor Editor (VS Code) not found. Please open the project manually."
fi

# Clean up the temporary script at the end
rm /tmp/helper_functions.sh

echo "✅ Laravel project setup complete!"
