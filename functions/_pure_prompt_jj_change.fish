function _pure_prompt_jj_change \
    --description 'Display the current jj change ID'

    set --local jj_change_id (command jj log -r @ --no-graph -T 'change_id.shortest(4)' --ignore-working-copy 2>/dev/null)
    set --local jj_change_color (_pure_set_color $pure_color_jj_change)

    echo "$jj_change_color$jj_change_id"
end
