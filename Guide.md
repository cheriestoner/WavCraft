以下是一份完整流程，从 WSL 安装开始到环境搭建和第三方库准备，结合之前的经验和清华/南科大镜像配置，尽量保证国内下载顺畅。
---

## 1 安装 WSL（Windows Subsystem for Linux）

在 Windows PowerShell（管理员）中运行：
···
wsl --install
wsl --set-default-version 2
···
如果已经有 WSL，可以升级到 WSL2：
···
wsl --set-version <发行版名称> 2
···
安装好 Ubuntu（或其他 Linux 发行版）后，启动 WSL：
···
wsl
···

---

## 2 安装 Miniconda

在 WSL 里：
···
# 下载 Miniconda 安装脚本
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 安装
bash Miniconda3-latest-Linux-x86_64.sh
# 按提示选择安装路径，添加到 PATH
# 重新加载 shell 配置
source ~/.bashrc
···

---

## 3 配置国内镜像
···
# 清华镜像
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
# 南科大镜像（用于 nvidia 包）
conda config --set custom_channels.nvidia https://mirrors.sustech.edu.cn/anaconda-extra/cloud
# 默认
conda config --add channels defaults

# 查看顺序
conda config --show channels
···
顺序建议：
1. conda-forge
2. 清华镜像 main
3. defaults
4. nvidia（custom_channels）

---

## 4 环境安装脚本 setup_envs.sh
···
#!/bin/bash

# AudioCraft
mamba env create -f venvs/audiocraft.yml --no-pip -y
conda activate AudioCraft
pip install -r audiocraft.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

# AudioLDM
mamba env create -f venvs/audioldm.yml --no-pip -y
conda activate AudioLDM
pip install -r audioldm.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

# AudioSR
mamba env create -f venvs/audiosr.yml --no-pip -y
conda activate AudioSR
pip install -r audiosr.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

# WavCraft
mamba env create -f venvs/wavcraft.yml --no-pip -y
conda activate WavCraft
pip install -r wavcraft.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

# Prepare third-party repos
mkdir -p ext
cd ext

git clone https://github.com/haoheliu/AudioLDM.git
git clone https://github.com/Audio-AGI/AudioSep.git

wget https://uplex.de/audiowmark/releases/audiowmark-0.6.1.tar.gz
tar -xzvf audiowmark-0.6.1.tar.gz
cd audiowmark-0.6.1
./configure
make
sudo make install
···

注意：
- pip 部分加了 -i 和 --trusted-host 保证国内源下载。
- 每个环境安装后都 conda activate，确保 pip 安装在对应环境里。
- 第三方库安装需要 sudo 权限。

---

## 5 常用检查命令
···
# 查看当前环境
conda info --envs

# 激活某个环境
conda activate AudioCraft

# 检查 torch 是否能用 GPU
python -c "import torch; print(torch.cuda.is_available())"
···