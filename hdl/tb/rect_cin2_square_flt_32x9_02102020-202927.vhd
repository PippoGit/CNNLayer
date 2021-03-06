library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb_967236 is
end cnnlayer_tb_967236;

  architecture bhv of cnnlayer_tb_967236 is
  constant T_CLK    : time := 8 ns;
  constant T_RESET  : time := 12 ns;

  constant INPUT_WIDTH    : natural := 4;
  constant INPUT_HEIGHT   : natural := 8;

  constant FILTER_WIDTH   : natural := 3;
  constant FILTER_HEIGHT  : natural := 3;

  constant ADDRESS_LENGTH : natural :=  4;
  constant CNN_OUTPUT_BIT : natural :=  20;

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_HEIGHT-1, 0 to INPUT_WIDTH-1) := (("00101000", "01000100", "01101000", "00110010"), ("00000010", "01010101", "01111101", "01110011"), ("00011110", "01010011", "00111111", "00011101"), ("01100001", "00101000", "01100010", "00101010"), ("01100001", "01000101", "00100010", "00100011"), ("00111011", "00010101", "01001111", "01010111"), ("00110111", "00010001", "01111010", "01100110"), ("00011100", "00110001", "01010001", "01111110"));
  signal flt : cnn_matrix_t(0 to FILTER_HEIGHT-1, 0 to FILTER_WIDTH-1) := (("01111000", "01010011", "01000001"), ("00110100", "00110001", "00111001"), ("01100111", "00011010", "01000000"));

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
--     40    68    104    50
--     2    85    125    115
--     30    83    63    29
--     97    40    98    42
--     97    69    34    35
--     59    21    79    87
--     55    17    122    102
--     28    49    81    126


-- FILTER MAT:
--     120    83    65
--     52    49    57
--     103    26    64


-- EXPECTED RESULT DEC:
--     37878    49185
--     41941    46462
--     41135    36581
--     43372    32698
--     42092    34750
--     33947    42625


-- EXPECTED RESULT HEX:
--     0x93f6    0xc021
--     0xa3d5    0xb57e
--     0xa0af    0x8ee5
--     0xa96c    0x7fba
--     0xa46c    0x87be
--     0x849b    0xa681

