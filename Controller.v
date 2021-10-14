module Controller (
	input Clock, RXDV,
	input [15:0]	RX, AD0, AP4, Noise, 
	input [7:0] Tstart,
	input [15:0] dFAP4, ReYY, ImYY, Ucp,
	output reg TXDV,
	output reg [15:0]	TX, 
	output reg [15:0]	Uupr, D = 0,
	output reg [7:0]	AddrRAM, Mode,
	output wire RAMOReadClock
//	,output reg RXDVI, RXDVII, RXDVIII
);

assign RAMOReadClock	=	RXDVII;

reg RXDVI, RXDVII, RXDVIII;
always @(posedge Clock)
begin
	RXDVI		<= RXDV;
	RXDVII	<=	RXDVI;
	RXDVIII	<= RXDVII;
	
	TXDV		<= RXDVIII;
end

reg [7:0] HalfU, HalfD;
always @(posedge RXDVI)
begin
	case (RX[15:8])
		8'd0:	
			begin
				Mode		<= RX[7:0];
				
				AddrRAM	<=	8'd0;
			end
		8'd1:
			begin
				HalfU		<= RX[7:0];
				
				AddrRAM	<=	8'd0;
			end
		8'd2:
			begin
				Uupr		<= {HalfU,RX[7:0]};
				
				AddrRAM	<=	8'd0;
			end
		8'd3:
			begin
				HalfD		<= RX[7:0];
				
				AddrRAM	<=	8'd0;
			end
		8'd4:
			begin
				D			<= {HalfD,RX[7:0]};
				
				AddrRAM	<=	8'd0;
			end
		8'd5:
			begin
//				if (RX[7:0] == 8'd0)
//					begin
//						AddrRAM	<=	8'd0;
//					end
//				else
//					begin
						AddrRAM	<= RX[7:0];
//					end
			end
		8'd6:
			begin
				if (RX[7:0] == 8'd0)
					begin
						AddrRAM	<= RX[7:0];
					end
				else
					begin
						AddrRAM	<= RX[7:0];
					end
			end
		8'd7:
			begin
				if (RX[7:0] == 8'd0)
					begin
						AddrRAM	<= RX[7:0];
					end
				else
					begin
						AddrRAM	<= RX[7:0];
					end
			end
		8'd8:
			begin
				AddrRAM	<=	8'd0;
			end
		default:
			begin
				Uupr		<=	16'd0;
				D			<= 16'd0;
				AddrRAM	<=	8'd0;
			end
	endcase
end

always @(posedge RXDVIII)
begin
	case (RX[15:8])
		8'd0:	
			begin
				TX		<= AD0;
//				TX		<= 16'hEFDA;
			end
		8'd1:
			begin
				TX		<=	AP4;
//				TX		<= 16'hEFDB;
			end
		8'd2:
			begin
				TX		<= Noise;
//				TX		<= 16'hEFDC;
			end
		8'd3:
			begin
				TX[7:0]		<= Tstart;
				TX[15:8]		<= 8'd0;
//				TX		<= 16'hEFDD;
			end
		8'd4:
			begin
				TX		<= dFAP4;
//				TX		<= 16'hEFDE;
			end
		8'd5:
			begin
//				if (RX[7:0] == 8'd0)
//					TX			<= dFAP4;
//				else
					TX			<=	ReYY;
//					TX			<=	{8'hFA, RX[7:0]};
			end
		8'd6:
			begin
//				if (RX[7:0] == 8'd0)
//					TX			<= ReYY;
//				else
					TX			<= ImYY;
//					TX			<=	{8'hFB, RX[7:0]};
			end
		8'd7:
			begin
//				if (RX[7:0] == 8'd0)
//					TX			<= ImYY;
//				else
					TX			<=	Ucp;
//					TX			<=	{8'hFC, RX[7:0]};
			end
		8'd8:
			begin
				TX		<= 16'h2B;
			end
			
		default:
			begin
				TX		<= 16'h2B;
			end
	endcase
end



endmodule
	