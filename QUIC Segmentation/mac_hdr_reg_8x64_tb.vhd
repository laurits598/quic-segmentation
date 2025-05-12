library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mac_hdr_reg_8x64_tb is
end mac_hdr_reg_8x64_tb;

architecture Behavioral of mac_hdr_reg_8x64_tb is

    -- Component Declaration
    component mac_hdr_reg_8x64 is
        Port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            we       : in  std_logic;
            wr_addr  : in  unsigned(2 downto 0);
            rd_addr  : in  unsigned(2 downto 0);
            d        : in  std_logic_vector(63 downto 0);
            q        : out std_logic_vector(63 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal we       : std_logic := '0';
    signal wr_addr  : unsigned(2 downto 0) := (others => '0');
    signal rd_addr  : unsigned(2 downto 0) := (others => '0');
    signal d        : std_logic_vector(63 downto 0) := (others => '0');
    signal q        : std_logic_vector(63 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate DUT
    uut: mac_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => rst,
            we       => we,
            wr_addr  => wr_addr,
            rd_addr  => rd_addr,
            d        => d,
            q        => q
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset the register file
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- Write 0xDEADBEEF00000001 to address 0
        we <= '1';
        wr_addr <= "000";
        d <= x"DEADBEEF00000001";
        wait for clk_period;

        -- Write 0xCAFEBABE00000002 to address 1
        wr_addr <= "001";
        d <= x"CAFEBABE00000002";
        wait for clk_period;

        -- Disable write
        we <= '0';

        -- Read from address 0
        rd_addr <= "000";
        wait for clk_period;

        -- Read from address 1
        rd_addr <= "001";
        wait for clk_period;

        -- Done
        wait;
    end process;

end Behavioral;
