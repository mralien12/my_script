#! /bin/sh


#Configure git with your real name and email address.
echo "Configure git with your real name and email address."
printf "Your full name: "
read your_name
printf "Your user id: "
read user
git config --global user.name "$your_name"
git config --global user.email "${user}@alticast.com"
git_url_base="ssh://${user}@exg.humaxdigital.com:29418/"
git config --global url.${git_url_base}.insteadOf "ssh://hmx_exg_gerrit/"

# It covers how to set up Android build environment.
sudo apt-get install -y vim xclip

# Install required packages.
sudo apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip

# Install ruby for Alticast build script
sudo apt-get -y install ruby

# Install JDK. (Java 1.8.x for Android 'N')
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
sudo update-alternatives --config javac

# Install Android REPO
REPO_DIR=~/bin
BASHRC_FILE=~/.bashrc

if [ ! -d ${REPO_DIR} ]; then
	echo "Creating $REPO_DIR ..."
	mkdir -p ${REPO_DIR}
fi

curl https://storage.googleapis.com/git-repo-downloads/repo > ${REPO_DIR}/repo
sudo chmod a+x ${REPO_DIR}/repo
echo "export PATH=${REPO_DIR}:\$PATH" >> $BASHRC_FILE
echo "Android repo completed"
echo
echo 

#Create and register ssh key
Create SSH Key
SSH_DIR=~/.ssh
if [ -d ${SSH_DIR} ]; then
	echo "ssh key already have"
else
	ssh-keygen
fi

##ssh-agent bash
ssh-add

xclip -sel clip < ${SSH_DIR}/id_rsa.pub
echo 
echo
echo "ssh key is coppied into clipboard. Paste ssh key by Ctrl + V"
echo "Please register public key in gerrit Sever."
echo "1. Login in http://swat.humaxdigital.com:8080/ and http://exg.humaxdigital.com:8080/ using Chrome browser."
echo "   If you can not log in these pages. Please use VPN connectiong or contact to administrator"
echo "2. Go to personal settings in these page."
echo "3. And Select SSH Public Keys"
echo "4. Add a your public key"

while :
do
	echo
	printf "To continue you must register ssh key.\n"
	printf "Did you register ssh key in gerrit server (y/n)? "
	read confirm
	confirm=`echo $confirm | tr '[a-z]' '[A-Z]'`
	if [ "$confirm" = "Y" ] || [ "$confirm" = "YE" ] || [ "$confirm" = "YES" ]; then
		echo "ssh key already registerd"
		break
	fi
done

#Edit ssh config file
ssh_config="host swat.humaxdigital.com\n\t 			\
				user ${user}\n\t   					\
				port 29418\n\t   					\
				IdentityFile ~/.ssh/id_rsa\n 		\
host exg.humaxdigital.com\n\t   		\
				user ${user}\n\t    				\
				port 29418\n\t   					\
				IdentityFile ~/.ssh/id_rsa"

echo $ssh_config >> ~/.ssh/config


echo "Setup completed."


