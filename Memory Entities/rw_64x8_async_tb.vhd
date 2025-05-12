library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rw_64x8_async_tb is
end rw_64x8_async_tb;

architecture Behavioral of rw_64x8_async_tb is

    -- Adjusted to 4 words and 4-bit data
    component rw_64x8_async
        Port (
            we      : in  std_logic;
            addr    : in  std_logic_vector(2 downto 0);
            data_in : in  std_logic_vector(63 downto 0);
            data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    signal we       : std_logic := '0';
    signal addr     : std_logic_vector(2 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal data_out : std_logic_vector(63 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: rw_64x8_async
        Port map (
            we      => we,
            addr    => addr,
            data_in => data_in,
            data_out=> data_out
        );

    -- Stimulus process
    stim_proc: process
    begin
	 
		  for i in 0 to 7 loop
            addr <= std_logic_vector(to_unsigned(i, 3));
            data_in <= std_logic_vector(to_unsigned(i * 10, 64)); -- Arbitrary data (e.g., 0, 10, 20, ...)
            we <= '1';
            wait for 10 ns;
        end loop;
		  
		  
        --we <= '1'; -- Enable writing
--
        --addr <= "00";
        --data_in <= x"B";
        --wait for 10 ns;
--
        --addr <= "01";
        --data_in <= x"C";
        --wait for 10 ns;
--
        --addr <= "10";
        --data_in <= x"2";
        --wait for 10 ns;
--
        --addr <= "11";
        --data_in <= x"A";
        --wait for 10 ns;

        we <= '0'; -- Switch to read mode

        for i in 0 to 7 loop
            addr <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        wait;
    end process;

end Behavioral;









