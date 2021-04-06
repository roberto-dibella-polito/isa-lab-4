-- HALF ADDER

library ieee;
use ieee.std_logic_1164.all;

entity HA is
	port(
		A,B		: in std_logic;
		S, COUT	: out std_logic
	);
end HA;

architecture structure of HA is

begin

	S <= A xor B;
	COUT <= A and B;

end structure;