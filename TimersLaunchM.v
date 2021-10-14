module TimersLaunchM(
	input Clk100MHz,
	input SynchrM,
	input LaunchM,
//	input SynchrFSK,

	output reg [7:0] ResultTimer
);

wire Ready;
assign Ready = MainCountTimer[7] /* synthesis keep */; 

reg [7:0] MainCountTimer, ResultTimer_r;
reg SynchrM_r1, SynchrM_r2, LaunchM_r1, LaunchM_r2;

always @(negedge Clk100MHz)
begin
	SynchrM_r1 	<= SynchrM;
	SynchrM_r2	<= SynchrM_r1;
	
	LaunchM_r1	<=	LaunchM;
	LaunchM_r2	<= LaunchM_r1;
end

always @(posedge Clk100MHz)
begin
	if (SynchrM_r1 && !SynchrM_r2)
		begin
			MainCountTimer <= 7'd0;
		end
	else if (LaunchM_r1 && !LaunchM_r2)
		begin
			ResultTimer_r <= MainCountTimer;
		end
	else if (MainCountTimer < 128)
		begin
			MainCountTimer	<= MainCountTimer + 1'b1;
		end
	else
		begin
			ResultTimer_r <= 8'b01111111;
		end
end

always @(posedge Ready /*or posedge LaunchM_r1 && !LaunchM_r2*/)
begin
	ResultTimer <= ResultTimer_r;
end
endmodule
