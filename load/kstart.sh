# 3.5 disk = 2 head of 80 tracks of 18 sectors: 2 * 80 * 18 = 2880
# A diskette(or a DOS partion of a hard disk) is laid out like so:
# 1. Boot and reserved sector(s)
# 2. FAT #1
# 3. FAT #2(optional -- not use on RAM disks)
# 4. root directory
# 5. data area(all file data reside here, including files for directories)
dd if=/dev/zero of=floppy.img bs=512 count=2880 # заполняем дискету(3.5) нулями 
dd if=$1 count=1 of=floppy.img conv=notrunc     # записываем 1-е 512 байт (our loader)                
dd if=$2 skip=1 count=2878 of=floppy.img seek=1 conv=notrunc # записываем freeDos без загрузчика
dd if=$2 count=1 of=floppy.img seek=2878 conv=notrunc        # кладем загрузчик freeDos
dd if=$1 skip=1 count=1 of=floppy.img seek=2879 conv=notrunc # кладем код фрейма
qemu-system-x86_64 -drive format=raw,index=0,if=floppy,file=floppy.img
    
