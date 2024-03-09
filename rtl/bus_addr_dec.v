`include "global.v"

module bus_addr_dec(
    input wire[`BUS_SLAVE_ADDR] s_addr, // 从属选择地址

    output reg s0_cs,                   // 片选
    output reg s1_cs,
    output reg s2_cs,
    output reg s3_cs,
    output reg s4_cs,
    output reg s5_cs,
    output reg s6_cs,
    output reg s7_cs
);
    // 关注高三位
    wire[3:0] s_index = s_addr[31:29];

    always @(*) begin
        s0_cs = `DISABLE;
        s1_cs = `DISABLE;
        s2_cs = `DISABLE;
        s3_cs = `DISABLE;
        s4_cs = `DISABLE;
        s5_cs = `DISABLE;
        s6_cs = `DISABLE;
        s7_cs = `DISABLE;
        case(s_index)
            `BUS_SLAVE_0:begin
                s0_cs = `ENABLE;
            end
            `BUS_SLAVE_1:begin
                s1_cs = `ENABLE;
            end
            `BUS_SLAVE_2:begin
                s2_cs = `ENABLE;
            end
            `BUS_SLAVE_3:begin
                s3_cs = `ENABLE;                
            end
            `BUS_SLAVE_4:begin
                s4_cs = `ENABLE;                
            end
            `BUS_SLAVE_5:begin
                s5_cs = `ENABLE;                
            end
            `BUS_SLAVE_6:begin
                s6_cs = `ENABLE;                
            end
            `BUS_SLAVE_7:begin
                s7_cs = `ENABLE;                
            end
        endcase
    end

endmodule