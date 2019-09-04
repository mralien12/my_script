# !/bin/bash

LNX=~/workspace/picozed/linux-xlnx
CSCOPE_DIR=~/cscope

if [ ! -d $CSCOPE_DIR ];then
	mkdir $CSCOPE_DIR
fi

find $LNX					\
	-path "$LNX/arch/arm*" -prune -o	\
	-path "$LNX/include/*" -prune -o	\
	-path "$LNX/Documentation*" -prune -o	\
	-path "$LNX/scripts*" -prune -o		\
	-path "$LNX/driver*" -prune -o		\
	-name "*.[chxsS]" -print > ~/cscope/cscope.files

cd $CSCOPE_DIR

# The -b flag tell Cscope to just build database, and not launch the Cscope GUI
# The -q flag caused an addtional, 'inverted index' file to be created, which make searchs run much faster for large database.
# The -k flag set Cscope's kernel mode, it will not look in /usr/include for any header file that are #include in your source file.
cscope -b -q -k
