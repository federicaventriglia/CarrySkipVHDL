library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Blocco del Propagate
entity PG_BLOCK is
	Port(
			A: in std_logic;    -- Primo bit
			B: in std_logic;    -- Secondo bit
			--
			P: out std_logic;  -- propagate output
      G: out std_logic
	);
end PG_BLOCK;

architecture STRUCTURAL of PG_BLOCK is
    begin
      P <= A xor B;
      G <= A and B;
end STRUCTURAL;
