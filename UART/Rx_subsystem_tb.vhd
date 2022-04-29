-------------------------------
-- Michael Campo
-- Receiving Subsystem Testbench
--------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Rx_subsystem_tb is
-- Port();
    -- 9600 * 16 = 153,600
    -- 50 MHz / 153,600 = mod 326 counter
end Rx_subsystem_tb;

architecture rx_tb of Rx_subsystem_tb is

component Rx_subsystem
port(
    clk, reset: in std_logic;
    rx: in std_logic;
    s_tick: in std_logic;
    rx_done_tick: out std_logic;
    dout: out std_logic_vector(7 downto 0)
    );
end component;

signal clk, reset, rx, s_tick, rx_done_tick: std_logic;
signal dout: std_logic_vector(7 downto 0);
constant clk_period: time := 20ns; -- 50MHz

begin
tb: Rx_subsystem port map(clk=>clk, reset=>reset, rx=>rx, s_tick=>s_tick, rx_done_tick=>rx_done_tick, dout=>dout);
-- Clock operation
process
begin
    clk <= '1';
    wait for clk_period/4;
    clk <= '0';
    wait for clk_period/4;
end process;
-- clear reset
process
begin
    reset <= '1';
    wait for 100ns;
    reset <='0';
    wait;
end process;
-- simulate baud rate tick
process
begin
    s_tick <= '1';
    wait for clk_period;
    s_tick <= '0';
    wait for clk_period;
end process;
-- rx data
process 
begin
    rx <='0';
    wait for clk_period;
    rx <='1';
    wait for (clk_period*4);
end process;

end rx_tb;
