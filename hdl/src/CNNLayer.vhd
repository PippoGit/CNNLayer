library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;


entity CNNLayer is
  generic(InputWidth:natural; InputHeight:natural);
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;

    -- just a cell as output to test it...
    Cin   : in  cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
    out_i : out cnn_cell_t
  );
end CNNLayer;

architecture CNNLayer_Arch of CNNLayer is  
  constant FILTER_WIDTH    : natural := 3;
  constant FILTER_HEIGHT   : natural := 3;
  constant CNN_MEMORY_SIZE : natural := (InputHeight - FILTER_HEIGHT + 1)*(InputWidth-FILTER_WIDTH + 1);

  type cnn_memory_t is array(0 to CNN_MEMORY_SIZE-1) of cnn_cell_t; 

  component CNNFilterRom is
    port (
      filter_3x3 : out cnn_matrix_t(0 to 2, 0 to 2);
      filter_4x4 : out cnn_matrix_t(0 to 3, 0 to 3);
      filter_6x6 : out cnn_matrix_t(0 to 5, 0 to 5)
    );
  end component;
  

  component CNNRegister is
    port (
      clk   : in std_logic;
      reset : in std_logic;
      d_in  : in  cnn_cell_t;
      d_out : out cnn_cell_t
    );
  end component;
      
  -- signals to put all together
  signal conv_to_mem  : cnn_cell_t;
  signal filt_to_conv : cnn_matrix_t(0 to FILTER_WIDTH-1, 0 to FILTER_HEIGHT-1);

begin

  -- FILTER_ROM 
  FLT : CNNFilterRom port map (
    filter_3x3 => filt_to_conv,
    filter_4x4 => open,
    filter_6x6 => open
  );

  -- Register for Last Channel Output
  REG : CNNRegister port map (
    clk   => clk,
    reset => reset,
    d_in  => conv_to_mem,
    d_out => out_i 
  );
  
  -- Process
  process(clk, reset)
    variable index_r   : natural := 0;
    variable index_c   : natural := 0;
    variable sub_mat   : cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
    variable mem_index : natural := 0;
  
    -- Memory
    variable CNNMemory : cnn_memory_t;  
  begin
    if reset = '1' then
      index_c   := 0;
      index_r   := 0;
      mem_index := 0;
    elsif (clk='1' and clk'event) then
       if mem_index <  CNN_MEMORY_SIZE then
         if index_c + FILTER_WIDTH  = InputWidth + 1 then 
           index_c := 0;
           index_r := index_r + 1;
         end if;

         -- convolution for i-th output
         conv_to_mem <= slice(Cin, index_r, index_c, FILTER_WIDTH, FILTER_HEIGHT)*filt_to_conv;
         CNNMemory(mem_index) := conv_to_mem;

         -- increment indices...
         index_c   := index_c + 1;
         mem_index := mem_index + 1;
       end if;
    end if;
  end process;
end CNNLayer_Arch;