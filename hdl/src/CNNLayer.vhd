library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;

-- What i'm going to do here:
-- just add OutH*OutW CNNConvolutionModule and a bunch of input registers CinH*CinW 
-- OutH = (InH-FiH)
-- OutW = (InW-FiW)
-- Since stride is 1 and padding is zero.
--
-- Then connect each submatrix to the right CNNConvolutionModule and that's it. is it?

entity CNNLayer is
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;

    -- In/Out
    d_in  : in  cnn_cell_t;
    d_out : out cnn_cell_t
  );
end CNNLayer;

architecture CNNLayer_Arch of CNNLayer is  
begin
end CNNLayer_Arch;