module testbench;
	wire RMAR,RR,tIR,tMDR,tbuff,RDR,tpc,tMAR,tsp,ldbuff,ldIR,RDM,ldpc,ldsp,ldMDR,ldMAR,WRR,D_cond,cout_1,cout_2,Cin,Vin,Sin;
	reg clk;
	wire [2:0] fn;
	wire [6:0] IRController;
	wire [15:0] spOut,pcOut,MDROut,MAROut,MDRinp,regBankOut,IROut,buffOut,X,Y,DBus,ABus,labelOut,RBus,inpBus,RMAROut,RROut,tIROut,tMDROut,tbuffOut,RDROut,tpcOut,tMAROut,tspOut;
	datapath datapathInit (RMAR,RR,tIR,tMDR,tbuff,RDR,tpc,tMAR,tsp,ldbuff,ldIR,RDM,fn,ldpc,ldsp,ldMDR,ldMAR,WRR,IRController,spOut,D_cond,cout_1,cout_2,Cin,Vin,Sin,pcOut,MDROut,MAROut,MDRinp,regBankOut,IROut,buffOut,X,Y,DBus,ABus,labelOut,RBus,inpBus,RMAROut,RROut,tIROut,tMDROut,tbuffOut,RDROut,tpcOut,tMAROut,tspOut);
	controller controllerInit (clk, IRController, tMAR, ldMAR, RDM, ldIR, tIR, RR, RMAR, ldMDR, tMDR, ldbuff, tbuff, RDR, WRR, ldsp, tsp, tpc, ldpc, fn);
	
	initial 
		begin
			$dumpfile ("beh.vcd");
			$dumpvars;			
		end
	
	initial
		begin
			/*tpc =1;
			fn = 6;
			ldMAR = 1;
			RMAR = 0;
			RR = 0;
			tIR = 0;
			tMDR = 0;
			tbuff = 0;
			RDR = 0;
			tMAR = 0;
			tsp = 0;
			ldbuff = 0;
			ldIR = 0;
			RDM = 1;
			ldpc = 0;
			ldsp = 0;
			ldMDR = 0;
			WRR = 0;
			
			#10;
			fn = 7;
			RDM = 1;
			tMAR = 1;
			ldIR = 1;
			tpc = 0;
			ldMAR = 0;
			
			#10
			tpc = 1;
			fn = 0;
			ldpc = 1;
			tMAR = 0;
			ldIR = 0;
			
			#10
			tpc = 0;
			fn = 7;
			ldpc = 0;
			tIR = 1;
			ldMDR = 1;
			
			#10
			tIR = 0;
			ldMDR = 0;
			tpc = 1;
			ldbuff = 1;
			
			#10
			tpc = 0;
			ldbuff = 0;
			tbuff = 1;
			tMDR = 1;
			fn = 2;
			ldpc = 1;*/
			clk <= 1;
			
			#250 $finish; 
			
		end
		
		always
			begin
				#1 clk<=!clk;
			end
		
		
endmodule

