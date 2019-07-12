# Install vim version 8.0 onwards
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt update
sudo apt-get install -y vim wget cscope

# Download .vimrc from my git hub
wget https://raw.githubusercontent.com/mralien12/my_script/master/dotfile/vimrc -O ~/.vimrc

# Set up csope
mkdir ~/.vim/bundle/csope
wget http://cscope.sourceforge.net/cscope_maps.vim -O ~/.vim/bundle/cscope/cscope_maps.vim

# Set up plugins
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

