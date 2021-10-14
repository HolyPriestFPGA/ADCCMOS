module ResetGen(
	input Clock,
	output reg Reset = 1'b1
);
reg [4:0] cnt;
always @(posedge Clock)
begin		
	if (cnt < 30)
		begin
			Reset <= 1;
			cnt <= cnt + 1'b1;
		end
	else
		Reset <= 0;
end
endmodule
