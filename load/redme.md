#to get binary file from tasm
#use dosbox
#tlink /t boot.obj,boot.bin
#use test.sh
# boot file should start with 7c00h and  end with 0AA55h
# boot size should be 512 bytes
