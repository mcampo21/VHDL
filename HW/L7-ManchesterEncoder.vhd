----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2022 09:09:12 PM
-- Design Name: 
-- Module Name: man_encoder - Behavioral
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

entity man_encoder is
    Port ( str_input : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           str_output : out STD_LOGIC);
end man_encoder;

architecture Behavioral of man_encoder is

type state_type is (idle, s0, s1, s2, s3, s4, s5, s6, s7);
signal state_reg, state_next: state_type;
signal str_buff, str_in: std_logic;
begin

-- look-ahead output buffer --
process(clk,reset)
begin
    if(reset = '1') then
        state_reg <= idle;
        str_buff <= '0';
    elsif(rising_edge(clk)) then
        state_reg <= state_next;
        str_buff <= str_in;
    end if;
end process;

-- next state logic --
process(state_reg)
begin
case state_reg is
    when idle =>
        state_next <= s0;
        str_in <= '0';
    when s0 =>
        state_next <= s1;
        str_in <= str_input(7);
    when s1 =>
        state_next <= s2;
        str_in <= str_input(6);
    when s2 =>
        state_next <= s3;
        str_in <= str_input(5);
    when s3 =>
        state_next <= s4;
        str_in <= str_input(4);
    when s4 =>
        state_next <= s5;
        str_in <= str_input(3);
    when s5 =>
        state_next <= s6;
        str_in <= str_input(2);
    when s6 =>
        state_next <= s7;
        str_in <= str_input(1);
    when s7 =>
        state_next <= idle;
        str_in <= str_input(0);
end case;
end process;

str_output <= not(str_in xor clk);

end Behavioral;
