#!/bin/bash

# $1 will be either "file" (for fd) or "content" (for ripgrep)

if [ "$1" == "file" ]; then
    target=$(fd --hidden --exclude .git --exclude .cache --type f --type d . "$HOME" "/mnt/PAVAN" | fzf --prompt="Find File/Dir > " --reverse)
    
    [ -z "$target" ] && exit 0

    if [ -d "$target" ]; then
        # Spawns Yazi in the selected directory using your floating window rules
        swaymsg exec "kitty --class yazi-float --working-directory '$target' -e yazi"
    else
        mime=$(file -b --mime-type "$target")
        if [[ "$mime" == text/* ]] || [[ "$mime" == application/json ]] || [[ "$mime" == inode/x-empty ]]; then
            swaymsg exec "kitty -e nvim '$target'"
        elif [[ "$mime" == "application/pdf" ]]; then
            # Catch PDFs explicitly and open them with Zathura
            swaymsg exec "zathura '$target'"
        else
            swaymsg exec "xdg-open '$target'"
        fi
    fi

elif [ "$1" == "content" ]; then
    # 1. Added -L (follow symlinks) and --hidden. 
    # 2. Added -g '!.git' so it doesn't waste time searching inside git history logs.
    RG_PREFIX="rg --color=always --line-number --no-heading --smart-case -L --hidden -g '!.git'"
    
    # Removed the manual single quotes around {q} because fzf applies them automatically
    target_line=$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '' ~/.config" \
        fzf --ansi --disabled --reverse --prompt="Search Content > " \
            --bind "change:reload:$RG_PREFIX {q} ~/.config || true"
    )
    
    [ -z "$target_line" ] && exit 0
    
    file=$(echo "$target_line" | awk -F: '{print $1}')
    line=$(echo "$target_line" | awk -F: '{print $2}')
    
    # Hand off to Sway to spawn Neovim at the exact line
    swaymsg exec "kitty -e nvim '+$line' '$file'"
fi
