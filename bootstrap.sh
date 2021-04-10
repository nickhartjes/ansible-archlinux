#!/bin/bash
set -e

if [ ! "$HOME" == "$PWD" ]; then
  echo "This script is intended to be run from the user's home path: $HOME"
  exit 1
fi


# DEFAULTS
BRANCH="main"
ANSIBLE_ARGS=""

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -b|--branch)
    BRANCH="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# BOOTSTRAP
# Install Ansible & Git
sudo pacman -S git ansible

# Clone ansible-archlinux repo if not already present
if [ ! -d ".ansible-archlinux" ]; then
  git clone https://github.com/nickhartjes/ansible-archlinux.git .ansible-archlinux
fi

# Checkout specified branch
cd .ansible-archlinux
git checkout ${BRANCH}
git pull

# Run Ansible playbook
./install.sh