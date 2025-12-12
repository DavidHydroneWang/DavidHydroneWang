#!/bin/bash
# ~/.oh-my-bash/custom/my_bash.bash
# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/workspace/projects/m2/brainstormr
# cd $brainstormr
#
if [ -f $HOME/.alias ]; then
    source $HOME/.alias
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#source /opt/ros/foxy/setup.bash
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/david/Work_Mounted/ORB-SLAM3/ORB_SLAM3/Examples/ROS
#export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/david/Test/ORB_SLAM3/Examples_old/ROS
#source /opt/ros/noetic/setup.bash
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
C_INCLUDE_PATH=/home/david/imu_ws/src/code_utils/include/code_utils
export C_INCLUDE_PATH
CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/home/david/imu_ws/src/code_utils/include/code_utils
export CPLUS_INCLUDE_PATH
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
export VTK_DIR=/usr/local/include/vtk-7.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
#export PATH=$PATH:/usr/local/cuda/bin  
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64  
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/targets/x86_64-linux/lib
#export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64
#export PATH=$PATH:/usr/local/cuda-11.0/bin
#export PATH=$PATH:/usr/local/cuda-11.0/bin/nvcc
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64
#export PATH=$PATH:/usr/local/cuda-8.0/bin 
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
#export PATH="/usr/local/cuda/bin:$PATH"
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_HOME="/usr/local/cuda:$CUDA_HOME"
export PATH="/home/david/anaconda3/bin$PATH"

## 交叉编译环境配置
#export C_INCLUDE_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_arm-linux-gnueabihf/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_arm-linux-gnueabihf/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_arm-linux-gnueabihf/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_arm-linux-gnueabihf/lib:$LIBRARY_PATH"  
#export PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_arm-linux-gnueabihf/bin:$PATH"
#export C_INCLUDE_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_aarch64-linux-gnu/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_aarch64-linux-gnu/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_aarch64-linux-gnu/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_aarch64-linux-gnu/lib:$LIBRARY_PATH"  
#export PATH="/tools/toolchain/gcc-10.2.1-20210303-sigmastar-glibc-x86_64_aarch64-linux-gnu/bin:$PATH"
#export C_INCLUDE_PATH="/tools/toolchain/riscv_gcc/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain/riscv_gcc/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain/riscv_gcc/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain/riscv_gcc/lib:$LIBRARY_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain/riscv_gcc/lib64:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain/riscv_gcc/lib64:$LIBRARY_PATH"
#export PATH="/tools/toolchain/riscv_gcc/bin:$PATH"

## 新的交叉编译环境配置
#export C_INCLUDE_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_arm-linux-gnueabihf/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_arm-linux-gnueabihf/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_arm-linux-gnueabihf/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_arm-linux-gnueabihf/lib:$LIBRARY_PATH"  
#export PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_arm-linux-gnueabihf/bin:$PATH"
#export C_INCLUDE_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_aarch64-linux-gnu/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_aarch64-linux-gnu/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_aarch64-linux-gnu/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_aarch64-linux-gnu/lib:$LIBRARY_PATH"  
#export PATH="/tools/toolchain_new/gcc-10.2.1-20250126-linaro-glibc-x86_64_aarch64-linux-gnu/bin:$PATH"
#export C_INCLUDE_PATH="/tools/toolchain_new/riscv_gcc/bin/include:$C_INCLUDE_PATH"
#export CPLUS_INCLUDE_PATH="/tools/toolchain_new/riscv_gcc/bin/include:$CPLUS_INCLUDE_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain_new/riscv_gcc/lib:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain_new/riscv_gcc/lib:$LIBRARY_PATH"
#export LD_LIBRARY_PATH="/tools/toolchain_new/riscv_gcc/lib64:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/tools/toolchain_new/riscv_gcc/lib64:$LIBRARY_PATH"
#export PATH="/tools/toolchain_new/riscv_gcc/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/david/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/david/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/david/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/david/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PATH="/home/david/.local/bin:$PATH"
export CPATH="/usr/include/opencv4:$CPATH"
# 命令行历史记录
HISTTIMEFORMAT="%Y-%m-%d %T "
#HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "
export HISTSIZE=-1
export HISTFILESIZE=-1
HISTFILE=~/.bash_history
HISTCONTROL=ignoreboth
ISTCONTROL=ignoredups
HISTIGNORE="ls:cd:exit"
shopt -s histappend
#PROMPT_COMMAND='echo "$(whoami) $(date +%Y-%m-%d\ %H:%M:%S)   $(history 1)  " >> ~/.bash_history'
#PROMPT_COMMAND='echo "$(whoami) $(date +%Y-%m-%d\ %H:%M:%S) $(history -a) $(history -n)  $(history 1)  " >> ~/.bash_history'
append_prompt_command() {
    # 保存原有的 PROMPT_COMMAND
    if [ -n "$PROMPT_COMMAND" ]; then
        local existing_cmd="$PROMPT_COMMAND"
        # 追加你的历史记录命令
        PROMPT_COMMAND="${existing_cmd}; echo \"\$(whoami) \$(date +%Y-%m-%d\ %H:%M:%S) \$(history -a) \$(history -n) \$(history 1)\" >> ~/.bash_history"
    else
        PROMPT_COMMAND='echo "$(whoami) $(date +%Y-%m-%d\ %H:%M:%S) $(history -a) $(history -n) $(history 1)" >> ~/.bash_history'
    fi
}
append_prompt_command

xhost + &> /dev/null
export DOCKER_CATKINWS=/home/david/ROS_project/catkin_ws_openvins
export DOCKER_DATASETS=/home/david/ROS_project/openvins/datasets
alias ov_docker="sudo docker run -it --net=host --gpus all \
    --env=\"NVIDIA_DRIVER_CAPABILITIES=all\" --env=\"DISPLAY\" \
    --env=\"QT_X11_NO_MITSHM=1\" --volume=\"/tmp/.X11-unix:/tmp/.X11-unix:rw\" \
    --mount type=bind,source=$DOCKER_CATKINWS,target=/catkin_ws \
    --mount type=bind,source=$DOCKER_DATASETS,target=/datasets $1"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source /opt/ros/noetic/setup.bash

export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export MVCAM_SDK_PATH=/opt/MVS

export MVCAM_SDK_VERSION=

export MVCAM_COMMON_RUNENV=/opt/MVS/lib

export MVCAM_GENICAM_CLPROTOCOL=/opt/MVS/lib/CLProtocol

export ALLUSERSPROFILE=/opt/MVS/MVFG
export LD_LIBRARY_PATH=/opt/MVS/lib/64:/opt/MVS/lib/32:$LD_LIBRARY_PATH

export PATH=~/.bin:$PATH

