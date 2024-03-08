rm -rf ./generated/*
iverilog -s module_tb -y ../rtl/ -I ../rtl/ -o ./generated/module_tb.out module_tb.v
vvp ./generated/module_tb.out
gtkwave ./generated/module_tb.vcd