function _pure_is_inside_jj_repository \
    --description 'Check if inside a jj repository'

    command jj root --ignore-working-copy 2>/dev/null
end
