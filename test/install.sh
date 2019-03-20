#!/bin/bash
if [[ $0 != 'debug' ]]; then
    set -e
fi

promptn() {
    read -p 'Will you run '$1'?[y/N]' PMT
    if [[ $PMT == 'y' || $PMT == 'Y' ]]; then
        . ./$1
    fi
}

prompty() {
    read -p 'Will you run '$1'?[Y/n]' PMT
    if [[ $PMT != 'n' || $PMT != 'N' ]]; then
        . ./$1
    fi
}

dependency() {
    echo 'Installing part of the dependencies...'
    sudo apt update
    sudo apt install git espeak cowsay oneko sl fortune fish mlocate
    sudo updatedb
}

gitclone() {
    if [ ! -d ~/.local/share ]; then mkdir -p ~/.local/share; fi
    git clone https://github.com/the0demiurge/CharlesScripts.git ~/.local/share/CharlesScripts
    read -p 'Please type your backup git repo address. If you do not have one, you may create it on GitHub.com.\nPress Enter to skip\n' REPO
    git clone $REPO $CHARLES_BACKUP || true
    if [[ ! -x $CHARLES_BACKUP ]]; then
        echo 'Clone failed! Default CharlesBackup will be cloned!'
        git clone https://github.com/the0demiurge/CharlesScripts.git $CHARLES_BACKUP
        echo 'You may modify $CHARLES_BACKUP, and type:'
        echo 'cd $CHARLES_BACKUP'
        echo 'git remote set-url origin <your-git-url>'
        echo 'git add -A; git commit -m "init commit";git push -u origin master'
    fi
}

get() {
    Y_LIST=(get-fasd
        # get-powerline)
        #get-oh-my-fish
        # get-thefuck)
    )

    # N_LIST=(get-calibre
    # get-docker
    # get-spacemacs
    # get-spacevim
    # get-sublime-text-3
    # get-xsh)

    for Y in ${Y_LIST[@]}; do
        cd ~/.local/share/CharlesScripts/charles/installation.d/get.d/
        prompty $Y
    done

    for N in ${N_LIST[@]}; do
        cd ~/.local/share/CharlesScripts/charles/installation.d/get.d/
        prompty $N
    done
}

conf() {
    Y_LIST=(config-bash
        # config-fish
        config-git
        config-powerline-bash
        config-tmux)

    N_LIST=(config-powerline-ipython)

    for Y in ${Y_LIST[@]}; do
        cd ~/.local/share/CharlesScripts/charles/installation.d/conf.d/
        echo $Y
        prompty $Y
    done

    for N in ${N_LIST[@]}; do
        cd ~/.local/share/CharlesScripts/charles/installation.d/conf.d/
        echo $N
        prompty $N
    done
}

restore() {
    read -p 'DANGER! Restore dotfiles from ~/.local/share/CharlesScripts/data/home/.* ?[y/N]' PMT
    if [[ $PMT == 'y' || $PMT == 'Y' ]]; then
        cp -rvi ~/.local/share/CharlesScripts/data/home/.* ~/ || true
    fi

    cd ~/.local/share/CharlesScripts/charles/bin

    # Y_LIST=(
    #         omf-restore)

    for Y in ${Y_LIST[@]}; do
        echo $Y
        prompty $Y
    done
}
dependency
gitclone
get
conf
restore

cd ~/.local/share/CharlesScripts/charles/installation.d/get.d/
prompty get-oh-my-fish
