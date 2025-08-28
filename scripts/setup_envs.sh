#!/bin/bash

# 定义环境文件列表 (yml 和 txt 成对出现)
declare -a envs=(
  "audiocraft"
  "audioldm"
  "audiosr"
  "wavcraft"
)

for name in "${envs[@]}"; do
    yml_file="venvs/${name}.yml"
    txt_file="venvs/${name}.txt"

    # 读取 yml 中的环境名
    ENV_NAME=$(grep '^name:' "$yml_file" | awk '{print $2}')

    echo "==============================="
    echo "Processing environment: $ENV_NAME"
    echo "==============================="

    # 判断环境是否已存在
    if conda env list | grep -q "^\s*${ENV_NAME}\s"; then
        echo "Environment '${ENV_NAME}' already exists. Updating..."
        mamba env update -f "$yml_file" --prune
    else
        echo "Environment '${ENV_NAME}' does not exist. Creating..."
        mamba env create -f "$yml_file" -y
    fi

    # 用 pip 安装额外依赖
    if [ -f "$txt_file" ]; then
        echo "Installing pip dependencies for ${ENV_NAME}..."
        source activate "$ENV_NAME" 
        pip install -r "$txt_file" -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
        conda deactivate
    fi
done

echo "All environments processed."

# Prepare third-party repos
# Comment some of them if they are unnecessary
mkdir ext/
cd ext/

git clone https://github.com/haoheliu/AudioLDM.git

git clone https://github.com/Audio-AGI/AudioSep.git

wget https://uplex.de/audiowmark/releases/audiowmark-0.6.1.tar.gz
tar -xzvf audiowmark-0.6.1.tar.gz
cd audiowmark-0.6.1
./configure
make
make install