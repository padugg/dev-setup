#!/bin/bash

setup_git() {
    if [[ -f ~/.ssh/id_25519 ]]; then
        read -p "Enter your github.com email: " email
        ssh-keygen -t ed25519 -C "$email"
    fi

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519 

    grep 'Host github.com' ~/.ssh/config
    if [[ $? != 0 ]]; then
        echo 'Host github.com                                                                                                                                                                 HostName github.com
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes' >> ~/.ssh/config
    fi
}

setup_nvim() {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz

    grep 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"'  ~/.bashrc
    if [[ $? != 0 ]]; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
    fi

    # Configure Neovim
    mkdir ~/.config
    cd ~/.config/
    rm -rf ~/.config/nvim
    git clone git@github.com:evandeters/nvim.git

    grep 'alias vim=nvim'  ~/.bashrc
    if [[ $? != 0 ]]; then
        echo "alias vim=nvim" >> ~/.bashrc
        echo "alias vi=nvim" >> ~/.bashrc
    fi
}

setup_zoxide() {
    grep 'eval "$(zoxide init bash)"'  ~/.bashrc
    if [[ $? != 0 ]]; then
        echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    fi

    grep 'alias cd=z' ~/.bashrc
    if [[ $? != 0 ]]; then
        echo 'alias cd=z' >> ~/.bashrc
    fi
}

setup_git_alias() {
    grep '#gs()' ~/.bashrc
    if [[ $? != 0 ]]; then
        echo '#gs()' >> ~/.bashrc
        echo 'gs() {
    git status
}' >> ~/.bashrc
    echo >> ~/.bashrc
    fi

    grep '#gb()' ~/.bashrc
    if [[ $? != 0 ]]; then
        echo '#gb()' >> ~/.bashrc
        echo 'gb() {
    git branch
}' >> ~/.bashrc
    echo >> ~/.bashrc
    fi

    grep '#gto()' ~/.bashrc
    if [[ $? != 0 ]]; then
        echo '#gto()' >> ~/.bashrc
        echo 'gto() {
    branch=$1
    git switch $branch
}' >> ~/.bashrc
    echo >> ~/.bashrc
    fi
}

# Install Things
sudo dnf config-manager --set-enabled crb
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel{,-next}-release-latest-9.noarch.rpm
sudo dnf install make gcc zoxide git ansible -y

setup_git

setup_nvim

setup_zoxide

setup_git_alias

source ~/.bashrc
