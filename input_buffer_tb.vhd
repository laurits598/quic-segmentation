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
				
						
				
				rdy_to_send		 : out std_logic;
				data_out 		 : out std_logic_vector(63 downto 0);
				metadata_out  	 : out std_logic_vector(7 downto 0);
				
				mac_hdr_out     : out std_logic_vector(63 downto 0);	
				ip_hdr_out      : out std_logic_vector(63 downto 0);
				udp_hdr_out     : out std_logic_vector(63 downto 0);
				
				preamble        : out std_logic_vector(7 downto 0);
            total_len       : out std_logic_vector(15 downto 0);
            seg_len         : out std_logic_vector(7 downto 0);
            seg_count       : out std_logic_vector(7 downto 0);
            mac_hdr_len     : out std_logic_vector(7 downto 0);
            ip_hdr_len      : out std_logic_vector(7 downto 0);
            udp_hdr_len     : out std_logic_vector(7 downto 0)
			);
		end component;
	 
	 
	 
	 
	 
	 
	 

    -- Signals
    signal clk               	: std_logic := '0';
    signal reset             	: std_logic := '0';
    signal data_in        		: std_logic_vector(63 downto 0) := (others => '0');
	 signal is_seg_rdy_for_nxt_pkt : std_logic;
	 signal is_seg_rdy_for_payload : std_logic;
	 
	 
    signal rdy_to_send    : std_logic;
    signal data_out       : std_logic_vector(63 downto 0);
    signal mac_hdr_out    : std_logic_vector(63 downto 0);
    signal metadata_out   : std_logic_vector(7 downto 0);
    signal ip_hdr_out     : std_logic_vector(63 downto 0);
    signal udp_hdr_out    : std_logic_vector(63 downto 0);
	 
	 signal preamble        : std_logic_vector(7 downto 0);
    signal total_len       : std_logic_vector(15 downto 0);
    signal seg_len         : std_logic_vector(7 downto 0);
    signal seg_count       : std_logic_vector(7 downto 0);
    signal mac_hdr_len     : std_logic_vector(7 downto 0);
    signal ip_hdr_len      : std_logic_vector(7 downto 0);
    signal udp_hdr_len     : std_logic_vector(7 downto 0);
	 
	 
	 
    type packet_array is array (0 to 14) of std_logic_vector(63 downto 0);
    constant packets : packet_array := (
    0  => x"0000000000000001",
    1  => x"0000000000000002",
    2  => x"0000000000000003",
    3  => x"0000000000000004",
    4  => x"0000000000000005",
    5  => x"0000000000000006",
    6  => x"0000000000000007",
    7  => x"0000000000000008",
    8  => x"0000000000000009",
    9  => x"000000000000000A",
    10 => x"000000000000000B",
    11 => x"000000000000000C",
    12 => x"000000000000000D",
    13 => x"000000000000000E",
    14 => x"000000000000000F"
);


	type packet_array2 is array (0 to 29) of std_logic_vector(63 downto 0);

	
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
            udp_hdr_out   => udp_hdr_out,
            --enable      => '1',  -- always enabled
            --metadata_in => data_in,
 
            preamble        => preamble,
            total_len       => total_len,
            seg_len         => seg_len,
            seg_count       => seg_count,
            mac_hdr_len     => mac_hdr_len,
            ip_hdr_len      => ip_hdr_len,
            udp_hdr_len     => udp_hdr_len
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for clk_period;
		  
		  
		  -- AB+ 08+10+08+08 = 28,   28+80=A8
		  
        --data_in <= x"AB00A82010080880";
		  
			data_in <= x"AB00681008080840";
			--data_in <= x"AB00881810101040";
			--data_in <= x"AB00500808080830";
			--data_in <= x"AB006C0A0C080840";
			--data_in <= x"AB00841410080850";
			--data_in <= x"AB007C2010080840";
			--data_in <= x"AB00480804040824";
			--data_in <= x"AB00581008080830";
			--data_in <= x"AB00902020101040";
			--data_in <= x"AB0064140A080840";
		    
			wait for clk_period;
			
			for i in 0 to 29 loop
				data_in <= std_logic_vector(to_unsigned(i + 1, 64));
				wait for clk_period;
			end loop;
			 
			 
        wait;
    end process;

end architecture;















