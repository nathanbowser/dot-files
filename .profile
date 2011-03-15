source `brew --prefix`/Library/Contributions/brew_bash_completion.sh
source `brew --prefix`/etc/bash_completion.d/git-completion.bash

PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '


