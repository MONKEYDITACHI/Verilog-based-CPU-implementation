module testbench;

	wire [6:0] IRController;
	wire tlab, tpcX, tpc, tRDM, tregY, treg, RDM, spSel, inc, WRR, ldsp, retCh,D_cond,pcMUXCheck;
	reg clk;
	wire [2:0] fn;
	wire [15:0] D_bus,X,Y;
	wire [15:0] R,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut;
	wire [15:0] S1_pcAdderOut,S1_IROut,S1_spMUXOut;
	wire S1_WRR,S1_RDM,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab;
	wire [2:0] S1_fn;
	wire S2_WRR;
	wire [2:0] S2_fn;
	wire [15:0] S2_X,S2_Y;
	wire [15:0] S3_R;
	wire S3_D_cond;
	

	controller controllerInit(IRController, tlab, tpcX, tpc, tRDM, tregY, treg, RDM, spSel, inc, WRR, fn, ldsp, retCh);
	datapath datapathInit(tlab,tpcX,tpc,tRDM,tregY,treg,RDM,spSel,inc,clk,WRR,ldsp,retCh,D_cond,pcMUXCheck,
							fn,IRController,
							D_bus,X,Y,R,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut,
							S1_pcAdderOut,S1_IROut,S1_spMUXOut,S1_WRR,S1_RDM,S1_fn,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab,
							S2_WRR,S2_X,S2_Y,S2_fn,
							S3_R,S3_D_cond);

	initial 
	 	begin 
	 		clk = 0;
		end
		
	initial 
		begin
			$dumpfile ("beh.vcd");
			$dumpvars;			
		end
	
	initial #100 $finish; 
		
	always
		#1 clk = !clk; 

endmodule

module controller (ir, tlab, tpcX, tpc, tRDM, tregY, treg, RDM, spSel, inc, WRR, fn, ldsp, retCh);

	input wire [6:0] ir;

	output wire tlab, tpcX, tpc, tRDM, tregY, treg, RDM, spSel, inc, WRR, ldsp, retCh;
	output wire [2:0] fn;

	wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12;

	nor n0 (c1, ir[6], ir[5], ir[4], ir[3]);
	nor n1 (c2, ir[2], ir[1], ir[0]);
	and a0 (c3, c1, c2);
	not n2 (c4, c2);
	and a1 (c5, c1, c4);
	not a2 (c6, c1);
	not n3 (c7, ir[5]);
	not n4 (c8, ir[3]);
	and a3 (c9, ir[6], c7, ir[4], c8);
	nor n6 (RDM, c9, c3);
	xnor n7 (c10, ir[6], ir[4]);
	and a4 (ldsp, c10, c7, c8);
	or o0 (spSel, c3, c9);
	and a5 (fn[2], c1, c4, ir[2]);
	and a6 (fn[0], c1, c4, ir[0]);
	and n8 (c11, c4, ir[1]);
	or o1 (fn[1], c11, c6);
	not n9 (c12, ir[0]);
	and a7 (retCh, c1, ir[2], ir[1], c12);

	assign treg = c3;
	assign WRR = c5;
	assign tregY = c5;
	assign tRDM = c5;
	assign inc = c5;
	assign tpcX = c6;
	assign tlab = c6;
	assign tpc = c9;

endmodule

