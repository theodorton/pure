function _pure_prompt_jj_bookmarks \
    --description 'Display bookmarks at current jj revision or its parent'

    set --local jj_bookmarks_color (_pure_set_color $pure_color_jj_bookmarks)

    # First check for bookmarks at current revision (@)
    set --local bookmarks_at_current (
        command jj log -r @ --no-graph -T 'separate(" ", bookmarks.map(|b| b.name()))' --ignore-working-copy 2>/dev/null
    )

    if test -n "$bookmarks_at_current"
        echo "$jj_bookmarks_color$bookmarks_at_current"
        return
    end

    # If no bookmarks at current, check parent revision (@-)
    # This is useful because jj users often work on empty commits above a bookmark
    set --local bookmarks_at_parent (
        command jj log -r '@-' --no-graph -T 'separate(" ", bookmarks.map(|b| b.name()))' --ignore-working-copy 2>/dev/null
    )

    if test -n "$bookmarks_at_parent"
        # Show parent bookmarks with a prefix to indicate they're not at current revision
        set --local parent_prefix "$pure_symbol_jj_parent_bookmark"
        echo "$jj_bookmarks_color$parent_prefix$bookmarks_at_parent"
    end
end
