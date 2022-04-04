@echo off
call :CurDIR "%cd%"
goto :eof
:CurDIR
set upper_path=%~nx1


:: **********************************************************************************
::                                   1-3�����ϵͳ�����ű�
:: ********************************************************************************** 

::================================================
::                                     ������������OS����
::================================================
echo ������������װ����
..\z_tools\nask.exe ipl10.nas ipl10.bin ipl10.lst

::��haribote.nas(ϵͳ����)�޸Ķ���, Ϊ����C���ԣ�������100�����ҵĻ����롣���Ĺ����ǳн�IPL���򣬵���bootpack.c�е���������OS����˴�����Ҫ�����ǵ���Ӳ�� 
echo *
echo ����OS����
..\z_tools\nask.exe asmhead.nas asmhead.bin asmhead.lst

::=================================================
::                              ���������ǽ�c���Ա���Ϊ���Ĳ���
::=================================================
echo *
echo ʹ��cc1.exe��bootpack.c����gas�������bootpack.gas
..\z_tools\cc1.exe -I$(INCPATH) -Os -Wall -quiet -o bootpack.gas bootpack.c

echo *
echo ʹ��gas2nask����gas�������bootpack.gas���nask�ܷ���Ļ������bootpack.nas
..\z_tools\gas2nask.exe -a bootpack.gas bootpack.nas

::================================================
::           ����������c���Բ��ܱ�д�ĳ����û����ɣ������ӵ�c���Գ�����
::================================================

echo *
echo ʹ��nask.exe��bootpack.nas����Ŀ���ļ�bootpack.obj���������ԣ�
..\z_tools\nask.exe bootpack.nas bootpack.obj bootpack.lst

echo *
echo ʹ��nask.exe��naskfunc.nas����Ŀ���ļ�naskfunc.obj���������ԣ�
..\z_tools\nask.exe naskfunc.nas naskfunc.obj naskfunc.lst

::��һ������ΪC���Բ��ܱ�д���еĳ�����һ�����û����д��Ȼ�����ӵ�C���Գ�����
echo *
echo ʹ��obj2bim.exe��bootpack.obj����naskfunc.obj���ɶ�����ӳ���ļ�bootpack.bim
..\z_tools\obj2bim.exe @..\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map bootpack.obj naskfunc.obj

::==================================================
::                                      �����������ļ��ӹ��ɿ������ľ���
::==================================================

::������Ϊӳ���ļ�ֻ�ǽ�������ȫ��������һ�������������Ļ��������ļ���Ϊ��ʵ��ʹ�ã�����Ҫ�ӹ��������ʶ����ļ�ͷ������ѹ���ȡ�
echo *
echo  ʹ��bim2hrb.exe��bootpack.obj����bootpack.hrb
..\z_tools\bim2hrb.exe bootpack.bim bootpack.hrb 0

echo *
echo ƴ��OS�ļ��ͳ����ļ�
copy /B asmhead.bin+bootpack.hrb haribote.sys

echo *
echo ͨ��edimg���߽�IPL.bin��haribote.sys����ʽӳ�䵽�������̾����ļ�
..\z_tools\edimg.exe  imgin:..\z_tools\fdimg0at.tek wbinimg src:ipl10.bin len:512 from:0 to:0 copy from:haribote.sys to:@: imgout:haribote.img

::=================================================
::                                                        ��������
::=================================================
echo *
echo ��������  
copy haribote.img ..\z_tools\qemu\fdimage0.bin
..\z_tools\make.exe -C ..\z_tools\qemu


echo ��ʼ���������ļ�

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
