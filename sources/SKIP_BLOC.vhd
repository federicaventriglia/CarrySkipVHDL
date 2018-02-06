library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Blocco del Carry Select
entity SKIP_BLOC is
	generic(WIDTH : integer :=4);
	Port(
			A: in std_logic_vector(WIDTH-1 downto 0);    -- Input a della cella
			B: in std_logic_vector(WIDTH-1 downto 0);    -- input b della cella
			carry_in: in std_logic;
      --
			carry_out: out std_logic;                    -- carry in uscita
			S: out std_logic_vector(WIDTH-1 downto 0)  -- risultato della somma
	);
end SKIP_BLOC;

architecture Structural of SKIP_BLOC is

signal c_out_rca : std_logic := '0';
signal BP : std_logic := '0'; -- block propagate BP = Pi and Pi-1 and ...

Component  RCADDER_P is
      generic (
        WIDTH : natural := 4
        );
      port (
        X  : in std_logic_vector(WIDTH-1 downto 0);
        Y  : in std_logic_vector(WIDTH-1 downto 0);
        C_in : in std_logic;
        --
        RESULT   : out std_logic_vector(WIDTH-1 downto 0);
        OVERFLOW  : out std_logic;
        BP        : out std_logic
        );
end Component;

component MUX2_1 is port(
        SEL: in STD_LOGIC;
        A:  in STD_LOGIC;
        B:  in STD_LOGIC;
        X_OUT: out STD_LOGIC
);
end component;
begin

-- primo rca
RCADDER1: RCADDER_P
	Generic map(WIDTH => WIDTH)
		Port map(
			X => A,
			Y => B,
			C_in => carry_in, -- riporto '1'
      --
      OVERFLOW => c_out_rca,
			RESULT => S,
      BP => BP
		);
-- secondo rca
MULTIPLEXER21: MUX2_1
		Port map(
            SEL => BP,
            A => carry_in ,
            B => c_out_rca ,
            X_OUT => carry_out --
		);

end Structural;
