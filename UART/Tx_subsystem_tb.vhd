-------------------------------
-- Michael Campo
-- Transmitter Subsystem Testbench
--------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Tx_subsystem_tb is
-- Port();
end Tx_subsystem_tb;

architecture Behavioral of Tx_subsystem_tb is

component Tx_subsystem is 
generic(
    DBIT: integer := 8;
    SB_TICK: integer :=16
    );
port(
    clk, reset: in std_logic;
    tx_start: in std_logic;
    s_tick: in std_logic;
    din: in std_logic_vector(7 downto 0);
    tx_done_tick, tx: out std_logic
    );
end component;

signal clk, reset, tx_start, s_tick, tx_done_tick, tx: std_logic;
signal din: std_logic_vector(7 downto 0);
constant clk_period: time := 20ns; -- 50MHz

begin
tb: Tx_subsystem port map(clk=>clk,reset=>reset,tx_start=>tx_start,s_tick=>s_tick,din=>din,tx_done_tick=>tx_done_tick,tx=>tx);

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
-- give data value
process 
begin
    din <= "01010101";
    wait for 20ns;
end process;
-- transmit data
process
begin
    tx_start <= '0';
    wait for 200ns;
    tx_start <= '1';
    wait for 40ns;
    tx_start <= '0';
    wait;
end process;

end Behavioral;
