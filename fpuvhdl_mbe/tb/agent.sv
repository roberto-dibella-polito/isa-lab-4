class agent extends uvm_agent;
    sequencer sqr;
    driver    drv;
    monitor   mon;

	// Defines a port, transaction type PACKET_IN, named ITEM_COLLECTED_PORT
    uvm_analysis_port #(packet_in) item_collected_port;

    `uvm_component_utils(agent)

	// Constructor
    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

	// BUILD PHASE: components of the agent are instantiated
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon", this);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
    endfunction

	// CONNECT PHASE: connects everything together
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_collected_port.connect(item_collected_port);
		
		// seq_item_connect is a method of UVM_sequencer to connect
		// the driver to the sequencer
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: agent
