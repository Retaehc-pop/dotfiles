#!/usr/bin/env bash
# Claude Code status line — mirrors oh-my-posh base.toml style

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ANSI colors (Nord palette approximations for terminal dim rendering)
blue=$'\033[38;5;110m'   # #88c0d0
green=$'\033[38;5;150m'  # #a3be8c
yellow=$'\033[38;5;222m' # #ebcb8b
cyan=$'\033[38;5;116m'   # #8fbcbb
purple=$'\033[38;5;183m' # #b48ead
reset=$'\033[0m'

# Helper: convert a future unix epoch to "Xh Ym" human-readable string
human_until() {
    local epoch="$1"
    local now
    now=$(date +%s)
    local diff=$(( epoch - now ))
    if [ "$diff" -le 0 ]; then
        echo "now"
        return
    fi
    local hours=$(( diff / 3600 ))
    local mins=$(( (diff % 3600) / 60 ))
    if [ "$hours" -gt 0 ]; then
        printf "%dh%02dm" "$hours" "$mins"
    else
        printf "%dm" "$mins"
    fi
}

# --- Path (shorten home to ~) ---
home="$HOME"
display_path="${cwd/#$home/\~}"

# --- Git info (branch + dirty flag) ---
git_info=""
if git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null); then
    dirty=""
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        dirty="*"
    fi
    git_info=" ${green}${git_branch}${dirty}${reset}"
fi

# --- 5-hour session limit ---
five_info=""
if [ -n "$five_pct" ]; then
    five_int=$(printf "%.0f" "$five_pct")
    five_info=" ${purple}5h:${five_int}%${reset}"
fi

# --- 7-day rolling limit ---
week_info=""
if [ -n "$week_pct" ]; then
    week_int=$(printf "%.0f" "$week_pct")
    week_reset_str=""
    if [ -n "$week_resets" ]; then
        week_reset_str=" 󰑐 $(human_until "$week_resets")"
    fi
    week_info=" ${cyan}7d:${week_int}%${week_reset_str}${reset}"
fi

# --- Model ---
model_info=""
if [ -n "$model" ]; then
    model_info=" ${yellow}${model}${reset}"
fi

printf "${blue}%s${reset}%s%s%s%s" "$display_path" "$git_info" "$five_info" "$week_info" "$model_info"
