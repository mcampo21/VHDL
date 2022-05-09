

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_system_tb is
    generic( WIDTH: natural := 8);
end UART_system_tb;

architecture arch of UART_system_tb is

component UART_system is
  Port (clk: in std_logic; 
        reset : in std_logic; 
        rx : in std_logic;
        tx : out std_logic);     
end component;

component baud_generator is
port(
    clk, reset: in std_logic;
    s_tick: out std_logic
    );
end component;

component Rx_subsystem is
port(
    clk, reset: in std_logic;
    rx: in std_logic;
    s_tick: in std_logic;
    rx_done_tick: out std_logic;
    dout: out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

component Tx_subsystem is
port(
    clk, reset: in std_logic;
    tx_start: in std_logic;
    s_tick: in std_logic;
    din: in std_logic_vector(WIDTH-1 downto 0);
    tx_done_tick, tx: out std_logic
    );
end component;

signal clk, reset, rx, tx_start, rx_done, tx_done, tx, s_tick_wire : std_logic;
signal tx_in, rx_out : std_logic_vector(7 downto 0) := (others=>'0');
constant clk_period : time:= 20ns;

begin

uart : UART_system port map(
clk=>clk, 
reset=>reset,
rx=>rx,
tx=>tx); 

baud_inst: baud_generator port map(
clk=>clk, 
reset=>reset, 
s_tick=>s_tick_wire);

rx_inst: Rx_subsystem port map(
clk=>clk, 
reset=>reset, 
rx=>tx, 
s_tick=>s_tick_wire, 
rx_done_tick=>rx_done, 
dout=>rx_out);

tx_inst: Tx_subsystem port map(
clk=>clk,
reset=>reset,
tx_start=>tx_start,
s_tick=>s_tick_wire,
din=>tx_in,
tx_done_tick=>tx_done,
tx=>rx);

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
        wait for 200ns;
        reset <='0';
        wait for 1000ns;
end process;

process
    begin
        wait for 200ns;
        -- Send A in ascii
        tx_in <= std_logic_vector(to_unsigned(65, WIDTH));
        tx_start <= '1';
        wait for clk_period;
        tx_start <= '0';
        
        
        -- Send B in ascii
        wait until (tx_done = '1');
        wait until (s_tick_wire = '1');
        tx_in <= std_logic_vector(to_unsigned(66, WIDTH));
        tx_start <= '1';
        wait for clk_period;
        tx_start <= '0';
        
        
        -- Send y in ascii
        wait until (tx_done = '1');
        wait until (s_tick_wire = '1');
        tx_in <= std_logic_vector(to_unsigned(121, WIDTH));
        tx_start <= '1';
        wait for clk_period;
        tx_start <= '0';
        
        
        -- Send 9 in ascii
        wait until (tx_done = '1');
        wait until (s_tick_wire = '1');
        tx_in <= std_logic_vector(to_unsigned(57, WIDTH));
        tx_start <= '1';
        wait for clk_period;
        tx_start <= '0';

        wait;
end process;
end arch;
