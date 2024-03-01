#include "Vtb.h"
#include "verilated.h"
#include <stdio.h>
#include <verilated_vcd_c.h>
#include <iostream>

#define MAX_TICKS 100

int main(int argc, char **argv)
{
    VerilatedContext *contextp = new VerilatedContext;
    VerilatedVcdC *tracep = new VerilatedVcdC;
    Vtb *top = new Vtb{contextp};
    contextp->traceEverOn(true);

    uint64_t sim_ticks = 0;
    top->trace(tracep, 0);
    tracep->open("wave.vcd");

    while (!contextp->gotFinish() && sim_ticks < MAX_TICKS)
    {
        if (sim_ticks == 0)
        {
            top->clk = 0;
            top->rest = 0;
        }

        if (sim_ticks >= 1)
        {
            top->rest = 1;
        }

        top->eval();
        tracep->dump(sim_ticks);
        sim_ticks++;
    }

    top->final();
    tracep->close();
    delete top;

    // printf("PC register value is %d", tb->u_cpu_top.u_cpu_core.u_pc_reg.pc2if_addr_o);
    // printf("x3 register value is %d", tb->u_cpu_top.u_cpu_core.u_regs.x_regs[3]);
    // printf("x4 register value is %d", tb->u_cpu_top.u_cpu_core.u_regs.x_regs[4]);
    // printf("x5 register value is %d", tb->u_cpu_top.u_cpu_core.u_regs.x_regs[5]);
    std::cout << "Over" << std::endl;
    std::cout << sim_ticks << std::endl;
    delete contextp;

    return 0;
}
