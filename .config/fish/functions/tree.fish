function tree
    set -l depth 3

    if test (count $argv) -gt 0; and string match --quiet --regex '^[0-9]+$' -- $argv[1]
        set depth $argv[1]
        set --erase argv[1]
    end

    eza --tree --level=$depth --color=always --icons=always --ignore-glob="$EZA_IGNORE" $argv
end
