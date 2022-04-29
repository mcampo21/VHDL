----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 06:39:07 PM
-- Design Name: 
-- Module Name: baud_generator_tb - arch_tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity baud_generator_tb is
--  Port ( );
end baud_generator_tb;

architecture arch_tb of baud_generator_tb is

component baud_generator
generic(
    N: integer := 8;
    M: integer := 163
    );
port(
    clk, reset: in std_logic;
    max_tick: out std_logic;
    q: out std_logic_vector(N-1 downto 0)
    );
end component; 

signal clk, reset, max_tick: std_logic; 
signal q: std_logic_vector(7 downto 0);
constant clk_period: time := 10ns;

begin
tb: baud_generator port map(clk=>clk, reset=>reset, max_tick=>max_tick, q=>q);

process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

process
begin
    reset <= '1';
    wait for 100ns;
    reset <= '0';
    wait;
end process;

end arch_tb;
