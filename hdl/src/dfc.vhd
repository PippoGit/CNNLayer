library IEEE;
use IEEE.std_logic_1164.all;

entity DFC is
  port (
    d_in   : in std_logic;
    clk    : in std_logic;
    reset  : in std_logic;
    q      : out std_logic
  );
end DFC;

architecture rtl of DFC is
begin
  dtc_p:process(reset, clk)
  begin
    if reset = '0' then
      q <= '0';
    elsif(rising_edge(clk)) then
      q <= d_in;
    end if;
  end process dtc_p;
end rtl;