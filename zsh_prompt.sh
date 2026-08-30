setopt PROMPT_SUBST

function git_branch {
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ -n "$BRANCH" ]]; then

        UNTRACKED=$(git ls-files --other --no-empty-directory --exclude-standard)
        STATUS_U=""
        if [[ -n "$UNTRACKED" ]]; then
            STATUS_U="%F{#df8e1d}%K{#dce0e8}%B ?%f%k%b"
        fi
        MODIFIED=$(git ls-files -m)
        STATUS_M=""
        if [[ -n "$MODIFIED" ]]; then
            STATUS_M="%F{#e64553}%K{#dce0e8}%B !%f%k%b"
        fi
        STAGED=$(git diff --name-only --cached)
        STATUS_S=""
        if [[ -n "$STAGED" ]]; then
            STATUS_S="%F{#40a02b}%K{#dce0e8}%B %f%k%b"
        fi
        STASHED=$(git stash list)
        STATUS_ST=""
        if [[ -n "$STASHED" ]]; then
            STATUS_ST="%F{#6c6f85}%K{#dce0e8}%B %f%k%b"
        fi

        echo " %F{#dce0e8}%f%F{#7287fd}%K{#dce0e8} $BRANCH$STATUS_U$STATUS_M$STATUS_S$STATUS_ST%f%k%F{#dce0e8}%f"
    else
        echo ""
    fi
}


function python_env {
    VENV_NAME=$(basename $VIRTUAL_ENV 2> /dev/null)
    if [[ -n "$VENV_NAME" ]]; then
        echo " %F{#dce0e8}%f%F{#179299}%K{#dce0e8}󱔎 $VENV_NAME%f%k%F{#dce0e8}%f"
    fi
}

export PS1=$'\n''%F{#acb0be}┌ [%n@%m]%f %F{#dce0e8}%f%F{#ea76cb}%K{#dce0e8}%~%f%k%F{#dce0e8}%f$(git_branch)$(python_env)%(?..%F{#e64553}%B  %?%b%f)'$'\n''%F{#acb0be}└ %f '
export PS2='%F{#acb0be}  %f'
export VIRTUAL_ENV_DISABLE_PROMPT=1
