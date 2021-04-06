-- FULL ADDER

library ieee;
use ieee.std_logic_1164.all;

entity FA is
	port(
		A,B,CIN : in std_logic;
		S, COUT	: out std_logic
	);
end FA;

architecture structure of FA is

begin

	S <= A xor B xor CIN;
	COUT <= (A and B) or (B and CIN) or (A and CIN);

end structure;	