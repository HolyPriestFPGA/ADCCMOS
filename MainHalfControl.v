module MainHalfControl (
	input 					ClockFromADC,
	input 					ClockFromGen,
	input 					SynchrM,
	input 					Reset,
	input unsigned			[13:0] Data,
	input unsigned			[13:0] DataEven, DataOdd,
	output wire 			CLKDivPos, CLKDivNeg, CLKDivFaster,
	output wire /*reg*/	WriteEnableEven, ReadEnableEven, WriteEnableOdd, ReadEnableOdd,
	output wire				BuffOn,
	output reg			 	[11:0] AddrWriteEven, AddrWriteOdd,
	output reg 				[11:0] AddrReadEven, AddrReadOdd,
	output reg				RAMWriteClock,
	output wire signed 	[13:0] DataOut,
	output wire signed 	[13:0] DataOutSlow,
	output reg				ReadyBuff
	);

wire [13:0] DataEven_w, DataOdd_w;
assign DataEven_w = DataEven[13]	? {1'b0, DataEven[12:0]} : {1'b1, DataEven[12:0]};
assign DataOdd_w	= DataOdd[13]	? {1'b0, DataOdd[12:0]}	 : {1'b1, DataOdd[12:0]};


//assign DataOutSlow = CLKDivNeg? DataEven - 14'd8192: DataOdd - 14'd8192;
assign DataOutSlow = CLKDividedPos? DataEven_w: DataOdd_w;
//assign DataOutSlow = CLKDivNeg? DataEven: DataOdd;
	
reg SynchrMt, SynchrMd; // регистры детектора фронта SynchrM
reg WrEnt, WrEnd; 		// регистры детектора спада WrEn
	
//assign DataOut = Data - 14'd8192;
assign DataOut = Data;

assign BuffOn = (WrEnt && (!WrEnd))? 1'b1 : 1'b0;
	
assign WriteEnableEven	= (AddrWriteEven < 2176)?	1'b1 : 1'b0; // 2144 2176
assign ReadEnableEven	= (AddrReadEven < 2176)	?	1'b1 : 1'b0;

assign WriteEnableOdd	= (AddrWriteOdd < 2176)	?	1'b1 : 1'b0;
assign ReadEnableOdd		= (AddrReadOdd < 2176)	?	1'b1 : 1'b0;
	
reg CLKDividedPos = 0, CLKDividedNeg = 0, CLKDividedCount; // регистры делителя частоты
assign CLKDivNeg 		= !CLKDividedNeg;
assign CLKDivPos 		= !CLKDividedPos;
assign CLKDivFaster 	= !CLKDividedCount;	
	
//----
//always @(posedge ClockFromGen)
//begin
//	if (AddrWriteEven < 2144)	WriteEnableEven	<= 1;		else	WriteEnableEven	<= 0;
//	if (AddrReadEven	< 2144)	ReadEnableEven		<= 1;		else	ReadEnableEven		<= 0;
//	if (AddrWriteOdd	< 2144)	WriteEnableOdd		<= 1;		else	WriteEnableOdd		<= 0;
//	if (AddrReadOdd 	< 2144)	ReadEnableOdd		<= 1;		else	ReadEnableOdd		<= 0;
//end
//----	
always @(negedge CLKDivFaster)
begin
	ReadyBuff <= ReadEnableOdd;
end


//---------------Делитель клока АЦПшки------------------//
always @(posedge ClockFromADC)
begin
	RAMWriteClock <= !RAMWriteClock;
end
//------------------------------------------------------//
	
	
//------------------Детектор Фронтов--------------------//
always @(posedge RAMWriteClock)
begin
	SynchrMt <= SynchrM;
	SynchrMd <= SynchrMt;
end
//------------------------------------------------------//

//-----------------Делитель частоты---------------------//
always @(posedge ClockFromGen)
begin
/*	if (SynchrMt && (!SynchrMd))
		begin
			CountDivider <= 0; 										// 6
		end
	else
		begin
		if (CountDivider >= 0) begin								// 6
*/
			CLKDividedCount 	<= !CLKDividedCount;
/*			CountDivider 		<= 0;
		end
			else
				CountDivider <= CountDivider + 1'b1; // быстрый клок
	end
*/
end

always @(posedge CLKDividedCount) 
begin
	CLKDividedPos <= !CLKDividedPos;
end
/*
always @(negedge CLKDividedCount) 
begin						
if (Reset)				
	CLKDividedNeg <= CLKDividedPos;
else							
	CLKDividedNeg <= !CLKDividedNeg;
end
*/
//------------------------------------------------------//

		
//--------Счётчик адреса запси нечётных отсчётов--------//
always @(posedge RAMWriteClock)
begin
	AddrWriteOdd <= AddrWriteEven;				
end
//------------------------------------------------------//

reg pipaW;
//---------Счётчик адреса запси чётных отсчётов---------//
always @(negedge RAMWriteClock)
begin
if (!Reset)											//
begin													//
	if (SynchrMt && (!SynchrMd)) 
	begin
		AddrWriteEven <= 12'd0;
	end
	else
	begin
		if (AddrWriteEven < 12'd2176)
		begin
		/*
			AddrWriteEven [6:0] <= AddrWriteEven [6:0] + 1'b1;
			pipaW = (AddrWriteEven [6:0] == 127);
			AddrWriteEven [11:7] <= AddrWriteEven [11:7] + pipaW;
		*/
			AddrWriteEven	<=	AddrWriteEven +1'b1;
		end		
	end	
end
else													/**/
	begin
		AddrWriteEven <= 12'd2176;							
	end													/**/
end
//------------------------------------------------------//

reg pipaR;
//------------------Чтение чётных-----------------------//
always @(negedge CLKDivPos)	
begin
if (!Reset)											//
begin													//
	WrEnt <= WriteEnableEven;
	WrEnd <= WrEnt;
	if (WrEnt && (!WrEnd) && !ReadEnableEven)
	begin
		AddrReadEven <= 12'd0;
	end
	else
	begin
		if (AddrReadEven < 12'd2176)
		begin
		/*
			AddrReadEven [6:0] <= AddrReadEven [6:0] + 1'b1;
			pipaR = (AddrReadEven [6:0] == 127);
			AddrReadEven [11:7] <= AddrReadEven [11:7] + pipaR;
		*/
			AddrReadEven	<=	AddrReadEven	+	1'b1;
		end	
	end
end
else													/**/
begin
	AddrReadEven <= 12'd2176;
end													/**/
end
//------------------------------------------------------//


//-----------------Чтение нечётных----------------------//
always @(posedge CLKDivPos)	
begin
	AddrReadOdd <= AddrReadEven;	
end
//------------------------------------------------------//
endmodule
