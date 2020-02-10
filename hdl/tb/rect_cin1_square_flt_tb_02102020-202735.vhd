library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb_855754 is
end cnnlayer_tb_855754;

  architecture bhv of cnnlayer_tb_855754 is
  constant T_CLK    : time := 8 ns;
  constant T_RESET  : time := 12 ns;

  constant INPUT_WIDTH    : natural := 8;
  constant INPUT_HEIGHT   : natural := 4;

  constant FILTER_WIDTH   : natural := 3;
  constant FILTER_HEIGHT  : natural := 3;

  constant ADDRESS_LENGTH : natural :=  4;
  constant CNN_OUTPUT_BIT : natural :=  20;

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_HEIGHT-1, 0 to INPUT_WIDTH-1) := (("01010010", "00011011", "00110011", "00010110", "00010001", "00011110", "00101000", "00001001"), ("01111010", "00011101", "01111100", "01010001", "01000101", "00111001", "01000110", "01010111"), ("00101011", "01110101", "01000001", "01001110", "01100011", "01010101", "01001101", "00100101"), ("01001001", "00000010", "01101111", "01000011", "01011100", "01010110", "01010111", "01001000"));
  signal flt : cnn_matrix_t(0 to FILTER_HEIGHT-1, 0 to FILTER_WIDTH-1) := (("01010010", "01101100", "01011111"), ("01111010", "01000001", "00000110"), ("00011001", "01111100", "01011111"));

  signal mem_data_out_s : std_logic_vector(CNN_OUTPUT_BIT-1 downto 0);
  signal mem_rd_en_s    : std_logic;
  signal mem_rd_addr_s  : std_logic_vector(ADDRESS_LENGTH-1 downto 0);

  
  component CNNLayer is
    generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural;
            AddressLength: natural; NumBitData:natural);
    port(
      -- Clock and reset 
      clk   : in std_logic;
      reset : in std_logic;
      Cin   : in cnn_matrix_t(0 to InputWidth-1,  0 to InputHeight-1);
      flt   : in cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

      -- Memory 
      mem_rd_en    : in std_logic;
      mem_rd_addr  : in std_logic_vector(AddressLength-1 downto 0);
      mem_data_out : out std_logic_vector(NumBitData-1 downto 0)
    );
  end component;

begin
  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
  reset_tb <= '1' after T_RESET;

  test_CNN: CNNLayer
  generic map (
    InputWidth => INPUT_WIDTH, InputHeight => INPUT_HEIGHT, 
    FilterWidth => FILTER_WIDTH, FilterHeight => FILTER_HEIGHT,
    AddressLength => ADDRESS_LENGTH, NumBitData => CNN_OUTPUT_BIT
  )
  port map(
    clk   => clk_tb,      
    reset => reset_tb,
    Cin   => Cin,
    flt   => flt,
 
    mem_data_out  => mem_data_out_s,
    mem_rd_en     => mem_rd_en_s,
    mem_rd_addr   => mem_rd_addr_s
  );
		
  cnnlayer_process: process(clk_tb, reset_tb)
    variable t : integer := 0;
  begin
    if(reset_tb = '0') then
      t := 0;
      mem_rd_en_s    <= '0';
      mem_rd_addr_s  <= (others => '0');
    elsif(clk_tb='1' and clk_tb'event) then
      case(t) is
        -- testing read from memory
        when 17 => mem_rd_en_s   <= '1'; mem_rd_addr_s <= (others => '0');
        when 18 => mem_rd_addr_s <= "0001";
        when 19 => mem_rd_addr_s <= "0010";
        when 20 => mem_rd_addr_s <= "0011";
        when 21 => mem_rd_addr_s <= "0100";
        when 22 => mem_rd_addr_s <= "0101";
        when 23 => mem_rd_addr_s <= "0110";
        when 24 => mem_rd_addr_s <= "0111";
        when 25 => mem_rd_addr_s <= "1000";
        when 26 => mem_rd_addr_s <= "1001";
        when 27 => mem_rd_addr_s <= "1010";
        when 28 => mem_rd_addr_s <= "1011";

        when 39 => end_sim <= '1'; mem_rd_en_s <= '0';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;

-- INPUT MAT:
--     82    27    51    22    17    30    40    9
--     122    29    124    81    69    57    70    87
--     43    117    65    78    99    85    77    37
--     73    2    111    67    92    86    87    72


-- FILTER MAT:
--     82    108    95
--     122    65    6
--     25    124    95


-- EXPECTED RESULT DEC:
--     53756    40291    49682    43500    41307    34849
--     50775    62611    58888    57223    57758    55874


-- EXPECTED RESULT HEX:
--     0xd1fc    0x9d63    0xc212    0xa9ec    0xa15b    0x8821
--     0xc657    0xf493    0xe608    0xdf87    0xe19e    0xda42

