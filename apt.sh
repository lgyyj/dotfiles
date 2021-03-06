#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the colours you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

#  Reset text attributes to normal + without clearing screen.
alias Reset="tput sgr0"

# Color-echo.
# arg $1 = message
# arg $2 = Color
cecho() {
  echo -e "${2}${1}"
  # Reset # Reset to normal.
  return
}

if hash apt-get 2>/dev/null; then
  cecho "apt has been installed, just continue install ..." $green
else
  cecho "no apt found! exit ..." $yellow
  exit
fi

# Ask for the administrator password upfront.
sudo -v

cecho "config the DNS" $yellow
echo ""

sudo chmod a+w  /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 114.114.114.114
EOF

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
cecho "Now time to install my favorate tools ..." $yellow

# emacs rep
#sudo apt-add-repository ppa:ubuntu-elisp/ppa
#sudo apt-get update

apps=(
    # Utilities
    libncurses5-dev
    libreadline-dev
    libpcre3-dev
    zlib1g-dev
    libssl-dev
    libssh-dev
    openssl
    build-essential
    perl
    make
    cmake
    g++
    autoconf
    m4
    wget
    curl
    openssh-server
    libgtk-3-dev
    libappindicator3-dev

    # cool terminal util
    # suggest terminator

    # cn input
    ibus-rime

    # proxychains
    # privoxy
    polipo

    ## for python
    python-pip
    python-dev

    ## for erlang: refer: https://packages.erlang-solutions.com/erlang/
    #libwxbase3.0-0
    #libwxbase3.0-0v5
    #libwxgtk3.0-0
    #libwxgtk3.0-0-v5
    #libsctp1
    #####$ wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
    #####$ sudo dpkg -i erlang-solutions_1.0_all.deb
    #####$ sudo apt-get update
    #####$ sudo apt-get upgrade -y
    #####$ sudo apt-get install -y erlang

    ## java
    ##sudo add-apt-repository ppa:webupd8team/java
    ##sudo apt-get update
    ##sudo apt-get install oracle-java8-installer
    ##sudo apt-get install oracle-java8-set-default
    #openjdk-8-jdk
)

for item in ${apps[@]}; do
  cecho "> ${item}" $magenta
done

echo ""

select yn in "Yes" "No"; do
  case $yn in
    Yes )
        cecho "Ok! installing apps, please wait ... " $yellow
        sudo apt-get install -y ${apps[@]}
        break;;
    No ) break;;
  esac
done
echo ""
echo ""
cecho "the ensential tools already installed just continue ===>" $green
echo ""
echo ""
echo -e "\033[40;32m install the z, refer: https://github.com/rupa/z/blob/master/z.sh \033[0m"
git clone https://github.com/rupa/z ~/z
. ~/z/z.sh

echo ""
echo ""
echo -e "\033[40;32m install liquidprompt \033[0m"
git clone https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
source ~/.liquidprompt/liquidprompt

echo ""
echo ""
cecho "Now, install my custom tools ===>" $green
echo ""
echo ""
read -p "do you want to deploy your own G-F-W vps and use shadowsocks client of python version ? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
  #apt-get install build-essential
  #wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
  cd sss
  tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
  ./configure && make -j2 && make install
  ldconfig
  cd ..

  #sudo apt-get install -y software-properties-common
  #sudo bash -c "LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php"
  #sudo apt-get update
  #sudo apt-get install -y libsodium-dev

  #sudo -H pip install shadowsocks
  #pip install --upgrade git+https://github.com/shadowsocks/shadowsocks.git@master
  sudo -H pip install --upgrade git+https://github.com/shadowsocks/shadowsocks.git@master
  echo -e "\033[40;32m deploy the proxy server on your remote vps: server[1,2,3] \033[0m"
  SS_CFG="/etc/shadowsocks.json"
  if [ ! -f "$SS_CFG" ]; then
    echo "no found shadowsocks config file, touching file: /etc/shadowsocks.json";
    sudo touch "$SS_CFG"
  fi
  sudo chmod a+w "$SS_CFG"

cat > "$SS_CFG" <<EOF
{
  "server":["server1","server2"],
  "server_port":8080,
  "local_address":"127.0.0.1",
  "local_port":1080,
  "password":"password",
  "timeout":300,
  "method":"chacha20-ietf-poly1305",
  "fast_open": false
}
EOF

  echo -e "\033[40;32m you can start the shadowsocks server on remote vps: sudo ssserver -c /etc/shadowsocks.json -d start \033[0m"
  echo -e "\033[40;32m you can start the shadowsocks client on your local laptop: sslocal -c /etc/shadowsocks.json \033[0m"