module controller (clk, ir, tmar, ldmar, rdm, lir, tir, rr, rmar, ldmdr, tmdr, ldbuff, tbuff, rdr, wrr, ldsp, tsp, tpc, ldpc, fnsel);

	input wire clk;
	input wire [6:0] ir;

	output reg tmar, ldmar, rdm, lir, tir, rr;
	output reg ldmdr, tmdr, rmar, ldbuff, tbuff, rdr, wrr;
	output reg ldsp, tsp, tpc, ldpc;
	output reg [2:0] fnsel; 

	reg [2:0] cno;
	reg [4:0] st;

	reg en1, over;
	wire c1, c2, c3, c4, c5;

	assign c1 = (ir[6:3] == 0) ? 1 : 0;
	assign c2 = (ir[2:0] == 0) ? 1 : 0;
	assign c3 = (ir[2:0] == 6) ? 1 : 0;
	assign c4 = ((ir[2:0] == 2) || (ir[2:0] == 4)) ? 1 : 0;
	assign c5 = (ir[6:3] == 10) ? 1 : 0;

	initial
		begin
			st <= 0;
			cno <= 3;
			tmar <= 0;
			ldmar <= 0;
			rdm <= 1;
			lir <= 0;
			tir <= 0;
			rr <= 0;
			ldmdr <= 0;
			tmdr <= 0;
			ldbuff <= 0;
			tbuff <= 0;
			rdr <= 0;
			wrr <= 0;
			ldsp <= 0;
			rmar <= 0;
			tsp <= 0;
			tpc <= 0;
			ldpc <= 0;
			fnsel <= 7; 
			over <= 0;
		end

	always @(posedge clk)
		begin
			case (st)
				0: 	begin
						case (cno)
							0:	begin
									tpc <= 0;
									ldmar <= 0;
									tmar <= 1;
									lir <= 1;
									fnsel <= 7;
									cno <= 1;
								end
							1:	begin
									tmar <= 0;
									lir <= 0;
									tpc <= 1;
									fnsel <= 0;
									ldpc <= 1;
									cno <= 2;
								end
							2:	begin
									tpc <= 0;
									fnsel <= 7;
									ldpc <= 0;
									cno <= 0;
									if (c1)
										begin
											if (c2)
												begin
													st <= 1;
													tsp <= 1;
													fnsel <= 1;
													ldmar <= 1;
													ldsp <= 1;
												end
											else
												begin
													st <= 2;
													tsp <= 1;
													fnsel <= 6;
													ldmar <= 1;
												end
										end
									else
										begin
											if (c5)
												begin
													st <= 8;
													tsp <= 1;
													fnsel <= 1;
													ldmar <= 1;
													ldsp <= 1;
												end
											else
												begin
													st <= 7;
													tir <= 1;
													ldmdr <= 1;
												end
										end
								end
							3:	begin
									cno <= 0;
									tpc <= 1;
									fnsel <= 6;
									ldmar <= 1;
								end							
						endcase
					end
				1:	begin
						case (cno)
							0:	begin
									tsp <= 0;
									fnsel <= 7;
									ldmar <= 0;
									ldsp <= 0;
									rdr <= 1;
									fnsel <= 6;
									rr <= 1;
									ldmdr <= 1;
									cno <= 1;
								end
							1:	begin
									rdr <= 0;
									fnsel <= 7;
									rr <= 0;
									ldmdr <= 0;
									tmar <= 1;
									rdm <= 0;
									rmar <= 1;
									cno <= 2;
								end
							2:	begin
									tmar <= 0;
									rdm <= 1;
									rmar <= 0;
									cno <= 0;
									st <= 0;
									tpc <= 1;
									fnsel <= 6;
									ldmar <= 1;
								end
						endcase
					end
				2:	begin
						case (cno)
							0:	begin
									tsp <= 0;
									fnsel <= 7;
									ldmar <= 0;
									tmar <= 1;
									rmar <= 1;
									ldmdr <= 1;
									cno <= 1;
								end
							1:	begin
									tmar <= 0;
									rmar <= 0;
									ldmdr <= 0;
									cno <= 0;
									if (c3)
										begin
											tmdr <= 1;
											fnsel <= 6;
											ldpc <= 1;
											st <= 3;
										end
									else
										begin
											if (c4)
												begin
													rdr <= 1;
													ldbuff <= 1;
													st <= 5;
												end
											else
												begin
													tmdr <= 1;
													tbuff <= 1;
													fnsel <= ir[2:0];
													wrr <= 1;
													st <= 4;
												end
										end
								end
						endcase
					end
				3:	begin
						tmdr <= 0;
						ldpc <= 0;
						tsp <= 1;
						fnsel <= 0;
						ldsp <= 1;
						st <= 6;
					end
				4:	begin
						tmdr <= 0;
						tbuff <= 0;
						wrr <= 0;
						tsp <= 1;
						fnsel <= 0;
						ldsp <= 1;
						st <= 6;
					end
				5:	begin
						rdr <= 0;
						ldbuff <= 0;
						tmdr <= 1;
						tbuff <= 1;
						fnsel <= ir[2:0];
						wrr <= 1;
						st <= 4;
					end
				6:	begin
						tsp <= 0;
						ldsp <= 0;									
						tpc <= 1;
						fnsel <= 6;
						ldmar <= 1;
						st <= 0;
					end
				7:	begin
						case (cno)
							0:	begin
									tir <= 0;
									ldmdr <= 0;
									tpc <= 1;
									ldbuff <= 1;
									cno <= 1;
								end
							1:	begin
									tpc <= 0;
									ldbuff <= 0;
									tbuff <= 1;
									tmdr <= 1;
									fnsel <= 2;
									ldpc <= 1;
									cno <= 2;
								end
							2:	begin
									tbuff <= 0;
									tmdr <= 0;
									ldpc <= 0;
									cno <= 0;
									tpc <= 1;
									fnsel <= 6;
									ldmar <= 1;
									st <= 0;
								end
						endcase
					end
				8:	begin
						case (cno)
							0:	begin
									ldmar <= 0;
									tsp <= 0;
									ldsp <= 0;
									tpc <= 1;
									fnsel <= 6;
									rr <= 1;
									ldmdr <= 1;
									cno <= 1;
								end
							1:	begin
									tpc <= 0;
									rr <= 0;
									ldmdr <= 0;
									fnsel <= 7;
									tmar <= 1;
									rdm <= 0;
									rmar <= 1;
									cno <= 2;
								end
							2:	begin
									tmar <= 0;
									rdm <= 1;
									rmar <= 0;
									fnsel <= 7;
									tir <= 1;
									ldmdr <= 1;
									cno <= 0;							
									st <= 7;
								end
						endcase
					end
			endcase
		end

