all: gen exe wave

gen:
	verilator -y ../rtl --cc -Wall --exe sim_main.cpp tb.v --top-module tb --trace
	make -C ./obj_dir -f Vtb.mk Vtb
exe:
	./obj_dir/Vtb
wave:
	gtkwave wave.vcd

.PHONY:clean
clean:
	rm -rf ./obj_dir/
