
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_system_tb is
--  Port ( );
end RAM_system_tb;

architecture arch of RAM_system_tb is
component RAM_system is
generic( WIDTH: natural := 8;
         ADDRW: natural := 9);
  Port ( clk : in std_logic;
         reset: in std_logic;
         rx_empty: in std_logic;
         tx_full: in std_logic;
         rx_data: in std_logic_vector((WIDTH-1) downto 0);
         tx_data: out std_logic_vector((WIDTH-1) downto 0);
         rx_rd: out std_logic;
         tx_wr: out std_logic);
end component;
signal clk, reset, rx_empty, tx_full, rx_rd, tx_wr: std_logic;
signal rx_data, tx_data: std_logic_vector(7 downto 0);
begin
tb: RAM_system port map( 
clk => clk,
reset => reset,
rx_data => rx_data,
rx_rd => rx_rd,
rx_empty => rx_empty,
tx_data => tx_data,
tx_wr => tx_wr,
tx_full => tx_full);

process
    begin 
        clk<='1';
        wait for 20ns;
        clk<='0';
        wait for 20ns;
end process;
-- Reset signal
process
    begin 
        reset<='1';
        wait for 200ns;
        reset<='0';
        wait;
end process;

process
    begin 
        rx_empty<='0';
        wait for 600ns;
        rx_empty<='1';
        wait for 200ns;
end process;

process
    begin 
        tx_full<='1';
        wait for 800ns;
        tx_full<='0';
        wait for 200ns;
end process;
-- Data input
process
    begin 
        rx_data<="10010111";
        wait for 20ns;
        rx_data<="00010101";
        wait for 20ns;
        rx_data<="11110101";
        wait for 20ns;
end process;
end arch;
