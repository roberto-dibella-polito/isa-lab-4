/******************************************************************************
** PACKET IN - MODIFIED VERSION
** Describes a TRANSACTION class used to transfer data
**
** UVM_ALL_ON	-> All the data structures have to be used in all data methods
** UVM_HEX		-> Represented in hexadecimal
**
** MODIFICATION: 8-bit values (changed int to byte)
*******************************************************************************/

class packet_in extends uvm_sequence_item;
    rand byte A;
    rand byte B;

    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_in
