/*********************************************
	Multiplier reference model
**********************************************/

class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    packet_in tr_in;
    packet_out tr_out;
    uvm_get_port #(packet_in) in;
    uvm_put_port #(packet_out) out;

	shortreal fp_A, fp_B;
	real fp_data;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = packet_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            in.get(tr_in);
			
			fp_A = $bitstoshortreal(tr_in.A);
			fp_B = $bitstoshortreal(tr_in.B);
			fp_data = fp_A * fp_B;			
			tr_out.data = $shortrealtobits(fp_data);		
            //tr_out.data = tr_in.A * tr_in.B;

            $display("refmod: input A = %0.40f, input B = %0.40f, output OUT = %0.40f",fp_A, fp_B, fp_data);
			$display("refmod: input A = %b, input B = %b, output OUT = %b",tr_in.A, tr_in.B, tr_out.data);
            out.put(tr_out);
        end
    endtask: run_phase
endclass: refmod
