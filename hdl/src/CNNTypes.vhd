library ieee;
use ieee.std_logic_1164.all;

library work;

package cnn_types is
	-- Constants
	constant N_BIT_INTEGER : integer := 8;
	--

	-- Types
	type cnn_cell_t   is array(N_BIT_INTEGER-1 downto 0) of std_logic;
	type cnn_row_t    is array(natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
	type cnn_matrix_t is array(natural range <>, natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
end cnn_types;