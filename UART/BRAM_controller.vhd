library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BRAM_controller is
generic( WIDTH: natural := 8;
         ADDRW: natural := 9);
 Port ( clk: in std_logic;
        reset: in std_logic;
        rd_data : in std_logic_vector(WIDTH-1 downto 0);
        ram_data: in std_logic_vector(WIDTH-1 downto 0);
        rx_empty, tx_full: in std_logic;
        addr: out std_logic_vector(ADDRW-1 downto 0);
        d_in, d_out: out std_logic_vector(WIDTH-1 downto 0);
        wr_en_ram, rd_en_FIFO, wr_en_FIFO: out std_logic     
        );
end BRAM_controller;

architecture arch of BRAM_controller is

type state_type is (idle, write, read);
signal state_reg, state_next: state_type;
signal addr_reg, addr_next, addr_iter: unsigned(ADDRW-1 downto 0);
signal d_in_reg, d_in_next: std_logic_vector(WIDTH-1 downto 0);
signal wr_ram_reg, wr_ram_next : std_logic;
signal wr_FIFO_reg, wr_FIFO_next: std_logic;

begin

process(clk,reset)
    begin
        if(reset='1') then
            state_reg <= idle;
            wr_ram_reg <= '0';
            wr_FIFO_reg <= '0';
            d_in_reg <= (others => '0');
            addr_reg <= (others => '0');
        elsif(clk'event and clk ='1') then
            state_reg <= state_next;
            wr_ram_reg <= wr_ram_next;
            wr_FIFO_reg <= wr_FIFO_next;
            d_in_reg <= d_in_next;
            addr_reg <= addr_next;  
        end if;
end process;

process(state_reg, addr_reg, d_in_reg, wr_ram_reg, wr_FIFO_reg, rx_empty, tx_full, addr_iter)
begin
state_next <= state_reg;
addr_next<=addr_reg;
d_in_next<=d_in_reg;
wr_ram_next<= wr_ram_reg;
wr_FIFO_next<=wr_FIFO_reg;
addr_iter <= addr_reg+1;

case state_reg is
    when idle =>
        wr_FIFO_reg <= '0';
        wr_ram_reg <= '0';
        if (rx_empty ='1') then
            state_next<=idle;
        else 
            state_next <= write;
            wr_ram_next <= '1';
        end if;
    when write =>
        d_in_next <= rd_data;
        addr_next <= addr_iter;
        state_next <= read;
    when read=>
        wr_ram_next <='0';
        if(tx_full = '0') then
            wr_FIFO_next <='1';
        else
            state_next <= read;
        end if;
        state_next <=idle;
end case;
end process;

rd_en_FIFO <= wr_ram_reg;
wr_en_ram <= wr_ram_reg;
wr_en_FIFO <= wr_FIFO_reg;
addr <= std_logic_vector(addr_reg(ADDRW-1 downto 0));
d_in<= d_in_reg;
d_out<= ram_data;
end arch;