endmodule

module datapath(RMAR,RR,tIR,tMDR,tbuff,RDR,tpc,tMAR,tsp,ldbuff,ldIR,RDM,fn,ldpc,ldsp,ldMDR,ldMAR,WRR,IRController,spOut,D_cond,cout_1,cout_2,Cin,Vin,Sin,pcOut,MDROut,MAROut,MDRinp,regBankOut,IROut,buffOut,X,Y,DBus,ABus,labelOut,RBus,inpBus,RMAROut,RROut,tIROut,tMDROut,tbuffOut,RDROut,tpcOut,tMAROut,tspOut);
	input wire RMAR,RR,tIR,tMDR,tbuff,RDR,tpc,tMAR,tsp,ldbuff,ldIR,RDM,ldpc,ldsp,ldMDR,ldMAR,WRR;
	input wire [2:0] fn;
	output wire [6:0] IRController;
	
	output wire [15:0] inpBus;
	output wire [15:0] RBus,R_cond;
	output wire [15:0] spOut,pcOut,MDROut,MAROut,MDRinp,regBankOut,IROut,buffOut,X,Y,DBus,ABus,labelOut;
	output wire cout_1,cout_2,Cin,Vin,Sin;
	output wire D_cond;
	output wire [15:0] RMAROut,RROut,tIROut,tMDROut,tbuffOut,RDROut,tpcOut,tMAROut,tspOut;
	assign IRController = IROut[15:9];
	assign X = inpBus;
	assign Y = tbuffOut;
	assign inpBus = tspOut;
	assign inpBus = RDROut;
	assign inpBus = tpcOut ;
	assign inpBus = tMDROut ;
	assign MDRinp = RMAROut;
	assign MDRinp = tIROut;
	assign MDRinp = RROut ;
	assign ABus = tMAROut;
	assign DBus = RDM ? 16'bz : MDROut;
	
	sp spInit (RBus,ldsp,spOut);
	pc pcInit (RBus,ldpc,pcOut);
	MDR MDRInit (MDRinp,ldMDR,MDROut);
	MAR MARInit (RBus,ldMAR,MAROut);
	regBank regBankInit (RBus,regBankOut,IROut[8:6],WRR);
	buff buffInit (inpBus,ldbuff,buffOut);
	ALU ALUInit (X,Y,RBus,R_cond,fn,cout_1,cout_2);
	statusDetect statusDetectInit (cout_1,cout_2,R_cond,Cin,Vin,Zin,Sin);
	statusSelect statusSelectInit (IROut[15:12],Cin,Vin,Zin,Sin,D_cond);
	memory memoryInit (DBus,ABus,RDM);
	IR IRInit (DBus,ldIR,IROut);
	labelSelect labelSelectInit (IROut[11:0],D_cond,labelOut);	
	RMARSwitch RMARSwitchInit (DBus,RMAR,RMAROut);
	RRSwitch RRSwitchInit (RBus,RR,RROut);
	tIRSwitch tIRSwitchInit (labelOut,tIR,tIROut);
	tMDRSwitch tMDRSwitchInit (MDROut,tMDR,tMDROut);
	tbuffSwitch tBuffSwitchInit (buffOut,tbuff,tbuffOut);
	RDRSwitch RDRSwitchInit (regBankOut,RDR,RDROut);
	tpcSwitch tpcSwitchInit (pcOut,tpc,tpcOut);
	tMARSwitch tMARSwitchInit (MAROut,tMAR,tMAROut);
	tspSwitch tspSwitchInit (spOut,tsp,tspOut);	
	 
