library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity async_fifo_tb is
end entity;

architecture behavior of async_fifo_tb is

    -- Clock signals
    signal wr_clk, rd_clk : std_logic := '0';

    -- DUT control and data
    signal rst     : std_logic := '0';
    signal wr_en   : std_logic := '0';
    signal rd_en   : std_logic := '0';
    signal full    : std_logic;
    signal empty   : std_logic;
    signal data_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out : std_logic_vector(63 downto 0);

    -- DUT component
    component async_fifo
        Port (
            wr_clk   : in  std_logic;
            rd_clk   : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            rd_en    : in  std_logic;
            data_in  : in  std_logic_vector(63 downto 0);
            data_out : out std_logic_vector(63 downto 0);
            full     : out std_logic;
            empty    : out std_logic
        );
    end component;

    -- Packet list
    type packet_array is array (0 to 14) of std_logic_vector(63 downto 0);
    constant packets : packet_array := (
        0  => x"1111111111111111",
        1  => x"2222222222222222",
        2  => x"3333333333333333",
        3  => x"4444444444444444",
        4  => x"5555555555555555",
        5  => x"6666666666666666",
        6  => x"7777777777777777",
        7  => x"8888888888888888",
        8  => x"9999999999999999",
        9  => x"AAAAAAAAAAAAAAAA",
        10 => x"BBBBBBBBBBBBBBBB",
        11 => x"CCCCCCCCCCCCCCCC",
        12 => x"DDDDDDDDDDDDDDDD",
        13 => x"EEEEEEEEEEEEEEEE",
        14 => x"FFFFFFFFFFFFFFFF"
    );

begin

    -- Clock generation
    wr_clk_process : process
    begin
        while true loop
            wr_clk <= '0'; wait for 5 ns;
            wr_clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    rd_clk_process : process
    begin
        while true loop
            rd_clk <= '0'; wait for 5 ns;
            rd_clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- DUT instantiation
    uut: async_fifo
        port map (
            wr_clk   => wr_clk,
            rd_clk   => rd_clk,
            rst      => rst,
            wr_en    => wr_en,
            rd_en    => rd_en,
            data_in  => data_in,
            data_out => data_out,
            full     => full,
            empty    => empty
        );

    -- Stimulus: reset and write
    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        -- Write 8 packets
        wait for 10 ns;
        for i in 0 to 7 loop
            wr_en <= '1';
            data_in <= packets(i);
            wait for 10 ns;
        end loop;
        wr_en <= '0';

        --wait for 20 ns;

        -- Read back 8 packets
		  for i in 0 to 7 loop -- Read from 0 to 7

            rd_en <= '1';
            wait for 10 ns;
        end loop;
        rd_en <= '0';

        wait;
    end process;

end behavior;
