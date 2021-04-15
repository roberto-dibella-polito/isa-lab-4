/**************************************************************************
	Module DUT declaration
	- It has an INPUT interface and OUTPUT interface defined into dut_if
	- It uses 9 states
	
	@reset, state = INITIAL
	At each clock cycle state is evaluated.
	INITIAL: 	
		- the READY signal is raised (DUT is ready)
		- state updated to WAIT
	WAIT_i:
		Waits for new inputs
		Last one:
		- Prints to the user the values of inputs and the evaluated output
		- VALID is rised
		- State is updated to SEND

	Other WAIT are used to wait for the pipeline
	
	SEND:
		Used to send values to the test to be compared
		- VALID is set to zero
		- DUT is READY again
		- and it WAITS for new values
	
	? two clock cycles to evalate data? -> N.B.: Clock is defined by TOP
	
****************************************************************************/ 

module DUT(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [3:0] {INITIAL,WAIT_1,WAIT_2,WAIT_3,WAIT_4,WAIT_5,WAIT_6,WAIT_7,SEND} state);
    
	
	// Device Under Test instatiation
    FPmul fpmul_under_test(
		.FP_A(in_inter.A),
		.FP_B(in_inter.B),
		.clk(in_inter.clk),
		.FP_Z(out_inter.data) );

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
                    state <= WAIT_1;
                end
                
                WAIT_1: begin
                    if(in_inter.valid) begin
                        in_inter.ready <= 0;
                        //out_inter.data <= in_inter.A * in_inter.B;
                        //$display("adder: input A = %0.40f, input B = %0.40f, output OUT = %d",in_inter.A,in_inter.B,out_inter.data);
                        //$display("adder: input A = %b, input B = %b, output OUT = %b",in_inter.A,in_inter.B,out_inter.data);
                        //out_inter.valid <= 1;
						$display("Samples entering pipeline");
						$display("mult: input A = %0.40f, input B = %0.40f", $bitstoshortreal(in_inter.A), $bitstoshortreal(in_inter.B));
						$display("mult: input A = %b, input B = %b", in_inter.A, in_inter.B);
                        state <= WAIT_2;
                    end
                end
				
				WAIT_2: begin
					//$display("Stage 2");
					state <= WAIT_3;
				end

				WAIT_3: begin
					//$display("Stage 3");
					state <= WAIT_4;
				end

				WAIT_4: begin
					//$display("Stage 4");
					state <= WAIT_5;
				end

				WAIT_5: begin
					//$display("Stage 5");
					state <= WAIT_6;
				end
	
				WAIT_6: begin
					//$display("Output valid");
					//$display("mult: output = %d", out_inter.data);
					//out_inter.valid <= 1;
					state <= WAIT_7;
				end
				
				WAIT_7: begin
					$display("Output valid");
					$display("mult: output = %0.40f", $bitstoshortreal(out_inter.data));
					$display("mult: output = %b", out_inter.data);
					out_inter.valid <= 1;
					state <= SEND;
				end
				
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT_1;
                    end
                end
        endcase
    end
endmodule: DUT
