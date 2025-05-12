library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity multiplexer_2to1 is
    port (
        --clk      : in std_logic;
        --reset    : in std_logic;
        --enable   : in std_logic;
		  sel      : in std_logic;
		  hdr_data_in, payload_data_in :	in std_logic_vector(63 downto 0);
		  
        data_out  	: out std_logic_vector(63 downto 0)		
    );
end multiplexer_2to1;

architecture Behavioral of multiplexer_2to1 is
	 
	 
begin 
	 
	with sel select
		data_out <= hdr_data_in when '0',
						payload_data_in when '1',
						(others => '0') when others;

end architecture;






