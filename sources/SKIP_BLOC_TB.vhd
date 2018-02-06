library ieee;
use ieee.std_logic_1164.all;

entity SKIP_BLOC_TB is
end SKIP_BLOC_TB;

architecture behavior of SKIP_BLOC_TB is

  component SKIP_BLOC is
    generic(WIDTH : integer :=4);
  	Port(
  			A: in std_logic_vector(WIDTH-1 downto 0);    -- Input a della cella
  			B: in std_logic_vector(WIDTH-1 downto 0);    -- input b della cella
  			carry_in: in std_logic;
        --
  			carry_out: out std_logic;                    -- carry in uscita
  			S: out std_logic_vector(WIDTH-1 downto 0)  -- risultato della somma
  	);
  end component;

  --
  signal t_A,t_B : std_logic_vector(3 downto 0) := (others => '0');
  signal t_carry_in : std_logic := '0';
  --
  signal t_carry_out : std_logic := '0';
  signal t_S : std_logic_vector (3 downto 0) := (others => '0');

begin

  uut: SKIP_BLOC
  Port map (
      A => t_A,  -- Input a della cella
      B =>  t_B , -- input b della cell
      carry_in =>  t_carry_in,
      --
      carry_out => t_carry_out ,              -- carry in uscita
      S =>  t_S -- risultato della somma
  );

  stim_proc: process

       --variable to track errors
       variable errCnt : integer := 0;
    begin
       --TEST 1
       t_A <= "0000";
       t_B <= "0001";
       wait for 15 ns;
       assert(t_S = "0001")
       report "Error 1 RESULT not 0001" severity error;
       assert(t_carry_out = '0')
       report "Error 1 OVERFLOW 1" severity error;
       if(t_S /= "0001" or t_carry_out /= '0') then
          errCnt := errCnt + 1;
       end if;

   	 --TEST 2
       t_A <= "0001";
       t_B <= "0011";
       t_carry_in <= '0';
       wait for 15 ns;
       assert(t_S = "0100")
       report "Error 2 RESULT not 0100" severity error;
       assert(t_carry_out = '0')
       report "Error 2 OVERFLOW 1" severity error;
       if(t_S /= "0100" or t_carry_out /= '0') then
          errCnt := errCnt + 1;
       end if;

       --TEST 3
       t_A <= "1010";
       t_B <= "0101";
       t_carry_in <= '0';
       wait for 15 ns;
       assert(t_S = "1111")
       report "Error 3 RESULT not 1111" severity error;
       assert(t_carry_out = '0')
       report "Error 3 OVERFLOW 1" severity error;
       if(t_S /= "1111" or t_carry_out /= '0') then
       end if;

 	   --TEST 4
       t_A <= "0011";
       t_B <= "1000";
       t_carry_in <= '0';
       wait for 15 ns;
       assert(t_S = "1011")
       report "Error 4 RESULT not 1011" severity error;
       assert(t_carry_out = '0')
       report "Error 4 OVERFLOW 1" severity error;
       if(t_S /= "1011" or t_carry_out /= '0') then
          errCnt := errCnt + 1;
       end if;

       --TEST 5
         t_A <= "1111";
         t_B <= "1000";
         t_carry_in <= '1';
         wait for 15 ns;
         assert(t_S = "1000")
         report "Error 5 RESULT not 1011" severity error;
         assert(t_carry_out = '1')
         report "Error 5 OVERFLOW NOT 1" severity error;
         if(t_S /= "0111" or t_carry_out /= '0') then
            errCnt := errCnt + 1;
         end if;

       --TEST 6
         t_A <= "1111";
         t_B <= "1110";
         t_carry_in <= '0';
         wait for 15 ns;
         assert(t_S = "1101")
         report "Error 6 RESULT not 1011" severity error;
         assert(t_carry_out = '1')
         report "Error 6 OVERFLOW NOT 1" severity error;
         if(t_S /= "0111" or t_carry_out /= '0') then
            errCnt := errCnt + 1;
         end if;

 	  -------------- SUMMARY -------------
       if(errCnt = 0) then
          assert false report "Good!"  severity note;
       else
          assert true report "Error!"  severity error;
       end if;
 	  wait;

    end process;

end behavior;
