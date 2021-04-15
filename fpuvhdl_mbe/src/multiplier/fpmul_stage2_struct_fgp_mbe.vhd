-- VHDL Entity HAVOC.FPmul_stage2.interface
--
-- Created by
-- Guillermo Marcus, gmarcus@ieee.org
-- using Mentor Graphics FPGA Advantage tools.
--
-- Visit "http://fpga.mty.itesm.mx" for more info.
--
-- 2003-2004. V1.0
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPmul_stage2 IS
   PORT( 
      A_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      A_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      B_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      B_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      SIGN_out_stage1 : IN     std_logic;
      clk             : IN     std_logic;
      isINF_stage1    : IN     std_logic;
      isNaN_stage1    : IN     std_logic;
      isZ_tab_stage1  : IN     std_logic;
      EXP_in          : OUT    std_logic_vector (7 DOWNTO 0);
      EXP_neg_stage2  : OUT    std_logic;
      EXP_pos_stage2  : OUT    std_logic;
      SIGN_out_stage2 : OUT    std_logic;
      SIG_in          : OUT    std_logic_vector (27 DOWNTO 0);
      isINF_stage2    : OUT    std_logic;
      isNaN_stage2    : OUT    std_logic;
      isZ_tab_stage2  : OUT    std_logic
   );

-- Declarations

END FPmul_stage2 ;

--
-- VHDL Architecture HAVOC.FPmul_stage2.struct
--
-- Created by
-- Guillermo Marcus, gmarcus@ieee.org
-- using Mentor Graphics FPGA Advantage tools.
--
-- Visit "http://fpga.mty.itesm.mx" for more info.
--
-- Copyright 2003-2004. V1.0
--


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ARCHITECTURE struct OF FPmul_stage2 IS

	component mbe
		port(
				A_SIG	: in std_logic_vector(31 downto 0);
				B_SIG	: in std_logic_vector(31 downto 0);
				PROD	: out std_logic_vector(63 downto 0)
			);
	end component;

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL EXP_in_int  : std_logic_vector(7 DOWNTO 0);
   SIGNAL EXP_neg_int : std_logic;
   SIGNAL EXP_pos_int : std_logic;
   SIGNAL SIG_in_int  : std_logic_vector(27 DOWNTO 0);
   SIGNAL dout        : std_logic;
   SIGNAL dout1       : std_logic_vector(7 DOWNTO 0);
   SIGNAL prod        : std_logic_vector(63 DOWNTO 0);


	-- Internal signals - Added registers
	-- Register on the output of the multiplier
	signal prod_to_sig 		  : std_logic_vector(63 downto 0);
	signal EXP_in_int_to_out  : std_logic_vector(7 DOWNTO 0);
   	signal EXP_neg_int_to_out : std_logic;
   	signal EXP_pos_int_to_out : std_logic;

	-- Registers for direct in-to-out signals
	signal isINF_s1_to_s2 : std_logic;
    signal isNaN_s1_to_s2 : std_logic;
    signal isZ_tab_s1_to_s2 : std_logic;
    signal SIGN_out_s1_to_s2: std_logic;



BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 sig
   -- eb1 1

	-- MULTIPLIER OUTPUT REGISTER -------------------
	mult_reg: process(clk)
	begin
		if RISING_EDGE(clk) then
			prod_to_sig <= prod;
		end if;
	end process mult_reg;

	SIG_in_int <= prod_to_sig(47 DOWNTO 20);
	-------------------------------------------------

   -- HDL Embedded Text Block 2 inv
   -- eb5 5
   EXP_in_int <= (NOT dout1(7)) & dout1(6 DOWNTO 0);

   -- HDL Embedded Text Block 3 latch
   -- eb2 2
   
	--------------------------------------------------
	-- In-to-out registers
	int_to_out_regs: PROCESS(clk)
	BEGIN
	  IF RISING_EDGE(clk) THEN
	     EXP_in_int_to_out <= EXP_in_int;
	     SIG_in <= SIG_in_int;
	     EXP_pos_int_to_out <= EXP_pos_int;
	     EXP_neg_int_to_out <= EXP_neg_int;
	  END IF;
	END PROCESS int_to_out_regs;

	-- Output registers
   out_regs: PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         EXP_in <= EXP_in_int_to_out;
         EXP_pos_stage2 <= EXP_pos_int_to_out;
         EXP_neg_stage2 <= EXP_neg_int_to_out;
      END IF;
   END PROCESS out_regs;

   -- HDL Embedded Text Block 4 latch2
   -- latch2 4

	-- Direct in-to-out pipelining registers

   s1_to_s2_out_regs: PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         isINF_stage2 <= isINF_s1_to_s2;
         isNaN_stage2 <= isNaN_s1_to_s2;
         isZ_tab_stage2 <= isZ_tab_s1_to_s2;
         SIGN_out_stage2 <= SIGN_out_s1_to_s2;
      END IF;
   END PROCESS s1_to_s2_out_regs;

   s1_to_s2_regs: PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         isINF_s1_to_s2 <= isINF_stage1;
         isNaN_s1_to_s2 <= isNaN_stage1;
         isZ_tab_s1_to_s2 <= isZ_tab_stage1;
         SIGN_out_s1_to_s2 <= SIGN_out_stage1;
      END IF;
   END PROCESS s1_to_s2_regs;
	----------------------------------------------


   -- HDL Embedded Text Block 5 eb1
   -- exp_pos 5
   EXP_pos_int <= A_EXP(7) AND B_EXP(7);
--   EXP_neg_int <= NOT(A_EXP(7) OR B_EXP(7));
   EXP_neg_int <= '1' WHEN ( (A_EXP(7)='0' AND NOT (A_EXP=X"7F")) AND (B_EXP(7)='0' AND NOT (B_EXP=X"7F")) ) ELSE '0';


   -- ModuleWare code(v1.1) for instance 'I4' of 'add'
   I4combo: PROCESS (A_EXP, B_EXP, dout)
   VARIABLE mw_I4t0 : std_logic_vector(8 DOWNTO 0);
   VARIABLE mw_I4t1 : std_logic_vector(8 DOWNTO 0);
   VARIABLE mw_I4sum : unsigned(8 DOWNTO 0);
   VARIABLE mw_I4carry : std_logic;
   BEGIN
      mw_I4t0 := '0' & A_EXP;
      mw_I4t1 := '0' & B_EXP;
      mw_I4carry := dout;
      mw_I4sum := unsigned(mw_I4t0) + unsigned(mw_I4t1) + mw_I4carry;
      dout1 <= conv_std_logic_vector(mw_I4sum(7 DOWNTO 0),8);
   END PROCESS I4combo;

   -- ModuleWare code(v1.1) for instance 'I2' of 'mult'
   --I2combo : PROCESS (A_SIG, B_SIG)
   --VARIABLE dtemp : unsigned(63 DOWNTO 0);
   --BEGIN
   --   dtemp := (unsigned(A_SIG) * unsigned(B_SIG));
   --   prod <= std_logic_vector(dtemp);
   --END PROCESS I2combo;

	-- MBE MULTIPLIER
	mult: mbe port map
	(	A_SIG	=> A_SIG,
		B_SIG	=> B_SIG,
		PROD	=> PROD
	);

   -- ModuleWare code(v1.1) for instance 'I6' of 'vdd'
   dout <= '1';

   -- Instance port mappings.

END struct;
