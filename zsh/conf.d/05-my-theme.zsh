# Match fish's "Tomorrow Night" theme in zsh's command-line editor.
# Preserve exact fish theme colours on true-colour terminals. Only fall back
# to the nearest 256-colour approximation when true colour is unavailable.
[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor 2>/dev/null

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f8285'
typeset -gA ZSH_HIGHLIGHT_STYLES
typeset -gA ZSH_HIGHLIGHT_REGEXP
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS

ZSH_HIGHLIGHT_HIGHLIGHTERS=(
	regexp main arithmetic shell_syntax redirection parameter shell_tokens \
		glob_qualifier word_expansion completion_file
)
ZSH_HIGHLIGHT_REGEXP+=(
	'[^-[:space:]][^[:space:]]*' 'fg=#81a2be'
)

ZSH_HIGHLIGHT_STYLES=(
	default                             'fg=#c5c8c6'
	unknown-token                      'fg=#cc6666'
	reserved-word                      'fg=#c47570'
	alias                              'fg=#b294bb'
	suffix-alias                       'fg=#b294bb'
	global-alias                       'fg=#81a2be'
	builtin                            'fg=#b294bb'
	function                           'fg=#b294bb'
	command                            'fg=#b294bb'
	hashed-command                     'fg=#b294bb'
	precommand                         'fg=#b294bb'
	commandseparator                   'fg=#969896,bold'
	autodirectory                      'fg=#81a2be'
	path                               'fg=#81a2be'
	path_pathseparator                 'fg=#81a2be'
	path_prefix                        'fg=#81a2be'
	path_prefix_pathseparator          'fg=#81a2be'
	globbing                           'fg=#81a2be,underline'
	history-expansion                  'fg=#b3a06d'
	command-substitution               'none'
	command-substitution-body          'fg=#81a2be'
	command-substitution-delimiter     'fg=#b3a06d'
	process-substitution               'none'
	process-substitution-delimiter     'fg=#bd8b52'
	arithmetic-expansion               'fg=#c5c8c6'
	arithmetic-expansion-delimiter     'fg=#b3a06d'
	arithmetic-operator                'fg=#969896,bold'
	test-delimiter                     'fg=#b3a06d,bold'
	single-hyphen-option               'fg=#81a2be'
	double-hyphen-option               'fg=#81a2be'
	back-quoted-argument               'fg=#b5bd68'
	back-quoted-argument-unclosed      'fg=#cc6666'
	back-quoted-argument-delimiter     'fg=#b3a06d'
	single-quoted-argument             'fg=#b5bd68'
	single-quoted-argument-unclosed    'fg=#cc6666'
	double-quoted-argument             'fg=#b5bd68'
	double-quoted-argument-unclosed    'fg=#cc6666'
	dollar-quoted-argument             'fg=#b5bd68'
	dollar-quoted-argument-unclosed    'fg=#cc6666'
	rc-quote                           'fg=#b5bd68'
	dollar-double-quoted-argument      'fg=#8abeb7'
	back-double-quoted-argument        'fg=#8abeb7'
	back-dollar-quoted-argument        'fg=#8abeb7'
	parameter                          'fg=#8abeb7'
	assign                             'fg=#8abeb7'
	assign-operator                    'fg=#969896'
	structure                          'fg=#b3a06d'
	redirection                        'fg=#bd8b52'
	comment                            'fg=#f0c674'
	named-fd                           'fg=#bd8b52'
	numeric-fd                         'fg=#81a2be'
	arg0                               'fg=#cc6666'
)

# Highlight unquoted parameter expansions with the same colour as parameter
# expansions inside double quotes. Quoted strings retain their own style.
_zsh_highlight_highlighter_parameter_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_parameter_paint() {
	local quote='' escaped=0 char next
	integer i=1 end length=${#BUFFER}

	while (( i <= length )); do
		char="${BUFFER[i]}"
		if (( escaped )); then
			escaped=0
		elif [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
		elif [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
		elif [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
		elif [[ -z "$quote" && "$char" == '$' ]]; then
			next="${BUFFER[i+1]}"
			case "$next" in
				('{')
					end=$(( i + 1 ))
					while (( end <= length )) &&
						[[ "${BUFFER[end]}" != '}' ]]; do
						(( end++ ))
					done
					(( end <= length )) || end=$length
					_zsh_highlight_add_highlight \
						$(( i - 1 )) "$end" parameter
					i=$(( end + 1 ))
					continue
					;;
				('('|"'"|'"')
					;;
				([A-Za-z_])
					end=$i
					while (( end < length )) &&
						[[ "${BUFFER[end+1]}" == [[:alnum:]_] ]]; do
						(( end++ ))
					done
					_zsh_highlight_add_highlight \
						$(( i - 1 )) "$end" parameter
					i=$(( end + 1 ))
					continue
					;;
				([0-9?#@*!$-])
					_zsh_highlight_add_highlight \
						$(( i - 1 )) $(( i + 1 )) parameter
					(( i += 2 ))
					continue
					;;
			esac
		fi
		(( i++ ))
	done
}

_zsh_highlight_highlighter_shell_tokens_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_shell_tokens_apply() {
	local word="${BUFFER[$1,$2]}"
	REPLY=0
	[[ "$word" == '[[' || "$word" == ']]' ]] && return

	if [[ "$word" == [[:alpha:]_][[:alnum:]_]#(|\[*\])(|[+])=* ]]; then
		local lhs="${word%%=*}" rhs="${word#*=}"
		integer name_end=$(( $1 + ${#lhs} - 1 ))
		integer equals_pos=$(( name_end + 1 ))
		_zsh_highlight_add_highlight $(( $1 - 1 )) "$name_end" assign
		_zsh_highlight_add_highlight \
			$(( equals_pos - 1 )) "$equals_pos" assign-operator
		if [[ "$rhs" == [[:alnum:]_.#%/-]## ]]; then
			_zsh_highlight_add_highlight \
				"$equals_pos" "$2" default
		fi
		REPLY=1
	elif (( $3 )); then
		_zsh_highlight_add_highlight $(( $1 - 1 )) "$2" globbing
	elif [[ "$word" == '{' || "$word" == '}' ]]; then
		_zsh_highlight_add_highlight $(( $1 - 1 )) "$2" structure
		[[ "$word" == '{' ]] && REPLY=1
	elif [[ "$word" == 'in' || ${reswords[(Ie)$word]} -gt 0 ]]; then
		_zsh_highlight_add_highlight $(( $1 - 1 )) "$2" reserved-word
		[[ "$word" == (do|then|else|elif|if|while|until|!|time|coproc|'{'|'(' ) ]] &&
			REPLY=1
	elif (( $4 )) && [[ "$word" == [[:alnum:]_.#%/-]## &&
		"$word" != -* && "$word" != [0-9]## ]]; then
		local expanded="${(Q)word}"
		if [[ "$expanded" != (/*|./*|../*|~*) ]] &&
			[[ ! -e "$expanded" ]]; then
			_zsh_highlight_add_highlight $(( $1 - 1 )) "$2" default
		fi
	fi
}

_zsh_highlight_highlighter_shell_tokens_paint() {
	emulate -L zsh
	setopt localoptions extendedglob

	integer i=1 length=${#BUFFER} token_start=0
	integer token_has_glob=0 command_position=1
	integer separator_lookback separator_has_space
	local quote='' escaped=0 char

	while (( i <= length )); do
		char="${BUFFER[i]}"
		if (( escaped )); then
			escaped=0
		elif [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
			(( token_start )) || token_start=$i
		elif [[ "$char" == "'" && "$quote" != '"' ]]; then
			(( token_start )) || token_start=$i
			[[ "$quote" == "'" ]] && quote='' || quote="'"
		elif [[ "$char" == '"' && "$quote" != "'" ]]; then
			(( token_start )) || token_start=$i
			[[ "$quote" == '"' ]] && quote='' || quote='"'
		elif [[ -z "$quote" && "$char" == [[:space:]\;\|\&\<\>\(\)] ]]; then
			if (( token_start )); then
				_zsh_highlight_shell_tokens_apply \
					"$token_start" $(( i - 1 )) \
					"$token_has_glob" "$(( ! command_position ))"
				(( REPLY )) || command_position=0
				token_start=0
				token_has_glob=0
			fi
			separator_lookback=$(( i - 1 ))
			separator_has_space=0
			while (( separator_lookback > 0 )) &&
				[[ "${BUFFER[separator_lookback]}" == [[:space:]] ]]; do
				separator_has_space=1
				(( separator_lookback-- ))
			done
			if [[ "$char" == ';' &&
				"${BUFFER[separator_lookback]}" == [\&\|] ]]; then
				_zsh_highlight_add_highlight \
					$(( i - 1 )) "$i" commandseparator
			elif [[ "$char" == ';' ]] &&
				(( separator_has_space )) &&
				[[ "${BUFFER[separator_lookback]}" == ';' ]]; then
				_zsh_highlight_add_highlight \
					$(( i - 1 )) "$i" commandseparator
			fi
			[[ "$char" == [\;\|\&\(] ]] && command_position=1
		else
			(( token_start )) || token_start=$i
			if [[ -z "$quote" && "$char" == [*?[] ]]; then
				token_has_glob=1
			fi
		fi
		(( i++ ))
	done

	if (( token_start )); then
		_zsh_highlight_shell_tokens_apply \
			"$token_start" "$length" "$token_has_glob" "$(( ! command_position ))"
	fi
}

_zsh_highlight_highlighter_glob_qualifier_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_glob_qualifier_paint() {
	emulate -L zsh
	setopt localoptions extendedglob

	integer i=1 j depth length=${#BUFFER} start close_start
	local quote='' escaped=0 char

	while (( i <= length )); do
		char="${BUFFER[i]}"
		if (( escaped )); then
			escaped=0
		elif [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
		elif [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
		elif [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
		elif [[ -z "$quote" && "$char" == [*?[] ]]; then
			start=$i
			while (( start > 1 )) &&
				[[ "${BUFFER[start-1]}" != [[:space:]\;\|\&\<\>\(\)] ]]; do
				(( start-- ))
			done
			j=$i
			while (( j <= length )) &&
				[[ "${BUFFER[j]}" != [[:space:]\;\|\&\<\>\(\)] ]]; do
				(( j++ ))
			done
			if (( j <= length )) && [[ "${BUFFER[j]}" == '(' ]]; then
				depth=1
				close_start=0
				(( j++ ))
				while (( j <= length )); do
					char="${BUFFER[j]}"
					if [[ "$char" == '(' ]]; then
						(( depth++ ))
					elif [[ "$char" == ')' ]]; then
						(( depth-- ))
						if (( depth == 0 )); then
							close_start=$j
							break
						fi
					fi
					(( j++ ))
				done
				if (( close_start )); then
					_zsh_highlight_add_highlight \
						$(( start - 1 )) "$close_start" globbing
					i=$(( close_start + 1 ))
					continue
				fi
			fi
		fi
		(( i++ ))
	done
}

_zsh_highlight_highlighter_word_expansion_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_word_expansion_paint() {
	emulate -L zsh
	setopt localoptions extendedglob

	integer i=1 j k length=${#BUFFER} depth close_start slash
	local quote='' escaped=0 char word raw_path prefix_path suffix

	while (( i <= length )); do
		char="${BUFFER[i]}"
		if (( escaped )); then
			escaped=0
			(( i++ ))
			continue
		fi
		if [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
			(( i++ ))
			continue
		fi
		if [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
			(( i++ ))
			continue
		fi
		if [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
			(( i++ ))
			continue
		fi

		# Brace expansion: {a,b} and {1..3}. Command groups are excluded
		# because they contain unquoted whitespace.
		if [[ -z "$quote" && "$char" == '{' &&
			"${BUFFER[i-1]}" != '$' ]]; then
			depth=1
			close_start=0
			j=$(( i + 1 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '{' ]]; then
					(( depth++ ))
				elif [[ "$char" == '}' ]]; then
					(( depth-- ))
					if (( depth == 0 )); then
						close_start=$j
						break
					fi
				elif [[ "$char" == [[:space:]] ]]; then
					break
				fi
				(( j++ ))
			done
			if (( close_start )); then
				word="${BUFFER[i,close_start]}"
				if [[ "${word[2,-2]}" == [[:alpha:]_][[:alnum:]_]## &&
					"${BUFFER[close_start+1]}" == [\<\>] ]]; then
					_zsh_highlight_add_highlight \
						$(( i - 1 )) "$i" structure
					_zsh_highlight_add_highlight \
						$(( close_start - 1 )) "$close_start" structure
					i=$(( close_start + 1 ))
					continue
				elif [[ "$word" == *,* || "$word" == *..* ]]; then
					_zsh_highlight_add_highlight \
						$(( i - 1 )) "$i" structure
					_zsh_highlight_add_highlight \
						$(( close_start - 1 )) "$close_start" structure
					for (( k = i + 1; k < close_start; k++ )); do
						char="${BUFFER[k]}"
						if [[ "$char" == ',' ]]; then
							_zsh_highlight_add_highlight \
								$(( k - 1 )) "$k" structure
						elif [[ "${BUFFER[k,k+1]}" == '..' ]]; then
							_zsh_highlight_add_highlight \
								$(( k - 1 )) $(( k + 1 )) structure
							(( k++ ))
						fi
					done
					i=$(( close_start + 1 ))
					continue
				fi
			fi
		fi

		(( i++ ))
	done

	# Split a non-existent path into an existing directory prefix and a normal
	# basename. This applies to redirection targets too: only redirection syntax
	# belongs to the I/O family, while a path retains normal path semantics.
	i=1
	while (( i <= length )); do
		while (( i <= length )) &&
			[[ "${BUFFER[i]}" == [[:space:]\;\|\&\<\>\(\)] ]]; do
			(( i++ ))
		done
		(( i <= length )) || break
		j=$i
		while (( j <= length )) &&
			[[ "${BUFFER[j]}" != [[:space:]\;\|\&\<\>\(\)] ]]; do
			(( j++ ))
		done
		word="${BUFFER[i,j-1]}"
		k=$(( i - 1 ))
		while (( k > 0 )) && [[ "${BUFFER[k]}" == [[:space:]] ]]; do
			(( k-- ))
		done
		if [[ "$word" == */* && "$word" != *'$'* && "$word" != *'`'* &&
			"$word" != *[\*\?\[]* && "$word" != -* && "$word" != *=* ]]; then
			raw_path="${(Q)word}"
			if [[ "$raw_path" == '~/'* ]]; then
				raw_path="${HOME}/${raw_path#\~/}"
			elif [[ "$raw_path" != /* ]]; then
				raw_path="${PWD}/${raw_path}"
			fi
			slash=${word[(I)/]}
			suffix="${word[slash+1,-1]}"
			prefix_path="${(Q)${word[1,slash]}}"
			if [[ "$prefix_path" == '~/'* ]]; then
				prefix_path="${HOME}/${prefix_path#\~/}"
			elif [[ "$prefix_path" != /* ]]; then
				prefix_path="${PWD}/${prefix_path}"
			fi
			if [[ ! -e "$raw_path" && -d "$prefix_path" && -n "$suffix" ]]; then
				_zsh_highlight_add_highlight \
					$(( i - 1 )) $(( i + slash - 1 )) path
				_zsh_highlight_add_highlight \
					$(( i + slash - 1 )) $(( j - 1 )) default
			fi
		fi
		i=$j
	done
}

zle_highlight=(
	region:fg=white,bg=8,bold
	isearch:fg=white,bg=8,bold
	special:standout
	paste:standout
)

# zsh-syntax-highlighting styles arithmetic expansions as one region. Split
# delimiters and operators out so the expression matches fish's visual layers.
_zsh_highlight_highlighter_arithmetic_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_arithmetic_paint() {
	integer i=1 j length=${#BUFFER} depth close_start last
	local quote='' escaped=0 char
	local operator_chars='()+-*/%<>=!&|^~?:$'

	while (( i <= length )); do
		char="${BUFFER[i]}"

		if (( escaped )); then
			escaped=0
			(( i++ ))
			continue
		fi
		if [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
			(( i++ ))
			continue
		fi
		if [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
			(( i++ ))
			continue
		fi
		if [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
			(( i++ ))
			continue
		fi
		if [[ -z "$quote" && "$char" == '#' &&
			( $i -eq 1 || "${BUFFER[i-1]}" == [[:space:]] ) ]]; then
			break
		fi
		if [[ "$quote" != "'" && "${BUFFER[i,i+2]}" == "\$((" ]]; then
			depth=2
			close_start=0
			j=$(( i + 3 ))

			while (( j <= length )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '(' ]]; then
					(( depth++ ))
				elif [[ "$char" == ')' ]]; then
					(( depth-- ))
					if (( depth == 0 )); then
						close_start=$(( j - 1 ))
						break
					fi
				fi
				(( j++ ))
			done

			# The main highlighter owns the purple expression body. This
			# highlighter separates structural delimiters from operators.
			_zsh_highlight_add_highlight \
				$(( i - 1 )) $(( i + 2 )) arithmetic-expansion-delimiter
			last=$(( close_start ? close_start - 1 : length ))

			# In command position zsh can classify the inner expression as an
			# unknown token. Repaint the complete body before operators.
			if (( last >= i + 2 )); then
				_zsh_highlight_add_highlight \
					$(( i + 2 )) "$last" arithmetic-expansion
			fi
			for (( j = i + 3; j <= last; j++ )); do
				char="${BUFFER[j]}"
				if [[ -n "$char" && "$operator_chars" == *"$char"* ]]; then
					_zsh_highlight_add_highlight \
						$(( j - 1 )) "$j" arithmetic-operator
				fi
			done
			if (( close_start )); then
				_zsh_highlight_add_highlight \
					$(( close_start - 1 )) $(( close_start + 1 )) \
					arithmetic-expansion-delimiter
				i=$(( close_start + 2 ))
			else
				break
			fi
			continue
		fi
		(( i++ ))
	done
}

# zsh-syntax-highlighting clears highlighted operands inside [[ ... ]] and
# styles grouping parentheses like commands. Keep structural syntax distinct
# and style command-like test operands with the normal command color.
_zsh_highlight_highlighter_shell_syntax_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_shell_syntax_style_test_operators() {
	setopt localoptions extendedglob
	integer j=$1 end=$2 word_start
	local char inner_quote word

	while (( j < end )); do
		while (( j < end )) && [[ "${BUFFER[j]}" == [[:space:]] ]]; do
			(( j++ ))
		done
		word_start=$j
		if (( j >= end )); then
			break
		fi

		char="${BUFFER[j]}"
		if [[ "$char" == "'" || "$char" == '"' ]]; then
			inner_quote=$char
			(( j++ ))
			while (( j < end )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '\' && "$inner_quote" != "'" ]]; then
					(( j += 2 ))
					continue
				fi
				[[ "$char" == "$inner_quote" ]] && { (( j++ )); break }
				(( j++ ))
			done
		else
			while (( j < end )) && [[ "${BUFFER[j]}" != [[:space:]] ]]; do
				(( j++ ))
			done
			word="${BUFFER[word_start,j-1]}"
			case "$word" in
				('&&'|'||'|'!')
					_zsh_highlight_add_highlight \
						$(( word_start - 1 )) $(( j - 1 )) commandseparator
					;;
				('=='|'!='|'=~'|'-eq'|'-ne'|'-gt'|'-ge'|'-lt'|'-le')
					_zsh_highlight_add_highlight \
						$(( word_start - 1 )) $(( j - 1 )) arithmetic-operator
					;;
			esac
		fi
	done
}

_zsh_highlight_highlighter_shell_syntax_paint() {
	setopt localoptions extendedglob
	integer i=1 j depth length=${#BUFFER} open_start close_start word_start
	local quote='' inner_quote='' escaped=0 inner_escaped=0
	local char previous word

	while (( i <= length )); do
		char="${BUFFER[i]}"

		if (( escaped )); then
			escaped=0
			(( i++ ))
			continue
		fi
		if [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
			(( i++ ))
			continue
		fi
		if [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
			(( i++ ))
			continue
		fi
		if [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
			(( i++ ))
			continue
		fi
		if [[ -z "$quote" && "$char" == '#' &&
			( $i -eq 1 || "${BUFFER[i-1]}" == [[:space:]] ) ]]; then
			break
		fi

		# Parentheses belonging to expansions are handled by the main
		# highlighter and the arithmetic/redirection layers.
		if [[ "$quote" != "'" && "${BUFFER[i,i+2]}" == "\$((" ]]; then
			depth=2
			j=$(( i + 3 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '(' ]]; then
					(( depth++ ))
				elif [[ "$char" == ')' ]]; then
					(( depth-- ))
					(( depth == 0 )) && break
				fi
				(( j++ ))
			done
			i=$(( depth == 0 ? j + 1 : length + 1 ))
			continue
		fi

		# In command position zsh can treat a command substitution as an
		# unknown command word. Reapply its delimiters and inner syntax first.
		if [[ "$quote" != "'" && "$char" == '$' &&
			"${BUFFER[i+1]}" == '(' && "${BUFFER[i+2]}" != '(' ]]; then
			depth=1
			inner_quote=''
			inner_escaped=0
			close_start=0
			j=$(( i + 2 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if (( inner_escaped )); then
					inner_escaped=0
				elif [[ "$char" == '\' && "$inner_quote" != "'" ]]; then
					inner_escaped=1
				elif [[ "$char" == "'" && "$inner_quote" != '"' ]]; then
					[[ "$inner_quote" == "'" ]] && inner_quote='' || inner_quote="'"
				elif [[ "$char" == '"' && "$inner_quote" != "'" ]]; then
					[[ "$inner_quote" == '"' ]] && inner_quote='' || inner_quote='"'
				elif [[ -z "$inner_quote" && "$char" == '(' ]]; then
					(( depth++ ))
				elif [[ -z "$inner_quote" && "$char" == ')' ]]; then
					(( depth-- ))
					if (( depth == 0 )); then
						close_start=$j
						break
					fi
				fi
				(( j++ ))
			done
			if (( close_start )); then
				if (( close_start > i + 2 )); then
					_zsh_highlight_add_highlight \
						$(( i + 1 )) $(( close_start - 1 )) \
						command-substitution-body
				fi
				_zsh_highlight_add_highlight \
					$(( i - 1 )) $(( i + 1 )) command-substitution-delimiter
				_zsh_highlight_add_highlight \
					$(( close_start - 1 )) "$close_start" \
					command-substitution-delimiter

				j=$(( i + 2 ))
				while (( j < close_start )) &&
					[[ "${BUFFER[j]}" == [[:space:]] ]]; do
					(( j++ ))
				done
				word_start=$j
				while (( j < close_start )) &&
					[[ "${BUFFER[j]}" != [[:space:]\;\|\(\<\>] ]]; do
					(( j++ ))
				done
				word="${BUFFER[word_start,j-1]}"
				if [[ "$word" == [[:alpha:]_][[:alnum:]_./-]## ]]; then
					_zsh_highlight_add_highlight \
						$(( word_start - 1 )) $(( j - 1 )) command
				fi
				i=$(( close_start + 1 ))
				continue
			fi
		fi

		previous="${BUFFER[i-1]}"
		if [[ -z "$quote" && "$char" == '(' &&
			"$previous" != '$' && "$previous" != '<' && "$previous" != '>' ]]; then
			depth=1
			inner_quote=''
			j=$(( i + 1 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '\' && "$inner_quote" != "'" ]]; then
					(( j += 2 ))
					continue
				fi
				if [[ "$char" == "'" && "$inner_quote" != '"' ]]; then
					[[ "$inner_quote" == "'" ]] && inner_quote='' || inner_quote="'"
				elif [[ "$char" == '"' && "$inner_quote" != "'" ]]; then
					[[ "$inner_quote" == '"' ]] && inner_quote='' || inner_quote='"'
				elif [[ -z "$inner_quote" && "$char" == '(' ]]; then
					(( depth++ ))
				elif [[ -z "$inner_quote" && "$char" == ')' ]]; then
					(( depth-- ))
					(( depth == 0 )) && break
				fi
				(( j++ ))
			done
			if (( depth == 0 )); then
				_zsh_highlight_add_highlight \
					$(( i - 1 )) "$i" commandseparator
				_zsh_highlight_add_highlight \
					$(( j - 1 )) "$j" commandseparator
			fi
			(( i++ ))
			continue
		fi

		# A standalone "[" is the test builtin; "[abc]" remains a glob pattern.
		if [[ -z "$quote" && "$char" == '[' &&
			"${BUFFER[i+1]}" != '[' &&
			( -z "$previous" || "$previous" == [[:space:]\;\|\(\&] ) &&
			"${BUFFER[i+1]}" == [[:space:]] ]]; then
			close_start=0
			inner_quote=''
			inner_escaped=0
			j=$(( i + 1 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if (( inner_escaped )); then
					inner_escaped=0
				elif [[ "$char" == '\' && "$inner_quote" != "'" ]]; then
					inner_escaped=1
				elif [[ "$char" == "'" && "$inner_quote" != '"' ]]; then
					[[ "$inner_quote" == "'" ]] && inner_quote='' || inner_quote="'"
				elif [[ "$char" == '"' && "$inner_quote" != "'" ]]; then
					[[ "$inner_quote" == '"' ]] && inner_quote='' || inner_quote='"'
				elif [[ -z "$inner_quote" && "$char" == ']' &&
					"${BUFFER[j-1]}" == [[:space:]] &&
					( $j -eq $length ||
						"${BUFFER[j+1]}" == [[:space:]\;\|\(\&] ) ]]; then
					close_start=$j
					break
				fi
				(( j++ ))
			done
			if (( close_start )); then
				_zsh_highlight_add_highlight \
					$(( i - 1 )) "$i" test-delimiter
				_zsh_highlight_add_highlight \
					$(( close_start - 1 )) "$close_start" test-delimiter
				_zsh_highlight_shell_syntax_style_test_operators \
					$(( i + 2 )) "$close_start"
			fi
			(( i++ ))
			continue
		fi

		if [[ -n "$quote" || "$char" != '[' ||
			"${BUFFER[i+1]}" != '[' ]]; then
			(( i++ ))
			continue
		fi

		open_start=$i
		close_start=0
		inner_quote=''
		inner_escaped=0
		j=$(( i + 2 ))
		while (( j <= length )); do
			char="${BUFFER[j]}"
			if (( inner_escaped )); then
				inner_escaped=0
			elif [[ "$char" == '\' && "$inner_quote" != "'" ]]; then
				inner_escaped=1
			elif [[ "$char" == "'" && "$inner_quote" != '"' ]]; then
				[[ "$inner_quote" == "'" ]] && inner_quote='' || inner_quote="'"
			elif [[ "$char" == '"' && "$inner_quote" != "'" ]]; then
				[[ "$inner_quote" == '"' ]] && inner_quote='' || inner_quote='"'
			elif [[ -z "$inner_quote" && "$char" == ']' &&
				"${BUFFER[j+1]}" == ']' ]]; then
				close_start=$j
				break
			fi
			(( j++ ))
		done

		_zsh_highlight_add_highlight \
			$(( open_start - 1 )) $(( open_start + 1 )) test-delimiter
		if (( close_start )); then
			_zsh_highlight_add_highlight \
				$(( close_start - 1 )) $(( close_start + 1 )) test-delimiter
			_zsh_highlight_shell_syntax_style_test_operators \
				$(( open_start + 2 )) "$close_start"
		fi

		if (( close_start )); then
			i=$(( close_start + 2 ))
		else
			i=$(( open_start + 2 ))
		fi
	done
}

# Redirections have two distinct roles. Their syntax (FD declarations/numbers,
# operators and numeric dup targets) belongs to the I/O family. A filename
# target does not: it keeps the normal argument/path colouring below.
_zsh_highlight_highlighter_redirection_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_redirection_paint() {
	emulate -L zsh
	setopt localoptions extendedglob

	integer i=1 j k length=${#BUFFER} depth
	integer token_start operator_end target_start target_end
	integer named_fd_start operator_length
	local quote='' target_quote='' escaped=0 target_escaped=0 char
	local operator_tail

	while (( i <= length )); do
		char="${BUFFER[i]}"

		if (( escaped )); then
			escaped=0
			(( i++ ))
			continue
		fi
		if [[ "$char" == '\' && "$quote" != "'" ]]; then
			escaped=1
			(( i++ ))
			continue
		fi
		if [[ "$char" == "'" && "$quote" != '"' ]]; then
			[[ "$quote" == "'" ]] && quote='' || quote="'"
			(( i++ ))
			continue
		fi
		if [[ "$char" == '"' && "$quote" != "'" ]]; then
			[[ "$quote" == '"' ]] && quote='' || quote='"'
			(( i++ ))
			continue
		fi
		if [[ -z "$quote" && "$char" == '#' &&
			( $i -eq 1 || "${BUFFER[i-1]}" == [[:space:]] ) ]]; then
			break
		fi

		# Arithmetic comparison operators are not shell redirections.
		if [[ "$quote" != "'" && "${BUFFER[i,i+2]}" == "\$((" ]]; then
			depth=2
			j=$(( i + 3 ))
			while (( j <= length )); do
				char="${BUFFER[j]}"
				if [[ "$char" == '(' ]]; then
					(( depth++ ))
				elif [[ "$char" == ')' ]]; then
					(( depth-- ))
					(( depth == 0 )) && break
				fi
				(( j++ ))
			done
			i=$(( depth == 0 ? j + 1 : length + 1 ))
			continue
		fi

		# Process substitutions use '<(' and '>(' and are not redirections.
		if [[ -z "$quote" && ( "$char" == '<' || "$char" == '>' ) &&
			"${BUFFER[i+1]}" == '(' ]]; then
			(( i++ ))
			continue
		fi
		if [[ -n "$quote" ]] ||
			[[ "$char" != '<' && "$char" != '>' &&
				( "$char" != '&' ||
					"${BUFFER[i+1]}" != [\<\>] ) ]]; then
			(( i++ ))
			continue
		fi

		token_start=$i
		if [[ "$char" == '<' || "$char" == '>' ]]; then
			k=$(( i - 1 ))
			if [[ "${BUFFER[k]}" == '}' ]]; then
				named_fd_start=$k
				while (( named_fd_start > 1 )) &&
					[[ "${BUFFER[named_fd_start]}" != '{' ]]; do
					(( named_fd_start-- ))
				done
				if [[ "${BUFFER[named_fd_start]}" == '{' ]] &&
					[[ "${BUFFER[named_fd_start+1,k-1]}" ==
						[[:alpha:]_][[:alnum:]_]## ]]; then
					# The named-fd syntax binds this identifier to the newly
					# allocated descriptor. Braces are structural delimiters;
					# the identifier itself is a variable assignment target.
					_zsh_highlight_add_highlight \
						"$named_fd_start" $(( k - 1 )) assign
				fi
			else
				while (( k >= 1 )) &&
					[[ "${BUFFER[k]}" == [[:digit:]] ]]; do
					(( k-- ))
				done
				if (( k < i - 1 )) &&
					( (( k == 0 )) ||
						[[ "${BUFFER[k]}" == [[:space:]\;\|\(\)] ]] ); then
					token_start=$(( k + 1 ))
				fi
			fi
		fi

		# Parse the operator as a lexical unit. Treating only '>' specially
		# leaves the '&' in >& detached and makes the following descriptor look
		# like a filename.
		operator_tail="${BUFFER[i,-1]}"
		case "$operator_tail" in
			('&>>'[\|\!]*) operator_length=4 ;;
			('&>>'*) operator_length=3 ;;
			('&>'[\|\!]*) operator_length=3 ;;
			('&>'*|'&<'*) operator_length=2 ;;
			('<<<'*) operator_length=3 ;;
			('<<-'*|'<>'*|'<&'*) operator_length=3 ;;
			('<<'*) operator_length=2 ;;
			('<'*) operator_length=1 ;;
			('>>&|'*) operator_length=4 ;;
			('>>|'*|'>>&'*) operator_length=3 ;;
			('>>'*|'>|'*|'>&|'*) operator_length=3 ;;
			('>&'*) operator_length=2 ;;
			('>'*) operator_length=1 ;;
			(*) (( i++ )); continue ;;
		esac

		operator_end=$(( i + operator_length - 1 ))
		j=$(( i + operator_length ))
		_zsh_highlight_add_highlight \
			$(( token_start - 1 )) "$operator_end" redirection

		while (( j <= length )) && [[ "${BUFFER[j]}" == [[:space:]] ]]; do
			(( j++ ))
		done
		target_start=$j
		target_end=$(( j - 1 ))
		target_quote=''
		target_escaped=0

		while (( j <= length )); do
			char="${BUFFER[j]}"
			if (( target_escaped )); then
				target_escaped=0
			elif [[ "$char" == '\' && "$target_quote" != "'" ]]; then
				target_escaped=1
			elif [[ "$char" == "'" && "$target_quote" != '"' ]]; then
				[[ "$target_quote" == "'" ]] && target_quote='' || target_quote="'"
			elif [[ "$char" == '"' && "$target_quote" != "'" ]]; then
				[[ "$target_quote" == '"' ]] && target_quote='' || target_quote='"'
			elif [[ -z "$target_quote" &&
				"$char" == [[:space:]\;\|\(\)\<\>] ]]; then
				break
			fi
			target_end=$j
			(( j++ ))
		done

		# The target of descriptor duplication (&N / <&N) is another file
		# descriptor, not a filename. Keep it in the I/O family. Ordinary
		# filename targets are deliberately left to the path highlighters.
		if (( target_end >= target_start )) &&
			[[ "${BUFFER[operator_end]}" == '&' &&
				"${BUFFER[target_start,target_end]}" == ([0-9]##|-) ]]; then
			_zsh_highlight_add_highlight \
				$(( target_start - 1 )) "$target_end" redirection
		fi
		i=$(( target_end > operator_end ? target_end + 1 : operator_end + 1 ))
	done
}
