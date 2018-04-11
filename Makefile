
all: counter.v bcdto7seg.v
	iverilog -tnull -Wall counter.v bcdto7seg.v
