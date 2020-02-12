library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;


entity CNNConvolution is
  generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural;
          AddressLength:natural; NumBitData:natural);
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;
    Cin   : in cnn_matrix_t(0 to InputHeight-1,  0 to InputWidth-1);
    flt   : in cnn_matrix_t(0 to FilterHeight-1, 0 to FilterWidth-1);

    -- Memory 
    mem_wr_en    : out std_logic;
    mem_wr_addr  : out std_logic_vector(AddressLength-1 downto 0);
    mem_data     : out std_logic_vector(NumBitData-1 downto 0)
  );
end CNNConvolution;

architecture CNNConvolution_Arch of CNNConvolution is  
  -- utility constants
  constant CNN_MEMORY_HEIGHT : natural := (InputHeight - FilterHeight + 1);
  constant CNN_MEMORY_WIDTH  : natural := (InputWidth - FilterWidth + 1);
  constant CNN_MEMORY_SIZE   : natural := CNN_MEMORY_HEIGHT*CNN_MEMORY_WIDTH;

  signal mem_wr_en_s : std_logic;
  signal mem_data_s : std_logic_vector(NumBitData-1 downto 0);
  signal mem_wr_addr_s : std_logic_vector(AddressLength-1 downto 0);

begin
  -- Process
  process(clk, reset)
    variable index_r   : natural := 0;
    variable index_c   : natural := 0;
    variable mem_index : natural := 0;
    variable sub_mat   : cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
  begin
    if reset = '0' then
      -- reset stuff
      index_c   := 0;
      index_r   := 0;
      mem_index := 0;
      mem_wr_en_s <= '0';

    elsif (clk='1' and clk'event) then
         if mem_index <  CNN_MEMORY_SIZE then
           if index_c + FilterWidth  = InputWidth + 1 then 
             index_c := 0;
             index_r := index_r + 1;
           end if;
    
           -- write to memory
           mem_wr_addr_s <= std_logic_vector(to_unsigned(mem_index, AddressLength));
           mem_data_s    <= std_logic_vector(to_signed(slice(cin, index_r, index_c, FilterWidth, FilterHeight)*flt, NumBitData));
           mem_wr_en_s   <= '1';
    
           -- increment indices...
           index_c   := index_c + 1;
           mem_index := mem_index + 1;
         else 
           -- convolution is done, i don't have to write to mem anymore
           mem_wr_en_s <= '0';
         end if;
       end if;
  end process;

  mem_wr_en <= mem_wr_en_s;
  mem_data <= mem_data_s;
  mem_wr_addr <= mem_wr_addr_s;

end CNNConvolution_Arch;