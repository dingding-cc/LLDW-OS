@echo off
call :CurDIR "%cd%"
goto :eof
:CurDIR
set upper_path=%~nx1


:: **********************************************************************************
::                                   1-3天操作系统制作脚本
:: ********************************************************************************** 

::================================================
::                                     生成启动器和OS程序
::================================================
echo 生成启动程序装载器
..\z_tools\nask.exe ipl10.nas ipl10.bin ipl10.lst

::由haribote.nas(系统程序)修改而来, 为调用C语言，添加了100行左右的汇编代码。它的功能是承接IPL程序，调用bootpack.c中的主函数，OS程序此处的主要功能是调用硬件 
echo *
echo 生成OS程序
..\z_tools\nask.exe asmhead.nas asmhead.bin asmhead.lst

::=================================================
::                              下面两步是将c语言编译为汇编的步骤
::=================================================
echo *
echo 使用cc1.exe从bootpack.c生成gas汇编语言bootpack.gas
..\z_tools\cc1.exe -I$(INCPATH) -Os -Wall -quiet -o bootpack.gas bootpack.c

echo *
echo 使用gas2nask，将gas汇编语言bootpack.gas变成nask能翻译的汇编语言bootpack.nas
..\z_tools\gas2nask.exe -a bootpack.gas bootpack.nas

::================================================
::           以下三步将c语言不能编写的程序用汇编完成，并连接到c语言程序上
::================================================

echo *
echo 使用nask.exe将bootpack.nas生成目标文件bootpack.obj（机器语言）
..\z_tools\nask.exe bootpack.nas bootpack.obj bootpack.lst

echo *
echo 使用nask.exe将naskfunc.nas生成目标文件naskfunc.obj（机器语言）
..\z_tools\nask.exe naskfunc.nas naskfunc.obj naskfunc.lst

::这一步是因为C语言不能编写所有的程序，有一部分用汇编来写，然后链接到C语言程序上
echo *
echo 使用obj2bim.exe将bootpack.obj连接naskfunc.obj生成二进制映像文件bootpack.bim
..\z_tools\obj2bim.exe @..\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map bootpack.obj naskfunc.obj

::==================================================
::                                      将机器语言文件加工成可启动的镜像
::==================================================

::这是因为映像文件只是将各部分全都链接在一起，做成了完整的机器语言文件，为了实际使用，还需要加工，如加上识别的文件头，或者压缩等。
echo *
echo  使用bim2hrb.exe将bootpack.obj生成bootpack.hrb
..\z_tools\bim2hrb.exe bootpack.bim bootpack.hrb 0

echo *
echo 拼接OS文件和程序文件
copy /B asmhead.bin+bootpack.hrb haribote.sys

echo *
echo 通过edimg工具将IPL.bin和haribote.sys按格式映射到虚拟软盘镜像文件
..\z_tools\edimg.exe  imgin:..\z_tools\fdimg0at.tek wbinimg src:ipl10.bin len:512 from:0 to:0 copy from:haribote.sys to:@: imgout:haribote.img

::=================================================
::                                                        启动镜像
::=================================================
echo *
echo 启动镜像  
copy haribote.img ..\z_tools\qemu\fdimage0.bin
..\z_tools\make.exe -C ..\z_tools\qemu


echo 开始清理缓存文件

del *.bin
del *.lst
del *.gas
del *.obj
del bootpack.nas
del bootpack.map
del bootpack.bim
del bootpack.hrb
del haribote.sys
del ..\z_tools\qemu\fdimage0.bin

