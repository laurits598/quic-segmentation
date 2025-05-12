library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_and_meta is
    port (
        clk                   : in std_logic;
        reset                 : in std_logic;
        data_in               : in std_logic_vector(63 downto 0);
        is_seg_rdy_for_nxt_pkt : in std_logic;
        is_seg_rdy_for_payload : in std_logic;
		  
        rdy_to_send     : out std_logic;
        data_out        : out std_logic_vector(63 downto 0);
        metadata_out    : out std_logic_vector(7 downto 0);
        
		  -- Headers
		  mac_hdr_out     : out std_logic_vector(63 downto 0);
        ip_hdr_out      : out std_logic_vector(63 downto 0);
        udp_hdr_out     : out std_logic_vector(63 downto 0);
		  
		  -- Metadata
        preamble        : out std_logic_vector(7 downto 0);
        total_len       : out std_logic_vector(15 downto 0);
        seg_len         : out std_logic_vector(7 downto 0);
        seg_count       : out std_logic_vector(7 downto 0);
        mac_hdr_len     : out std_logic_vector(7 downto 0);
        ip_hdr_len      : out std_logic_vector(7 downto 0);
        udp_hdr_len     : out std_logic_vector(7 downto 0)
    );
end input_and_meta;

architecture arch of input_and_meta is
	 
	 signal mac_hdr_words_remaining  : unsigned(7 downto 0) := (others => '0');
    signal ip_hdr_words_remaining  : unsigned(7 downto 0) := (others => '0');
    signal udp_hdr_words_remaining : unsigned(7 downto 0) := (others => '0');
    signal seg_words_remaining     : unsigned(7 downto 0) := (others => '0');
	 	 	 
	 type state_type is (IDLE, RECEIVE_MAC_HDR, RECEIVE_IP_HDR, RECEIVE_UDP_HDR, FORWARD_PAYLOAD);
	 signal fsm_state_s : state_type;
	 
	 signal tell_write : std_logic := '0';
	 signal tell_read  : std_logic;
	 
	 signal m_out, i_out, u_out : std_logic_vector(63 downto 0);
	 
	 signal mac_hdr_len_s, ip_hdr_len_s, udp_hdr_len_s : std_logic_vector(7 downto 0) := (others => '0');
	 
	 signal mac_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
    signal  ip_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
    signal udp_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
	 
	 
	 signal reset_reg 		: std_logic := '1';
	 
	 
