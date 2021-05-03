library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;

entity tb_IRAM is
end entity;

architecture test of tb_IRAM is

component IRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    I_SIZE : integer := NBIT);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(NBIT-1 downto 0);
    Dout : out std_logic_vector(NBIT-1 downto 0)
    );

end component;

  constant tb_period : time := 10ns;

   signal Rst  : std_logic;
   signal Addr : std_logic_vector(NBIT-1 downto 0);
   signal Dout : std_logic_vector(NBIT-1 downto 0);
   

begin

  DUT : IRAM
    generic map (RAM_DEPTH => MEM_size,
                 I_SIZE => NBIT)
    port map(
                 Rst => Rst,
                 Addr => Addr,
                 Dout => Dout
                );

  stimuli : process

                procedure apply_stimuli (
                        constant Rst_val : in std_logic;
                        constant Addr_val : in integer;
                        
                        signal Rst : out std_logic;
                        signal Addr : out std_logic_vector(NBIT-1 downto 0)
                        ) is
                begin
                      Rst <= Rst_val;
                      Addr <= std_logic_vector(to_unsigned(Addr_val, NBIT));
                       
                        wait for tb_period;
                       
                end apply_stimuli;
  begin

   --apply_stimuli(input values, signals);
   
   apply_stimuli('1', 0, Rst, Addr);

    for i in 0 to 2 loop
      apply_stimuli('1', 3+4*i, Rst, Addr);
    end loop;

  end process;

end test;
