`include "global.v"

module bus_arbiter(
    input clk,
    input rest,

    input wire m0_req,  // 0号总线主控(请求)
    output reg m0_grnt, // 0号总线主控(赋予)

    input wire m1_req,  
    output reg m1_grnt, 

    input wire m2_req,  
    output reg m2_grnt, 

    input wire m3_req,  
    output reg m3_grnt
);
    reg[2:0] owner;// 总线使用者

    always @(*) begin
        m0_grnt = `DISABLE;
        m1_grnt = `DISABLE;
        m2_grnt = `DISABLE;
        m3_grnt = `DISABLE;

        case(owner)
            `BUS_OWNER_MASTER_0:begin
                m0_grnt = `ENABLE;
            end
            `BUS_OWNER_MASTER_1:begin
                m1_grnt = `ENABLE;
            end
            `BUS_OWNER_MASTER_2:begin
                m2_grnt = `ENABLE;
            end
            `BUS_OWNER_MASTER_3:begin
                m3_grnt = `ENABLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (rest == `RESET) begin
            owner <= `BUS_OWNER_MASTER_0;
        end else begin
            case(owner)
                `BUS_OWNER_MASTER_0:begin
                    if (m0_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_0;
                    end else if (m1_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_1;
                    end else if (m2_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_2;
                    end else if (m3_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_3;
                    end
                end
                `BUS_OWNER_MASTER_1:begin
                    if (m1_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_1;
                    end else if (m2_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_2;
                    end else if (m3_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_3;
                    end else if (m0_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_0;
                    end
                end
                `BUS_OWNER_MASTER_2:begin
                    if (m2_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_2;
                    end else if (m3_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_3;
                    end else if (m0_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_0;
                    end else if (m1_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_1;
                    end
                end
                `BUS_OWNER_MASTER_3:begin
                    if (m3_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_3;
                    end else if (m0_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_0;
                    end else if (m1_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_1;
                    end else if (m2_req == `ENABLE) begin
                        owner <= `BUS_OWNER_MASTER_2;
                    end
                end
            endcase
        end
    end

endmodule