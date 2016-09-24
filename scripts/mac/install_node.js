
# Install nvm
echo "Install node version manager ..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash

# Load nvm
echo "Load nvm enviroment ..."
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node
echo "Install Node v6 by using nvm"
nvm install v6
