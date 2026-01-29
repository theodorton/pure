function _pure_prompt_jj_conflicts \
    --description 'Display conflict indicator when jj working copy has conflicts'

    set --local jj_conflict_symbol
    set --local jj_conflict_color

    set --local has_conflicts (
        command jj log -r @ --no-graph -T 'if(conflict, "true", "")' --ignore-working-copy 2>/dev/null
    )

    if test -n "$has_conflicts"
        set jj_conflict_symbol "$pure_symbol_jj_conflict"
        set jj_conflict_color (_pure_set_color $pure_color_jj_conflict)
    end

    echo "$jj_conflict_color$jj_conflict_symbol"
end
