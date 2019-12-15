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
