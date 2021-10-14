module NoiseDetector(
	input SynchrM,
	input signed[13:0] DataADC,
	input ClkFromADC,
	
	output reg signed [15:0] Noise

//	,output reg signed [20:0] NoiseReg
//	,output reg [12:0] CountPause
//	,output reg SynchrM_r1, SynchrM_r2, Ready
);

reg [20:0] NoiseReg;
reg [12:0] CountPause;

reg SynchrM_r1, SynchrM_r2;
reg Ready;

always @(negedge ClkFromADC)
begin
	SynchrM_r1 	<= SynchrM;
	SynchrM_r2	<= SynchrM_r1;
end

always @(posedge ClkFromADC)
begin
	if (SynchrM_r1 && !SynchrM_r2)
		begin
			CountPause	<= 13'd0;
			NoiseReg		<= 21'd0;
			Ready			<= 1'b0;
		end
	else if (CountPause <= 8000)
		begin
			CountPause	<= CountPause + 1'b1;
		end
	else if ((CountPause > 8000) && (CountPause <= 8128))
		begin
			CountPause	<= CountPause + 1'b1;
			NoiseReg	<= NoiseReg + DataADC;
		end
	else
		begin
			Ready	<= 1'b1;
		end
end

always @(posedge Ready)
begin
	Noise	<= NoiseReg[20:5];
end

endmodule
