-- MBE Multiplier
-- Dadda reduction tree

library ieee;
use ieee.std_logic_1164.all;

entity dadda is
	port(
		P0 : in std_logic_vector(35 downto 0);
		P1 : in std_logic_vector(36 downto 0);
		P2 : in std_logic_vector(36 downto 0);
		P3 : in std_logic_vector(36 downto 0);
		P4 : in std_logic_vector(36 downto 0);
		P5 : in std_logic_vector(36 downto 0);
		P6 : in std_logic_vector(36 downto 0);
		P7 : in std_logic_vector(36 downto 0);
		P8 : in std_logic_vector(36 downto 0);
		P9 : in std_logic_vector(36 downto 0);
		P10 : in std_logic_vector(36 downto 0);
		P11 : in std_logic_vector(36 downto 0);
		P12 : in std_logic_vector(36 downto 0);
		P13 : in std_logic_vector(36 downto 0);
		P14 : in std_logic_vector(36 downto 0);
		P15 : in std_logic_vector(35 downto 0);
		P16 : in std_logic_vector(33 downto 0);
		PARTIAL_1 : out std_logic_vector(63 downto 0);
		PARTIAL_2 : out std_logic_vector(63 downto 0);
		OV	: out std_logic
	);
end dadda;

architecture structure of dadda is

	component FA 
		port(
			A,B,CIN : in std_logic;
			S, COUT	: out std_logic
		);
	end component;
	
	component HA
		port(
			A,B		: in std_logic;
			S, COUT	: out std_logic
		);
	end component;
	
	-- DOT REPRESENTATION MATRIX
	type matrix_L0 is array (0 to 16) of std_logic_vector(63 downto 0);
	type matrix_L1 is array (0 to 12) of std_logic_vector(63 downto 0);
	type matrix_L2 is array (0 to 8) of std_logic_vector(63 downto 0);
	type matrix_L3 is array (0 to 5) of std_logic_vector(63 downto 0);
	type matrix_L4 is array (0 to 3) of std_logic_vector(63 downto 0);
	type matrix_L5 is array (0 to 2) of std_logic_vector(63 downto 0);
	
	signal LV0 : matrix_L0;
	signal LV1 : matrix_L1;
	signal LV2 : matrix_L2;
	signal LV3 : matrix_L3;
	signal LV4 : matrix_L4;
	signal LV5 : matrix_L5;
	
	signal L0_R1_i 		: std_logic_vector(42 downto 24);
	signal L0_R1_i_1	: std_logic_vector(42 downto 24);
	signal L0_R2_i 		: std_logic_vector(40 downto 26);
	signal L0_R2_i_1 	: std_logic_vector(40 downto 26);
	signal L0_R3_i 		: std_logic_vector(38 downto 28);
	signal L0_R3_i_1 	: std_logic_vector(38 downto 28);
	signal L0_R4_i 		: std_logic_vector(36 downto 30);
	signal L0_R4_i_1 	: std_logic_vector(36 downto 30);
	
