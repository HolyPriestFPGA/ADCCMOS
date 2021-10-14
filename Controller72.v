module Controller72 (
	input RXDV,
	input [15:0] RX,
	output wire TXDV,
	output wire [15:0]	TX, 
	output reg [7:0]	Column
); 

assign TX = 16'h196;
assign TXDV = RXDV;

always @(posedge RXDV)
begin
	Column	<= RX[7:0]; 
end


endmodule
