library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Counter is
    port (clk, reset   : in  std_logic;
          en           : in  std_logic;
          cnt          : out std_logic_vector(15 downto 0));
end entity;

architecture arch of Counter is
    signal cnt_int : integer range 0 to 255;
	 
	 
begin
	 
    COUNTER : process (clk, reset)
    begin
        if (reset = '1') then
            cnt_int <= 0;
        elsif rising_edge(clk) then
            if (en = '1') then
                if (cnt_int = 255) then
                    cnt_int <= 0;
                else
                    cnt_int <= cnt_int + 1;
                end if;
            end if;
        end if;
		  
    end process;

    cnt <= std_logic_vector(to_unsigned(cnt_int, 16));
end architecture;
