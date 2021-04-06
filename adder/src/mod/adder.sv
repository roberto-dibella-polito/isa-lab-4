/************************************************
	ADDER - 8-bit modified version
*************************************************/

module adder(   input logic [7:0] A, B, 
                output logic [7:0] OUT );

    assign OUT = A + B;

endmodule: adder
