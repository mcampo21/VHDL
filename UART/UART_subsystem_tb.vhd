

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_subsystem_tb is
--  Port ( );
end UART_subsystem_tb;

architecture Behavioral of UART_subsystem_tb is

component UART_subsystem is
generic(
DBIT : integer := 8
);
Port (
clk : in std_logic;
         reset : in std_logic;
         rx : in std_logic;
         tx_start : in std_logic;
         tx_in : in std_logic_vector(DBIT-1 downto 0);
         rx_out : out std_logic_vector(DBIT-1 downto 0);
         tx_done : out std_logic;
         rx_done : out std_logic;
         tx : out std_logic);
end component;

signal clk, reset, rx, tx_start, rx_done, tx_done, tx : std_logic;
signal tx_in, rx_out : std_logic_vector(7 downto 0);
constant clk_period : time:= 20ns;

begin
tb: UART_subsystem port map ( 
         clk => clk,
         reset => reset,
         rx => rx,
         tx_start => tx_start,
         tx_in => tx_in,
         rx_out => rx_out,
         tx_done => tx_done,
         rx_done => rx_done,
         tx => tx);
         
-- Clock operation        
process
    begin
        clk<='1';
        wait for clk_period;
        clk <='0';
        wait for clk_period;
end process;
-- Reset operation
process
    begin 
        reset <='1';
        wait for clk_period;
        reset <='0';
        wait for 1000ms;
end process;
-- send data signal to Rx
process 
begin
    rx <='0';
    wait for clk_period;
    rx <='1';
    wait for (clk_period*4);
end process;
-- give data value
process 
begin
    tx_in <= "01010101";
    wait for 20ns;
end process;
-- transmit data
process
begin
    tx_start <= '0';
    wait for 200ns;
    tx_start <= '1';
    wait for 200ns;
    tx_start <= '0';
    wait;
end process;

end Behavioral;
