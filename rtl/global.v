`ifndef __GLOBAL_H__
`define __GLOBAL_H__

// 以下都为正逻辑，负逻辑在后面加_
// 正逻辑
`define RESET 1'b0
`define A_PC 32'd4
`define WORD_ADDR 31:0
`define WORD_DATA 31:0

`define ENABLE 1'b1
`define DISABLE 1'b0

`define DEFAULT_32_ZERO 32'b0
`define DEFAULT_5_ZERO 5'b0

`define RISCV_OPCODE 6:0
`define RISCV_RD 4:0
`define RISCV_RS1 4:0
`define RISCV_RS2 4:0
`define RISCV_FUNCT3 2:0

`define RISCV_IMMI 11:0
`define RISCV_IMMSB 12:0
`define RISCV_IMMUJ 20:0
`define RISCV_IMMS 11:0
// 此处改成32位，前面没考虑周到
// `define RISCV_IMMI 31:0
// `define RISCV_IMMSB 31:0
// `define RISCV_IMMUJ 31:0

`define REGS_ADDR 4:0
`define REGS_NUM 6'd32 // ?

`define BYTE 7:0

// 总线
`define BUS_OWNER_MASTER_0 2'b00
`define BUS_OWNER_MASTER_1 2'b01
`define BUS_OWNER_MASTER_2 2'b10
`define BUS_OWNER_MASTER_3 2'b11

`define BUS_SLAVE_0 3'b000
`define BUS_SLAVE_1 3'b001
`define BUS_SLAVE_2 3'b010
`define BUS_SLAVE_3 3'b011
`define BUS_SLAVE_4 3'b100
`define BUS_SLAVE_5 3'b101
`define BUS_SLAVE_6 3'b110
`define BUS_SLAVE_7 3'b111

// 定时器
// start
`define TIMER_ENABLE 1'b0
`define TIMER_DISABLE 1'b1

// mode[0]
`define TIMER_UP 1'b1
`define TIMER_DOWN 1'b0

// mode[1]
`define TIMER_SINGLE 1'b1
`define TIMER_CIRCLE 1'b0

// mode
`define TIMER_MODE_CIRCLE_UP ((`TIMER_CIRCLE << 1) | (`TIMER_UP))
`define TIMER_MODE_CIRCLE_DOWN ((`TIMER_CIRCLE << 1) | (`TIMER_DOWN))
`define TIMER_MODE_SINGLE_UP ((`TIMER_SINGLE << 1) | (`TIMER_UP))
`define TIMER_MODE_SINGLE_DOWN ((`TIMER_SINGLE << 1) | (`TIMER_DOWN))

// wr_data
`define TIMER_STOP (`TIMER_DISABLE << 2)
`define TIMER_CIRCLE_UP ((`TIMER_ENABLE << 2) | `TIMER_MODE_CIRCLE_UP)
`define TIMER_CIRCLE_DOWN ((`TIMER_ENABLE << 2) | `TIMER_MODE_CIRCLE_DOWN)
`define TIMER_SINGLE_UP ((`TIMER_ENABLE << 2) | `TIMER_MODE_SINGLE_UP)
`define TIMER_SINGLE_DOWN ((`TIMER_ENABLE << 2) | `TIMER_MODE_SINGLE_DOWN)

`define TIMER_ACCESS_ADDR 2:0

// addr
`define TIMER_EXPR_ADDR    2'b00
`define TIMER_COUNTER_ADDR 2'b01
`define TIMER_STATE_ADDR   2'b10
`define TIMER_CTRL_ADDR    2'b11

`define TIMER_MAX_EXPR     8'd255

// 读写
`define READ 1'b0
`define WRITE 1'b1

`define BUS_SLAVE_ADDR 31:0
// 参考了《CPU自制入门一书》，书中相关的值给了30，这里给了3我觉得就够了

// 负逻辑

`endif