begin

	-- The order of the dots into each column is not important
	
	-- Dot matrix - level 0

	LV0(0)(63 downto 0) 	<= P16(33 downto 6)  & P0;
	LV0(1)(63 downto 0) 	<= P15(35 downto 8)  & P1(35 downto 0);
	LV0(2)(62 downto 2) 	<= P14(36 downto 10) & P2(33 downto 0);
	LV0(3)(60 downto 4) 	<= P13(36 downto 12) & P3(31 downto 0);
	LV0(4)(58 downto 6) 	<= P12(36 downto 14) & P4(29 downto 0);
	LV0(5)(56 downto 8) 	<= P11(36 downto 16) & P5(27 downto 0);
	LV0(6)(54 downto 10) 	<= P10(36 downto 18) & P6(25 downto 0);
	LV0(7)(52 downto 12) 	<= P9 (36 downto 20) & P7(23 downto 0);
	LV0(8)(50 downto 14) 	<= P8;
	LV0(9)(48 downto 16) 	<= P7 (36 downto 24) & P9(19 downto 0);
	LV0(10)(46 downto 18) 	<= P6 (36 downto 26) & P10(17 downto 0);
	LV0(11)(44 downto 20) 	<= P5 (36 downto 28) & P11(15 downto 0);
	LV0(12)(42 downto 22) 	<= P4 (36 downto 30) & P12(13 downto 0);
	LV0(13)(40 downto 24) 	<= P3 (36 downto 32) & P13(11 downto 0);
	LV0(14)(38 downto 26) 	<= P2 (36 downto 34) & P14(9 downto 0);
	LV0(15)(36 downto 28) 	<= P1 (36) & P15(7 downto 0);
	LV0(16)(35 downto 30) 	<= P16(5 downto 0);
	
	-- COMPRESSORS
	-- Structured into four rows, each row begins and ends with HA
	
	--------------------------------------------
	-- Row 1
	--------------------------------------------
	HA1_row_1_1: HA port map
	(	A		=> LV0(0)(24),
		B		=> LV0(1)(24),
		S		=> LV1(0)(24),
		COUT	=> LV1(0)(25)
	);
	
	FA1_row_1: for i in 25 to 41 generate
		FA1_1_i: FA port map
		(	A		=> LV0(0)(i),
			B		=> LV0(1)(i),
			CIN		=> LV0(2)(i),
			S		=> LV1(1)(i),
			COUT	=> LV1(0)(i+1)
		);
	end generate;
	
	HA1_row_1_2: HA port map
	(	A		=> LV0(0)(42),
		B		=> LV0(1)(42),
		S		=> LV1(1)(42),
		COUT	=> LV1(0)(43)
	);
	
	--------------------------------------------
	--	Row 2
	--------------------------------------------
	HA1_row_2_1: HA port map
	(	A		=> LV0(3)(26),
		B		=> LV0(4)(26),
		S		=> LV1(2)(26),
		COUT	=> LV1(2)(27)
	);
	
	FA1_row_2: for i in 27 to 39 generate
		FA1_2_i: FA port map
		(	A		=> LV0(3)(i),
			B		=> LV0(4)(i),
			CIN		=> LV0(5)(i),
			S		=> LV1(3)(i),
			COUT	=> LV1(2)(i+1)
		);
	end generate;
	
	HA1_row_2_2: HA port map
	(	A		=> LV0(3)(40),
		B		=> LV0(4)(40),
		S		=> LV1(3)(40),
		COUT	=> LV1(2)(41)
	);
	
	--------------------------------------------
	--	Row 3
	--------------------------------------------
	HA1_row_3_1: HA port map
	(	A		=> LV0(6)(28),
		B		=> LV0(7)(28),
		S		=> LV1(4)(28),
		COUT	=> LV1(4)(29)
	);
	
	FA1_row_3: for i in 29 to 37 generate
		FA1_3_i: FA port map
		(	A		=> LV0(6)(i),
			B		=> LV0(7)(i),
			CIN		=> LV0(8)(i),
			S		=> LV1(5)(i),
			COUT	=> LV1(4)(i+1)
		);
	end generate;
	
	HA1_row_3_2: HA port map
	(	A		=> LV0(6)(38),
		B		=> LV0(7)(38),
		S		=> LV1(5)(38),
		COUT	=> LV1(4)(39)
	);
	
	--------------------------------------------
	--	Row 4
	--------------------------------------------
	HA1_row_4_1: HA port map
	(	A		=> LV0(9)(30),
		B		=> LV0(10)(30),
		S		=> LV1(6)(30),
		COUT	=> LV1(6)(31)
	);
	
	FA1_row_4: for i in 31 to 35 generate
		FA1_4_i: FA port map
		(	A		=> LV0(9)(i),
			B		=> LV0(10)(i),
			CIN		=> LV0(11)(i),
			S		=> LV1(7)(i),
			COUT	=> LV1(6)(i+1)
		);
	end generate;
	
	HA1_row_4_2: HA port map
	(	A		=> LV0(9)(36),
		B		=> LV0(10)(36),
		S		=> LV1(7)(36),
		COUT	=> LV1(6)(37)
	);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- DOT REPRESENTATION MATRIX
	-- LEVEL 1
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	-- Lower bits
	LV1(0)(23 downto 0) 	<= 																								 LV0(0)(23 downto 0);
	LV1(1)(24 downto 0) 	<= 																					LV0(2)(24) & LV0(1)(23 downto 0);
	LV1(2)(25 downto 2) 	<= 														  			   LV0(3)(25) & LV0(3)(24) & LV0(2)(23 downto 2);
	LV1(3)(26 downto 4) 	<= 														  LV0(5)(26) & LV0(4)(25) & LV0(4)(24) & LV0(3)(23 downto 4);
	LV1(4)(27 downto 6) 	<= 											 LV0(6)(27) & LV0(6)(26) & LV0(5)(25) & LV0(5)(24) & LV0(4)(23 downto 6);
	LV1(5)(28 downto 8) 	<= 								LV0(8)(28) & LV0(7)(27) & LV0(7)(26) & LV0(6)(25) & LV0(6)(24) & LV0(5)(23 downto 8);
	LV1(6)(29 downto 10) 	<= 				 LV0(9) (29)  & LV0(9)(28) & LV0(8)(27) & LV0(8)(26) & LV0(7)(25) & LV0(7)(24) & LV0(6)(23 downto 10);
	LV1(7)(30 downto 12) 	<= LV0(11)(30) & LV0(10)(29) & LV0(10)(28) & LV0(9)(27) & LV0(9)(26) & LV0(8)(25) & LV0(8)(24) & LV0(7)(23 downto 12);
	
	-- Higher bits
	LV1(0)(63 downto 44) 	<= LV0(0)(63 downto 44);
	LV1(1)(63 downto 43) 	<= LV0(1)(63 downto 44) & LV0(0)(43); 
	LV1(2)(62 downto 42) 	<= LV0(2)(62 downto 44) & LV0(1)(43) & LV0(2)(42); 
	LV1(3)(60 downto 41) 	<= LV0(3)(60 downto 44) & LV0(2)(43) & LV0(3)(42) & LV0(3)(41); 
	LV1(4)(58 downto 40) 	<= LV0(4)(58 downto 44) & LV0(3)(43) & LV0(4)(42) & LV0(4)(41) & LV0(5)(40); 
	LV1(5)(56 downto 39) 	<= LV0(5)(56 downto 44) & LV0(4)(43) & LV0(5)(42) & LV0(5)(41) & LV0(6)(40) & LV0(6)(39); 
	LV1(6)(54 downto 38) 	<= LV0(6)(54 downto 44) & LV0(5)(43) & LV0(6)(42) & LV0(6)(41) & LV0(7)(40) & LV0(7)(39) & LV0(8)(38); 
	LV1(7)(52 downto 37) 	<= LV0(7)(52 downto 44) & LV0(6)(43) & LV0(7)(42) & LV0(7)(41) & LV0(8)(40) & LV0(8)(39) & LV0(9)(38) & LV0(9)(37); 
	
	-- Final rows
	LV1(8)(50 downto 14) 	<= LV0(8)(50 downto 44) 		& LV0(7)(43) 	& LV0(8)(42) 	& LV0(8)(41) 	& LV0(9)(40)  	& LV0(9)(39) 	& LV0(10)(38) & LV0(10)(37) & LV0(11)(36) & LV0(12)(35 downto 30) & LV0(11)(29) & LV0(11)(28) & LV0(10)(27) & LV0(10)(26) & LV0(9)(25)  & LV0(9)(24)  & LV0(8)(23 downto 14);
	LV1(9)(48 downto 16) 	<= LV0(9)(48 downto 44) 		& LV0(8)(43) 	& LV0(9)(42) 	& LV0(9)(41) 	& LV0(10)(40) 	& LV0(10)(39) 	& LV0(11)(38) & LV0(11)(37) & LV0(12)(36) & LV0(13)(35 downto 30) & LV0(12)(29) & LV0(12)(28) & LV0(11)(27) & LV0(11)(26) & LV0(10)(25) & LV0(10)(24) & LV0(9)(23 downto 16);
	LV1(10)(46 downto 18) 	<= LV0(10)(46 downto 44)  		& LV0(9)(43) 	& LV0(10)(42)	& LV0(10)(41) 	& LV0(11)(40) 	& LV0(11)(39) 	& LV0(12)(38) & LV0(12)(37) & LV0(13)(36) & LV0(14)(35 downto 30) & LV0(13)(29) & LV0(13)(28) & LV0(12)(27) & LV0(12)(26) & LV0(11)(25) & LV0(11)(24) & LV0(10)(23 downto 18);
	LV1(11)(44 downto 20) 	<= LV0(11)(44)					& LV0(10)(43) 	& LV0(11)(42) 	& LV0(11)(41) 	& LV0(12)(40) 	& LV0(12)(39) 	& LV0(13)(38) & LV0(13)(37) & LV0(14)(36) & LV0(15)(35 downto 30) & LV0(14)(29) & LV0(14)(28) & LV0(13)(27) & LV0(13)(26) & LV0(12)(25) & LV0(12)(24) & LV0(11)(23 downto 20);
	LV1(12)(43 downto 22) 	<= 								  LV0(11)(43) 	& LV0(12)(42) 	& LV0(12)(41) 	& LV0(13)(40) 	& LV0(13)(39) 	& LV0(14)(38) & LV0(14)(37) & LV0(15)(36) & LV0(16)(35 downto 30) & LV0(15)(29 downto 28) 	  & LV0(14)(27) & LV0(14)(26) & LV0(13)(25) & LV0(13)(24) & LV0(12)(23 downto 22);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- COMPRESSORS
	-- LEVEL 2
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	--------------------------------------------
	-- Level2 compressors, Row 1
	--------------------------------------------
	HA2_row_1_1: HA port map
	(	A		=> LV1(0)(16),
		B		=> LV1(1)(16),
		S		=> LV2(0)(16),
		COUT	=> LV2(0)(17)
	);
	
	FA2_row_1: for i in 17 to 49 generate
		FA2_1_i: FA port map
		(	A		=> LV1(0)(i),
			B		=> LV1(1)(i),
			CIN		=> LV1(2)(i),
			S		=> LV2(1)(i),
			COUT	=> LV2(0)(i+1)
		);
	end generate;
	
	HA2_row_1_2: HA port map
	(	A		=> LV1(0)(50),
		B		=> LV1(1)(50),
		S		=> LV2(1)(50),
		COUT	=> LV2(0)(51)
	);
	
	-- Completion of rows 0 & 1
	
	
	
	--------------------------------------------
	--	Level2 Compressors, Row 2
	--------------------------------------------
	HA2_row_2_1: HA port map
	(	A		=> LV1(3)(18),
		B		=> LV1(4)(18),
		S		=> LV2(2)(18),
		COUT	=> LV2(2)(19)
	);
	
	FA2_row_2: for i in 19 to 47 generate
		FA2_2_i: FA port map
		(	A		=> LV1(3)(i),
			B		=> LV1(4)(i),
			CIN		=> LV1(5)(i),
			S		=> LV2(3)(i),
			COUT	=> LV2(2)(i+1)
		);
	end generate;
	
	HA2_row_2_2: HA port map
	(	A		=> LV1(3)(48),
		B		=> LV1(4)(48),
		S		=> LV2(3)(48),
		COUT	=> LV2(2)(49)
	);
	
	--------------------------------------------
	--	Level2 Compressors, Row 3
	--------------------------------------------
	HA2_row_3_1: HA port map
	(	A		=> LV1(6)(20),
		B		=> LV1(7)(20),
		S		=> LV2(4)(20),
		COUT	=> LV2(4)(21)
	);
	
	FA2_row_3: for i in 21 to 45 generate
		FA2_3_i: FA port map
		(	A		=> LV1(6)(i),
			B		=> LV1(7)(i),
			CIN		=> LV1(8)(i),
			S		=> LV2(5)(i),
			COUT	=> LV2(4)(i+1)
		);
	end generate;
	
	HA2_row_3_2: HA port map
	(	A		=> LV1(6)(46),
		B		=> LV1(7)(46),
		S		=> LV2(5)(46),
		COUT	=> LV2(4)(47)
	);
	
	--------------------------------------------
	--	Level2 Compressors, Row 4
	--------------------------------------------
	HA2_row_4_1: HA port map
	(	A		=> LV1(9)(22),
		B		=> LV1(10)(22),
		S		=> LV2(6)(22),
		COUT	=> LV2(6)(23)
	);
	
	FA2_row_4: for i in 23 to 43 generate
		FA2_4_i: FA port map
		(	A		=> LV1(9)(i),
			B		=> LV1(10)(i),
			CIN		=> LV1(11)(i),
			S		=> LV2(7)(i),
			COUT	=> LV2(6)(i+1)
		);
	end generate;
	
	HA2_row_4_2: HA port map
	(	A		=> LV1(9)(44),
		B		=> LV1(10)(44),
		S		=> LV2(7)(44),
		COUT	=> LV2(6)(45)
	);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- DOT REPRESENTATION MATRIX
	-- LEVEL 2
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	-- Higher bits
	LV2(0)(63 downto 52) <= LV1(0)(63 downto 52);
	LV2(1)(63 downto 51) <= LV1(1)(63 downto 52) & LV1(0)(51);
	LV2(2)(62 downto 50) <= LV1(2)(62 downto 52) & LV1(1)(51) & LV1(2)(50); 
	LV2(3)(60 downto 49) <= LV1(3)(60 downto 52) & LV1(2)(51) & LV1(3)(50) & LV1(3)(49); 
	LV2(4)(58 downto 48) <= LV1(4)(58 downto 52) & LV1(3)(51) & LV1(4)(50) & LV1(4)(49) & LV1(5)(48); 
	LV2(5)(56 downto 47) <= LV1(5)(56 downto 52) & LV1(4)(51) & LV1(5)(50) & LV1(5)(49) & LV1(6)(48) & LV1(6)(47); 
	LV2(6)(54 downto 46) <= LV1(6)(54 downto 52) & LV1(5)(51) & LV1(6)(50) & LV1(6)(49) & LV1(7)(48) & LV1(7)(47) & LV1(8)(46); 
	LV2(7)(52 downto 45) <= LV1(7)(52)			 & LV1(6)(51) & LV1(7)(50) & LV1(7)(49) & LV1(8)(48) & LV1(8)(47) & LV1(9)(46) & LV1(9)(45); 
	
	-- Lower bits
	LV2(0)(15 downto 0)  <= 																							  LV1(0)(15 downto 0);
	LV2(1)(16 downto 0)  <= 																				 LV1(2)(16) & LV1(1)(15 downto 0);
	LV2(2)(17 downto 2)  <= 																	LV1(3)(17) & LV1(3)(16) & LV1(2)(15 downto 2);
	LV2(3)(18 downto 4)  <= 													   LV1(5)(18) & LV1(4)(17) & LV1(4)(16) & LV1(3)(15 downto 4);
	LV2(4)(19 downto 6)  <= 										  LV1(6)(19) & LV1(6)(18) & LV1(5)(17) & LV1(5)(16) & LV1(4)(15 downto 6);
	LV2(5)(20 downto 8)  <= 			  				LV1(8)(20)  & LV1(7)(19) & LV1(7)(18) & LV1(6)(17) & LV1(6)(16) & LV1(5)(15 downto 8);
	LV2(6)(21 downto 10) <= 			  LV1(9)(21)  & LV1(9)(20)  & LV1(8)(19) & LV1(8)(18) & LV1(7)(17) & LV1(7)(16) & LV1(6)(15 downto 10);
	LV2(7)(22 downto 12) <= LV1(11)(22) & LV1(10)(21) & LV1(10)(20) & LV1(9)(19) & LV1(9)(18) & LV1(8)(17) & LV1(8)(16) & LV1(7)(15 downto 12);
	
	-- Last row
	LV2(8)(51 downto 14) <= LV1(7)(51) & LV1(8)(50) & LV1(8)(49) & LV1(9)(48) & LV1(9)(47) & LV1(10)(46) & LV1(10)(45) & LV1(11)(44) & LV1(12)(43 downto 22) & LV1(11)(21 downto 20) & LV1(10)(19 downto 18) & LV1(9)(17 downto 16) & LV1(8)(15 downto 14);         
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- COMPRESSORS
	-- LEVEL 3
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	--------------------------------------------
	-- Level3 compressors, Row 1
	--------------------------------------------
	HA3_row_1_1: HA port map
	(	A		=> LV2(0)(10),
		B		=> LV2(1)(10),
		S		=> LV3(0)(10),
		COUT	=> LV3(0)(11)
	);
	
	FA3_row_1: for i in 11 to 55 generate
		FA3_1_i: FA port map
		(	A		=> LV2(0)(i),
			B		=> LV2(1)(i),
			CIN		=> LV2(2)(i),
			S		=> LV3(1)(i),
			COUT	=> LV3(0)(i+1)
		);
	end generate;
	
	HA3_row_1_2: HA port map
	(	A		=> LV2(0)(56),
		B		=> LV2(1)(56),
		S		=> LV3(1)(56),
		COUT	=> LV3(0)(57)
	);
	
	--------------------------------------------
	--	Level3 Compressors, Row 2
	--------------------------------------------
	HA3_row_2_1: HA port map
	(	A		=> LV2(3)(12),
		B		=> LV2(4)(12),
		S		=> LV3(2)(12),
		COUT	=> LV3(2)(13)
	);
	
	FA3_row_2: for i in 13 to 53 generate
		FA2_2_i: FA port map
		(	A		=> LV2(3)(i),
			B		=> LV2(4)(i),
			CIN		=> LV2(5)(i),
			S		=> LV3(3)(i),
			COUT	=> LV3(2)(i+1)
		);
	end generate;
	
	HA3_row_2_2: HA port map
	(	A		=> LV2(3)(54),
		B		=> LV2(4)(54),
		S		=> LV3(3)(54),
		COUT	=> LV3(2)(55)
	);
	
	--------------------------------------------
	--	Level3 Compressors, Row 3
	--------------------------------------------
	HA3_row_3_1: HA port map
	(	A		=> LV2(6)(14),
		B		=> LV2(7)(14),
		S		=> LV3(4)(14),
		COUT	=> LV3(4)(15)
	);
	
	FA3_row_3: for i in 15 to 51 generate
		FA2_3_i: FA port map
		(	A		=> LV2(6)(i),
			B		=> LV2(7)(i),
			CIN		=> LV2(8)(i),
			S		=> LV3(5)(i),
			COUT	=> LV3(4)(i+1)
		);
	end generate;
	
	HA3_row_3_2: HA port map
	(	A		=> LV2(6)(52),
		B		=> LV2(7)(52),
		S		=> LV3(5)(52),
		COUT	=> LV3(4)(53)
	);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- DOT REPRESENTATION MATRIX
	-- LEVEL 3
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	-- Higher bits
	LV3(0)(63 downto 58) <= LV2(0)(63 downto 58);
	LV3(1)(63 downto 57) <= LV2(1)(63 downto 58) & LV2(0)(57);
	LV3(2)(62 downto 56) <= LV2(2)(62 downto 58) & LV2(1)(57) & LV2(2)(56); 
	LV3(3)(60 downto 55) <= LV2(3)(60 downto 58) & LV2(2)(57) & LV2(3)(56) & LV2(3)(55);
	LV3(4)(58 downto 54) <= LV2(4)(58) 			 & LV2(3)(57) & LV2(4)(56) & LV2(4)(55) & LV2(5)(54);
	LV3(5)(57 downto 53) <= 					   LV2(4)(57) & LV2(5)(56) & LV2(5)(55) & LV2(6)(54) & LV2(6)(53);   
	
	-- Lower bits
	LV3(0)(9 downto 0)  <= 																	LV2(0)(9 downto 0);
	LV3(1)(10 downto 0) <= 													   LV2(2)(10) & LV2(1)(9 downto 0);
	LV3(2)(11 downto 2) <= 										  LV2(3)(11) & LV2(3)(10) & LV2(2)(9 downto 2);
	LV3(3)(12 downto 4) <= 							 LV2(5)(12) & LV2(4)(11) & LV2(4)(10) & LV2(3)(9 downto 4);
	LV3(4)(13 downto 6) <= 				LV2(6)(13) & LV2(6)(12) & LV2(5)(11) & LV2(5)(10) & LV2(4)(9 downto 6);
	LV3(5)(14 downto 8) <= LV2(8)(14) & LV2(7)(13) & LV2(7)(12) & LV2(6)(11) & LV2(6)(10) & LV2(5)(9 downto 8);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- COMPRESSORS
	-- LEVEL 4
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	--------------------------------------------
	-- Level4 compressors, Row 1
	--------------------------------------------
	HA4_row_1_1: HA port map
	(	A		=> LV3(0)(6),
		B		=> LV3(1)(6),
		S		=> LV4(0)(6),
		COUT	=> LV4(0)(7)
	);
	
	FA4_row_1: for i in 7 to 59 generate
		FA4_1_i: FA port map
		(	A		=> LV3(0)(i),
			B		=> LV3(1)(i),
			CIN		=> LV3(2)(i),
			S		=> LV4(1)(i),
			COUT	=> LV4(0)(i+1)
		);
	end generate;
	
	HA4_row_1_2: HA port map
	(	A		=> LV3(0)(60),
		B		=> LV3(1)(60),
		S		=> LV4(1)(60),
		COUT	=> LV4(0)(61)
	);
	
	--------------------------------------------
	--	Level4 Compressors, Row 2
	--------------------------------------------
	HA4_row_2_1: HA port map
	(	A		=> LV3(3)(8),
		B		=> LV3(4)(8),
		S		=> LV4(2)(8),
		COUT	=> LV4(2)(9)
	);
	
	FA4_row_2: for i in 9 to 57 generate
		FA4_2_i: FA port map
		(	A		=> LV3(3)(i),
			B		=> LV3(4)(i),
			CIN		=> LV3(5)(i),
			S		=> LV4(3)(i),
			COUT	=> LV4(2)(i+1)
		);
	end generate;
	
	HA4_row_2_2: HA port map
	(	A		=> LV3(3)(58),
		B		=> LV3(4)(58),
		S		=> LV4(3)(58),
		COUT	=> LV4(2)(59)
	);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- DOT REPRESENTATION MATRIX
	-- LEVEL 4
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	-- Higher bits
	LV4(0)(63 downto 62) <= LV3(0)(63 downto 62);
	LV4(1)(63 downto 61) <= LV3(1)(63 downto 62) & LV3(0)(61);
	LV4(2)(62 downto 60) <= LV3(2)(62) 			 & LV3(1)(61) & LV3(2)(60); 
	LV4(3)(61 downto 59) <= 					   LV3(2)(61) & LV3(3)(60) & LV3(3)(59);
	
	-- Lower bits
	LV4(0)(5 downto 0) <= 									  LV3(0)(5 downto 0);
	LV4(1)(6 downto 0) <= 						  LV3(2)(6) & LV3(1)(5 downto 0);
	LV4(2)(7 downto 2) <= 			  LV3(3)(7) & LV3(3)(6) & LV3(2)(5 downto 2);
	LV4(3)(8 downto 4) <= LV3(5)(8) & LV3(4)(7) & LV3(4)(6) & LV3(3)(5 downto 4);

	--------------------------------------------------------------
	--------------------------------------------------------------
	-- COMPRESSORS
	-- LEVEL 5
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	HA5_row_1_1: HA port map
	(	A		=> LV4(0)(4),
		B		=> LV4(1)(4),
		S		=> LV5(0)(4),
		COUT	=> LV5(0)(5)
	);
	
	FA5_row_1: for i in 5 to 61 generate
		FA5_1_i: FA port map
		(	A		=> LV4(0)(i),
			B		=> LV4(1)(i),
			CIN		=> LV4(2)(i),
			S		=> LV5(1)(i),
			COUT	=> LV5(0)(i+1)
		);
	end generate;
	
	HA5_row_1_2: HA port map
	(	A		=> LV4(0)(62),
		B		=> LV4(1)(62),
		S		=> LV5(1)(62),
		COUT	=> LV5(0)(63)
	);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- DOT REPRESENTATION MATRIX
	-- LEVEL 5
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	LV5(0)(3 downto 0) <= LV4(0)(3 downto 0);
	
	LV5(1)(63) <= LV4(0)(63);
	LV5(1)(4 downto 0) <= LV4(2)(4) & LV4(1)(3 downto 0);
	
	--LV5(2)(63 downto 59) <= LV4(1)(63) & LV4(2)(62) & LV4(3)(61 downto 59);
	--LV5(2)(8 downto 2) <= LV4(3)(8 downto 4) & LV4(2)(3 downto 2);
	--LV5(2)(58 downto 9) <= LV4(3)(58 downto 9);
	
	LV5(2)(63 downto 2) <= LV4(1)(63) & LV4(2)(62) & LV4(3)(61 downto 4) & LV4(2)(3 downto 2);
	
	--------------------------------------------------------------
	--------------------------------------------------------------
	-- COMPRESSORS
	-- LEVEL 6 - Mapped directly to the output
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	--PARTIAL_1(1 downto 0) <= LV5(0)(1 downto 0);
	PARTIAL_1(1 downto 0) <= LV0(0)(1 downto 0);
	PARTIAL_2(2 downto 0) <= LV5(2)(2) & LV0(1)(1 downto 0);
	
	
	HA6_row_1_1: HA port map
	(	A		=> LV5(0)(2),
		B		=> LV5(1)(2),
		S		=> PARTIAL_1(2),
		COUT	=> PARTIAL_1(3)
	);
	
	FA6_row_1: for i in 3 to 62 generate
		FA6_1_i: FA port map
		(	A		=> LV5(0)(i),
			B		=> LV5(1)(i),
			CIN		=> LV5(2)(i),
			S		=> PARTIAL_2(i),
			COUT	=> PARTIAL_1(i+1)
		);
	end generate;
	
	FA6_final: FA port map
	(	A		=> LV5(0)(63),
		B		=> LV5(1)(63),
		CIN		=> LV5(2)(63),
		S		=> PARTIAL_2(63),
		COUT	=> OV
	);
	
end structure;
	

	
