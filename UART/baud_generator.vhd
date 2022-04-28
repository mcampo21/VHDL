----------------------------------------------------------------------------------
-- Michael Campo
-- Baud generator
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baud_generator is
generic(
    N: integer := 8; -- number of bits for count register, 2^8 = 256
    M: integer := 163 -- counter value
    );
port(
    clk, reset: in std_logic;
    max_tick: out std_logic;
    q: out std_logic_vector(N-1 downto 0)
    );
end baud_generator;

architecture arch of baud_generator is
    signal r_reg: unsigned(N-1 downto 0);
    signal r_next: unsigned(N-1 downto 0);
    
begin
process(clk, reset)
    begin
    if(reset = '1') then
        r_reg <= (others=>'0');
    elsif(rising_edge(clk)) then
        r_reg <= r_next;
    end if;
end process;

-- next state logic
r_next <= (others=>'0') when r_reg=(M-1) else r_reg + 1;

-- output logic
q <= std_logic_vector(r_reg);
max_tick <= '1' when r_reg = (M-1) else '0';

end arch;
