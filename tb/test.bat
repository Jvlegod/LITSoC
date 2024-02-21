@REM clear生成的可执行文件
rm -rf ./generated/*

iverilog -s tb -y ../rtl/ -I ../rtl/ -o ./generated/tb.out tb.v
vvp ./generated/tb.out
gtkwave ./generated/tb.vcd