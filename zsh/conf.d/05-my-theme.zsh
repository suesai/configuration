# Match fish's "Tomorrow Night" theme in zsh's command-line editor.
zmodload zsh/nearcolor 2>/dev/null

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f8285'
typeset -gA ZSH_HIGHLIGHT_STYLES
typeset -gA ZSH_HIGHLIGHT_REGEXP
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS

ZSH_HIGHLIGHT_HIGHLIGHTERS=(regexp main arithmetic shell_syntax redirection)
ZSH_HIGHLIGHT_REGEXP+=(
	'(^|[[:space:]])([^-[:space:]][^[:space:]]*)' 'fg=#81a2be'
)

ZSH_HIGHLIGHT_STYLES=(
	default                             'none'
	unknown-token                      'fg=#cc6666'
	reserved-word                      'fg=#b294bb'
	alias                              'fg=#b294bb'
	suffix-alias                       'fg=#b294bb'
	global-alias                       'fg=#b294bb'
	builtin                            'fg=#b294bb'
	function                           'fg=#b294bb'
	command                            'fg=#b294bb'
	hashed-command                     'fg=#b294bb'
	precommand                         'fg=#b294bb'
	commandseparator                   'fg=#69a9a1'
	autodirectory                      'fg=#81a2be,underline'
	path                               'fg=#81a2be,underline'
	path_pathseparator                 'fg=#81a2be,underline'
	path_prefix                        'fg=#81a2be,underline'
	path_prefix_pathseparator          'fg=#81a2be,underline'
	globbing                           'fg=#69a9a1'
	history-expansion                  'fg=#69a9a1'
	command-substitution               'none'
	command-substitution-body          'fg=#81a2be'
	command-substitution-delimiter     'fg=#69a9a1'
	process-substitution               'none'
	process-substitution-delimiter     'fg=#69a9a1'
	arithmetic-expansion               'fg=#b294bb'
	arithmetic-expansion-delimiter     'fg=#69a9a1'
	arithmetic-operator                'fg=#81a2be'
	test-delimiter                     'fg=#69a9a1'
	single-hyphen-option               'fg=#81a2be'
	double-hyphen-option               'fg=#81a2be'
	back-quoted-argument               'fg=#b5bd68'
	back-quoted-argument-unclosed      'fg=#cc6666'
	back-quoted-argument-delimiter     'fg=#69a9a1'
	single-quoted-argument             'fg=#b5bd68'
	single-quoted-argument-unclosed    'fg=#cc6666'
	double-quoted-argument             'fg=#b5bd68'
	double-quoted-argument-unclosed    'fg=#cc6666'
	dollar-quoted-argument             'fg=#b5bd68'
	dollar-quoted-argument-unclosed    'fg=#cc6666'
	rc-quote                           'fg=#69a9a1'
	dollar-double-quoted-argument      'fg=#69a9a1'
	back-double-quoted-argument        'fg=#69a9a1'
	back-dollar-quoted-argument        'fg=#69a9a1'
	assign                             'fg=#81a2be'
	redirection                        'fg=#d19a66'
	comment                            'fg=#f0c674'
	named-fd                           'fg=#81a2be'
	numeric-fd                         'fg=#81a2be'
	arg0                               'fg=#cc6666'
)

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

_zsh_highlight_shell_syntax_style_test_words() {
	setopt localoptions extendedglob
	integer j=$1 word_start
	integer end=$2
	local inner_quote char word

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
				if [[ "$char" == "$inner_quote" ]]; then
					(( j++ ))
					break
				fi
				(( j++ ))
			done
			continue
		fi

		while (( j < end )) && [[ "${BUFFER[j]}" != [[:space:]] ]]; do
			(( j++ ))
		done
		word="${BUFFER[word_start,j-1]}"
		case "$word" in
			('=='|'='|'!='|'=~'|'<'|'>'|'&&'|'||'|'!'|'('|')'|'-'*)
				;;
			([[:alpha:]_][[:alnum:]_.#-]##)
				_zsh_highlight_add_highlight \
					$(( word_start - 1 )) $(( j - 1 )) command
				;;
		esac
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
				_zsh_highlight_shell_syntax_style_test_words \
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
		fi

		if (( close_start )); then
			_zsh_highlight_shell_syntax_style_test_words \
				$(( open_start + 2 )) "$close_start"
		fi

		if (( close_start )); then
			i=$(( close_start + 2 ))
		else
			i=$(( open_start + 2 ))
		fi
	done
}

# zsh-syntax-highlighting colors a redirection target as a normal path. Fish
# colors the operator and its target as one redirection, so add a final,
# narrowly scoped layer for the target while preserving ordinary path styles.
_zsh_highlight_highlighter_redirection_predicate() {
	_zsh_highlight_buffer_modified
}

_zsh_highlight_highlighter_redirection_paint() {
	integer i=1 j k length=${#BUFFER} depth
	integer token_start operator_end target_start target_end
	local quote='' target_quote='' escaped=0 target_escaped=0 char

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
		if [[ -z "$quote" ]] && ( [[ "$char" == '<' || "$char" == '>' ]] ) &&
			[[ "${BUFFER[i+1]}" == '(' ]]; then
			(( i++ ))
			continue
		fi
		if [[ -n "$quote" ]] ||
			! ( [[ "$char" == '&' && "${BUFFER[i+1]}" == '>' ]] ||
				[[ "$char" == '<' || "$char" == '>' ]] ); then
			(( i++ ))
			continue
		fi

		token_start=$i
		if [[ "$char" == '<' || "$char" == '>' ]]; then
			k=$(( i - 1 ))
			while (( k >= 1 )) && [[ "${BUFFER[k]}" == [[:digit:]] ]]; do
				(( k-- ))
			done
			if (( k < i - 1 )) &&
				( (( k == 0 )) || [[ "${BUFFER[k]}" == [[:space:]\;\|\(\)] ]] ); then
				token_start=$(( k + 1 ))
			fi
		fi

		j=$i
		if [[ "${BUFFER[i,i+1]}" == '&>' ]]; then
			(( j += 2 ))
			[[ "${BUFFER[j]}" == '>' ]] && (( j++ ))
		elif [[ "$char" == '<' ]]; then
			if [[ "${BUFFER[i,i+2]}" == '<<<' ]]; then
				(( j += 3 ))
			elif [[ "${BUFFER[i+1]}" == ( '<'|'>'|'&' ) ]]; then
				(( j += 2 ))
			else
				(( j++ ))
			fi
		elif [[ "${BUFFER[i+1]}" == ( '>'|'|'|'&' ) ]]; then
			(( j += 2 ))
		else
			(( j++ ))
		fi

		operator_end=$(( j - 1 ))
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

		if (( target_end >= target_start )); then
			_zsh_highlight_add_highlight \
				$(( target_start - 1 )) "$target_end" redirection
		fi
		i=$(( target_end > operator_end ? target_end + 1 : operator_end + 1 ))
	done
}
