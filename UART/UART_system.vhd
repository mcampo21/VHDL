library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_system is
generic(DBIT : natural :=8;
        ADDRW : natural :=9);
  Port (clk: in std_logic; 
        reset : in std_logic; 
        rx : in std_logic;
        tx : out std_logic); 
        
end UART_system;

architecture Behavioral of UART_system is

component UART_subsystem is
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
end component;

component FIFO_buffer is
generic( WIDTH : natural := 8; -- 8 bits long
         ADDR: natural := 8);  -- # of rows
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
 
component RAM_system is
generic( WIDTH: natural := 8;
         ADDRW: natural := 9);
  Port ( clk : in std_logic;
         reset: in std_logic;
         rx_empty: in std_logic;
         tx_full: in std_logic;
         rx_data: in std_logic_vector((WIDTH-1) downto 0);
         tx_data: out std_logic_vector((WIDTH-1) downto 0);
         rx_rd: out std_logic;
         tx_wr: out std_logic);
end component;
 
 signal rx_wr_FIFO, rx_rd, rx_empty, tx_wr, tx_full, tx_empty, not_tx_empty, tx_rd_FIFO: std_logic;
 signal rx_d_uart, rx_data, wr_data, tx_d_uart, tx_data: std_logic_vector((DBIT-1) downto 0);
 signal rx_full:std_logic;
 
 begin 
 not_tx_empty <= not(tx_empty); 
 
BRAM: RAM_system port map(clk =>clk,
                            reset => reset,
                            rx_data => rx_data,
                            rx_empty => rx_empty,
                            tx_data => tx_data,
                            tx_wr => tx_wr,
                            tx_full => tx_full);

rx_FIFO_inst: FIFO_buffer port map(
                            clk => clk,
                            reset => reset,
                            wr_en => rx_wr_FIFO,
                            rd_en => rx_rd,
                            wr_data => rx_d_uart,
                            rd_data => rx_data,
                            empty_flag => rx_empty,
                            full_flag => rx_full);
                            
tx_FIFO_int: FIFO_buffer port map(
                            clk => clk,
                            reset => reset,
                            wr_en => '1',
                            rd_en => tx_rd_FIFO,
                            wr_data => tx_d_uart,
                            rd_data => tx_data,
                            empty_flag =>tx_empty,
                            full_flag => tx_full);
                    
UART_inst: UART_subsystem port map( 
                            clk => clk,
                            reset => reset,
                            rx => rx,
                            tx =>tx,
                            rx_out => rx_d_uart,
                            rx_done => rx_wr_FIFO,
                            tx_in => tx_d_uart,
                            tx_done => tx_rd_FIFO,
                            tx_start => not_tx_empty
);                     

end Behavioral;