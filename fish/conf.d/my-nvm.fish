set -gx NODE_MIRROR              https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
set -gx NODE_REPL_HISTORY        $HOME/.cache/node/node_repl_history
set -gx NVM_NODEJS_ORG_MIRROR    https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
set -gx nvm_mirror               https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

switch (uname -s)
	case Linux
		set -gx nvm_data                 $NVM_DIR/versions/node
		set -gx nvm_default_version      v22.1.0
end
