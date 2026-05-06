function rm --wraps rm --description 'Confirm before deleting multiple files or directories'
    set -l files 0
    set -l dirs 0
    set -l parsing_options true

    for arg in $argv
        if test "$parsing_options" = true
            switch $arg
                case --
                    set parsing_options false
                    continue
                case '-*'
                    continue
            end
        end

        if test -d "$arg"; and not test -L "$arg"
            set dirs (math $dirs + (find "$arg" -type d -print0 | string split0 | count))
            set files (math $files + (find "$arg" ! -type d -print0 | string split0 | count))
        else if test -e "$arg"; or test -L "$arg"
            set files (math $files + 1)
        end
    end

    if test $dirs -gt 0; or test $files -gt 1
        read --local --prompt-str="rm: delete $files file(s), $dirs dir(s)? [y/N] " confirm

        if not contains -- (string lower -- $confirm) y yes
            return 130
        end
    end

    command rm $argv
end
