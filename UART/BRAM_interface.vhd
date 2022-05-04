library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BRAM_512x8 is
generic( WIDTH : natural := 8;
         ADDRW : natural := 9);
Port ( clk : in STD_LOGIC;
       wr_en : in STD_LOGIC;
       addr : in STD_LOGIC_VECTOR (ADDRW-1 downto 0);
       d_in : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
       d_out : out STD_LOGIC_VECTOR (WIDTH-1 downto 0)
);
end BRAM_512x8;

architecture arch of BRAM_512x8 is
type ram_type is array (0 to 2**ADDRW-1) of std_logic_vector(WIDTH-1 downto 0);
signal RAM : ram_type := (others=>(others=>'0'));

begin
process(clk)
begin
if (rising_edge(clk)) then
    if (wr_en = '1') then
        RAM(to_integer(unsigned(addr))) <= d_in;
    end if;
end if;
end process;

d_out <= RAM(to_integer(unsigned(addr)));
end arch;