module datapath(tlab,tpcX,tpc,tRDM,tregY,treg,RDM,spSel,inc,clk,WRR,ldsp,retCh,D_cond,pcMUXCheck,
				fn,IRController,
				D_bus,X,Y,R,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut,
				S1_pcAdderOut,S1_IROut,S1_spMUXOut,S1_WRR,S1_RDM,S1_fn,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab,
				S2_WRR,S2_X,S2_Y,S2_fn,
				S3_R,S3_D_cond);
	input wire tlab,tpcX,tpc,tRDM,tregY,treg,RDM,spSel,inc,clk,WRR,ldsp,retCh;
	input wire [2:0] fn;
	output wire [6:0] IRController;
	output wire D_cond;
	output reg pcMUXCheck;
	
	wire cout_1,cout_2,Cin,Vin,Zin,Sin;
	output wire [15:0] D_bus,X,Y;
	output wire [15:0] R,R_cond,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut;
	
	output wire [15:0] S1_pcAdderOut,S1_IROut,S1_spMUXOut;
	output wire S1_WRR,S1_RDM,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab;
	output wire [2:0] S1_fn;
	
	output wire S2_WRR;
	output wire [2:0] S2_fn;
	output wire [15:0] S2_X,S2_Y;
	output wire [15:0] S3_R;
	output wire S3_D_cond;
	
	assign X = tpcXOut;
	assign X = tRDMOut;
	assign Y = tregYOut;
	assign Y = tlabOut;
	assign D_bus = tpcOut;
	assign D_bus = tregOut;
	assign IRController = IROut[15:9];
	
	initial pcMUXCheck = 0;
	
	always @(D_cond or retCh)
		pcMUXCheck = D_cond | retCh;
	
	pc pcInit(pcMUXOut,clk,pcOut);
	pcAdder pcAdderInit(pcOut,pcAdderOut);
	pcMUX pcMUXInit(pcAdderOut,S3_R,pcMUXCheck,pcMUXOut);
	instructionMemory instructionMemoryInit(instructionMemoryOut,pcOut);
	IR IRInit(instructionMemoryOut,IROut);
	sp spInit(spAdderOut,clk,spOut,ldsp);
	spAdder spAdderInit(spOut,spAdderOut,inc);
	spMUX spMUXInit(spOut,spAdderOut,spMUXOut,spSel);
	
	stationIFRD stationIFRDInit(pcAdderOut,IROut,WRR,spMUXOut,RDM,fn,treg,tregY,tRDM,tpc,tpcX,tlab,clk,S1_pcAdderOut,S1_IROut,S1_spMUXOut,S1_WRR,S1_RDM,S1_fn,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab);
	
	regBank regBankInit(R,regBankOut,S1_IROut[8:6],S2_WRR);
	dataMemory dataMemoryInit(D_bus,S1_spMUXOut,S1_RDM);
	tregSwitch tregSwitchInit(regBankOut,S1_treg,tregOut);
	tregYSwitch tregYSwitchInit(regBankOut,S1_tregY,tregYOut);
	tRDMSwitch tRDMSwitchInit(D_bus,S1_tRDM,tRDMOut);
	tpcSwitch tpcSwitchInit(S1_pcAdderOut,S1_tpc,tpcOut);
	tpcXSwitch tpcXSwitchInit(S1_pcAdderOut,S1_tpcX,tpcXOut);
	tlabSwitch tlabSwitchInit(S1_IROut[11:0],S1_tlab,tlabOut);
	
	stationRDEX stationRDEX(S1_fn,X,Y,S1_WRR,clk,S2_WRR,S2_X,S2_Y,S2_fn);
	
	ALU ALUInit(S2_X,S2_Y,S3_R,R_cond,S2_fn,cout_1,cout_2);
	statusDetect statusDetectInit(cout_1,cout_2,R_cond,Cin,Vin,Zin,Sin);
	statusSelect statusSelectInit(IROut[15:12],Cin,Vin,Zin,Sin,D_cond);
	
	stationEXWB stationEXWBInit(clk,R,D_cond,S3_R,S3_D_cond);
		
	
endmodule

module stationEXWB(clk,R,D_cond,S3_R,S3_D_cond);
	input wire [15:0] R;
	input wire clk,D_cond;
	output reg [15:0] S3_R;
	output reg S3_D_cond;
	
	initial S3_D_cond = 0;
	
	always
		begin
		#1;
			S3_R = R;
			S3_D_cond = D_cond;
		end
endmodule

module stationRDEX(S1_fn,X,Y,S1_WRR,clk,S2_WRR,S2_X,S2_Y,S2_fn);
	input wire [2:0] S1_fn;
	input wire [15:0] X,Y;
	input wire S1_WRR,clk;
	output reg S2_WRR;
	output reg [2:0] S2_fn;
	output reg [15:0] S2_X,S2_Y;
	
	always @(posedge clk)
		begin
			S2_WRR = S1_WRR;
			S2_X = X;
			S2_Y = Y;
			S2_fn = S1_fn;
		end
	
endmodule

module stationIFRD(pcAdderOut,IROut,WRR,spMUXOut,RDM,fn,treg,tregY,tRDM,tpc,tpcX,tlab,clk,S1_pcAdderOut,S1_IROut,S1_spMUXOut,S1_WRR,S1_RDM,S1_fn,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab);
	input wire [15:0] pcAdderOut,IROut,spMUXOut;
	input wire WRR,RDM,treg,tregY,tRDM,tpc,tpcX,tlab,clk;
	input wire [2:0] fn;
	output reg [15:0] S1_pcAdderOut,S1_IROut,S1_spMUXOut;
	output reg S1_WRR,S1_RDM,S1_treg,S1_tregY,S1_tRDM,S1_tpc,S1_tpcX,S1_tlab;
	output reg [2:0] S1_fn;
	
	always @(posedge clk)
		begin
			
			S1_pcAdderOut = pcAdderOut;
			S1_IROut = IROut;
			S1_spMUXOut = spMUXOut;
			S1_WRR = WRR;
			S1_RDM = RDM;
			S1_fn = fn;
			S1_treg = treg;
			S1_tregY = tregY;
			S1_tRDM = tRDM;
			S1_tpc = tpc;
			S1_tpcX = tpcX;
			S1_tlab = tlab;
		end
	
