/******************************************************
	Packet out for multiplier
*******************************************************/

class packet_out extends uvm_sequence_item;
    int data;	// 64 bits

    `uvm_object_utils_begin(packet_out)
        `uvm_field_int(data, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_out");
        super.new(name);
    endfunction: new
endclass: packet_out
