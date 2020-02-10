library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb_939286 is
end cnnlayer_tb_939286;

  architecture bhv of cnnlayer_tb_939286 is
  constant T_CLK    : time := 8 ns;
  constant T_RESET  : time := 12 ns;

  constant INPUT_WIDTH    : natural := 10;
  constant INPUT_HEIGHT   : natural := 10;

  constant FILTER_WIDTH   : natural := 5;
  constant FILTER_HEIGHT  : natural := 3;

  constant ADDRESS_LENGTH : natural :=  6;
  constant CNN_OUTPUT_BIT : natural :=  20;

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_HEIGHT-1, 0 to INPUT_WIDTH-1) := (("00010100", "00011110", "01101001", "01001000", "00101001", "01100100", "00101011", "00100011", "00001100", "00101011"), ("01100101", "01001010", "00011101", "01000000", "01010000", "00111011", "01010010", "01010110", "00010011", "01100101"), ("00001011", "00001111", "00011011", "00010111", "01110001", "00111000", "00110000", "00101101", "00111111", "01001101"), ("00011111", "01101000", "00001000", "01000110", "00000000", "00011110", "01111011", "01010010", "00010010", "01100100"), ("01000010", "00110000", "00001101", "01000010", "00011100", "00111110", "01001110", "01101111", "00001001", "00100100"), ("00110100", "01101000", "01101100", "01111100", "00011010", "01011011", "00111100", "00000100", "01000000", "00010010"), ("01001011", "00001101", "01101010", "01100001", "01000101", "01111010", "00101110", "01001111", "00000110", "01101110"), ("00011010", "01100110", "00000010", "00001100", "01100000", "01100100", "00111110", "00111010", "01100011", "01011110"), ("00111010", "00011000", "00000000", "00100000", "01110100", "01111100", "00010011", "00111101", "01011100", "00110110"), ("00111110", "01110101", "01011010", "00111000", "01001101", "01100100", "00011111", "01101010", "01100101", "01010011"));
  signal flt : cnn_matrix_t(0 to FILTER_HEIGHT-1, 0 to FILTER_WIDTH-1) := (("00101111", "00011111", "01110111", "00101101", "00001100"), ("01000001", "01100101", "01100001", "01101110", "01110001"), ("01101011", "00110000", "00101000", "00010111", "00011110"));

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
        when 53 => mem_rd_en_s   <= '1'; mem_rd_addr_s <= (others => '0');
        when 54 => mem_rd_addr_s <= "000001";
        when 55 => mem_rd_addr_s <= "000010";
        when 56 => mem_rd_addr_s <= "000011";
        when 57 => mem_rd_addr_s <= "000100";
        when 58 => mem_rd_addr_s <= "000101";
        when 59 => mem_rd_addr_s <= "000110";
        when 60 => mem_rd_addr_s <= "000111";
        when 61 => mem_rd_addr_s <= "001000";
        when 62 => mem_rd_addr_s <= "001001";
        when 63 => mem_rd_addr_s <= "001010";
        when 64 => mem_rd_addr_s <= "001011";
        when 65 => mem_rd_addr_s <= "001100";
        when 66 => mem_rd_addr_s <= "001101";
        when 67 => mem_rd_addr_s <= "001110";
        when 68 => mem_rd_addr_s <= "001111";
        when 69 => mem_rd_addr_s <= "010000";
        when 70 => mem_rd_addr_s <= "010001";
        when 71 => mem_rd_addr_s <= "010010";
        when 72 => mem_rd_addr_s <= "010011";
        when 73 => mem_rd_addr_s <= "010100";
        when 74 => mem_rd_addr_s <= "010101";
        when 75 => mem_rd_addr_s <= "010110";
        when 76 => mem_rd_addr_s <= "010111";
        when 77 => mem_rd_addr_s <= "011000";
        when 78 => mem_rd_addr_s <= "011001";
        when 79 => mem_rd_addr_s <= "011010";
        when 80 => mem_rd_addr_s <= "011011";
        when 81 => mem_rd_addr_s <= "011100";
        when 82 => mem_rd_addr_s <= "011101";
        when 83 => mem_rd_addr_s <= "011110";
        when 84 => mem_rd_addr_s <= "011111";
        when 85 => mem_rd_addr_s <= "100000";
        when 86 => mem_rd_addr_s <= "100001";
        when 87 => mem_rd_addr_s <= "100010";
        when 88 => mem_rd_addr_s <= "100011";
        when 89 => mem_rd_addr_s <= "100100";
        when 90 => mem_rd_addr_s <= "100101";
        when 91 => mem_rd_addr_s <= "100110";
        when 92 => mem_rd_addr_s <= "100111";
        when 93 => mem_rd_addr_s <= "101000";
        when 94 => mem_rd_addr_s <= "101001";
        when 95 => mem_rd_addr_s <= "101010";
        when 96 => mem_rd_addr_s <= "101011";
        when 97 => mem_rd_addr_s <= "101100";
        when 98 => mem_rd_addr_s <= "101101";
        when 99 => mem_rd_addr_s <= "101110";
        when 100 => mem_rd_addr_s <= "101111";

        when 111 => end_sim <= '1'; mem_rd_en_s <= '0';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;

-- INPUT MAT:
--     20    30    105    72    41    100    43    35    12    43
--     101    74    29    64    80    59    82    86    19    101
--     11    15    27    23    113    56    48    45    63    77
--     31    104    8    70    0    30    123    82    18    100
--     66    48    13    66    28    62    78    111    9    36
--     52    104    108    124    26    91    60    4    64    18
--     75    13    106    97    69    122    46    79    6    110
--     26    102    2    12    96    100    62    58    99    94
--     58    24    0    32    116    124    19    61    92    54
--     62    117    90    56    77    100    31    106    101    83


-- FILTER MAT:
--     47    31    119    45    12
--     65    101    97    110    113
--     107    48    40    23    30


-- EXPECTED RESULT DEC:
--     57925    53792    60168    68190    62207    59071
--     44719    56204    51725    59915    57957    61908
--     39825    38688    52759    60214    53470    64946
--     48114    59347    53674    67290    59910    59513
--     67571    70962    71515    64754    59072    62675
--     70263    84288    67617    72364    64624    64131
--     57663    60101    60500    74003    79334    78407
--     48584    67090    66033    71314    77548    72466


-- EXPECTED RESULT HEX:
--     0xe245    0xd220    0xeb08    0x10a5e    0xf2ff    0xe6bf
--     0xaeaf    0xdb8c    0xca0d    0xea0b    0xe265    0xf1d4
--     0x9b91    0x9720    0xce17    0xeb36    0xd0de    0xfdb2
--     0xbbf2    0xe7d3    0xd1aa    0x106da    0xea06    0xe879
--     0x107f3    0x11532    0x1175b    0xfcf2    0xe6c0    0xf4d3
--     0x11277    0x14940    0x10821    0x11aac    0xfc70    0xfa83
--     0xe13f    0xeac5    0xec54    0x12113    0x135e6    0x13247
--     0xbdc8    0x10612    0x101f1    0x11692    0x12eec    0x11b12