endmodule

module RMARSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module RRSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tIRSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tMDRSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tbuffSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module RDRSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tpcSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tMARSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tspSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module labelSelect(inp,D_cond,out);
	input wire [11:0] inp;
	input wire D_cond;
	output wire [15:0] out;
	
	assign out = D_cond ? {inp[11],inp[11],inp[11],inp[11],inp} : 0;
	
endmodule

module memory(D_bus,A_bus,RDM);
	input wire [15:0] A_bus;
	inout wire [15:0] D_bus;
	input wire RDM;
	
	reg [15:0] out; 
	integer i;
	reg [15:0] RAM[0:255];
	
	initial 
		begin
			RAM[20] = 16'd5;
			RAM[21] = 16'd4;
			RAM[22] = 16'd2;
			RAM[23] = 16'd5;
			RAM[24] = 16'd1;
			RAM[25] = 16'd2;
			RAM[26] = 16'd1;
			RAM[100] = 16'b0000011000000000;
			RAM[101] = 16'b0000010000000000;
			RAM[102] = 16'b0000010000000000;
			RAM[103] = 16'b0000000000000000;
			RAM[104] = 16'b1001111111111011;
		end
	
	assign D_bus = RDM ? out : 16'bz;
	
	always @(A_bus)
		begin
			if(RDM == 0)
				begin
					i = A_bus;
			 		RAM[i] = D_bus;
			 	end
			else
				begin
					i = A_bus;
					out = RAM[i];
				end
				 	
		end
	 
	
endmodule

module statusSelect(select,Cin,Vin,Zin,Sin,D_cond);
	input wire[3:0] select;
	input wire Cin,Vin,Zin,Sin;
	output reg D_cond;
	wire Cout,CoutBar,Vout,VoutBar,Zout,ZoutBar,Sout,SoutBar;
	
	signFF S (Sin,Sout,SoutBar);
	zeroFF Z (Zin,Zout,ZoutBar);
	overflowFF OF (Vin,Vout,VoutBar);
	carryFF C (Cin,Cout,CoutBar);
	
	always @(select)
		begin
			case(select)
				0 : D_cond = 0;
				1 : D_cond = 1;
				2 : D_cond = Cout;
				3 : D_cond = CoutBar;
				4 : D_cond = Zout;
				5 : D_cond = ZoutBar;
				6 : D_cond = Vout;
				7 : D_cond = VoutBar;
				8 : D_cond = Sout;
				9 : D_cond = SoutBar;
				10 : D_cond = 1;
				default : D_cond = 1'bz;
			endcase
		end   		
		
		
endmodule

module statusDetect(cout_1,cout_2,R,Cin,Vin,Zin,Sin);
	input wire cout_1,cout_2;
	input wire [15:0] R;
	output wire Cin,Vin,Zin,Sin;
	
	assign Cin = cout_1;
	assign Vin = cout_1^cout_2;
	assign Zin = !R;
	assign Sin = R[15];  

