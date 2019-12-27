library IEEE;
use IEEE.std_logic_1164.all;

library work;

entity DFlipFlop is
  generic(Nbit : integer);
  port (
    d_in     : in std_logic_vector(Nbit-1 downto 0);
    clk      : in std_logic;
    reset    : in std_logic;
    q        : out std_logic_vector(Nbit-1 downto 0)
  );
end DFlipFlop;

architecture rtl of DFlipFlop is
  component DFC
  port (
    d_in   : in  std_logic;
    clk    : in  std_logic;
    reset  : in  std_logic;
    q      : out std_logic
  );
  end component DFC;

begin
  GEN: for i in 0 to Nbit-1 generate
    D: DFC port map(
      d_in => d_in(i),
      clk => clk,
      reset => reset,
      q => q(i)
    );
  end generate GEN;
end;