library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;


entity CNNMemory is
  generic(MemorySize:natural; AddressLength:natural);
  port (
    -- Clock and reset
    clk      : in  std_logic;
    reset    : in  std_logic;

    wr_addr  : in  std_logic_vector(AddressLength-1 downto 0);
    wr_en    : in  std_logic;

    rd_addr  : in  std_logic_vector(AddressLength-1 downto 0);
    rd_en    : in  std_logic;

    data_in  : in  cnn_cell_t;
    data_out : out cnn_cell_t
  );
end CNNMemory;

architecture CNNMemory_Arch of CNNMemory is
  type   RAM_t is array(0 to MemorySize-1) of cnn_cell_t;
  signal RAM : ram_t;
begin
  process (clk, reset)
  begin
    if reset = '0' then
      RAM <= (others => ("ZZZZZZZZ")); -- reset the memory
    elsif (clk='1' and clk'event) then
       -- Read Data
       if rd_en='1' and to_integer(unsigned(rd_addr)) < MemorySize then 
         data_out <= RAM(to_integer(unsigned(rd_addr)));
       end if;
       -- Write data
       if wr_en='1' and to_integer(unsigned(wr_addr)) < MemorySize then
         RAM(to_integer(unsigned(wr_addr))) <= data_in;
       end if;
    end if;
  end process;
end CNNMemory_Arch;