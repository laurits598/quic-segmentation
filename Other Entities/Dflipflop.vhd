library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Dflipflop is
	port (
			clk      : in std_logic;
			D 			: in std_logic_vector(63 downto 0);
			Q			: out std_logic_vector(63 downto 0)
		  );
			
end Dflipflop;



architecture Behavioral of Dflipflop is

begin 
	
	proc : process(clk)
	begin
		if rising_edge(clk) then
			Q <= D;
		end if;
	end process;
	
	
end architecture;
