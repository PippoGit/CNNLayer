library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.cnn_types.all;

entity cnnlayer_tb_{id} is
end cnnlayer_tb_{id};

  architecture bhv of cnnlayer_tb_{id} is
  constant T_CLK    : time := {clock_period};
  constant T_RESET  : time := {reset_time};

  constant INPUT_WIDTH    : natural := {input_width};
  constant INPUT_HEIGHT   : natural := {input_height};

  constant FILTER_WIDTH   : natural := {filter_width};
  constant FILTER_HEIGHT  : natural := {filter_height};

  constant ADDRESS_LENGTH : natural :=  {address_length};
  constant CNN_OUTPUT_BIT : natural :=  {cnn_output_bit};

  -- Testbench signals
  signal clk_tb         : std_logic := '0';
  signal reset_tb       : std_logic := '0'; 
  signal end_sim        : std_logic := '1';

  signal Cin : cnn_matrix_t(0 to INPUT_HEIGHT-1, 0 to INPUT_WIDTH-1) := {cin_matrix};
  signal flt : cnn_matrix_t(0 to FILTER_HEIGHT-1, 0 to FILTER_WIDTH-1) := {flt_matrix};

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
        when {start_simulation_time} => mem_rd_en_s   <= '1'; mem_rd_addr_s <= (others => '0');
{simulation_cases}
        when {end_simulation_time} => end_sim <= '1'; mem_rd_en_s <= '0';
        when others => null;
      end case;
      t := t + 1;
    end if;
  end process;
end bhv;

-- INPUT MAT:
{cin_matrix_numeric}

-- FILTER MAT:
{flt_matrix_numeric}

-- EXPECTED RESULT DEC:
{res_dec_matrix_numeric}

-- EXPECTED RESULT HEX:
{res_matrix_numeric}
