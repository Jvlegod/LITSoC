# 只需要改变FILE_PRE文件就可以实现汇编，反汇编，以及二进制列表生成
FILE_PRE:=./test_lists/test
GCC:=riscv64-linux-gnu-
AS:=${GCC}as
OBJDUMP:=${GCC}objdump
PYTHON:=python3 as2bin.py

all: as objdump gen

as:
	@${AS} -c ${FILE_PRE}.asm -o ${FILE_PRE}.o
objdump:
	@${OBJDUMP} -d ${FILE_PRE}.o > ${FILE_PRE}.txt
gen:
	@${PYTHON} ${FILE_PRE}.txt ${FILE_PRE}.lst

.PHONY:clean
clean:
	@rm -rf ${FILE_PRE}.o ${FILE_PRE}.txt ${FILE_PRE}.lst
	@echo "finish all clean work"
