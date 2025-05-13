library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity segmentation_tb is
end segmentation_tb;

architecture Behavioral of segmentation_tb is

    

    -- Signals for testbench
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal enable      : std_logic := '0';
	 signal rdy_for_packet : std_logic := '0';
	 
    signal mac_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal mac_hdr_out : std_logic_vector(63 downto 0);
	 signal ip_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal ip_hdr_out : std_logic_vector(63 downto 0);
	 signal udp_hdr_in  : std_logic_vector(63 downto 0) := (others => '0');
    signal udp_hdr_out : std_logic_vector(63 downto 0);
	

	 signal mac_hdr_len        : std_logic_vector(7 downto 0) := x"20";
    signal ip_hdr_len         : std_logic_vector(7 downto 0) := x"10";
    signal udp_hdr_len        : std_logic_vector(7 downto 0) := x"20";
    
	 signal mac_hdr_len_out        : std_logic_vector(7 downto 0);
    signal  ip_hdr_len_out        : std_logic_vector(7 downto 0);
    signal udp_hdr_len_out        : std_logic_vector(7 downto 0);
	 
	 signal seg_rdy : std_logic := '0';
	 
    constant clk_period : time := 10 ns;
		
begin


	

	uut: entity work.segmentation
		port map (
        clk              => clk,
        reset            => reset,
        enable           => enable,

        rdy_for_packet   => rdy_for_packet,
		  rdy_to_receive	 => seg_rdy,

        mac_hdr_in       => mac_hdr_in,
        ip_hdr_in        => ip_hdr_in,
        udp_hdr_in       => udp_hdr_in,

        mac_hdr_len      => mac_hdr_len,
        ip_hdr_len       => ip_hdr_len,
        udp_hdr_len      => udp_hdr_len,

        mac_hdr_out      => mac_hdr_out,
        ip_hdr_out       => ip_hdr_out,
        udp_hdr_out      => udp_hdr_out,

        mac_hdr_len_out  => mac_hdr_len_out,
        ip_hdr_len_out   => ip_hdr_len_out,
        udp_hdr_len_out  => udp_hdr_len_out
    );

    -- Clock generation
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
        -- Reset sequence
        reset <= '1';
        wait for clk_period;
        reset <= '0';
		  enable <= '1';
        wait for clk_period;

        -- Write some values
        while seg_rdy = '0' loop
				wait for clk_period;
		  end loop;
		  --end while;
		  --wait for when seg_rdy = '1';
		  

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


		  
		  
		  
        
        -- Stop writing
        --enable <= '0'; wait for clk_period;

        -- Give a moment before observing output
        wait for 4 * clk_period;

        -- Simulation done
        wait;
    end process;

end Behavioral;











