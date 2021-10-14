module Switcher (
input ReadyBuff,
input Fast,
input [13:0] DataSlow,

input [15:0] PC,
input [15:0] PD,

input [1:0] Switch, //Switch8, Switch9

output reg [15:0] DataOut
);

always @(*)
begin
	case(Switch)
		2'b00:
			begin
				DataOut[13:0]	<=	DataSlow[13:0];
				DataOut[14]	<=	Fast;
				DataOut[15]	<=	ReadyBuff;
			end
		2'b01:
			begin
				DataOut[15:0] <= PC[15:0];
			end
		2'b11:
			begin
				DataOut[15:0] <= PD[15:0];
			end
		default:
			begin
				DataOut <= 16'd0;
			end	
	endcase
end

endmodule



