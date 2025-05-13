library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer is
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
end input_buffer;

architecture arch of input_buffer is
	 
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
	 
	 signal total_len_s : std_logic_vector(15 downto 0) := (others => '0');		
	 
	 signal seg_count_s           : unsigned(7 downto 0);
	 signal seg_words_reload    	: unsigned(7 downto 0);  -- holds original segment size

	 
	 
	 signal reset_reg 		: std_logic := '1';
	 
	 signal cnt_en	 :	std_logic := '0';
	 signal cnt_len : unsigned(15 downto 0) := (others => '0');
	 signal cnt_s	 : std_logic_vector(15 downto 0);
	 
	 
	 signal transmission_done : std_logic := '0';
	 
begin
	 
	 
	 counter_inst : entity work.Counter
			port map(
				clk 		=> clk,
				reset 	=> reset,
				en			=> cnt_en,
				cnt		=> cnt_s
			);
	 
	 
	 
	COUNTER : process(clk)
	begin
		 if rising_edge(clk) then 
			  if cnt_len = unsigned(cnt_s) then
					transmission_done <= '1';
			  end if;
		 end if;
	end process;
	
	 
    process(clk, reset)
        
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
							
								total_len_s <= data_in(55 downto 40);
								cnt_len <= unsigned(data_in(55 downto 40)) / 8;
								
								mac_hdr_words_remaining  <= unsigned(data_in(31 downto 24)) / 8;
								ip_hdr_words_remaining  <= unsigned(data_in(23 downto 16)) / 8;
								udp_hdr_words_remaining <= unsigned(data_in(15 downto 8)) / 8;
                        seg_words_remaining <= unsigned(data_in(39 downto 32)) / 8;
								
								seg_words_reload    <= unsigned(data_in(39 downto 32)) / 8;
								--seg_words_remaining <= seg_words_reload;
								seg_count_s           <= unsigned(data_in(7 downto 0)) / 8;  -- assuming seg_count is here

								
							
								cnt_en <= '1';
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
						 if seg_words_remaining > 1 then
								data_out <= data_in;
								seg_words_remaining <= seg_words_remaining - 1;

						 elsif seg_words_remaining = 1 then
							  data_out <= data_in;

							  if seg_count_s > 1 then
									seg_words_remaining <= seg_words_reload;
									seg_count_s <= seg_count_s - 1;
							  else
									seg_words_remaining <= (others => '0');
									state := IDLE;
							  end if;
						 end if;

					 when others =>
                    state := IDLE;

            end case;
        end if;
		
    end process;
	 
	 
	 

end architecture;


