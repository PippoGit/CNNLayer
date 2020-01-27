library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb is
end cnnlayer_tb;

architecture bhv of cnnlayer_tb is
  constant T_CLK        : time    :=  8 ns;
  constant T_RESET	: time    := 12 ns;

  constant INPUT_WIDTH    : natural := 5;
  constant INPUT_HEIGHT   : natural := 5;

  constant FILTER_WIDTH   : natural := 3;
  constant FILTER_HEIGHT  : natural := 3;

  constant ADDRESS_LENGTH : natural := 4; -- log(x, RAM_SIZE)
  

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_WIDTH-1, 0 to INPUT_HEIGHT-1) := (
    ("00000001", "00000001", "00000001", "00000000", "00000000"),
    ("00000000", "00000001", "00000001", "00000001", "00000000"),
    ("00000000", "00000000", "00000001", "00000001", "00000001"),
    ("00000000", "00000000", "00000001", "00000001", "00000000"),
    ("00000000", "00000001", "00000001", "00000000", "00000000")
  );

  signal flt : cnn_matrix_t(0 to FILTER_WIDTH-1, 0 to FILTER_HEIGHT-1) := (
     ("00000001", "00000000", "00000001"),
     ("00000000", "00000001", "00000000"),
     ("00000001", "00000000", "00000001") 
  );

  signal mem_data_out_s: cnn_cell_t;
  signal mem_rd_en_s   : std_logic;
  signal mem_rd_addr_s : std_logic_vector(ADDRESS_LENGTH-1 downto 0);

  
  component CNNLayer is
    generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural;
            AddressLength: natural);
    port(
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
  end component;

begin
  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
  reset_tb <= '1' after T_RESET;

  test_CNN: CNNLayer
  generic map (InputWidth => INPUT_WIDTH, InputHeight => INPUT_HEIGHT, 
               FilterWidth => FILTER_WIDTH, FilterHeight => FILTER_HEIGHT,
               AddressLength => ADDRESS_LENGTH)
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
      mem_rd_addr_s  <= "ZZZZ";
    elsif(clk_tb='1' and clk_tb'event) then
      case(t) is
        -- testing read from memory (10 clock cycles are enough for 5x5 + 3x3)
        when 10 => mem_rd_en_s   <= '1'; mem_rd_addr_s <= "0000";
        when 11 => mem_rd_addr_s <= "0001";
        when 12 => mem_rd_addr_s <= "0010";
        when 13 => mem_rd_addr_s <= "0011";
        when 14 => mem_rd_addr_s <= "0100";
        when 15 => mem_rd_addr_s <= "0101";
        when 16 => mem_rd_addr_s <= "0110";
        when 17 => mem_rd_addr_s <= "0111";
        when 18 => mem_rd_addr_s <= "1000";
        when 19 => mem_rd_en_s   <= '0'; 
        when 30 => end_sim       <= '1';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;