fi;

echo ""
echo ""
read -p "install the awesome fzf, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
fi;

echo ""
echo ""
read -p "install the chrome, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
fi;

echo ""
echo ""
read -p "install the awesome uget to get rid of the netpan, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
sudo add-apt-repository ppa:plushuang-tw/uget-stable
sudo apt-get update
sudo apt-get install -y uget
fi;

echo ""
echo ""
read -p "install the awesome tool htop2.0, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "install htop2.0";
  git clone https://github.com/hishamhm/htop
  cd $CURRENT_DIR/htop && ./autogen.sh && ./configure && make && sudo ln -s $CURRENT_DIR/htop/htop /usr/bin/htop
  cd -
fi;

echo ""
echo ""
read -p "polipo privoxy (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -f "/etc/polipo/config" ]; then
    sudo chmod a+w "/etc/polipo/config"

sudo cat >> /etc/polipo/config <<EOF
socksParentProxy = "localhost:1080"
proxyPort = 8123
socksProxyType = socks5
EOF
    sudo chmod a-w "/etc/polipo/config"
  fi
fi

read -p "install popcorn time - a very very cool movie player online !!!!!!!!!" -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sh -c "$(wget https://raw.githubusercontent.com/popcorn-official/popcorn-desktop/development/make_popcorn.sh -O -)"
fi;

echo ""
echo ""
read -p "install the awesome albert just like dash alfred in maxosx, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo add-apt-repository ppa:nilarimogard/webupd8
  sudo apt update
  sudo apt install -y albert
fi;

echo ""
echo ""
read -p "install the awesome theme: [materia-theme, flatabulous-theme, Flat-Plat-Blue], are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
sudo apt-get install -y libxml2-utils libglib2.0-dev gtk2-engines-murrine gnome-themes-standard
sudo apt install -y gnome-tweak-tool gnome-shell-extensions

sudo add-apt-repository ppa:dyatlov-igor/materia-theme
sudo apt update
sudo apt install -y materia-gtk-theme

sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install -y flatabulous-theme

wget https://github.com/peterychuang/Flat-Plat-Blue/archive/3.26.0-2.tar.gz
tar zxvf 3.26.0-2
cd Flat-Plat-Blue-3.26.0-2/
sudo ./install.sh
cd ..
fi;

echo ""
echo ""
read -p "install the awesome icon: [flat-remix, ultra-flat-icons], are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
sudo add-apt-repository ppa:daniruiz/flat-remix
sudo apt-get update
sudo apt-get install -y flat-remix

sudo add-apt-repository ppa:noobslab/icons
sudo apt-get update
sudo apt-get install -y ultra-flat-icons
fi;


echo ""
echo ""
read -p "install the awesome bottom app start docky like macosx bottom Dock, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
sudo add-apt-repository ppa:ricotz/docky
sudo apt-get update
sudo apt-get install -y docky
echo "now, the left sidebar can be adjust in the appreance system setting to set hide and resolation to 0"
fi;

echo ""
echo ""
read -p "install the awesome mpv player, are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
sudo add-apt-repository ppa:mc3man/mpv-tests
sudo apt update
sudo apt install mpv
fi;

echo ""
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cecho "!!! now, you can run ===> [ gnome-tweak-tool or unity-tweak-tool ] ===> in the terminal to change the theme and icon :-)" $green
cecho "!!! [ System Settings -> Text Entry ] add rime and use [shift + command] to switch the input source:-)" $green
cecho "!!! [ System Settings -> keyboard] adjust speed to fast :-)" $green
cecho "!!! [ open the keyboard shortcuts menu in Ubuntu1604 Top -> Devices -> Keyboard -> custom...-> keyboard menu -> + ===> " $green
cecho "Alt => Alt, Shift => Shift, Alt => Win, <- to Left, -> to Right ... ] :-)" $green


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo ""
echo -e "\033[40;32m change the default shell into: /bin/bash\033[0m"
sudo chsh -s /bin/bash

echo ""
echo ""
echo "cleanning ..."
echo ""
echo ""
cecho "Done, Happy Hacking At the Speed Of The Thought !!!" $green
echo ""
echo ""
