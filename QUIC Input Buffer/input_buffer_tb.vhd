library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity input_buffer_tb is
end input_buffer_tb;

architecture behavior of input_buffer_tb is

    -- Component under test
      
		component input_buffer
			port (
				clk      : in std_logic;
				reset    : in std_logic;
				--output_buffer_full   	: in std_logic;
				data_in  		: in std_logic_vector(63 downto 0);
				is_seg_rdy_for_nxt_pkt : in std_logic;
				is_seg_rdy_for_payload : in std_logic;
				
						
				
				rdy_to_send : out std_logic;
				data_out 		: out std_logic_vector(63 downto 0);
				mac_hdr_out    : out std_logic_vector(7 downto 0);	
				metadata_out  : out std_logic_vector(7 downto 0);
				ip_hdr_out     : out std_logic_vector(15 downto 0);
				udp_hdr_out    : out std_logic_vector(15 downto 0)
			);
		end component;
	 
	 
	 
	 
	 
	 
	 

    -- Signals
    signal clk               : std_logic := '0';
    signal reset             : std_logic := '0';
    signal data_in        : std_logic_vector(63 downto 0) := (others => '0');
	 signal is_seg_rdy_for_nxt_pkt : std_logic;
	 signal is_seg_rdy_for_payload : std_logic;
	 
	 
    signal rdy_to_send    : std_logic;
    signal data_out       : std_logic_vector(63 downto 0);
    signal mac_hdr_out    : std_logic_vector(7 downto 0);
    signal metadata_out  : std_logic_vector(7 downto 0);
    signal ip_hdr_out     : std_logic_vector(15 downto 0);
    signal udp_hdr_out    : std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    uut: input_buffer
        port map (
            clk              => clk,
            reset            => reset,
            data_in       => data_in,
				is_seg_rdy_for_nxt_pkt => is_seg_rdy_for_nxt_pkt,
				is_seg_rdy_for_payload => is_seg_rdy_for_payload,
            rdy_to_send   => rdy_to_send,
            data_out      => data_out,
            mac_hdr_out   => mac_hdr_out,
            metadata_out => metadata_out,
            ip_hdr_out    => ip_hdr_out,
            udp_hdr_out   => udp_hdr_out
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for clk_period;

        -- Send test packet (preamble = x"AB")
        data_in <= x"AB1234080E140880";
        --wait for 2 * clk_period;
		  wait for clk_period;
        -- Hold for observation
		  
        wait for 100 ns;

        -- Optionally display result
        report "Metadata Out     = " & integer'image(to_integer(unsigned(metadata_out))) severity note;
		  report "MAC Header Out   = " & integer'image(to_integer(unsigned(mac_hdr_out))) severity note;
		  report "IP Header Out    = " & integer'image(to_integer(unsigned(ip_hdr_out))) severity note;
		  report "UDP Header Out   = " & integer'image(to_integer(unsigned(udp_hdr_out))) severity note;
		  report "Ready to Send    = " & std_logic'image(rdy_to_send) severity note;


        wait;
    end process;

end architecture;
