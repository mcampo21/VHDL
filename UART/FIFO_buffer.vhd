

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_buffer is
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
end FIFO_buffer;

architecture arch of FIFO_buffer is
type memory is array (0 to ADDR-1) of std_logic_vector(WIDTH-1 downto 0);
signal mem_reg : memory := (others=> (others=> '0'));
signal rd_ptr, wr_ptr : integer range 0 to ADDR-1 := 0;
signal count : integer range -1 to ADDR + 1 := 0;
--signal rd_ptr, wr_ptr : UNSIGNED(ADDR-1 downto 0) := (others => '0'); -- 1 downto 0
signal full, empty : std_logic;

begin
-- control
process(reset, clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then
            rd_ptr <= 0;
            wr_ptr <= 0;
            mem_reg <= (others =>(others => '0'));
        else
        -- track wr/rd count
        if (wr_en = '1' and rd_en = '0') then
            count <= count + 1;
        elsif (wr_en = '0' and rd_en = '1') then
            count <= count -1;
        end if;
        -- track write index
        if (wr_en = '1' and full = '0') then
            if wr_ptr = ADDR-1 then
                wr_ptr <= 0;
            else
                wr_ptr <= wr_ptr + 1;
            end if;
        end if;
        -- track read index
        if (rd_en = '1' and empty = '0') then
            if rd_ptr = ADDR - 1 then
                rd_ptr <= 0;
            else
                rd_ptr <= rd_ptr + 1;
            end if;
        end if;
        -- Wirte to register
        if (wr_en = '1') then
            mem_reg(wr_ptr) <= wr_data;
        end if;
    end if;
end if;
end process;

rd_data <= mem_reg(rd_ptr);
full <= '1' when count = ADDR else '0';
empty <= '1' when count = 0 else '0';
-- Send flag status
full_flag <= full;
empty_flag <= empty;
    

end arch;