endmodule

module tlabSwitch(inp,tsel,out);
	input wire [11:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? {inp[11],inp[11],inp[11],inp[11],inp} : 16'bz;
	
endmodule

module tpcXSwitch(inp,tsel,out);
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

module tRDMSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tregYSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
endmodule

module tregSwitch(inp,tsel,out);
	input wire [15:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
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
	
	initial
		begin
			D_cond = 0;
		end
	
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
				default : D_cond = 1'b0;
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
			#0.5;
			R_cond = 0;
			cout_1 = 1'b1;
			cout_2 = 1'b1;
		end
	
	always @(fn or X or Y)
		begin
			case(fn)				
				7 : begin
					 ans = X+1;
					R = ans[15:0];
					end
				1 : begin
					 ans = X-1;
					R = ans[15:0];
					end
				2 : begin
					psuedoX = X[14:0];
					psuedoY = Y[14:0];
					ans = psuedoX+psuedoY;
					cout_2 = ans[15];
					ans = X+Y;
					cout_1 = ans[16];
					R = ans[15:0];
					R_cond = R;
					end
				3 : begin
					 R = -X;
					 R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				4 : begin
					 R = X|Y;
					 R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				5 : begin
					 R = ~X;
					 R_cond = R;
					cout_1=0;
					cout_2=0;
					end
				6 : begin
				     R = X;
					end						
				0 : begin
					R = 0;
					end 
			endcase
		end
	
	
endmodule

module dataMemory(D_bus,A_bus,RDM);
	input wire [15:0] A_bus;
	inout wire [15:0] D_bus;
	input wire RDM;
	
	reg [15:0] out; 
	integer i,val;
	initial val = 0;
	reg [15:0] RAM[0:255];
	
	initial 
		begin
			RAM[19] = 16'd5;
			RAM[20] = 16'd7;
			RAM[21] = 16'd6;
			RAM[22] = 16'd9;
			RAM[23] = 16'd4;
			RAM[24] = 16'd3;
			RAM[25] = 16'd2;
			RAM[26] = 16'd1;
		end
	
	assign D_bus = RDM ? out : 16'bz;
	
	always @(A_bus or RDM)
		begin
			if(RDM == 0)
				begin
					val = val+1;
					i = A_bus;
			 		RAM[i] = D_bus;
			 	end
		end
	always @(A_bus)
		begin
			if(RDM == 1)
				begin
					i = A_bus;
					out = RAM[i];
				end
				 	
		end
	 
	
endmodule

module spMUX(inp1,inp2,out,spSel);
	input wire [15:0] inp1;
	input wire [15:0] inp2;
	input wire spSel;
	output wire [15:0] out;
	
	assign out = spSel ? inp2 : inp1 ;
	 
endmodule

module spAdder(inp,out,inc);
	input wire [15:0] inp;
	input wire inc;
	output wire [15:0] out;
	
	assign out = inc ? inp+1 : inp-1 ;
	
endmodule

module sp(inp,clk,out,ld);
	input wire [15:0] inp;
	input wire clk,ld;
	output reg [15:0] out;
	
	initial out = 20; 
	
	always @(posedge clk)
		begin
			if(ld == 1) out = inp;
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
	
	always @(PAR)
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
		
	always
		begin
			#1;
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

module IR(inp,out);
	input wire [15:0] inp;
	output reg [15:0] out;
	
	always @(inp)
		begin
			out = inp;
		end
	
endmodule

module instructionMemory(D_bus,A_bus);
	input wire [15:0] A_bus;
	output reg [15:0] D_bus;
	
	integer i;
	reg [15:0] RAM[0:255];
	
	initial 
		begin
			RAM[99]  = 16'b0000011000000000;
			RAM[100] = 16'b0000011000000000;
			RAM[101] = 16'b0000010000000000;
			RAM[102] = 16'b0000010000000000;
			RAM[103] = 16'b0000000000000000;
			RAM[104] = 16'b1001111111111011;
		end
	
	always @(A_bus)
		begin
			i = A_bus;
			D_bus = RAM[i];	 	
		end
	 
	
endmodule

module pcMUX(inp1,inp2,D_cond,out);
	input wire [15:0] inp1;
	input wire [15:0] inp2;
	input wire D_cond;
	output wire [15:0] out;
	
	assign out = D_cond ? inp2 : inp1 ;
 	 
endmodule

module pcAdder(inp,out);
	input wire [15:0] inp;
	output wire [15:0] out;
	
	assign out = inp+1;
	
endmodule

module pc(inp,clk,out);
	input wire [15:0] inp;
	input wire clk;
	output reg [15:0] out;
	
	initial out = 100;
	
	always @(posedge clk)
		begin
			out = inp;
		end
	
endmodule
