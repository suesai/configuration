# Keep eza file listings aligned with zsh's Tomorrow Night palette.
# Names use muted accent colours without bold or underline.
typeset -ga _zsh_tomorrow_night_ls_colors=(
	'di=38;2;129;162;190'  # directory: path blue
	'fi=38;2;197;200;198'  # regular file: foreground
	'ln=38;2;105;169;161'  # symlink: delimiter teal
	'or=38;2;204;102;102'  # broken symlink: error red
	'ex=38;2;181;189;104'  # executable: string green
	'pi=38;2;209;154;102'  # named pipe: redirection orange
	'so=38;2;178;148;187'  # socket: keyword purple
	'bd=38;2;240;198;116'  # block device: comment yellow
	'cd=38;2;240;198;116'  # character device: comment yellow
)

# Override eza's semantic file categories and long-format metadata so its
# built-in bright colours do not clash with the rest of the Tomorrow Night
# theme. LS_COLORS only accepts the standard file-kind keys; the additional
# keys below belong to eza.
typeset -ga _zsh_tomorrow_night_eza_colors=(
	'im=38;2;178;148;187'  # image
	'vi=38;2;178;148;187'  # video
	'mu=38;2;129;162;190'  # lossy music
	'lo=38;2;105;169;161'  # lossless music
	'cr=38;2;181;189;104'  # cryptographic file
	'do=38;2;197;200;198'  # document
	'co=38;2;209;154;102'  # compressed archive
	'tm=38;2;150;152;150'  # temporary file
	'cm=38;2;240;198;116'  # compilation artifact
	'bu=38;2;240;198;116'  # build file
	'sc=38;2;181;189;104'  # source file
	'sp=38;2;150;152;150'  # special file
	'bO=38;2;204;102;102'  # broken symlink target
	'ur=38;2;150;152;150'
	'uw=38;2;150;152;150'
	'ux=38;2;150;152;150'
	'ue=38;2;150;152;150'
	'gr=38;2;150;152;150'
	'gw=38;2;150;152;150'
	'gx=38;2;150;152;150'
	'tr=38;2;150;152;150'
	'tw=38;2;150;152;150'
	'tx=38;2;150;152;150'
	'su=38;2;240;198;116'
	'sf=38;2;240;198;116'
	'xa=38;2;150;152;150'
	'uu=38;2;150;152;150'
	'uR=38;2;204;102;102'
	'un=38;2;197;200;198'
	'gu=38;2;150;152;150'
	'gR=38;2;204;102;102'
	'gn=38;2;150;152;150'
	'lc=38;2;150;152;150'
	'lm=38;2;240;198;116'
	'ga=38;2;181;189;104'
	'gm=38;2;240;198;116'
	'gd=38;2;204;102;102'
	'gv=38;2;178;148;187'
	'gt=38;2;129;162;190'
	'gi=38;2;150;152;150'
	'gc=38;2;204;102;102'
	'Gm=38;2;181;189;104'
	'Go=38;2;129;162;190'
	'Gc=38;2;181;189;104'
	'Gd=38;2;240;198;116'
	'da=38;2;150;152;150'
	'in=38;2;150;152;150'
	'bl=38;2;150;152;150'
	'sn=38;2;150;152;150'
	'sb=38;2;150;152;150'
	'xx=38;2;150;152;150'
	'hd=38;2;150;152;150;4'
)

typeset -gx LS_COLORS="${(j.:.)_zsh_tomorrow_night_ls_colors}"
typeset -gx EZA_COLORS="${(j.:.)_zsh_tomorrow_night_eza_colors}"
unset _zsh_tomorrow_night_ls_colors _zsh_tomorrow_night_eza_colors
