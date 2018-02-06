--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:31:13 11/27/2017
-- Design Name:   
-- Module Name:   C:/Users/IEUser/Desktop/EserciziISE/CARRYSKIP_ADDER_SUB/CARRY_SKIP_ADDER_SUB_TB.vhd
-- Project Name:  CARRYSKIP_ADDER_SUB
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CARRYSKIP_ADDER_SUB
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 entity CARRYSKIP_ADDER_SUB_TB is
end CARRYSKIP_ADDER_SUB_TB;

architecture behavior of CARRYSKIP_ADDER_SUB_TB is

  component CARRYSKIP_ADDER_SUB is
    generic (
    			N: integer := 4; 	-- Dimensione degli ingressi in bit
    			M: integer := 2 	--  Numero di bit per ogni blocco
     );
    port(
      A: in std_logic_vector (N-1 downto 0);
      B: in std_logic_vector (N-1 downto 0);
      C_in: in std_logic;
      SUB: in std_logic;
      --
      SUM: out std_logic_vector (N-1 downto 0);
      overflow: out std_logic
    );
  end component CARRYSKIP_ADDER_SUB;

  -- constants
  constant t_M : natural := 2;
  constant t_N : natural := 4;
  --
  signal t_A,t_B : std_logic_vector(t_N-1 downto 0) := (others => '0');
  signal t_C_in,t_SUB : std_logic := '0';
  --
  signal t_overflow : std_logic := '0';
  signal t_S : std_logic_vector (t_N-1 downto 0) := (others => '0');

begin

  uut: CARRYSKIP_ADDER_SUB generic map(
      N => t_N,
      M => t_M
  )   Port map (
      A => t_A,  -- Input a della cella
      B =>  t_B , -- input b della cell
      C_in =>  t_C_in,
      SUB => t_SUB,
      --
      overflow => t_overflow ,              -- carry in uscita
      SUM =>  t_S -- risultato della somma
  );

  stim_proc: process

       --variable to track errors
       variable errCnt : integer := 0;
    begin
      --TEST 1a
          t_A <= "0000";
          t_B <= "0001";
          wait for 15 ns;
          assert(t_S = "0001")
          report "Error 1a: SUM not 0001" severity error;
          assert(t_overflow = '0')
          report "Error OVERFLOW 1" severity error;
          if(t_S /= "0001" or t_overflow /= '0') then
             errCnt := errCnt + 1;
          end if;

          -- TEST 1b
          t_A <= "1111";
          t_B <= "1110";
          t_SUB <= '0';
          wait for 15 ns;
          assert(t_S = "1101")
          report "Error 1b: sub not 0001" severity error;
          assert(t_overflow = '1')
          report "Error 1b: OVERFLOW not 0" severity error;
          if(t_S /= "1101" or t_overflow /= '1') then
             errCnt := errCnt + 1;
          end if;

        --TEST 2
          t_A <= "0001";
          t_B <= "0011";
          wait for 15 ns;
          assert(t_S = "0100")
          report "Error SUM not 0100" severity error;
          assert(t_overflow = '0')
          report "Error OVERFLOW 1" severity error;
          if(t_S /= "0100" or t_overflow /= '0') then
             errCnt := errCnt + 1;
          end if;

          --TEST 3
          t_A <= "0101";
          t_B <= "1111";
          t_SUB <= '0';
          wait for 15 ns;
          assert(t_S = "0100")
          report "Error 1.3 sub not 0001" severity error;
          assert(t_overflow = '1')
          report "Error 1.3 OVERFLOW not 1" severity error;
          if(t_S /= "0100" or t_overflow /= '1') then
             errCnt := errCnt + 1;
          end if;

        --TEST 4
          t_A <= "0011";
          t_B <= "1000";
          t_C_in <= '1';
          wait for 15 ns;
          assert(t_S = "1100")
          report "Error SUM not 1011" severity error;
          assert(t_overflow = '0')
          report "Error OVERFLOW 1" severity error;
          if(t_S /= "1100" or t_overflow /= '0') then
             errCnt := errCnt + 1;
          end if;

        --TEST 5
          t_A <= "1111";
          t_B <= "1000";
          t_C_in <= '1';
          wait for 15 ns;
          assert(t_S = "1000")
          report "Error SUM not 1011" severity error;
          assert(t_overflow = '1')
          report "Error OVERFLOW NOT 1" severity error;
          if(t_S /= "1000" or t_overflow /= '0') then
             errCnt := errCnt + 1;
          end if;


          -- subtractor
        --TEST 1.1
          t_A <= "1111";
          t_B <= "1110";
          t_C_in <= '0';
          t_SUB <= '1';
          wait for 15 ns;
          assert(t_S = "0001")
          report "Error 1.1 sub not 0001" severity error;
          assert(t_overflow = '1')
          report "Error 1.1 OVERFLOW not 1" severity error;
          if(t_S /= "0001" or t_overflow /= '1') then
             errCnt := errCnt + 1;
          end if;

        --TEST 1.2
          t_A <= "0000";
          t_B <= "0001";
          t_SUB <= '1';
          wait for 15 ns;
          assert(t_S = "1111")
          report "Error 1.2 sub not 0001" severity error;
          assert(t_overflow = '0')
          report "Error 1.2 OVERFLOW not 0" severity error;
          if(t_S /= "1111" or t_overflow /= '0') then
             errCnt := errCnt + 1;
          end if;

        --TEST 1.3
          t_A <= "0111";
          t_B <= "0010";
          t_SUB <= '1';
          wait for 15 ns;
          assert(t_S = "0101")
          report "Error 1.3 sub not 0001" severity error;
          assert(t_overflow = '1')
          report "Error 1.3 OVERFLOW not 1" severity error;
          if(t_S /= "0101" or t_overflow /= '1') then
             errCnt := errCnt + 1;
          end if;

        --TEST 1.3
          t_A <= "1011";
          t_B <= "1110";
          t_SUB <= '1';
          wait for 15 ns;
          assert(t_S = "1101")
          report "Error 1.3 sub not 0001" severity error;
          assert(t_overflow = '0')
          report "Error 1.3 OVERFLOW not 1" severity error;
          if(t_S /= "1101" or t_overflow /= '0') then
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