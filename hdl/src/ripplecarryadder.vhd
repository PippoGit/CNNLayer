library IEEE;
use IEEE.std_logic_1164.all;

library work;

entity RippleCarryAdder is
  generic( Nbit : integer);
  port (
    a_rca    : in  std_logic_vector(Nbit-1 downto 0);
    b_rca    : in  std_logic_vector(Nbit-1 downto 0);
    cin_rca  : in  std_logic;
    cout_rca : out std_logic;
    f_rca    : out std_logic_vector(Nbit-1 downto 0)
  );
end RippleCarryAdder;

  architecture rtl of RippleCarryAdder is
    component FullAdder
      port (
        a    : in std_logic;
        b    : in std_logic;
        cin  : in std_logic;
        s    : out std_logic;
        cout : out std_logic
      );
    end component FullAdder;

    signal cout_s : std_logic_vector(Nbit-1 downto 0);

begin
  GEN: for i in 0 to Nbit-1 generate
    FIRST: if i = 0 generate
      FF1 : FullAdder port map(a_rca(0), b_rca(0), cin_rca, f_rca(0), cout_s(0));
    end generate FIRST;

    INTERNAL: if i > 0 and i < Nbit-1 generate
      FFI: FullAdder port map(a_rca(i), b_rca(i), cout_s(i-1), f_rca(i), cout_s(i));
    end generate INTERNAL;

    LAST: if i = Nbit-1 generate
      FFN: FullAdder port map(a_rca(i), b_rca(i), cout_s(i-1), f_rca(i), cout_rca);
    end generate LAST;

  end generate GEN;
end rtl;
