/**************************************************************************
	Module DUT declaration
	- It has an INPUT interface and OUTPUT interface defined into dut_if
	- It uses THREE states
	
	@reset, state = INITIAL
	At each clock cycle state is evaluated.
	INITIAL: 	
		- the READY signal is raised (DUT is ready)
		- state updated to WAIT
	WAIT:
		Waits for new inputs
		- Prints to the user the values of inputs and the evaluated output
		- VALID is rised
		- State is updated to SEND
	
	SEND:
		Used to send values to the test to be compared
		- VALID is set to zero
		- DUT is READY again
		- and it WAITS for new values
	
	? two clock cycles to evalate data? -> N.B.: Clock is defined by TOP
	
****************************************************************************/ 

module DUT(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [1:0] {INITIAL,WAIT,SEND} state);
    
	// Device Under Test instatiation
    adder adder_under_test(.A(in_inter.A),.B(in_inter.B),.OUT(out_inter.data));

    always_ff @(posedge in_inter.clk)
    begin
        if(in_inter.rst) begin
            in_inter.ready <= 0;
            out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
        end
        else case(state)
                INITIAL: begin
                    in_inter.ready <= 1;
                    state <= WAIT;
                end
                
                WAIT: begin
                    if(in_inter.valid) begin
                        in_inter.ready <= 0;
                        //out_inter.data <= in_inter.A + in_inter.B;
                        $display("adder: input A = %d, input B = %d, output OUT = %d",in_inter.A,in_inter.B,out_inter.data);
                        $display("adder: input A = %b, input B = %b, output OUT = %b",in_inter.A,in_inter.B,out_inter.data);
                        out_inter.valid <= 1;
                        state <= SEND;
                    end
                end
                
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT;
                    end
                end
        endcase
    end
endmodule: DUT