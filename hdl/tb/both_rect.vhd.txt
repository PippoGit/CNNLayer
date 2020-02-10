library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb_002586 is
end cnnlayer_tb_002586;

  architecture bhv of cnnlayer_tb_002586 is
  constant T_CLK    : time := 8 ns;
  constant T_RESET  : time := 12 ns;

  constant INPUT_WIDTH    : natural := 7;
  constant INPUT_HEIGHT   : natural := 10;

  constant FILTER_WIDTH   : natural := 5;
  constant FILTER_HEIGHT  : natural := 3;

  constant ADDRESS_LENGTH : natural :=  5;
  constant CNN_OUTPUT_BIT : natural :=  20;

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_HEIGHT-1, 0 to INPUT_WIDTH-1) := (("00011001", "01101110", "00011011", "01000011", "00111000", "01010110", "00100101"), ("00001100", "01111010", "00000110", "01010011", "00011111", "01011011", "01011111"), ("00110001", "00100010", "01100111", "01100001", "00000110", "00110010", "01001001"), ("01010010", "00010001", "01011000", "01101101", "01000011", "01111111", "01011110"), ("01011101", "00011110", "01111111", "00010010", "01101001", "00011011", "01110001"), ("00110001", "00110001", "01100111", "00101000", "01011100", "00111100", "00110001"), ("01011000", "01001110", "01011110", "01100101", "00110001", "00101111", "00100111"), ("00110010", "00000110", "00001100", "00101010", "01011100", "00110000", "01000101"), ("01011010", "00101000", "01000111", "01000000", "00110001", "00110001", "01001010"), ("00101010", "00001110", "00100111", "01101111", "01100111", "01110110", "01110010"));
  signal flt : cnn_matrix_t(0 to FILTER_HEIGHT-1, 0 to FILTER_WIDTH-1) := (("01111111", "01001100", "01011101", "00001100", "00101110"), ("00000010", "00111010", "01111000", "01110100", "00110011"), ("01110110", "01100110", "00010000", "01101011", "00010011"));

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
        when 29 => mem_rd_en_s   <= '1'; mem_rd_addr_s <= (others => '0');
        when 30 => mem_rd_addr_s <= "00001";
        when 31 => mem_rd_addr_s <= "00010";
        when 32 => mem_rd_addr_s <= "00011";
        when 33 => mem_rd_addr_s <= "00100";
        when 34 => mem_rd_addr_s <= "00101";
        when 35 => mem_rd_addr_s <= "00110";
        when 36 => mem_rd_addr_s <= "00111";
        when 37 => mem_rd_addr_s <= "01000";
        when 38 => mem_rd_addr_s <= "01001";
        when 39 => mem_rd_addr_s <= "01010";
        when 40 => mem_rd_addr_s <= "01011";
        when 41 => mem_rd_addr_s <= "01100";
        when 42 => mem_rd_addr_s <= "01101";
        when 43 => mem_rd_addr_s <= "01110";
        when 44 => mem_rd_addr_s <= "01111";
        when 45 => mem_rd_addr_s <= "10000";
        when 46 => mem_rd_addr_s <= "10001";
        when 47 => mem_rd_addr_s <= "10010";
        when 48 => mem_rd_addr_s <= "10011";
        when 49 => mem_rd_addr_s <= "10100";
        when 50 => mem_rd_addr_s <= "10101";
        when 51 => mem_rd_addr_s <= "10110";
        when 52 => mem_rd_addr_s <= "10111";

        when 63 => end_sim <= '1'; mem_rd_en_s <= '0';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;

-- INPUT MAT:
--     25    110    27    67    56    86    37
--     12    122    6    83    31    91    95
--     49    34    103    97    6    50    73
--     82    17    88    109    67    127    94
--     93    30    127    18    105    27    113
--     49    49    103    40    92    60    49
--     88    78    94    101    49    47    39
--     50    6    12    42    92    48    69
--     90    40    71    64    49    49    74
--     42    14    39    111    103    118    114


-- FILTER MAT:
--     127    76    93    12    46
--     2    58    120    116    51
--     118    102    16    107    19


-- EXPECTED RESULT DEC:
--     57846    63332    69291
--     65518    71463    69439
--     67584    84536    82571
--     67345    76685    79389
--     87162    68786    83757
--     67379    60804    60637
--     64379    67221    71455
--     54443    49622    68578


-- EXPECTED RESULT HEX:
--     0xe1f6    0xf764    0x10eab
--     0xffee    0x11727    0x10f3f
--     0x10800    0x14a38    0x1428b
--     0x10711    0x12b8d    0x1361d
--     0x1547a    0x10cb2    0x1472d
--     0x10733    0xed84    0xecdd
--     0xfb7b    0x10695    0x1171f
--     0xd4ab    0xc1d6    0x10be2

