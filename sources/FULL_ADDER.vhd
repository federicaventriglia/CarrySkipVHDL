-- full_adder

library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER is
	port(
      A : in std_logic;
			B : in std_logic;
			C_in : in std_logic;
			--
			S : out std_logic;
			C_out : out std_logic;
			P: out std_logic
		);
end FULL_ADDER;

architecture structural of FULL_ADDER is
begin

	s <= a xor b xor c_in;
	c_out <= (a and b) or (c_in and (a xor b));
	p <= a xor b;

end structural;
