library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity input_and_meta_tb is
end input_and_meta_tb;

architecture behavior of input_and_meta_tb is

    -- Component under test
      
		component input_and_meta
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
    signal clk               : std_logic := '0';
    signal reset             : std_logic := '0';
    signal data_in        : std_logic_vector(63 downto 0) := (others => '0');
	 signal is_seg_rdy_for_nxt_pkt : std_logic;
	 signal is_seg_rdy_for_payload : std_logic;
	 
	 
    signal rdy_to_send    : std_logic;
    signal data_out       : std_logic_vector(63 downto 0);
    signal mac_hdr_out    : std_logic_vector(63 downto 0);
    signal metadata_out  : std_logic_vector(7 downto 0);
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
		 
	 
	 type packet_array2 is array (0 to 4) of std_logic_vector(63 downto 0);
    constant packets1 : packet_array2 := (
        0  => x"0000000000000001",
        1  => x"0000000000000002",
        2  => x"0000000000000003",
        3  => x"0000000000000004",
        4  => x"0000000000000005"
	 );
	 constant packets2 : packet_array2 := (
        0  => x"0000000000000006",
        1  => x"0000000000000007",
        2  => x"0000000000000008",
        3  => x"0000000000000009",
        4  => x"000000000000000A"
	 );
	 constant packets3 : packet_array2 := (
        0  => x"000000000000000B",
        1  => x"000000000000000C",
        2  => x"000000000000000D",
        3  => x"000000000000000E",
        4  => x"000000000000000F"
	 );
	 
	 
	 

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
    uut: input_and_meta
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
		  
		  --data_in <= x"AB56780810081008"; 
		  
		  -- AB 1234 08 10 08 08 10
		  
        data_in <= x"AB12342010080810";

		  wait for clk_period; 
		  
		  for i in 0 to 4 loop
            data_in <= packets1(i);
            wait for clk_period;
        end loop;
		  
		  
		  --data_in <= x"AB56780810081008";
		  --wait for clk_period;
		  
		  for i in 0 to 4 loop
            data_in <= packets2(i);
            wait for clk_period;
        end loop;
		  
		  data_in <= x"AB56781010081008";
		  wait for clk_period;
		  
		  for i in 0 to 4 loop
            data_in <= packets3(i);
            wait for clk_period;
        end loop;
        --for i in 0 to 14 loop
        --    data_in <= packets(i);
        --    wait for clk_period;
        --end loop;
		  
		  
		  
		  
		 

        wait;
    end process;

end architecture;











