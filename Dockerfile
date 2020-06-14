FROM ubuntu:latest

USER root

RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Europe/Vienna /etc/localtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends neovim npm python3-pip bash git curl locales && \
    dpkg-reconfigure --frontend noninteractive tzdata
RUN npm install -g neovim
RUN pip3 install neovim

# Set the locale
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG de_DE.UTF-8  
ENV LANGUAGE de_DE:en  
ENV LC_ALL de_DE.UTF-8

RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

RUN sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN mkdir ~/.config && \
    cd ~/.config && \
    git clone https://github.com/LeiTi34/nvim.git

ENTRYPOINT [ "nvim" ]
