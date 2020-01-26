library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb is
end cnnlayer_tb;

architecture bhv of cnnlayer_tb is
  constant T_CLK        : time    :=  8 ns;
  constant T_RESET	: time    := 10 ns;

  constant INPUT_WIDTH  : natural := 5;
  constant INPUT_HEIGHT : natural := 5;

  constant FILTER_WIDTH  : natural := 3;
  constant FILTER_HEIGHT : natural := 3;

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '1'; 
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

  signal Cout : cnn_matrix_t(0 to FILTER_WIDTH-1, 0 to FILTER_HEIGHT-1);
  
  component CNNLayer is
    generic(InputWidth:natural; InputHeight:natural; FilterWidth:natural; FilterHeight:natural);
    port(
      -- Clock and reset
      clk   : in std_logic;
      reset : in std_logic;
      Cin   : in cnn_matrix_t(0 to InputWidth-1,  0 to InputHeight-1);
      flt   : in cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1);

      Cout  : out cnn_matrix_t(0 to FilterWidth-1, 0 to FilterHeight-1)
    );
  end component;

begin
  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
  reset_tb <= '0' after T_RESET;

  test_CNN: CNNLayer
  generic map (InputWidth => INPUT_WIDTH, InputHeight => INPUT_HEIGHT, 
               FilterWidth => FILTER_WIDTH, FilterHeight => FILTER_HEIGHT)
  port map(
    clk   => clk_tb,      
    reset => reset_tb,
    Cin   => Cin,
    flt   => flt,
    Cout  => Cout
  );
		
  cnnlayer_process: process(clk_tb, reset_tb)
    variable t : integer := 0;
  begin
    if(reset_tb = '0') then
      t := 0;
    elsif(rising_edge(clk_tb)) then
      case(t) is
        when 100 => end_sim  <= '0';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;