endmodule

module signFF(inp,q,qBar);
	input wire inp;
	output reg q;
	output wire qBar;
	
	assign qBar = ~q;
	
	always @(inp)
		begin
			q = inp;
		end
		
endmodule

module zeroFF(inp,q,qBar);
	input wire inp;
	output reg q;
	output wire qBar;
	
	assign qBar = ~q;
	
	always @(inp)
		begin
			q = inp;
		end
		
endmodule

module overflowFF(inp,q,qBar);
	input wire inp;
	output reg q;
	output wire qBar;
	
	assign qBar = ~q;
	
	always @(inp)
		begin
			q = inp;
		end
		
endmodule

module carryFF(inp,q,qBar);
	input wire inp;
	output reg q;
	output wire qBar;
	
	assign qBar = ~q;
	
	always @(inp)
		begin
			q = inp;
		end
		
endmodule

module ALU(X,Y,R,R_cond,fn,cout_1,cout_2);
	input wire [15:0] X,Y;
	input wire [2:0] fn;
	output reg [15:0] R,R_cond;
	output reg cout_1,cout_2;
	reg [16:0] ans;
	reg [14:0] psuedoX,psuedoY;
	
	initial
		begin
			cout_1 = 1'b1;
			cout_2 = 1'b1;
		end
	
	always @(fn)
		begin
			case(fn)				
				0 : begin
					#0.01 ans = X+1;
					R = ans[15:0];
					end
				1 : begin
					#0.01 ans = X-1;
					R = ans[15:0];
					end
				2 : begin
					#0.01 psuedoX = X[14:0];
					psuedoY = Y[14:0];
					ans = psuedoX+psuedoY;
					cout_2 = ans[15];
					ans = X+Y;
					cout_1 = ans[16];
					R = ans[15:0];
					R_cond = R;
					end
				3 : begin
					#0.01 R = -X;
					R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				4 : begin
					#0.01 R = X|Y;
					R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				5 : begin
					#0.01 R = ~X;
					R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				6 : begin
				    #0.01 R = X;
					end						
				7 : begin
					R = 0;
					end 
			endcase
		end
	
	
endmodule

module regBank(inp,out,PAR,WRR);
	input wire [15:0] inp;
	input wire [2:0] PAR;
	input wire WRR;
	output reg [15:0] out;
	reg ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7;
	wire [15:0] out0,out1,out2,out3,out4,out5,out6,out7;
	
	reg0 r0 (inp,ld0,out0);
	reg1 r1 (inp,ld1,out1);
	reg2 r2 (inp,ld2,out2);
	reg3 r3 (inp,ld3,out3);
	reg4 r4 (inp,ld4,out4);
	reg5 r5 (inp,ld5,out5);
	reg6 r6 (inp,ld6,out6);
	reg7 r7 (inp,ld7,out7);
	
	always @(PAR or WRR)
		begin
			case(PAR)
				0 : out = out0;
				1 : out = out1;
				2 : out = out2;
				3 : out = out3;
				4 : out = out4;
				5 : out = out5;
				6 : out = out6;
				7 : out = out7;
			endcase
		end
		
	always @(WRR)
		begin
			if(WRR == 1)
				begin
					case(PAR)
						0 : ld0 = 1;
						1 : ld1 = 1;
						2 : ld2 = 1;
						3 : ld3 = 1;
						4 : ld4 = 1;
						5 : ld5 = 1;
						6 : ld6 = 1;
						7 : ld7 = 1; 
					endcase
				end
			else
				{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7} = 8'b0;
		end

endmodule

module reg0(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg1(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg2(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg3(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg4(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg5(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg6(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module reg7(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module pc(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	initial out = 100;
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module sp(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	initial out = 20; 
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module MDR(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module MAR(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module buff(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule

module IR(inp,ld,out);
	input wire [15:0] inp;
	input wire ld;
	output reg [15:0] out;
	
	always @(ld or inp)
		begin
			if(ld==1) out = inp;
		end
	
endmodule
