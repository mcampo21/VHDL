----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 10:16:36 AM
-- Design Name: 
-- Module Name: man_encoder_tb - Behavioral
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

entity man_encoder_tb is
--  Port ( );
end man_encoder_tb;

architecture Behavioral of man_encoder_tb is
component man_encoder
Port( str_input : in STD_LOGIC_VECTOR (7 downto 0);
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      str_output : out STD_LOGIC);
end component;

signal str_input: std_logic_vector(7 downto 0);
signal clk, reset, str_output: std_logic;
constant clk_period: time := 10ns;

begin
tb: man_encoder port map(str_input=>str_input, clk=>clk, reset=>reset, str_output=>str_output);
str_input <= "10110010";

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
    wait for 80ns;
end process;

end Behavioral;
