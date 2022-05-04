----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2022 03:01:21 PM
-- Design Name: 
-- Module Name: RAM_system - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity BRAM_512x8 is
generic( w: natural := 8;  -- # of bits per RAM word
         r: natural := 9);  -- 2^r # of words in RAM
port(
    clk, w_en, r_en : in std_logic;
    addr : in std_logic_vector(r-1 downto 0);
    d_in : in std_logic_vector(w-1 downto 0);
    d_out : out std_logic_vector(w-1 downto 0)
    );
end BRAM_512x8;

architecture Behavioral of BRAM_512x8 is
type ram_type is array ((2**r)-1 downto 0) of std_logic_vector(w-1 downto 0);
signal RAM : ram_type := (others=>(others=>'0'));

begin
process(clk)
begin
    if (rising_edge(clk)) then
     --  if (r_en = '1') then
      --      d_out <= RAM(to_integer(unsigned(addr)));
            if (w_en = '1') then
                RAM(to_integer(unsigned(addr))) <= d_in;
            end if;
       -- end if;
       d_out <= RAM(to_integer(unsigned(addr)));
    end if;
end process;

end Behavioral;
