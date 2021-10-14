module MainControl (
	input 					Reset,
	input 					ClockFromADC,
	input 					ClockFromGen,
	input 					SynchrM,
	input					Fsk,
	input					[19:0]	DataCorr,
	input					ReadyCorr,
	input					CLKCorr,
	input 					[15:0]	Distance,
	input					[15:0]	ROMsin, ROMcos,
	input 					[17:0]	DataAccRe, DataAccIm, DataAccU,
	output reg				[12:0]	CounterStart,
	output reg 				WriteStart,
	output reg 				[15:0]	DistanceRegI
	,output wire					RAMAccWriteEnable
	,output reg 					FskRegI, FskRegII
	,output reg 			[6:0]	AddrROM
	,output /*reg*/ wire			ResetSynchrM
	,output reg	signed		[35:0]	sinReg, cosReg 
	,output reg unsigned	[17:0]	UReg
	,output reg	signed		[19:0]	DataRe, DataIm
	,output reg unsigned	[18:0]	DataU
	,output wire 					DataClock
	,output reg 			[7:0]	AddrRAM
	,output reg						RAMOutputWRen
	);



//----------------------Bias on D-----------------------//
//------------------------------------------------------//
reg SynchrMt, SynchrMd;

always @(negedge ClockFromADC)
begin
	SynchrMt	<=	SynchrM;
	SynchrMd	<=	SynchrMt;
end

always @(posedge Fsk)
begin
	DistanceRegI <= Distance;
end

//reg [12:0]	CounterStart;
always @(negedge ClockFromGen)
begin
if (!Reset)
	begin
		if (SynchrMt && (!SynchrMd))
			begin
				CounterStart	<= 13'd0;
				WriteStart		<= 1'b0;
			end
		else
			begin
				if (CounterStart < 4160)
					begin
						CounterStart	<= CounterStart	+	1'b1;
					end
					
				if (DistanceRegI < 16'd127)
					begin
						if (CounterStart == 5)
							begin
								WriteStart <= 1'b1;
							end
					end
				else 
					begin
						if	(DistanceRegI > 16'd4160)
							begin
								if (CounterStart == 4160/* - 2*/)
									begin
										WriteStart <= 1'b1;
									end
							end
						else
							begin
								if (CounterStart == DistanceRegI - 128/* - 3*/)
									begin
										WriteStart <= 1'b1;
									end
							end
					end
			end
	end
else
	begin
		CounterStart	<= 13'd8191;
	end
end
//------------------------------------------------------//
//------------------------------------------------------//





//------------------Number of SynchrM-------------------//
//------------------------------------------------------//
//
//reg	FskRegI, FskRegII;
//
//reg	[6:0]	AddrROM;
//
//wire	ResetSynchM;
assign ResetSynchrM = (FskRegI && !FskRegII);

always @(posedge SynchrM)
begin
	FskRegI	<= Fsk;
	FskRegII	<= FskRegI;
end

always @(posedge SynchrM or posedge ResetSynchrM)
begin
	if (ResetSynchrM)
		begin
			AddrROM <= 7'd0;												// !!!to correct!!! Sync of FSK???
		end
	else
		begin
			AddrROM	<=	AddrROM + 1'b1;								// Number of SynchrM
		end
end
//------------------------------------------------------//
//------------------------------------------------------//



//-------------------Find harm--------------------//
//------------------------------------------------------//
//reg	[35:0] sinReg, cosReg, UReg;

assign RAMAccWriteEnable = RAMWRStart? CLKDividedCountI: 1'b0;

always @(negedge CLKCorr)
begin
	UReg	<= DataCorr[19:2];
	sinReg	<= ROMsin*DataCorr[19:2];
	cosReg	<= ROMcos*DataCorr[19:2];
end

always @(posedge CLKCorr)
begin
	if (AddrROM == 0) // wrong (63)
		begin
			DataIm	<= sinReg[35:18];
			DataRe	<= cosReg[35:18];
			DataU	<= UReg;
		end
	else
		begin
			if (!DataIm[19]&&DataIm[18])
				DataIm	<= 20'b01011111111111111111;
			else
				if (DataIm[19]&&!DataIm[18])
					DataIm	<= 20'b10100000000000000000;
				else
					DataIm	<= DataAccIm	+	sinReg[35:18];
				
			if (!DataRe[19]&&DataRe[18])
				DataRe	<= 20'b01011111111111111111;
			else
				if (DataRe[19]&&!DataRe[18])
					DataRe	<= 20'b10100000000000000000;
				else
					DataRe	<= DataAccRe	+	cosReg[35:18];
			
//			if (DataU > 18'h3FFFF)
			if (DataU[18])
				begin
					DataU		<= 18'h3FFFF;
				end
			else
				begin
					DataU		<= DataAccU	+	UReg;
				end
		end
end

always @(posedge CLKDivFaster)
begin
	if (AddrROM == 7'd15)
		RAMOutputWRen	<= 1'b1;
	else
		RAMOutputWRen	<= 1'b0;
end

//------------------------------------------------------//
//------------------------------------------------------//

endmodule

