# -*-shell-script-*-

####################################################################
# Load local bashrc 
#  .bashrc.$MYHOST - version controlled
####################################################################
[ -f ~/.bashrc.$MYHOST ] && . ~/.bashrc.$MYHOST

#####################################################################
# Variables
#####################################################################
export MYGIT_CONFIGS=${MYGIT_CONFIGS:-~/git/configs}
export MYHOST=${MYHOST:?"MYHOST not defined....."}
export MYOS=${MYOS:?"MYOS not defined....."}

export PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ '
export PATH=$PATH:$MYGIT_CONFIGS/bin
export TERM=xterm-256color
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#ssh-agent
[ -x keychain ] && \
    eval `keychain --quiet --eval --agents ssh --inherit any-once --nogui id_dsa`

####################################################################
# Bash completions
####################################################################

# enable programmable completion features 
[ -f /etc/bash_completion ] && . /etc/bash_completion

# git completion
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash

#hostname complete for re re-add
complete -A hostname re re-add

#####################################################################
#aliases
#####################################################################
alias ls="ls -GCF"
alias sb=". ~/.bashrc"
alias eb="emacs -nw $MYGIT_CONFIGS/bashrc.common"
alias myscpresume="rsync --hard-links --archive --partial --progress --rsh=ssh"
alias myscpresume-cvsignore="rsync --cvs-exclude --hard-links --archive --partial --progress --rsh=ssh"
alias ec="emacs -nw"
alias mygit-log="git log --oneline --graph"

#Personal 
alias myavchd2iso="hdiutil makehybrid /Volumes/8GB\ SDHC/PRIVATE -o"
alias mybackup-mount="sshfs -ouid=1000 -ogid=1000 \
                      goli@goli-lnx:/media/securebackup /vol/securebackup/"
alias myvm-goli-bsd="nohup VBoxHeadless --comment \"FreeBSD 8.2\" --startvm 28db64a2-94cd-4bf1-8214-383d8a8f2824 < /dev/null > /dev/null 2>&1 &"
#work

####################################################################
# Functions
####################################################################

#Personal
function mync-fix() { sudo cp /etc/hosts.orig /etc/hosts ;
                      sudo kill -9 $(ps auxwww | grep [nN]cproxyd | awk '{print $2}'); }
function mymail-clean() { sqlite3 ~/Library/Mail/Envelope\ Index vacuum index; }
function mydvdcopy() { ddrescue -n -b2048 /dev/cdrom $1 $1.log; eject; }
function mydvdcopy-2ndpass () { ddrescue -b2048 /dev/cdrom $1 $1.log; eject; }
function mypassport-backup () {
    dst="readynas:/c/backup/My?Passport"
    opt="--archive --partial --progress --rsh=ssh --delete"

    rsync $opt  --exclude='Render?Files/' \
          /Volumes/My?Passport/Final?Cut?Projects/ $dst/Final?Cut?Projects
    rsync $opt /Volumes/My?Passport/Photos?Masters/ $dst/Photos?Masters
}

#Update X11 display
function myupdate-display() {
  display=$(netstat -an | grep 0\ [0-9,:,.]*:60..\  | awk '{print $4}' | tail -n 1)
  display=${display: -2}
  export DISPLAY=${HOSTNAME}:${display}.0
  echo $DISPLAY;
}

