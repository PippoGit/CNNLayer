library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;

-- This is the piece of hardware that should produce one Cout
entity CNNConvolution is
  generic(InputWidth: natural; InputHeight: natural);
  port(
	 	-- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;

    -- Matrix input
    Cin   : in cnn_matrix_t(0 to InputWidth, 0 to InputHeight);

		-- Output
		Cout  : out cnn_cell_t
  );
end CNNConvolution;

architecture CNNConvolution_Arch of CNNConvolution is
begin
	-- STUFF I AM GOING TO USE: 
  --  1) A ROM CONTAINING MY FILTER VALUES
	--  2) AN RCA ADDER
  --  3) A REGISTER for parial result
	-- Cout <= Cin * filter;
end CNNConvolution_Arch;
