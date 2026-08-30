FG_SURFACE2='\[\e[38;2;172;176;190m\]'  # acb0be
FG_CRUST='\[\e[38;2;220;224;232m\]'  # dce0e8
FG_SUBTEXT0='\[\e[01;38;2;108;111;133m\]'  # 6c6f85
FG_YELLOW='\[\e[01;38;2;223;142;29m\]'  # df8e1d
FG_MAROON='\[\e[01;38;2;230;69;83m\]'  # e64553
FG_GREEN='\[\e[01;38;2;64;160;43m\]'  # 40a02b
FG_LAVENDER='\[\e[38;2;114;135;253m\]'  # 7287fd
FG_TEAL='\[\e[38;2;23;146;153m\]'  # 179299
FG_PINK='\[\e[38;2;234;118;203m\]'  # ea76cb
BG_CRUST='\[\e[48;2;220;224;232m\]'  # dce0e8
COLOR_END='\[\033[0m'

function git_branch {
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ -n "$BRANCH" ]]; then

        UNTRACKED=$(git ls-files --other --no-empty-directory --exclude-standard)
        STATUS_U=""
        if [[ -n "$UNTRACKED" ]]; then
            STATUS_U="$FG_YELLOW$BG_CRUST ?$COLOR_END"
        fi
        MODIFIED=$(git ls-files -m)
        STATUS_M=""
        if [[ -n "$MODIFIED" ]]; then
            STATUS_M="$FG_MAROON$BG_CRUST !$COLOR_END"
        fi
        STAGED=$(git diff --name-only --cached)
        STATUS_S=""
        if [[ -n "$STAGED" ]]; then
            STATUS_S="$FG_GREEN$BG_CRUST $COLOR_END"
        fi
        STASHED=$(git stash list)
        STATUS_ST=""
        if [[ -n "$STASHED" ]]; then
            STATUS_ST="$FG_SUBTEXT0$BG_CRUST $COLOR_END"
        fi

        echo " $FG_CRUST$COLOR_END$FG_LAVENDER$BG_CRUST $BRANCH$COLOR_END$STATUS_U$STATUS_M$STATUS_S$STATUS_ST$FG_CRUST$COLOR_END"
    else
        echo ""
    fi
}


function python_env {
    VENV_NAME=$(basename $VIRTUAL_ENV 2> /dev/null)
    if [[ -n "$VENV_NAME" ]]; then
        echo " $FG_CRUST$COLOR_END$FG_TEAL$BG_CRUST󱔎 $VENV_NAME$COLOR_END$FG_CRUST$COLOR_END"
    fi
}

set_bash_prompt(){
    EXIT_CODE="$?"
    export PS1="\n$FG_SURFACE2┌ [\u@\H]$COLOR_END $FG_CRUST$COLOR_END$FG_PINK$BG_CRUST\w$COLOR_END$FG_CRUST$COLOR_END$(git_branch)$(python_env)$([ $EXIT_CODE -eq 0 ] && echo "" || echo $FG_MAROON  $EXIT_CODE$COLOR_END)\n$FG_SURFACE2└ $COLOR_END "
}

PROMPT_COMMAND=set_bash_prompt
export PS2="$FG_SURFACE2 $COLOR_END "
export VIRTUAL_ENV_DISABLE_PROMPT=1
