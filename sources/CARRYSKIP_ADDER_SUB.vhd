library ieee;
use ieee.STD_LOGIC_1164.all;

entity CARRYSKIP_ADDER_SUB is
  generic (
  			N: integer :=8; 	-- Dimensione degli ingressi in bit
  			M: integer := 4 	--  Numero di bit per ogni blocco
   );
  port(
        A: in std_logic_vector (N-1 downto 0);
        B: in std_logic_vector (N-1 downto 0);
        SUB: in std_logic; -- se SUB = 1 allora faccio la sottrazione -> complemento a 2 di B
        C_in: in std_logic;
        --
        SUM: out std_logic_vector (N-1 downto 0);
        overflow: out std_logic
  );
end CARRYSKIP_ADDER_SUB;

architecture DATAFLOW of CARRYSKIP_ADDER_SUB is
  -- componenti

  -- blocco composto da un ripple carry adder ed un MULTIPLEXER21
  component SKIP_BLOC is
    generic(WIDTH : integer := 2);
    Port(
        A: in std_logic_vector(WIDTH-1 downto 0);    -- Input a della cella
        B: in std_logic_vector(WIDTH-1 downto 0);    -- input b della cella
        carry_in: in std_logic;
        --
        carry_out: out std_logic;                    -- carry in uscita
        S: out std_logic_vector(WIDTH-1 downto 0)  -- risultato della somma
    );
  end component;

  Component  RCADDER_P is
        generic (
          WIDTH : natural := M
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

  -- creiamo 'p' ripple carry adder a 'm' bit
  -- in particolare p viene scelto come p =
  constant P : integer := N/M;

  -- segnali d'appoggio
  signal t_B, output_finale : std_logic_vector(N-1 downto 0); -- uscita di tutto il Carry Select
  signal carry_out_blocchi : std_logic_vector(P-1 downto 0); -- vettore per gestire i riporti

  begin

    -- sottrazione
    with SUB select
    t_B <= not B when '1' , B when others;

    with SUB select
    carry_out_blocchi(0) <= not C_in when '1' , C_in when others;
    -- iniziamo creando il primo blocco che è diverso ed è solo un RCA
    -- avente M bit di ingresso per X e Y


  --  carry_out_blocchi(0) <= C_in;
      -- generiamo i restanti P blocchi SKIP_BLOC
     SKIP_BLOCKS: for i in 1 to P-1 generate
      BLOCK1: SKIP_BLOC generic map (WIDTH => M)
        port map (
          A => A ((i)*M-1 downto (i-1)*M), -- per dividere i vettori a N bit in P-1 vettori a M bit
          B => t_B ((i)*M-1 downto (i-1)*M),
          carry_in => carry_out_blocchi(i-1),
          --
          carry_out => carry_out_blocchi(i),
          S => output_finale (M*(i)-1 downto M*(i-1))
        );
      end generate SKIP_BLOCKS;

      LAST_RCA:  RCADDER_P
      	Generic map(WIDTH => M)
      		Port map(
      			X => A (N-1 downto N-M),
      			Y => t_B (N-1 downto N-M),
      			C_in => carry_out_blocchi(P-1),
            --
            OVERFLOW => overflow,
      			RESULT => output_finale (N-1 downto N-M),
					BP => open -- non necessario per l'implementazione finale
      		);

      SUM <= output_finale;

end DATAFLOW;
