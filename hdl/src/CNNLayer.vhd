library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;


entity CNNLayer is
  generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural);
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;
    Cin   : in cnn_matrix_t(0 to InputWidth-1,  0 to InputHeight-1);
    flt   : in cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

    -- Output Channel
    Cout : out cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1)
  );
end CNNLayer;

architecture CNNLayer_Arch of CNNLayer is  
  constant CNN_MEMORY_SIZE : natural := (InputHeight - FilterHeight + 1)*(InputWidth-FilterWidth + 1);

  -- type cnn_memory_t is array(0 to CNN_MEMORY_SIZE-1) of cnn_cell_t; 
  signal CNNMemory : cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);
 
  signal cin_reg : cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
  signal flt_reg : cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

  -- Register
  component CNNRegister is
    generic(CNNWidth:natural; CNNHeight:natural);
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      d_in  : in  cnn_matrix_t(0 to CNNWidth-1, 0 to CNNHeight-1);
      d_out : out cnn_matrix_t(0 to CNNWidth-1, 0 to CNNHeight-1)
    );
  end component;
begin

  -- Registers
  CinRegister : CNNRegister
    generic map(CNNWidth => InputWidth, CNNHeight => InputHeight)
    port map(
      clk   => clk,
      reset => reset,
      d_in  => Cin,
      d_out => cin_reg
    );

  FltRegister : CNNRegister
    generic map(CNNWidth => FilterWidth, CNNHeight => FilterHeight)
    port map(
      clk   => clk,
      reset => reset,
      d_in  => flt,
      d_out => flt_reg
    );

  CoutRegister : CNNRegister
    generic map(CNNWidth => FilterWidth, CNNHeight => FilterHeight)
    port map(
      clk   => clk,
      reset => reset,
      d_in  => CNNMemory,
      d_out => Cout
    );

  -- Process
  process(clk, reset)
    variable index_r   : natural := 0;
    variable index_c   : natural := 0;
    variable sub_mat   : cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
    variable mem_index : natural := 0;
  begin
    if reset = '1' then
      index_c   := 0;
      index_r   := 0;
      mem_index := 0;
      CNNMemory <= (others => (others => "00000000")); -- reset the memory
    elsif (clk='1' and clk'event) then
       if mem_index <  CNN_MEMORY_SIZE then
         if index_c + FilterWidth  = InputWidth + 1 then 
           index_c := 0;
           index_r := index_r + 1;
         end if;

         -- convolution for i-th output
         CNNMemory(index_r, index_c)   <= slice(cin_reg, index_r, index_c, FilterWidth, FilterHeight)*flt_reg;

         -- increment indices...
         index_c   := index_c + 1;
         mem_index := mem_index + 1;
       end if;
    end if;
  end process;
  
  -- Output 
  -- Cout <= CNNMemory;
end CNNLayer_Arch;