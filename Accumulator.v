module Accumulator (
	input	[7:0]		Column,
	input [19:0]	DataDec,
	input				DDC, 
	input				DDR,
	input				ClockFromGen,
	input				Reset,
	output wire [19:0]	DataAccOut,
	output			DataAccClock,
	output	reg	DataAccReady
	,output	reg	[8:0]	AddrReadCycl
	,output	reg 	ColumnChangeRegI, ColumnChangeRegII
	,output	reg	[7:0]	ColumnReg
	,output	reg	[8:0]	AddrWriteAcc
	,output	reg	RegStartDDR
	,output	reg	[19:0]	DataAccRead
	,output	reg	[8:0] AddrReadOut
	,output	wire	WriteEnableAcc
	,output	wire	ClockReadAcc
	,output	wire	[19:0] DataAccWrite
	,output	wire	[8:0] AddrReadAcc
	,output	reg	Clock50MHz, Clock25MHz, Clock12MHz, ColumnChange
	,output	reg 	[5:0] IterationOnColumn = 0
);

assign DataAccClock = !Clock12MHz;

//assign OOO = (Column == ColumnReg)?	1'b1	:	0;
//reg [19:0]	DataAccRead;
//assign	DataAccOut	=	ColumnChange	?	DataAccRead	/	(IterationOnColumn/* + 1'b1*/)	:	20'd0;
assign	DataAccOut	=	ColumnChange	?	DataAccRead	:	20'd0;

//wire WriteEnableAcc;
assign WriteEnableAcc	=	(IterationOnColumn == 6'd63)	?	1'b0	:	DDR;

//wire ClockReadAcc;
assign ClockReadAcc	=	ColumnChange	?	Clock12MHz	:	!DDC;

//wire [19:0] DataAccWrite;
//assign DataAccWrite	=	ColumnChange	?	(DataDec >> 1)	:	(((DataDec /*>> 1*/) + DataAccRead) >> 1);
//assign DataAccWrite	=	ColumnChange	?	DataDec	:	((DataDec	+	DataAccRead) >> 1);							// рабочий, но странный вариант
//assign DataAccWrite	=	ColumnChange	?	(DataDec	>>	1)	:	((DataDec	>>	1)	+	(DataAccRead	>>	1));
assign DataAccWrite	=	ColumnChange	?	DataDec	:	DataDec	+	DataAccRead; // Поставить детектор переполнений

//wire [8:0] AddrReadAcc;
assign AddrReadAcc	=	ColumnChange	?	AddrReadOut	:	AddrReadCycl;

//--------------------------------------------------------//
//----------------Делитель частоты на 8-------------------//
//reg	Clock50MHz, Clock25MHz, Clock12MHz;
initial
begin
	Clock50MHz	<= 0;
	Clock25MHz	<= 0;
	Clock12MHz	<= 0;
end

always @(posedge ClockFromGen)
	Clock50MHz <= !Clock50MHz;
always @(posedge Clock50MHz)
	Clock25MHz <= !Clock25MHz;
always @(posedge Clock25MHz)
	Clock12MHz <= !Clock12MHz;
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//-------Установка адреса при аккумулирвоании-------------//
//reg	[8:0]	AddrReadCycl;																											//

always @(posedge DDC)
begin
	if (!DDR)
		AddrReadCycl	<= 0;
	else
		if (AddrReadCycl < 9'd511)
			AddrReadCycl <= AddrReadCycl + 1'b1;
end
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//-------Установка адреса чтения при смене столбца--------//
//reg ColumnChangeRegI, ColumnChangeRegII;																					//
always @(posedge Clock12MHz)
begin
	ColumnChangeRegI	<= ColumnChange;
	ColumnChangeRegII	<= ColumnChangeRegI;
end

//reg	[8:0] AddrReadOut;																											//

always @(negedge Clock12MHz)
begin
if (!Reset)
	if (ColumnChangeRegI && !ColumnChangeRegII)
	begin
		AddrReadOut		<=	1'b0;
		DataAccReady	<=	1'b1;
	end
	else
	begin
		if (AddrReadOut	< 9'd511)
			AddrReadOut	<= AddrReadOut + 1'b1;
		DataAccReady	<=	1'b0;
	end
else
begin
	AddrReadOut		<= 9'd511;
	DataAccReady	<=	1'b0;
end
end
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//------------Регистр сравнения стобцов-------------------//
//reg	[7:0]	ColumnReg;																												//

//reg [6:0] CountMult;
//always @(posedge	DDR)
//begin
//	if (ColumnChange)
//		CountMult <= 0;
//	else
//		CountMult <= CountMult + 1'b1;			
//end

initial
begin
	ColumnChange	<= 0;
	ColumnReg		<=	0;
end

//always @(posedge DDR)
//begin
//	ColumnReg	<= Column;
//end

//reg ColumnChange;																													//
always @(negedge DDR or posedge Reset)
begin
	if(Reset)
		begin
			ColumnChange	<= 0;
			ColumnReg		<= 0;
		end
	else
		begin
			ColumnReg	<= Column;
			if (Column == ColumnReg)
				ColumnChange <= 0;
			else
				ColumnChange <= 1'b1;
		end
end
// Если флаг поднят, то следующий ЗапускМ запсывает без сложения
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//--------------------Регистр старта----------------------//
//reg RegStartDDR;

always @(posedge DDC)
begin
	if (!DDR)
		RegStartDDR	<=	1'd1;
	else
		RegStartDDR	<=	1'd0;
end
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//-------------------Счётчик записи-----------------------//
//reg	[8:0]	AddrWriteAcc;																											//

always @ (negedge DDC or posedge RegStartDDR)
begin
	if (RegStartDDR)
		AddrWriteAcc <= 0;
	else
		if (AddrWriteAcc < 9'd511)
			AddrWriteAcc	<= AddrWriteAcc + 1'd1;
end
//--------------------------------------------------------//
//--------------------------------------------------------//

//--------------------------------------------------------//
//----------------Память аккумулятора---------------------//
reg [19:0] RAMAcc[511:0];

//reg [5:0] IterationOnColumn;


always @(posedge RegStartDDR)
begin
	if (ColumnChangeRegI)
		IterationOnColumn <= 6'd0;
	else 
		if (IterationOnColumn == 6'd63)
			IterationOnColumn <= 6'd63;
		else
			IterationOnColumn <= IterationOnColumn + 1'b1;
end

/*
always @(posedge RegStartDDR)
begin
	if (ColumnChangeRegII)
		begin
			IterationOnColumn <= 0;
		end
	else
		begin
			if (IterationOnColumn == 7'd127)
				begin
					IterationOnColumn <= 127;
				end
			else
				begin
					iterationOnColumn <= IterationOnColumn + 1'b1;
				end
		end
end
*/

always @ (posedge DDC)
begin
	if (WriteEnableAcc)
		RAMAcc[AddrWriteAcc] <= DataAccWrite;
end


always @ (/*neg*/posedge ClockReadAcc)
begin
	DataAccRead <= RAMAcc[AddrReadAcc];
end
//--------------------------------------------------------//
//--------------------------------------------------------//
	
endmodule 