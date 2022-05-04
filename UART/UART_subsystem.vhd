

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_subsystem is
  generic( DBIT : natural := 8);
  Port ( clk : in std_logic;
         reset : in std_logic;
         rx : in std_logic;
         tx_start : in std_logic;
         tx_in : in std_logic_vector(DBIT-1 downto 0);
         rx_out : out std_logic_vector(DBIT-1 downto 0);
         tx_done : out std_logic;
         rx_done : out std_logic;
         tx : out std_logic);
end UART_subsystem;

architecture arch of UART_subsystem is

component baud_generator is
port(
    clk, reset: in std_logic;
    s_tick: out std_logic
    );
end component;

component Rx_subsystem is
generic(
    DBIT: integer := 8; -- # of data bits
    SB_TICK: integer := 16 -- # of ticks for stop bit
    );
port(
    clk, reset: in std_logic;
    rx: in std_logic;
    s_tick: in std_logic;
    rx_done_tick: out std_logic;
    dout: out std_logic_vector(7 downto 0)
    );
end component;

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

signal s_tick_wire : std_logic;
begin

baud_inst: baud_generator port map(
clk=>clk, 
reset=>reset, 
s_tick=>s_tick_wire);

rx_inst: Rx_subsystem port map(
clk=>clk, 
reset=>reset, 
rx=>rx, 
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
tx=>tx);


end arch;