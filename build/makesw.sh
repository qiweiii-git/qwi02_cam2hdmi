#*****************************************************************************
# makefw.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 4, 2019      Initial Release
#*****************************************************************************
#!/bin/bash

FileSys='..'
BuildDir='.build'
WorkspaceDir='workspace'
CopyRunFileDir='build'
ElfDir='Debug'
CopyElfFileDir='bin'
CopyElfRoute='../../../../..'

PrjName=$1
hwName=$2
echo "--Info: Project Name is $PrjName------"

cd $FileSys
#make dir
if [ -d $BuildDir ]; then
   echo "--Warning: Building Directory $BuildDir Exist--"
   rm -r $BuildDir
   echo "--Info: Old Building Directory $BuildDir Removing--"
fi
mkdir $BuildDir
echo "--Info: Building Directory $FileSys/$BuildDir Establish---"

#copy source files
cp * $BuildDir -r

#building
cd $BuildDir
mkdir $WorkspaceDir
cp ./$CopyElfFileDir/$hwName.hdf $WorkspaceDir
cp ./$CopyRunFileDir/runsw.tcl $WorkspaceDir
cd $WorkspaceDir
echo "--Info: $PrjName Project is building----"
xsdk -batch -source runsw.tcl

#finish building
echo "--Info: $PrjName Project finish building----"

#copy the elf file
cd ./$WorkspaceDir/$PrjName/$ElfDir
if [ -f $PrjName.elf ]; then
   cp $PrjName.elf $CopyElfRoute/$CopyElfFileDir
   echo "--Info: $PrjName elf file moved to BIN-----"
   #clean
   cd $CopyElfRoute
   rm -rf $BuildDir
   echo "--Info: $PrjName elf file finish making-----"
   echo -e "\n   Success \n"
else
   echo "--Error: $PrjName Project built failed-----"
   echo "--Error: $PrjName Project make failed-----"
   echo -e "\n   Failure \n"
fi
