# Carry Skip Adder VHDL


A Carry Skip adder is an optimized version of the Carry Select adder that, as the last one, implements the parallel addition of N bit operands by dividing them in P blocks of M bits each. The difference between a Carry Skip and a Carry Select can be seen in terms of area. 

- In this project we're going to showcase the logic behind this parallel adder, using the following tools:
  - VHDL 
  - Xilinx ISE WebPack 
  - FPGA Board, Digilent Nexys2 

# Schematics!
The general schematic of the Carry Skip Adder can be found online, the one we created for this project can be summarized in the following image
![picture](https://preview.ibb.co/iGPwrH/Carry_Skip.png)

We can outline the following elements:
  - Ripple Carry Adder (Generic N bit)
  - 2to1 Multiplexer
 Those elements are combined in the so called Skip Block which works in order to calculate the carries before hand, so that the machine wouldn't have to wait for all the previous ones to be calculated if the carry isn't propagated. The basic functionality of the skip block is the following:

![picture](https://preview.ibb.co/m5OpBH/Skip_Block.png)

### Syntesys 

We syntetized the project on an FPGA board, specifically a Nexys2 by Digilent. The RTL Schematic is the following:

![picture](https://image.ibb.co/nH3Lkc/schema_rtl.png)

### Area & Timing
In terms of area and delays, using the syntesys tool by Xilins, the results we got (specifically for out Nexys2 board) are the following:
![picture](https://image.ibb.co/nH3Lkc/schema_rtl.png)

### Simulation
We've tested the circuit using ISE and stimulating it with different inputs such as 

```
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

```
Resulting in the following waveforms...
![picture](https://preview.ibb.co/dwAY5c/testbench.png)
