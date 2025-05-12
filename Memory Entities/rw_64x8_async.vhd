library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rw_64x8_async is
    Port (
        we      : in  std_logic; -- Write Enable
        addr    : in  std_logic_vector(2 downto 0); -- 3-bit address for 8 words
        data_in : in  std_logic_vector(63 downto 0);
        data_out: out std_logic_vector(63 downto 0)

    );
end rw_64x8_async;

architecture Behavioral of rw_64x8_async is
    
	 -- Define memory type: 8 words, 64 bits each
    type memory_array is array (0 to 7) of std_logic_vector(63 downto 0);
	 
	 signal mem : memory_array;
    -- signal mem : memory_array := (others => (others => '0')); -- initialize to zero
	 
	 
begin

    memory : process (addr, we, data_in)
		 begin
			if (we = '1') then
				mem(to_integer(unsigned(addr))) <= data_in; -- Write
			else
				data_out <= mem(to_integer(unsigned(addr)));     -- Read
			end if;
		 end process;
end Behavioral;
