source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj.fish
source (status dirname)/../functions/_pure_prompt_jj_change.fish
source (status dirname)/../functions/_pure_prompt_jj_dirty.fish
source (status dirname)/../functions/_pure_prompt_jj_conflicts.fish
source (status dirname)/../functions/_pure_prompt_jj_bookmarks.fish
source (status dirname)/../functions/_pure_is_inside_jj_repository.fish
source (status dirname)/../functions/_pure_string_width.fish
@echo (_print_filename (status filename))


function before_each
    _purge_configs
    _clean_all_mocks
    _disable_colors
    # Restore the original type command
    functions --erase type 2>/dev/null
end

function after_all
    _clean_all_mocks
    functions --erase type 2>/dev/null
end

# Helper to mock type to report jj as available
function _mock_jj_available
    function type
        if test "x$argv" = "x-q --no-functions jj"
            return $SUCCESS
        end
        # Fall back to builtin type for other commands
        builtin type $argv
    end
end

# Helper to mock type to report jj as NOT available
function _mock_jj_missing
    function type
        if test "x$argv" = "x-q --no-functions jj"
            return $FAILURE
        end
        # Fall back to builtin type for other commands
        builtin type $argv
    end
end


before_each
@test "_pure_prompt_jj: fails when jj is missing" (
    set --universal pure_enable_jj true
    _mock_jj_missing

    _pure_prompt_jj
    set exit_status $status

    echo $exit_status
) -eq $ABORT_FEATURE

before_each
@test "_pure_prompt_jj: ignores directory that are not jj repository" (
    set --universal pure_enable_jj true
    _mock_jj_available

    # Mock jj as available but not in a jj repo
    _mock_response _pure_is_inside_jj_repository $EMPTY

    _pure_prompt_jj
) $status -eq $SUCCESS

before_each
@test "_pure_prompt_jj: returns an empty string when pure_enable_jj is false" (
    set --universal pure_enable_jj false
    _mock_jj_available
    _mock_response _pure_is_inside_jj_repository /tmp/test_repo

    _pure_prompt_jj
) $status -eq $SUCCESS

before_each
@test "_pure_prompt_jj: shows change id when in jj repository" (
    set --universal pure_enable_jj true
    _mock_jj_available
    _mock_response _pure_is_inside_jj_repository /tmp/test_repo
    _mock_response _pure_prompt_jj_change wxyz
    _mock_response _pure_prompt_jj_dirty $EMPTY
    _mock_response _pure_prompt_jj_conflicts $EMPTY
    _mock_response _pure_prompt_jj_bookmarks $EMPTY

    _pure_prompt_jj
) = 'wxyz'

before_each
@test "_pure_prompt_jj: shows change id with dirty indicator" (
    set --universal pure_enable_jj true
    _mock_jj_available
    _mock_response _pure_is_inside_jj_repository /tmp/test_repo
    _mock_response _pure_prompt_jj_change wxyz
    _mock_response _pure_prompt_jj_dirty '*'
    _mock_response _pure_prompt_jj_conflicts $EMPTY
    _mock_response _pure_prompt_jj_bookmarks $EMPTY

    _pure_prompt_jj
) = 'wxyz*'

before_each
@test "_pure_prompt_jj: shows change id with conflict indicator" (
    set --universal pure_enable_jj true
    _mock_jj_available
    _mock_response _pure_is_inside_jj_repository /tmp/test_repo
    _mock_response _pure_prompt_jj_change wxyz
    _mock_response _pure_prompt_jj_dirty $EMPTY
    _mock_response _pure_prompt_jj_conflicts '!'
    _mock_response _pure_prompt_jj_bookmarks $EMPTY

    _pure_prompt_jj
) = 'wxyz!'

before_each
@test "_pure_prompt_jj: shows bookmarks" (
    set --universal pure_enable_jj true
    _mock_jj_available
    _mock_response _pure_is_inside_jj_repository /tmp/test_repo
    _mock_response _pure_prompt_jj_change wxyz
    _mock_response _pure_prompt_jj_dirty $EMPTY
    _mock_response _pure_prompt_jj_conflicts $EMPTY
    _mock_response _pure_prompt_jj_bookmarks main

    _pure_prompt_jj
) = 'wxyz main'

after_all
