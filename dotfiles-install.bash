#!/bin/bash -e

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

git clone --bare git@github.com:jamesgmorgan/.dotfiles.git $HOME/.dotfiles

backupFolder=~/.dotfiles-backup
mkdir -p $backupFolder

dotfiles checkout > /dev/null 2>&1 || exitStatus=1
if [ "$exitStatus" == "1" ]; then
    echo "Backing up pre-existing dot files to ${backupFolder}";
    cd ~
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ${backupFolder}/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no

# This is needed to get history on a revert, see:
# https://groups.google.com/forum/#!topic/git-users/stW21F_eNmI
# https://stackoverflow.com/questions/18784097/difference-between-different-refspecs-in-a-git-pull-call/18787744#18787744
dotfiles config --add remote.origin.fetch '+refs/*:refs/*'
