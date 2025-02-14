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

# Create temporary script with helper functions
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
    local ascii_art_height=12
    local message_row=$((ascii_art_height + 2))
    
    messages=(
        "🧹 Dusting off the repository..."
        "🔄 Cloning in progress..."
        "🚀 Preparing for deployment..."
        "🤖 Configuring environment..."
        "🎮 Loading save game..."
        "🧙‍♂️ Casting clone spells..."
        "🎲 Rolling for successful clone..."
        "🎵 Playing git tunes..."
        "🔍 Finding project files..."
        "🌈 Adding development magic"
    )
    random_index=$((RANDOM % ${#messages[@]}))
    message="${messages[$random_index]}"
    
    echo -e "\033[${message_row};0H\033[K"
    echo -e "\033[${message_row};4H${message}"
}

show_command_output() {
    local output="$1"
    echo -e "\033[20;0H\033[K"
    echo "$output" | tail -n 3
}
EOFSCRIPT

# Source the helper functions
source /tmp/helper_functions.sh

# Print RootPi ASCII Art
print_rootpi

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker not found. Please install Docker first."
    exit 1
fi

if (! docker stats --no-stream &> /dev/null); then
    echo "⚠️  Docker is installed but not running. Please start Docker and try again."
    exit 1
fi

# Get GitHub URL
read -p "Enter the GitHub repository URL: " REPO_URL

# Extract project name from URL
PROJECT_NAME=$(basename "$REPO_URL" .git)

# Clone the repository
echo "🚀 Cloning repository..."
git clone "$REPO_URL" 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Change to project directory
cd "$PROJECT_NAME"

# Copy .env.example to .env
if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "✅ Created .env file from .env.example"
else
    echo "⚠️  No .env.example file found!"
    exit 1
fi

# Install composer dependencies
echo "📦 Installing Composer dependencies..."
docker run --rm -e TERM=xterm-256color -v $(pwd):/app -v /tmp/helper_functions.sh:/helper_functions.sh -w /app laravelsail/php83-composer:latest bash -c "
    source /helper_functions.sh &&
    composer install --no-interaction 2>&1 | while IFS= read -r line; do
        print_rootpi
        show_fun_message
        show_command_output \"\$line\"
    done
"

# Add Sail to PATH if not already added
if ! grep -q 'export PATH="$PATH:./vendor/bin"' ~/.zshrc; then
    echo "📝 Adding vendor/bin to PATH..."
    echo 'export PATH="$PATH:./vendor/bin"' >> ~/.zshrc
    source ~/.zshrc
fi

# Start Sail
echo "🚀 Starting Laravel Sail..."
./vendor/bin/sail up -d 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Generate application key
echo "🔑 Generating application key..."
./vendor/bin/sail artisan key:generate 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Run migrations
echo "🔄 Running database migrations..."
./vendor/bin/sail artisan migrate 2>&1 | while IFS= read -r line; do
    print_rootpi
    show_fun_message
    show_command_output "$line"
done

# Open in Cursor if available
if command -v cursor &> /dev/null; then
    echo "🚀 Opening project in Cursor (VS Code)..."
    cursor .
else
    echo "⚠️  Cursor Editor not found. Please open the project manually."
fi

# Clean up
rm /tmp/helper_functions.sh

echo "✅ Project setup complete!"
echo "🌟 You can now access:"
echo "   - Your application at: http://localhost"
echo "   - Pulse dashboard at: http://localhost/pulse"
echo "   - Horizon dashboard at: http://localhost/horizon"
echo ""
echo "💡 Use 'sail' command to manage your application:"
echo "   - sail up -d    # Start the application"
echo "   - sail down     # Stop the application"
echo "   - sail artisan  # Run artisan commands"
