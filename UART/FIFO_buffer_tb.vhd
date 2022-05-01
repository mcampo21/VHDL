

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_buffer_tb is
--  Port ( );
end FIFO_buffer_tb;

architecture Behavioral of FIFO_buffer_tb is
constant bits : integer := 8;
constant rows : integer := 8;

component FIFO_buffer is
generic( WIDTH : natural := 8; -- 8 bits long
         ADDR: natural := 16);  -- # of rows
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         wr_en : in STD_LOGIC;
         rd_en : in STD_LOGIC;
         wr_data : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
         rd_data : out STD_LOGIC_VECTOR (WIDTH-1 downto 0);
         empty_flag : out STD_LOGIC;
         full_flag : out STD_LOGIC
         );
end component;
-- Signal list
signal clk, reset, wr_en, rd_en, empty_flag, full_flag: std_logic;
signal wr_data, rd_data : std_logic_vector(bits-1 downto 0);
constant clk_period: time := 20ns; --50 MHz

begin
tb: FIFO_buffer 
generic map(
    WIDTH => bits,
    ADDR => rows
    )
port map( 
                     clk=>clk,
                     reset=>reset,
                     wr_en=>wr_en,
                     rd_en=>rd_en,
                     wr_data=>wr_data,
                     rd_data=>rd_data,
                     empty_flag=>empty_flag,
                     full_flag=>full_flag
                     );
-- clock signal                  
process
begin
    clk <= '1';
    wait for clk_period;
    clk <= '0';
    wait for clk_period;
end process;
-- send reset signal
process
begin
    reset <= '1';
    wait for 80ns;
    reset <='0';
    wait;
end process;
-- send read signal
process
begin
    wr_en <= '0';
    rd_en <= '0';
    wait for 100ns;
    wr_en <= '1';
    rd_en <= '0';
    wait for clk_period*16;
    wr_en <= '0';
    rd_en <= '0';
    wait for clk_period*4;
    wr_en <= '0';
    rd_en <= '1';
    wait for clk_period*16;
    
end process;
-- write data to register
process
begin
    wr_data <= "11010011";
    wait for clk_period*2;
    wr_data <= "00010011";
    wait for clk_period*2;
    wr_data <= "11110011";
    wait for clk_period*2;
    wr_data <= "00000011";
    wait for clk_period*2;
    wr_data <= "01110011";
    wait for clk_period*2;
    wr_data <= "10110011";
    wait for clk_period*2;
    wr_data <= "00000001";
    wait for clk_period*2;
end process;



end Behavioral;
