library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;


entity CNNLayer is
  generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural;
          AddressLength:natural);
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;
    Cin   : in cnn_matrix_t(0 to InputWidth-1,  0 to InputHeight-1);
    flt   : in cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

    -- Memory 
    mem_rd_en    : in std_logic;
    mem_rd_addr  : in std_logic_vector(AddressLength-1 downto 0);
    mem_data_out : out cnn_cell_t
  );
end CNNLayer;

architecture CNNLayer_Arch of CNNLayer is  
  -- utility constants
  constant CNN_MEMORY_HEIGHT : natural := (InputHeight - FilterHeight + 1);
  constant CNN_MEMORY_WIDTH  : natural := (InputWidth - FilterWidth + 1);
  constant CNN_MEMORY_SIZE   : natural := CNN_MEMORY_HEIGHT*CNN_MEMORY_WIDTH;
 
  signal cin_reg : cnn_matrix_t(0 to InputWidth-1, 0 to InputHeight-1);
  signal flt_reg : cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

  signal stbl_cin : std_logic;
  signal stbl_flt : std_logic;

  signal mem_data_s    : cnn_cell_t;
  signal mem_wr_addr_s : std_logic_vector(AddressLength-1 downto 0);
  signal mem_wr_en_s   : std_logic;
  
  -- Register
  component CNNRegister is
    generic(CNNWidth:natural; CNNHeight:natural);
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      d_in  : in  cnn_matrix_t(0 to CNNWidth-1, 0 to CNNHeight-1);
      d_out : out cnn_matrix_t(0 to CNNWidth-1, 0 to CNNHeight-1);
      stbl  : out std_logic
    );
  end component;

  -- Memory
  component CNNMemory is
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
  end component;

begin

  -- Registers
  CinRegister : CNNRegister
    generic map(CNNWidth => InputWidth, CNNHeight => InputHeight)
    port map(
      clk   => clk,
      reset => reset,
      d_in  => Cin,
      d_out => cin_reg,
      stbl  => stbl_cin
    );

  FltRegister : CNNRegister
    generic map(CNNWidth => FilterWidth, CNNHeight => FilterHeight)
    port map(
      clk   => clk,
      reset => reset,
      d_in  => flt,
      d_out => flt_reg,
      stbl  => stbl_flt
    );

  RAM: CNNMemory
    generic map(MemorySize => CNN_MEMORY_SIZE, AddressLength => AddressLength)
    port map(
      clk      => clk,
      reset    => reset,

      wr_addr  => mem_wr_addr_s,
      wr_en    => mem_wr_en_s,

      rd_en    => mem_rd_en,
      rd_addr  => mem_rd_addr,

      data_in  => mem_data_s,
      data_out => mem_data_out
    );

  -- Process
  process(clk, reset, stbl_cin, stbl_flt)
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

    elsif (clk='1' and clk'event and stbl_cin ='1' and stbl_flt='1') then
       if mem_index <  CNN_MEMORY_SIZE then
         if index_c + FilterWidth  = InputWidth + 1 then 
           index_c := 0;
           index_r := index_r + 1;
         end if;

         -- write to memory
         mem_wr_addr_s <= std_logic_vector(to_unsigned(mem_index, AddressLength));
         mem_data_s    <= slice(cin_reg, index_r, index_c, FilterWidth, FilterHeight)*flt_reg;
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
  
  -- Output 
  -- Cout <= CNNMemory;
end CNNLayer_Arch;