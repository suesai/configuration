# man
set -gx MANPAGER                 "sh -c 'col -bx | bat -l man --style plain --paging=always'"
set -gx MANROFFOPT               "-c"

# editor
set -gx EDITOR                   nvim

# language
set -gx LC_ALL                   en_US.UTF-8
set -gx LANG                     en_US.UTF-8
set -gx LANGUAGE                 en_US.UTF-8
