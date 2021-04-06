typedef virtual dut_if.port_in input_vif;

class driver extends uvm_driver #(packet_in);
    `uvm_component_utils(driver)
    input_vif vif;
    event begin_record, end_record;

	// Constructor
    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

	// Builds (configures) the driver
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(input_vif)::get(this, "", "vif", vif));
    endfunction
	
	/********************************************
		RUN PHASE
		Driver invokes its own defined methods
		to run the test and drive the DUT
	*********************************************/
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
            record_tr();
        join
    endtask

	/********************************************
		RESET_SIGNALS
		User-defined task
		Used to reset everything
	*********************************************/
    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.valid <= '0;
            vif.A <= 'x;
            vif.B <= 'x;
            @(posedge vif.rst);
        end
    endtask

	/********************************************
		GET_AND_DRIVE 
		Waits until the reset is down, then starts to record
	*********************************************/
    virtual protected task get_and_drive(uvm_phase phase);
        wait(vif.rst === 1);	// Waits until TRUE
        @(negedge vif.rst);
        @(posedge vif.clk);
        
        forever begin
            seq_item_port.get(req);
            -> begin_record;		// TRIGGER begin_record, used to trigger record_tr (see below)
									// it's like an ASYNCHRONOUS EVENT!
            drive_transfer(req);
        end
    endtask

	/******************************************************
		DRIVE_TRANSFER
		Transmits data to the DUT using the vif interface
	*******************************************************/
    virtual protected task drive_transfer(packet_in tr);
        vif.A = tr.A;
        vif.B = tr.B;
        vif.valid = 1;
		
		// Triggered at clk positive edge
		// NOTES that here there is not forever begin:
		// it is called every time by get_and_drive!
        @(posedge vif.clk)
        
        while(!vif.ready)
            @(posedge vif.clk);
        
        -> end_record;
        @(posedge vif.clk); //hold time
        vif.valid = 0;
        @(posedge vif.clk);
    endtask

	/*****************************************************************
		RECORD_TR
		The method that TRULY handles the transmission
		It works with ALWAYS: it is started by GET AND DRIVE
		and stopped by DRIVE_TRANSFER (that is inside GET AND DRIVE)
	******************************************************************/
    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(req, "driver");
            @(end_record);
            end_tr(req);
        end
    endtask
endclass
