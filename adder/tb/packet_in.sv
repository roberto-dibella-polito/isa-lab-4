/******************************************************************************
** PACKET IN
** Describes a TRANSACTION class used to transfer data
**
** UVM_ALL_ON	-> All the data structures have to be used in all data methods
** UVM_HEX		-> Represented in hexadecimal
*******************************************************************************/

class packet_in extends uvm_sequence_item;
    rand integer A;
    rand integer B;

	//constraint my_range { A < 1000; A > 100; B < A/10; B > -A;}
	
	constraint my_range { A inside {[100:1000]}; B inside {[-A/10 : A/10]}; }
	

    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_in
