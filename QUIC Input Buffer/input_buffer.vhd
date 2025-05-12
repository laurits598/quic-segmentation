library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity input_buffer is
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
end input_buffer;

architecture arch of input_buffer is

	
	component metadata_parser is
		port (
         clk         : in std_logic;
         reset       : in std_logic;
         enable      : in std_logic;
         metadata_in : in std_logic_vector(63 downto 0);
         
         preamble        : out std_logic_vector(7 downto 0);
         total_len       : out std_logic_vector(15 downto 0);
         seg_len         : out std_logic_vector(7 downto 0);
         seg_count       : out std_logic_vector(7 downto 0);
         mac_hdr_len     : out std_logic_vector(7 downto 0);
         ip_hdr_len      : out std_logic_vector(7 downto 0);
         udp_hdr_len     : out std_logic_vector(7 downto 0)
        );
    end component;

	 
		-- Internal Signals for Metadata Parser
	
	signal to_meta  		  : std_logic_vector(63 downto 0);	-- If metadata
	
	signal preamble        : std_logic_vector(7 downto 0);
	signal total_len       : std_logic_vector(15 downto 0);
	signal seg_len         : std_logic_vector(7 downto 0);
	signal seg_count       : std_logic_vector(7 downto 0);
	signal mac_hdr_len     : std_logic_vector(7 downto 0);
	signal ip_hdr_len      : std_logic_vector(7 downto 0);
	signal udp_hdr_len     : std_logic_vector(7 downto 0);
	signal hdr : std_logic_vector(7 downto 0);
	
	
	signal meta_enable : std_logic := '0'; 
	

	signal preamble_s       : std_logic_vector(7 downto 0);
   signal mac_hdr_len_s    : std_logic_vector(7 downto 0);
   signal ip_hdr_len_s     : std_logic_vector(7 downto 0);
   signal udp_hdr_len_s    : std_logic_vector(7 downto 0);
	signal preamble_check        : std_logic_vector(7 downto 0);

	
	signal ip_hdr_word_count : unsigned(7 downto 0) := (others => '0');
	signal words_expected    : unsigned(7 downto 0) := (others => '0');

	
	
	
	
	

	 
	 
begin


 -- Directly feed metadata
--    meta_inst : metadata_parser
--        port map (
--            clk         => clk,
--            reset       => reset,
--            enable      => '1',  -- always enabled
--            metadata_in => data_in,
--
--            preamble        => preamble_s,
--            total_len       => open,
--            seg_len         => open,
--            seg_count       => open,
--            mac_hdr_len     => mac_hdr_len_s,
--            ip_hdr_len      => ip_hdr_len_s,
--            udp_hdr_len     => udp_hdr_len_s
--        );
--	 preamble_check <= data_in(63 downto 56);
--	 
--    process(clk, reset)
--    begin
--        if reset = '1' then
--            metadata_out <= (others => '0');
--            mac_hdr_out  <= (others => '0');
--            ip_hdr_out   <= (others => '0');
--            udp_hdr_out  <= (others => '0');
--            data_out     <= (others => '0');
--            rdy_to_send  <= '0';
--        elsif rising_edge(clk) then
--				
--				if preamble_check = "10101011" then
--					mac_hdr_out  <= mac_hdr_len_s;
--					ip_hdr_out   <= "00000000" & ip_hdr_len_s;
--					udp_hdr_out  <= "00000000" & udp_hdr_len_s;
--					data_out     <= data_in;
--					rdy_to_send  <= '1';
--				else
--					udp_hdr_out  <= "00000000" & udp_hdr_len_s;
--					data_out     <= data_in;
--				end if;
--					
--        end if;
--    end process;



	meta_inst : metadata_parser
       port map (
           clk         => clk,
           reset       => reset,
           enable      => '1',  -- always enabled
           metadata_in => data_in,

           preamble        => preamble_s,
           total_len       => total_len,
           seg_len         => seg_len,
           seg_count       => seg_count,
           mac_hdr_len     => mac_hdr_len_s,
           ip_hdr_len      => ip_hdr_len_s,
           udp_hdr_len     => udp_hdr_len_s
       );



	preamble_check <= data_in(63 downto 56);
	process(clk, reset)
		 -- Declare internal FSM states
	type state_type is (IDLE, PARSE_META, SEND_META, RECEIVE_IP_HDR);
	variable state : state_type := IDLE;
	begin
		 if reset = '1' then
			  -- Reset all outputs and state
			  metadata_out      <= (others => '0');
			  mac_hdr_out       <= (others => '0');
			  ip_hdr_out        <= (others => '0');
			  udp_hdr_out       <= (others => '0');
			  data_out          <= (others => '0');
			  rdy_to_send       <= '0';
			  to_meta           <= (others => '0');
			  words_expected    <= (others => '0');
			  ip_hdr_word_count <= (others => '0');
			  state             := IDLE;
		 
		 
		 elsif rising_edge(clk) then
			  case state is

					when IDLE =>
						 rdy_to_send <= '0';
						 if preamble_check = "10101011" then  -- metadata packet
							  to_meta <= data_in;
							  state := PARSE_META;
						 end if;

					when PARSE_META =>
						 -- Give metadata_parser 1 cycle to parse
						 state := SEND_META;

					when SEND_META =>
						 metadata_out <= preamble;
						 mac_hdr_out  <= mac_hdr_len;
						 ip_hdr_out   <= "00000000" & ip_hdr_len;
						 udp_hdr_out  <= "00000000" & udp_hdr_len;
						 data_out     <= data_in;
						 rdy_to_send  <= '1';
						 
						 
						 report "DEBUG: MAC HDR = " & integer'image(to_integer(unsigned(mac_hdr_len))) severity note;

						 
						 -- Calculate # of 64-bit words to receive
						 words_expected    <= (unsigned(ip_hdr_len) + 7) / 8;
						 ip_hdr_word_count <= (others => '0');
						 state             := RECEIVE_IP_HDR;

					when RECEIVE_IP_HDR =>
						 rdy_to_send <= '0';
						 data_out <= data_in;  -- Forward each word (optional)

						 if ip_hdr_word_count < words_expected - 1 then
							  ip_hdr_word_count <= ip_hdr_word_count + 1;
						 else
							  state := IDLE;  -- Or transition to next state (e.g. payload)
						 end if;

					when others =>
						 state := IDLE;

			  end case;
		 end if;
	end process;



























	
end architecture;


















