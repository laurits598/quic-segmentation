library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rw_64x8_fifo_tb is
end rw_64x8_fifo_tb;

architecture behavior of rw_64x8_fifo_tb is

    signal clk       : std_logic := '0';
    signal we        : std_logic := '0';
    signal re        : std_logic := '0';
    signal data_in   : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out  : std_logic_vector(63 downto 0);

    component rw_64x8_fifo
        Port (
            clk      : in  std_logic;
            we       : in  std_logic;
            re       : in  std_logic;
            data_in  : in  std_logic_vector(63 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component;

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
	 signal read_trigger : integer := 0;

begin

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- UUT instantiation
    uut: rw_64x8_fifo
        port map (
            clk      => clk,
            we       => we,
            re       => re,
            data_in  => data_in,
            data_out => data_out
        );
		  
		  
		  
	 write_proc : process
	 begin
		wait for clk_period;

        -- Write 15 packets (will overwrite older ones)
        we <= '1';
        for i in 0 to 14 loop
            data_in <= packets(i);
            wait for clk_period;
        end loop;
        we <= '0';
	 end process;
	 
	 
	 read_proc : process
	 begin
		wait for clk_period;
		
		if (read_trigger = 6) then
			re <= '1';
		end if;
	 end process;
		  
		  

    -- Stimulus
    stim_proc: process
    begin
		wait for clk_period;
		if read_trigger >= 6 then
			re <= '1';
		else
			read_trigger <= read_trigger + 1;
		
		end if;
		
    end process;

end behavior;











