/******************************************************************************
** PACKET OUT - MODIFIED VERSION
** Describes a TRANSACTION class used to transfer data - output
**
** UVM_ALL_ON	-> All the data structures have to be used in all data methods
** UVM_HEX		-> Represented in hexadecimal
**
** MODIFICATION: 8-bit values (changed int to byte)
*******************************************************************************/


class packet_out extends uvm_sequence_item;
    byte data;

    `uvm_object_utils_begin(packet_out)
        `uvm_field_int(data, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_out");
        super.new(name);
    endfunction: new
endclass: packet_out
