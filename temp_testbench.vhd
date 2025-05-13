library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temp_testbench is
end temp_testbench;

architecture Behavioral of temp_testbench is
    
	 
	 
	 signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal enable      : std_logic := '0';
	 
	 signal mac_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal mac_hdr_out : std_logic_vector(63 downto 0);
	 signal ip_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal ip_hdr_out : std_logic_vector(63 downto 0);
	 signal udp_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal udp_hdr_out : std_logic_vector(63 downto 0);
	 signal read_enable, write_enable : std_logic := '0';
	 
	 signal mac_hdr_len        : std_logic_vector(7 downto 0) := x"20";
    signal ip_hdr_len         : std_logic_vector(7 downto 0) := x"10";
    signal udp_hdr_len        : std_logic_vector(7 downto 0) := x"20";
    
	 signal data        : std_logic_vector(63 downto 0);
	 
	 constant clk_period : time := 10 ns;
		
	 
	 
begin
    -- Instantiate Multiplexer
    uut: entity work.register_controller
        port map (
            clk         => clk,
            reset       => reset,
            enable      => enable,
				read_enable => read_enable,
				write_enable => write_enable,
				mac_hdr_len => mac_hdr_len,
				ip_hdr_len  => ip_hdr_len,
				udp_hdr_len  => udp_hdr_len,				
            mac_hdr_in  => mac_hdr_in,
            mac_hdr_out => mac_hdr_out,
				ip_hdr_in  => ip_hdr_in,
            ip_hdr_out => ip_hdr_out,
				udp_hdr_in  => udp_hdr_in,
            udp_hdr_out => udp_hdr_out
				
        );
	  
	 
	 clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;
	 
	 
	 
    
    -- Test Sequence
    stimulus_process: process
    begin
		  -- Reset sequence
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
		  enable <= '1';
        --wait for clk_period;
		  
		  write_enable <= '1';
			
		  
		  
		  
		  mac_hdr_in  <= x"0000000000000001"; --wait for clk_period;
		  ip_hdr_in   <= x"0000000000000001"; --wait for clk_period;
		  udp_hdr_in  <= x"0000000000000001"; wait for clk_period;
  
		  mac_hdr_in  <= x"0000000000000002"; --wait for clk_period;
		  ip_hdr_in   <= x"0000000000000002"; --wait for clk_period;
		  udp_hdr_in  <= x"0000000000000002"; wait for clk_period;
  
		  mac_hdr_in  <= x"0000000000000003"; --wait for clk_period;
		  ip_hdr_in   <= x"0000000000000003"; --wait for clk_period;
		  udp_hdr_in  <= x"0000000000000003"; wait for clk_period;
  
		  mac_hdr_in  <= x"0000000000000004"; --wait for clk_period;
		  ip_hdr_in   <= x"0000000000000004"; --wait for clk_period;
		  udp_hdr_in  <= x"0000000000000004"; wait for clk_period;
  
		  mac_hdr_in  <= x"0000000000000005"; --wait for clk_period;
		  ip_hdr_in   <= x"0000000000000005"; --wait for clk_period;
		  udp_hdr_in  <= x"0000000000000005"; wait for clk_period;
		  
		  
        --wait for clk_period;
		  
		 
			-- MAC headers: 5 values
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000006"; udp_hdr_in <= x"000000000000000B"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000002"; ip_hdr_in <= x"0000000000000007"; udp_hdr_in <= x"000000000000000C"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000003"; ip_hdr_in <= x"0000000000000008"; udp_hdr_in <= x"000000000000000D"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000004"; ip_hdr_in <= x"0000000000000009"; udp_hdr_in <= x"000000000000000E"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000005"; ip_hdr_in <= x"000000000000000A"; udp_hdr_in <= x"000000000000000F"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			--mac_hdr_in <= x"0000000000000001"; ip_hdr_in <= x"0000000000000002"; udp_hdr_in <= x"0000000000000003"; wait for clk_period;
			wait for 2 * clk_period;
			write_enable <= '0';
			read_enable <= '1';
			
		  wait for 4 * clk_period;
		  read_enable <= '1';
			
		  
        -- End simulation
        wait;
    end process;

end Behavioral;

























