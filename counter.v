module counter (
	CLOCK_50,
	SW,		//input from switch
	KEY,
	LEDG,		//output to green LEDs
	LEDR,
	GPIO,		//output to GPIO port
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5);

input CLOCK_50;
input [17:0] SW;
input [0:0] KEY;
output [8:0] LEDG;
output [17:0] LEDR;
output [35:0] GPIO;
output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;

reg [31:0] count;
wire reset;
reg [3:0] bcd;
reg [17:0] LEDR;
wire [6:0] seg;
wire [6:0] bigseg0;
wire [6:0] bigseg1;
wire [6:0] bigseg2;
wire [6:0] bigseg3;
reg [6:0] bigseg;
reg [1:0] sel;

bcdto7seg hex0 (
	.bcd(count[19:16]), 
	.seg(HEX0)
);
bcdto7seg hex1 (
	.bcd(count[23:20]), 
	.seg(HEX1)
);
bcdto7seg hex2 (
	.bcd(count[27:24]), 
	.seg(HEX2)
);
bcdto7seg hex3 (
	.bcd(count[31:28]), 
	.seg(HEX3)
);
bcdto7seg bighex0 (
	.bcd(~count[19:16]),
	.seg(bigseg0)
);
bcdto7seg bighex1 (
	.bcd(~count[23:20]),
	.seg(bigseg1)
);
bcdto7seg bighex2 (
	.bcd(~count[27:24]),
	.seg(bigseg2)
);
bcdto7seg bighex3 (
	.bcd(~count[31:28]),
	.seg(bigseg3)
);

assign LEDG[1:0] = SW[1:0];
assign HEX4[6:0] = bigseg2;
assign HEX5[6:0] = bigseg3;
assign reset = KEY[0];
assign GPIO[6:0] = bigseg;
assign GPIO[9:8] = sel;

always @ (posedge CLOCK_50)
if (~reset) begin
	count <= 0;
	bcd[3:0] <= 4'b0000;
end else begin
	count <= count - 1;
	if (count == 0) begin
		count <= 32'hffffffff;
		LEDR[0] <= ~LEDR[0];
		bcd <= bcd + 1;
		LEDR[17:14] <= bcd;
	end
	if (count[20]) begin
		sel <= 2'b01;
		bigseg <= ~bigseg3;
	end else begin
		sel <= 2'b10;
		bigseg <= ~bigseg2;
	end
end
endmodule

