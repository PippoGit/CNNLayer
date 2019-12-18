library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;

-- This is the piece of hardware that should produce one Cout
entity CNNConvolution is
  generic(InputWidth: natural; InputHeight: natural; NBits: natural);
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

-- TODO: Add a register for the output!
architecture CNNConvolution_Arch of CNNConvolution is
  signal filter  : cnn_matrix_t(0 to InputWidth, 0 to InputHeight);
  signal convres : cnn_cell_t;

  component CNNRegister is
    port (
      clk   : in std_logic;
      reset : in std_logic;
      d_in  : in  cnn_cell_t;
      d_out : out cnn_cell_t
    );
  end component;
  
begin
  REG: CNNRegister 
  port map (
    clk   => clk,
    reset => reset,
    d_in  => convres,
    d_out => Cout 
  );

  convres <= Cin*filter;
end CNNConvolution_Arch;
