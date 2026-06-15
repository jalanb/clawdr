#! /bin/cat

# fuzzy recency scoring for files/dirs/projects
#
# CONTEXT: Started with fuzzy set theory discussion for aggregating track ratings 
# to album ratings (London Calling analogy). We have files pre-processed into 
# time groups (last hour, day, week, etc.) and want fuzzy aggregation "up" 
# from files → directories → projects with strong recency bias.
#
# THE OVERALL VISION: Intelligent project discovery for "show recent projects"
# - Even one recently edited file should boost a directory's score significantly
# - Surface active work buried among stale files (20 old files + 1 fresh edit = high score)
# - Provide scoring primitives for other AI assistants to prioritize work
# - Bridge file timestamps to meaningful project activity signals
# - Uses OWA (Ordered Weighted Averaging) with decreasing weights [0.4, 0.3, 0.15...]
#
# USAGE PATTERN: 
#   file_recency file.txt                  # score individual file (1-5)
#   dir_recency ~/project/src              # score directory based on files  
#   project_recency ~/project              # score project based on directories
#   fuzzy_recent_projects_sorted ~/src     # list top recent projects
#
# FOR THE NEXT AI: These functions implement recency-biased fuzzy aggregation.
# Use them to surface recently active projects even when mixed with stale content.
# The scoring heavily weights recent signals while including mixed directories.
# Perfect for "what should I work on today?" queries.

file_recency () {
    local __doc__="""file recency score (1-5), based on access/modification times"""
    local file_="$1"
    [[ -f "$file_" ]] || return 1
    
    local now_=$(date +%s)
    local mtime_=$(stat -c %Y "$file_" 2>/dev/null || stat -f %m "$file_")
    local atime_=$(stat -c %X "$file_" 2>/dev/null || stat -f %a "$file_")
    local latest_=$mtime_
    [[ $atime_ -gt $mtime_ ]] && latest_=$atime_
    
    local age_=$(( (now_ - latest_) / 86400 ))  # days
    
    # Score: 5=today, 4=few days, 3=week, 2=month, 1=year
    [[ $age_ -eq 0 ]] && echo 5 && return 0
    [[ $age_ -le 3 ]] && echo 4 && return 0  
    [[ $age_ -le 7 ]] && echo 3 && return 0
    [[ $age_ -le 30 ]] && echo 2 && return 0
    [[ $age_ -le 365 ]] && echo 1 && return 0
    echo 0
}

fuzzy_aggregation () {
    local __doc__="""fuzzy aggregate ratings with recency bias"""
    [[ "$*" ]] || return 1
    
    # Sort ratings descending
    local sorted_=($(printf '%s\n' "$@" | sort -nr))
    local count_=${#sorted_[@]}
    
    # OWA weights favor high ratings
    local weights_=(0.4 0.3 0.15 0.1 0.05)
    local weighted_sum_=0
    local total_weight_=0
    local i_=0
    
    for rating_ in "${sorted_[@]}"; do
        local weight_=${weights_[$i_]:-0.01}  # tiny weight for extras
        weighted_sum_=$(echo "$weighted_sum_ + $rating_ * $weight_" | bc -l)
        total_weight_=$(echo "$total_weight_ + $weight_" | bc -l)
        i_=$((i_ + 1))
    done
    
    # Add small boost from overall average  
    local avg_=$(echo "scale=2; ($(IFS=+; echo "${sorted_[*]}")) / $count_" | bc -l)
    local boost_=$(echo "$avg_ * 0.1" | bc -l)
    
    local final_=$(echo "scale=1; $weighted_sum_ + $boost_" | bc -l)
    echo $final_
}

dir_recency () {
    local __doc__="""file directory recency scores"""
    local dir_="${1:-.}"
    [[ -d "$dir_" ]] || return 1
    
    local ratings_=()
    for file_ in "$dir_"/*; do
        [[ -f "$file_" ]] || continue
        ratings_+=($(file_recency "$file_"))
    done
    
    [[ ${#ratings_[@]} -gt 0 ]] || return 1
    fuzzy_aggregation "${ratings_[@]}"
}

project_recency () {
    local __doc__="""fuzzy project recency score"""
    local project_="${1:-.}"
    [[ -d "$project_" ]] || return 1
    
    local dir_scores_=()
    for subdir_ in "$project_"/*; do
        [[ -d "$subdir_" ]] || continue
        local score_=$(dir_recency "$subdir_")
        [[ $score_ ]] && dir_scores_+=($score_)
    done
    
    [[ ${#dir_scores_[@]} -gt 0 ]] || return 1
    fuzzy_aggregation "${dir_scores_[@]}"
}

# for debugging
file_recency_scores () {
    local __doc__="""show file recency scores"""
    local dir_="${1:-.}"
    [[ -d "$dir_" ]] || return 1
    
    for file_ in "$dir_"/*; do
        [[ -f "$file_" ]] || continue
        local score_=$(file_recency "$file_")
        printf "%s: %s\n" "$(basename "$file_")" "$score_"
    done
}

# for debugging
fuzzy_recent_projects_sorted () {
    local __doc__="""fuzzy recent projects sorted"""
    local projects_dir_="${1:-~/src}"
    [[ -d "$projects_dir_" ]] || return 1
    
    local scored_projects_=()
    for project_ in "$projects_dir_"/*; do
        [[ -d "$project_" ]] || continue
        local score_=$(project_recency "$project_")
        [[ $score_ ]] && scored_projects_+=("$score_:$(basename "$project_")")
    done
    
    printf '%s\n' "${scored_projects_[@]}" | sort -nr | head -10
}
