#!/bin/sh
echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -sfn .zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Get oc cli for openshift and kubernetes
# Password is required to mv executables to /usr/local/bin on new rh managed macs
wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/macosx/oc.tar.gz
tar -xvf oc.tar.gz
sudo mv oc /usr/local/bin
sudo mv kubectl /usr/local/bin

# Install kubens (kubens is a tool to switch between Kubernetes namespaces (and configure them for kubectl) easily)
curl -sS https://webi.sh/kubens | sh

# Create a symlink for the system Java wrappers to find the JDK under Brew
ln -sfn \
     /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk.jdk

# Set macOS preferences - we will run this last because this will reload the shell
# shellcheck disable=SC2039
source ./.macos
