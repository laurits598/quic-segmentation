-- File: reg_file_8x64.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quic_hdr_reg_8x64 is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        we       : in  std_logic;
        wr_addr  : in  unsigned(2 downto 0);  -- 3-bit address for 8 registers
        rd_addr  : in  unsigned(2 downto 0);
        d        : in  std_logic_vector(63 downto 0);
        q        : out std_logic_vector(63 downto 0)
    );
end quic_hdr_reg_8x64;

architecture Behavioral of quic_hdr_reg_8x64 is
    type reg_array_t is array (0 to 7) of std_logic_vector(63 downto 0);
    signal regs : reg_array_t := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                regs <= (others => (others => '0'));
            elsif we = '1' then
                regs(to_integer(wr_addr)) <= d;
            end if;
        end if;
    end process;

    q <= regs(to_integer(rd_addr));
end Behavioral;
