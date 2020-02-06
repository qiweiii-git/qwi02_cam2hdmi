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
CopyElfRoute='../..'

PrjName=$1
hwName=$2
PrjFsbl=$PrjName\_fsbl
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

#copy files
cd $BuildDir
mkdir $WorkspaceDir
cp ./$CopyElfFileDir/$hwName.hdf $WorkspaceDir
cp ./$CopyRunFileDir/runsw.tcl $WorkspaceDir
cd $WorkspaceDir
echo "the_ROM_image:" >> image.bif
echo "{" >> image.bif
echo "   [bootloader]./$WorkspaceDir/$PrjFsbl/$ElfDir/$PrjFsbl.elf" >> image.bif
echo "   ./$WorkspaceDir/$CopyElfRoute/$CopyElfFileDir/$PrjName.bit" >> image.bif
echo "   ./$WorkspaceDir/$PrjName/$ElfDir/$PrjName.elf" >> image.bif
echo "}" >> image.bif
#building
echo "--Info: $PrjName Project is building----"
xsdk -batch -source runsw.tcl

#finish building
echo "--Info: $PrjName Project finish building----"

#copy the elf file
if [ -f BOOT.bin ]; then
   cp BOOT.bin $CopyElfRoute/$CopyElfFileDir
   cp $WorkspaceDir/$PrjName/$ElfDir/$PrjName.elf $CopyElfRoute/$CopyElfFileDir
   cp $WorkspaceDir/$PrjFsbl/$ElfDir/$PrjFsbl.elf $CopyElfRoute/$CopyElfFileDir
   echo "--Info: $PrjName BOOT.bin file moved to BIN-----"
   #clean
   cd $CopyElfRoute
   rm -rf $BuildDir
   echo "--Info: $PrjName BOOT.bin file finish making-----"
   echo -e "\n   Success \n"
else
   echo "--Error: $PrjName Project built failed-----"
   echo "--Error: $PrjName Project make failed-----"
   echo -e "\n   Failure \n"
fi