begin
	 
	 
	 -- Instantiate register
    reg_inst: entity work.register_controller
        port map (
            clk         	=> clk,
            reset       	=> reset_reg,
            enable      	=> '1',
				read_enable 	=> tell_read,
				write_enable 	=> tell_write,
				mac_hdr_len 	=> mac_hdr_len_s,
				ip_hdr_len  	=> ip_hdr_len_s,
				udp_hdr_len  	=> udp_hdr_len_s,
            mac_hdr_in  	=> mac_hdr_out_s,
            mac_hdr_out 	=> open,
				ip_hdr_in  		=> ip_hdr_out_s,
            ip_hdr_out 		=> open,
				udp_hdr_in  	=> udp_hdr_out_s,
            udp_hdr_out 	=> open
				
        );
	 
	 
	 
	 
    process(clk, reset)
        --type state_type is (IDLE, RECEIVE_MAC_HDR, RECEIVE_IP_HDR, RECEIVE_UDP_HDR, FORWARD_PAYLOAD);
        variable state : state_type := IDLE;
		  
		  
    begin
	 
		  
		  
        if reset = '1' then
            preamble             <= (others => '0');
            total_len            <= (others => '0');
            seg_len              <= (others => '0');
            seg_count            <= (others => '0');
            mac_hdr_len          <= (others => '0');
            ip_hdr_len           <= (others => '0');
            udp_hdr_len          <= (others => '0');
				
            metadata_out         <= (others => '0');
            mac_hdr_out          <= (others => '0');
            ip_hdr_out           <= (others => '0');
            udp_hdr_out          <= (others => '0');
            data_out             <= (others => '0');
            rdy_to_send          <= '0';
            ip_hdr_words_remaining  <= (others => '0');
            udp_hdr_words_remaining <= (others => '0');
            seg_words_remaining     <= (others => '0');
				
				reset_reg <= '1';
				
				tell_write <= '1';
            state := IDLE;

        elsif rising_edge(clk) then
				--reset_reg <= '0';
            case state is
                when IDLE =>
                    -- AB 1234 20 08 08 08 80
						  if data_in(63 downto 56) = x"AB" then
                        preamble     <= data_in(63 downto 56); -- AB
                        total_len    <= data_in(55 downto 40); -- 1234
                        seg_count    <= data_in(39 downto 32); -- 20
                        mac_hdr_len_s  <= data_in(31 downto 24); -- 08
                        ip_hdr_len_s   <= data_in(23 downto 16); -- 08
                        udp_hdr_len_s  <= data_in(15 downto 8); -- 08
								mac_hdr_len  <= data_in(31 downto 24); -- 08
                        ip_hdr_len   <= data_in(23 downto 16); -- 08
                        udp_hdr_len  <= data_in(15 downto 8); -- 08
                        seg_len      <= data_in(7 downto 0); -- 80
							
						
								mac_hdr_words_remaining  <= unsigned(data_in(31 downto 24)) / 8;
								ip_hdr_words_remaining  <= unsigned(data_in(23 downto 16)) / 8;
								udp_hdr_words_remaining <= unsigned(data_in(15 downto 8)) / 8;
                        seg_words_remaining <= unsigned(data_in(39 downto 32)) / 8;
								
								
								reset_reg <= '1';
								state := RECEIVE_MAC_HDR;
								
								
								
								
						  else
								reset_reg <= '1';
                        rdy_to_send <= '1';
                    end if;

					 
					 when RECEIVE_MAC_HDR =>
							 reset_reg <= '0';
							 if mac_hdr_words_remaining > 1 then
								  mac_hdr_out <= data_in;
								  mac_hdr_out_s <= data_in;
								  mac_hdr_words_remaining <= mac_hdr_words_remaining - 1;
								
							 elsif mac_hdr_words_remaining = 1 then
								  mac_hdr_out <= data_in;
								  mac_hdr_out_s <= data_in;
								  mac_hdr_words_remaining <= (others => '0');
								  state := RECEIVE_IP_HDR;
							 end if;
							 
                when RECEIVE_IP_HDR =>
					 
							 if ip_hdr_words_remaining > 1 then
								  ip_hdr_out <= data_in;
								  ip_hdr_out_s <= data_in;
								  ip_hdr_words_remaining <= ip_hdr_words_remaining - 1;
								
							 elsif ip_hdr_words_remaining = 1 then
								  ip_hdr_out <= data_in;
								  ip_hdr_out_s <= data_in;
								  ip_hdr_words_remaining <= (others => '0');
								  state := RECEIVE_UDP_HDR;
					
							 end if;
							 
					when RECEIVE_UDP_HDR =>
						 if udp_hdr_words_remaining = 1 then
							  udp_hdr_out <= data_in;
							  udp_hdr_out_s <= data_in;
							  udp_hdr_words_remaining <= (others => '0');
							  --reset_reg <= '1';
							  
							  --seg_words_remaining <= unsigned(seg_count) / 8;
							  state := FORWARD_PAYLOAD;
							  rdy_to_send <= '0';

						 elsif udp_hdr_words_remaining > 1 then
							  udp_hdr_out <= data_in;
							  udp_hdr_out_s <= data_in;
							  udp_hdr_words_remaining <= udp_hdr_words_remaining - 1;

						 end if;
						 
					 when FORWARD_PAYLOAD =>
						 --reset_reg <= '0';
						 if seg_words_remaining > 1 then
							  data_out <= data_in;
							  seg_words_remaining <= seg_words_remaining - 1;
							  
						 elsif seg_words_remaining = 1 then
							  data_out <= data_in;
							  seg_words_remaining <= (others => '0');
							  
							  state := IDLE;
						 end if;
					 when others =>
                    state := IDLE;

            end case;
        end if;
		--mac_hdr_len <= mac_hdr_len_s ;
		--ip_hdr_len  <= ip_hdr_len_s;
		--udp_hdr_len <= udp_hdr_len_s;
		
		--mac_hdr_out <=  mac_hdr_out_s;
		--ip_hdr_out  <= ip_hdr_out_s;
		--udp_hdr_out <= udp_hdr_out_s;
		
		fsm_state_s <= state;
    end process;

	 
	 

end architecture;








































