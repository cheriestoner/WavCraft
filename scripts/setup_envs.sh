mamba env create -f venvs/audiocraft.yml --no-pip -y
source activate AudioCraft
pip install -r audiocraft.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

mamba env create -f venvs/audioldm.yml --no-pip -y
source activate AudioLDM
pip install -r audioldm.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

mamba env create -f venvs/audiosr.yml --no-pip -y
source activate AudioSR
pip install -r audiosr.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

mamba env create -f venvs/wavcraft.yml --no-pip -y
source activate WavCraft
pip install -r wavcraft.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
conda deactivate

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