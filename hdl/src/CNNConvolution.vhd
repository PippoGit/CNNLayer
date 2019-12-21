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

    -- Input Matrices
    Cin    : in cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
    filter : in cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);

    -- Output Cell
    Cout  : out cnn_cell_t
  );
end CNNConvolution;

architecture CNNConvolution_Arch of CNNConvolution is
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
