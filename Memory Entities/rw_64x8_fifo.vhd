library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rw_64x8_fifo is
    Port (
        clk      : in  std_logic;
        we       : in  std_logic;
        re       : in  std_logic;
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(63 downto 0)
    );
end rw_64x8_fifo;

architecture Behavioral of rw_64x8_fifo is

    type memory_array is array (0 to 7) of std_logic_vector(63 downto 0);
    signal mem     : memory_array := (others => (others => '0'));

    signal wr_ptr  : integer range 0 to 7 := 0;
    signal rd_ptr  : integer range 0 to 7 := 0;
    signal dout    : std_logic_vector(63 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                mem(wr_ptr) <= data_in;
                wr_ptr <= (wr_ptr + 1) mod 8;
            end if;

            if re = '1' then
                dout <= mem(rd_ptr);
                rd_ptr <= (rd_ptr + 1) mod 8;
            end if;
        end if;
    end process;

    data_out <= dout;

end Behavioral;
