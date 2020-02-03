library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;

package cnn_types is
  -- Constants
  constant N_BIT_INTEGER : integer := 8;
  --

  -- Types
  subtype cnn_cell_t is std_logic_vector(N_BIT_INTEGER-1 downto 0);
  subtype cnn_outcell_t is std_logic_vector(2*N_BIT_INTEGER downto 0); -- don't forget overflow issues! 

  type cnn_row_t     is array(natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
  type cnn_col_t     is array(natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
  type cnn_matrix_t  is array(natural range <>, natural range <>) of std_logic_vector(N_BIT_INTEGER-1 downto 0);
  
  -- Filters Enumeration
  type cnn_filter_enum is (CNNFilter_3x3, CNNFilter_4x4, CNNFilter_6x6);

  -- Define convolution as a product between cnn_matrix_t
  function "*"(m, f : cnn_matrix_t) return cnn_outcell_t;
  function slice(m: cnn_matrix_t; row_index: natural; col_index: natural; w: natural; h:natural) return cnn_matrix_t;
end cnn_types;


package body cnn_types is
  function "*"(m, f : cnn_matrix_t) return cnn_outcell_t is
    variable conv : cnn_outcell_t;
    variable pres : integer := 0;
  begin
    for idx in 0 to f'length(1)-1 loop
      for idy in 0 to f'length(2)-1 loop
        pres := pres + to_integer( signed(m(idx, idy))*signed(f(idx, idy)) );
      end loop;
    end loop;
    conv := std_logic_vector(to_signed(pres, conv'length));
    return conv;
  end function;

  function slice(m: cnn_matrix_t; row_index: natural; col_index: natural; w: natural; h:natural) return cnn_matrix_t is
    variable subm: cnn_matrix_t(0 to h-1, 0 to w-1);
  begin
    for i in 0 to h-1 loop
      for j in 0 to w-1 loop
        subm(i, j) := m(row_index + i, col_index + j);
      end loop;
    end loop;
    return subm;
  end function;
end package body cnn_types;
