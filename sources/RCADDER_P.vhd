library ieee;
use ieee.std_logic_1164.all;

entity RCADDER_P is
  generic (
    WIDTH : natural := 2
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
end RCADDER_P;


architecture RTL of RCADDER_P is

  component FULL_ADDER is
    port (
        A : in std_logic;
        B : in std_logic;
        C_in : in std_logic;
        S : out std_logic;
        C_out : out std_logic;
        P: out std_logic
      );
  end component;

  component AND_M IS
      generic (M: natural := 8); --array size
      port (
          inp: in std_logic_vector(M-1 downto 0);
          outp: out std_logic);
  end component;

-- SEGNALI D'APPOGGIO
--  CARRY è un bus contenente i riporti intermedi generati dai FULL_ADDER
-- SUM è un registro contenente i risultati delle somme
  signal CARRY : std_logic_vector(WIDTH downto 0);
--  signal SUM   : std_logic_vector(WIDTH-1 downto 0);
  signal P     : std_logic_vector(WIDTH-1 downto 0);
  signal BP_value : std_logic := '0'; -- d'appoggio per il calcolo di BP

begin

  CARRY(0) <= C_in;                    -- no carry input on first full adder
  OVERFLOW <= CARRY(WIDTH);

  FULL_ADDERS : for i in 0 to WIDTH-1 generate
    i_FULL_ADDER_INST : FULL_ADDER
      port map (
        A  => X(i),
        B  => Y(i),
        C_in => CARRY(i),

        S  => RESULT(i),
        C_out => CARRY(i+1),
        P => P(i)
        );
  end generate FULL_ADDERS;

  CALCOLO_BP: AND_M generic map(WIDTH) port map (
    inp => P,
    outp => BP
  );

end RTL;
