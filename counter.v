module counter (
	input CLOCK_50,
	input [17:0] SW,
	input [0:0] KEY,
	output [8:0] LEDG,
	output [17:0] LEDR,
	output [35:0] GPIO,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3);

reg [31:0] count;
wire reset;
reg [6:0] bigseg;
wire [6:0] seg0;
wire [6:0] seg1;
wire [6:0] seg2;
wire [6:0] seg3;
reg	 [1:0] sel;

bcdto7seg hex0 (
	.bcd(count[19:16]),
	.seg(seg0)
);
bcdto7seg hex1 (
	.bcd(count[23:20]),
	.seg(seg1)
);
bcdto7seg hex2 (
	.bcd(count[27:24]),
	.seg(seg2)
);
bcdto7seg hex3 (
	.bcd(count[31:28]),
	.seg(seg3)
);

assign LEDG[1:0] = SW[1:0];
assign HEX0[6:0] = seg0;
assign HEX1[6:0] = seg1;
assign HEX2[6:0] = seg2;
assign HEX3[6:0] = seg3;
assign reset = KEY[0];
assign inhibit = SW[17];
assign GPIO[6:0] = bigseg;
assign GPIO[9:8] = sel;
assign LEDR[17:0] = count[31:14];

always @ (posedge CLOCK_50)
	if (!reset) begin
		count <= 0;
	end 
	else if (!inhibit) begin
		count <= count + 1;
		if (count[17]) begin
			sel <= 2'b01;
			bigseg <= ~seg3;
		end else begin
			sel <= 2'b10;
			bigseg <= ~seg2;
		end
	end
endmodule

