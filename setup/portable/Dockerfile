FROM ubuntu:latest

RUN apt update && apt -y install software-properties-common build-essential git python3 python3-pip zsh curl locales
RUN add-apt-repository ppa:neovim-ppa/unstable && apt update
RUN apt -y install neovim 

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

WORKDIR /root/dotfiles
COPY ./setup.sh .
COPY ./setup_prezto.zsh .
COPY ./vim-conf ./vim-conf
COPY ./zpreztorc zpreztorc

RUN chmod +x setup.sh && ./setup.sh

WORKDIR /root

