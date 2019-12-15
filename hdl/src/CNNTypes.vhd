library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package cnn_types is
	-- Constants
	constant N_BIT_INTEGER : integer := 8;
	--

	-- Types
	subtype cnn_cell_t is std_logic_vector(N_BIT_INTEGER-1 downto 0);
	type cnn_row_t     is array(natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
	type cnn_col_t     is	array(natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
	type cnn_matrix_t  is array(natural range <>, natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);


	-- Define convolution as a product between cnn_matrix_t
	function "*"(m, f : cnn_matrix_t) return cnn_cell_t;

end cnn_types;


package body cnn_types is
	function "*"(m, f : cnn_matrix_t) return cnn_cell_t is
		variable conv : cnn_cell_t;
		variable pres : integer;
	begin
		pres := 0;
		for idx in f'range(1) loop
			for idy in f'range(2) loop
				pres := pres + to_integer( signed(m(idx, idy))*signed(f(idx, idy)) );
			end loop;
		end loop;
		conv := std_logic_vector(to_signed(pres, conv'length));
		return conv;
	end function;
end package body cnn_types;
