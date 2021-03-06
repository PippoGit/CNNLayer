library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_STD.all;

library work;
use work.cnn_types.all;

entity CNNRegister is
  generic (CNNWidth:natural; CNNHeight:natural);
  port (
    -- Clock and reset
    clk   : in std_logic;
    reset : in std_logic;

    -- In/Out
    d_in  : in  cnn_matrix_t(0 to CNNHeight-1, 0 to CNNWidth-1);
    d_out : out cnn_matrix_t(0 to CNNHeight-1, 0 to CNNWidth-1);
    stbl  : out std_logic
  );
end CNNRegister;

architecture CNNRegister_Arch of CNNRegister is
begin
  process(clk, reset)
  begin
    if reset = '0' then
       d_out <= (others => (others => "00000000")); -- reset the register
       stbl  <= '0';
    elsif (clk='1' and clk'event) then
       d_out <= d_in;
       stbl  <= '1'; 
    end if;
  end process;
end CNNRegister_Arch;