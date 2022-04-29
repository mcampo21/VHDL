----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2022 01:36:42 PM
-- Design Name: 
-- Module Name: Tx_subsystem - Behavioral
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

entity Tx_subsystem is
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
end Tx_subsystem;

architecture Behavioral of Tx_subsystem is
type state_type is (idle, start, data, stop);
signal state_reg, state_next: state_type;
signal s_reg, s_next: unsigned(3 downto 0);
signal n_reg, n_next: unsigned(2 downto 0);
signal b_reg, b_next: std_logic_vector(7 downto 0);
signal tx_reg, tx_next: std_logic;

begin
-- FSM state and data regs.
process(clk,reset)
begin
    if(reset='1') then
        state_reg <= idle;
        s_reg <= (others=>'0');
        n_reg <= (others=>'0');
        b_reg <= (others=>'0');
        tx_reg <= '1';
    elsif(rising_edge(clk)) then
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
        tx_reg <= tx_next;
    end if;
end process;
--next state logic
process(state_reg,s_reg,n_reg,b_reg,tx_reg,s_tick,tx_start,din)
begin
    state_next <= state_reg;
    s_next <= s_reg;
    n_next <= n_reg;
    b_next <= b_reg;
    tx_next <= tx_reg;
    tx_done_tick <= '0';
    -- functioning of each state   
    case state_reg is 
    -- idle state
    when idle =>        
        tx_next <= '1';
        if(tx_start='1') then
            state_next <= start;
            s_next <= (others=>'0');
            b_next <= din;
        end if;
    -- start state    
    when start =>
        tx_next <= '0';
        if (s_tick='1') then
            if (s_reg=15) then
                state_next <= data;
                s_next <= (others=>'0');
                n_next <= (others=>'0');
            else
                s_next <= s_reg + 1;
            end if;
        end if;
    -- data state
    when data =>
        tx_next <= b_reg(0);
        if (s_tick='1') then
            if (s_reg=15) then
                s_next <= (others=>'0');
                b_next <= '0' & b_reg(7 downto 1);
                if (n_reg=DBIT-1) then
                    state_next <= stop;
                else
                    n_next <= n_reg + 1;
                end if;
            else
            s_next <= s_reg + 1;
            end if;
       end if;
    -- stop state
    when stop =>
        tx_next <='1';
        if (s_tick='1') then
            if (s_reg=SB_TICK-1) then
                state_next <= idle;
                tx_done_tick <= '1';
            else
                s_next <= s_reg + 1;
            end if;
        end if;
    end case;
end process;
-- output data
tx <= tx_reg;
        
end Behavioral;
