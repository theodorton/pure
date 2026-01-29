function _pure_prompt_jj_dirty \
    --description 'Display dirty indicator when jj working copy has changes'

    set --local jj_dirty_symbol
    set --local jj_dirty_color

    # In jj, "empty" means no changes in the working copy commit
    # We show the dirty symbol when the working copy is NOT empty (has changes)
    set --local is_dirty (
        command jj log -r @ --no-graph -T 'if(empty, "", "true")' --ignore-working-copy 2>/dev/null
    )

    if test -n "$is_dirty"
        set jj_dirty_symbol "$pure_symbol_jj_dirty"
        set jj_dirty_color (_pure_set_color $pure_color_jj_dirty)
    end

    echo "$jj_dirty_color$jj_dirty_symbol"
end
