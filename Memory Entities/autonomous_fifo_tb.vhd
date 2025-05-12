library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity autonomous_fifo_tb is
end entity;

architecture behavior of autonomous_fifo_tb is

    -- Clock and control
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal rd_en    : std_logic := '0';

    -- Data signals
    signal data_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out : std_logic_vector(63 downto 0);
    signal full     : std_logic;
    signal empty    : std_logic;

    -- FIFO component
    component autonomous_fifo
        Port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            rd_en    : in  std_logic;
            data_in  : in  std_logic_vector(63 downto 0);
            data_out : out std_logic_vector(63 downto 0);
            full     : out std_logic;
            empty    : out std_logic
        );
    end component;

    -- Test data
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

    constant clk_period : time := 10 ns;

begin

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for clk_period / 2;
            clk <= '1'; wait for clk_period / 2;
        end loop;
    end process;

    -- FIFO instantiation
    uut: autonomous_fifo
        port map (
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            rd_en    => rd_en,
            data_in  => data_in,
            data_out => data_out,
            full     => full,
            empty    => empty
        );

    -- Test procedure
    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        -- Write 8 packets
        for i in 0 to 14 loop
            wr_en <= '1';
            data_in <= packets(i);
            wait for clk_period;
        end loop;
        wr_en <= '0';
		  
        --wait until full = '1';
        --wait for clk_period;

        -- Read back 8 packets
        for i in 0 to 7 loop
			rd_en <= '1';
		   wait for clk_period;
			rd_en <= '0';
		   wait for clk_period;
		  end loop;


        wait;
    end process;

end behavior;
