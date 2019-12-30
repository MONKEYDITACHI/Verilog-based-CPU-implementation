module datapath(tlab,tpcX,tpc,tRDM,tregY,treg,RDM,spSel,inc,clk,WRR,ldsp,retCh,fn,IRController,D_bus,X,Y,
R,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut);
	input wire tlab,tpcX,tpc,tRDM,tregY,treg,RDM,spSel,inc,clk,WRR,ldsp,retCh;
	input wire [2:0] fn;
	output wire [6:0] IRController;
	
	wire D_cond,cout_1,cout_2,Cin,Vin,Zin,Sin,pcMUXCheck;
	output wire [15:0] D_bus,X,Y;
	output wire [15:0] R,pcOut,pcMUXOut,pcAdderOut,instructionMemoryOut,IROut,regBankOut,spAdderOut,spOut,spMUXOut,YOut,tregYOut,tregOut,tRDMOut,tpcOut,tpcXOut,tlabOut;
	
	assign X = tpcXOut;
	assign X = tRDMOut;
	assign Y = tregYOut;
	assign Y = tlabOut;
	assign D_bus = tpcOut;
	assign D_bus = tregOut;
	assign IRController = IROut[15:9];
	assign pcMUXCheck = D_cond | retCH;
	
	pc pcInit(pcMUXOut,clk,pcOut);
	pcAdder pcAdderInit(pcOut,pcAdderOut);
	pcMUX pcMUXInit(pcAdderOut,R,pcMUXCheck,pcMUXOut);
	instructionMemory instructionMemoryInit(instructionMemoryOut,pcOut);
	IR IRInit(instructionMemoryOut,IROut);
	regBank regBankInit(R,regBankOut,IROut[8:6],WRR,clk);
	sp spInit(spAdderOut,clk,spOut,ldsp);
	spAdder spAdderInit(spOut,spAdderOut,inc);
	spMUX spMUXInit(spOut,spAdderOut,spMUXOut,spSel);
	dataMemory dataMemoryInit(D_bus,spMUXOut,RDM);
	ALU ALUInit(X,Y,R,fn,cout_1,cout_2);
	statusDetect statusDetectInit(cout_1,cout_2,R,Cin,Vin,Zin,Sin);
	statusSelect statusSelectInit(IROut[15:12],Cin,Vin,Zin,Sin,D_cond);
	tregSwitch tregSwitchInit(regBankOut,treg,tregOut);
	tregYSwitch tregYSwitchInit(regBankOut,tregY,tregYOut);
	tRDMSwitch tRDMSwitchInit(D_bus,tRDM,tRDMOut);
	tpcSwitch tpcSwitchInit(pcAdderOut,tpc,tpcOut);
	tpcXSwitch tpcXSwitchInit(pcAdderOut,tpcX,tpcXOut);
	tlabSwitch tlabSwitchInit(IR[11:0],tlab,tlabOut);	
	
endmodule

module Station_IF_RD(pcAdderOut,IROut,WRR,spMUXOut,RDM,fn,treg,tregY,tRDM,tpc,tpcX,tlab,clk);
	input wire [15:0] pcAdderOut,IROut,spMUXOut;
	input wire WRR,RDM,fn,treg,tregY,tRDM,tpc,tpcX,tlab;
	input wire clk;
	
	output reg [15:0] O_pcAdderOut,O_IROut,O_spMUXOut;
	output reg O_WRR,O_RDM,O_fn,O_treg,O_tregY,O_tRDM,O_tpc,O_tpcX,O_tlab;
	
	always @(posedge clk)
		begin
			O_pcAdderOut = pcAdderOut;
			O_IROut = IROut;
			O_spMUXOut = spMUXOut;
			O_WRR = WRR;
			O_RDM = RDM;
			O_fn = fn;
			O_treg = treg;
			O_tregY = tregY;
			O_tRDM = tRDM;
			O_tpc = tpc;
			O_tpcX = tpcX;
			O_tlab = tlab;
		end
	
endmodule

module tlabSwitch(inp,tsel,out);
	input wire [11:0] inp;
	input wire tsel;
	output wire [15:0] out;
	
	assign out = tsel ? inp : 16'bz;
	
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

module ALU(X,Y,R,fn,cout_1,cout_2);
	input wire [15:0] X,Y;
	input wire [2:0] fn;
	output reg [15:0] R;
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
				7 : begin
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
					end
				3 : begin
					#0.01 R = -X;
					cout_1=0;
					cout_2=0;
					end
				4 : begin
					#0.01 R = X|Y;
					cout_1=0;
					cout_2=0;
					end
				5 : begin
					#0.01 R = ~X;
					cout_1=0;
					cout_2=0;
					end
				6 : begin
				    #0.01 R = X;
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
	integer i;
	reg [15:0] RAM[0:255];
	
	initial 
		begin
			RAM[20] = 16'd5;
			RAM[21] = 16'd4;
			RAM[22] = 16'd2;
		end
	
	assign D_bus = RDM ? out : 16'bz;
	
	always @(A_bus or RDM)
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

module regBank(inp,out,PAR,WRR,clk);
	input wire [15:0] inp;
	input wire [2:0] PAR;
	input wire WRR,clk;
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
	
	always @(posedge clk)
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
			RAM[100] = 16'b0000011000000000;
			RAM[101] = 16'b0000010000000000;
			RAM[102] = 16'b0000010000000000;
			RAM[103] = 16'b0000000000000000;
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
	
	always @(negedge clk)
		begin
			out = inp;
		end
	
endmodule
