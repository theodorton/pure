function _pure_prompt_jj \
    --description 'Print jj (jujutsu) repository information: change id, dirty state, conflicts, bookmarks'

    set ABORT_FEATURE 2

    if set --query pure_enable_jj; and test "$pure_enable_jj" != true
        return
    end

    if not type -q --no-functions jj # skip jj-related features when `jj` is not available
        return $ABORT_FEATURE
    end

    set --local is_jj_repository (_pure_is_inside_jj_repository)

    if test -n "$is_jj_repository"
        set --local jj_prompt (_pure_prompt_jj_change)(_pure_prompt_jj_dirty)(_pure_prompt_jj_conflicts)
        set --local jj_bookmarks (_pure_prompt_jj_bookmarks)

        if test (_pure_string_width "$jj_bookmarks") -ne 0
            set --append jj_prompt $jj_bookmarks
        end

        echo $jj_prompt
    end
end
