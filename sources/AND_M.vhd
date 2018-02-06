library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND_M IS
    generic (M: natural := 8); --array size
    port (
        inp: in std_logic_vector(M-1 downto 0);
        outp: out std_logic);
end entity;

architecture DATAFLOW of AND_M is
    signal temp: std_logic_vector(M-1 downto 0);
begin
    temp(0) <= inp(0);
    gen: for i in 1 to M-1 generate
        temp(i) <= temp(i-1) and inp(i);
    end generate;
    outp <= temp(M-1);
end architecture;
