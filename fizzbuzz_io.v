//PORT//
module fizzbuzz_io (
	input					clk,
	input					reset,
	input					address,
	input					read,
	input					write,
	input		[31:0]	writedata,
	output	[31:0]	readdata
);

///WIRE///
wire			[2:0]		remain3;
wire			[2:0]		remain5;

//REGISTER//
reg			[31:0]	number;
reg			[2:0]		fizzbuzz;


//PARAMETER//
parameter THREEE	=	3'b011;
parameter FIVE		=	3'b101;


//SELECTOR//
assign readdata = (read==1'b0)		?	{32{1'b0}}			:
						(address==1'b0)	?	number[31:0]		:	{{ 29{1'b0}} , fizzbuzz};

//REG//
always @(posedge clk) begin
	if (reset)
		number <= {32{1'b0}};
	else if (address==1'b0 && write==1'b1) begin
			number <= writedata[31:0];
	end
end

//DIVIDER3//
DIVIDER	DIVIDER3 (
	.denom ( THREEE ),
	.numer ( number ),
	.remain ( remain3 )
);

//DIVIDER5//
DIVIDER	DIVIDER5 (
	.denom ( FIVE ),
	.numer ( number ),
	.remain ( remain5 )
);

//FIZZBUZZDECODER//

always @(posedge clk) begin
	if (reset)
		fizzbuzz <= {3{1'b0}};
	else if (number=={32{1'b0}}) begin
		fizzbuzz <= 3'b000;
	end
	else begin
		fizzbuzz[2] <= (remain3 == 3'b000)&&(remain5 == 3'b000);
		fizzbuzz[1] <= (remain5 == 3'b000);
		fizzbuzz[0] <= (remain3 == 3'b000);
	end
end

endmodule
