#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Install MariaDB
sudo apt install mariadb-server mariadb-client -y

# Install PHP and necessary extensions
sudo apt install php php-mysql libapache2-mod-php -y

# Install NVM (Node Version Manager) and Node.js (LTS version)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Load NVM to the current shell session
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest Node.js LTS version via NVM
nvm install --lts

# Optionally, install global npm packages (e.g., yarn, pm2)
npm install -g yarn pm2

# Install Golang (Download the latest version from the official site)
GO_VERSION="1.21.1"
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

# Remove any previous Go installation
sudo rm -rf /usr/local/go

# Install Go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

# Set up Go environment variables
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile

# Verify Go installation
go version

# Install MongoDB (add MongoDB repo, and install)
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Enable mod_rewrite for Apache
sudo a2enmod rewrite
sudo systemctl restart apache2

# Optionally set up MariaDB with a root password or create a database/user
sudo mysql_secure_installation

# Create a MariaDB database and user (Optional)
# sudo mysql -e "CREATE DATABASE my_database;"
# sudo mysql -e "CREATE USER 'my_user'@'localhost' IDENTIFIED BY 'my_password';"
# sudo mysql -e "GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'localhost';"
# sudo mysql -e "FLUSH PRIVILEGES;"

# Start and enable services
sudo systemctl start apache2
sudo systemctl start mariadb
sudo systemctl start mongod

# ---------------------------------------------------
# Install Docker
# ---------------------------------------------------

# Remove older versions of Docker if installed
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start Docker and enable it to run on boot
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group so that Docker commands can be run without sudo
sudo usermod -aG docker $USER

# Load new group settings without logging out
newgrp docker

# Verify Docker installation
docker --version
docker run hello-world  # Test Docker installation

# ---------------------------------------------------
# Install Git
# ---------------------------------------------------

# Install Git
sudo apt install git -y

# Configure Git (Optional)
# Replace with your own name and email
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# ---------------------------------------------------
# Install Visual Studio Code
# ---------------------------------------------------

# Install dependencies for VSCode
sudo apt install software-properties-common apt-transport-https wget -y

# Import Microsoft GPG key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

# Enable Visual Studio Code repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# Install Visual Studio Code
sudo apt update
sudo apt install code -y

# ---------------------------------------------------
# End of Script
# ---------------------------------------------------
