library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdr_agg_sft_reg is
    Port (
        clk             : in  std_logic;
        reset           : in  std_logic;
        enable          : in  std_logic;
		  mac_hdr_in   	: in std_logic_vector(63 downto 0);
		  ip_hdr_in    	: in std_logic_vector(63 downto 0);
		  udp_hdr_in   	: in std_logic_vector(63 downto 0);
        data_in : in std_logic_vector(63 downto 0);
		  
		  data_out       	: out std_logic_vector(63 downto 0)
		  
    );
end hdr_agg_sft_reg;

architecture Behavioral of hdr_agg_sft_reg is
 
	 signal mac_hdr_in_s : std_logic_vector(63 downto 0);
    signal ip_hdr_in_s  : std_logic_vector(63 downto 0);
    signal udp_hdr_in_s : std_logic_vector(63 downto 0);
	 
	 
	 signal data_out_s : std_logic_vector(63 downto 0);
	 
	 
	 type shift_array is array(0 to 7) of std_logic_vector(63 downto 0);
	 signal agg_shift_reg_mac : shift_array;
	 signal agg_shift_reg_ip  : shift_array;
	 signal agg_shift_reg_udp : shift_array;

	 type state_type is (IDLE, MAC, IP, UDP);
    signal state : state_type := IDLE;

begin
	 
   
    process(clk, reset)
    begin
        if reset = '1' then
				agg_shift_reg_mac(7) <= (others => '0');
				agg_shift_reg_mac(6) <= (others => '0');
				agg_shift_reg_mac(5) <= (others => '0');
				agg_shift_reg_mac(4) <= (others => '0');
            agg_shift_reg_mac(3) <= (others => '0');
				agg_shift_reg_mac(2) <= (others => '0');
				agg_shift_reg_mac(1) <= (others => '0');
				agg_shift_reg_mac(0) <= (others => '0');
            --data_out    <= (others => '0');
            

        elsif rising_edge(clk) then				
				agg_shift_reg_mac(7) <= agg_shift_reg_mac(6);
				agg_shift_reg_mac(6) <= agg_shift_reg_mac(5);
				agg_shift_reg_mac(5) <= agg_shift_reg_mac(4);
				agg_shift_reg_mac(4) <= agg_shift_reg_mac(3);
            agg_shift_reg_mac(3) <= agg_shift_reg_mac(2);
				agg_shift_reg_mac(2) <= agg_shift_reg_mac(1);
				agg_shift_reg_mac(1) <= agg_shift_reg_mac(0);
				agg_shift_reg_mac(0) <= mac_hdr_in;
            
        end if;
    end process;
	 
	 process(clk, reset)
    begin
        if reset = '1' then
				agg_shift_reg_ip(7) <= (others => '0');
				agg_shift_reg_ip(6) <= (others => '0');
				agg_shift_reg_ip(5) <= (others => '0');
				agg_shift_reg_ip(4) <= (others => '0');
            agg_shift_reg_ip(3) <= (others => '0');
				agg_shift_reg_ip(2) <= (others => '0');
				agg_shift_reg_ip(1) <= (others => '0');
				agg_shift_reg_ip(0) <= (others => '0');
            --data_out    <= (others => '0');
            

        elsif rising_edge(clk) then				
				agg_shift_reg_ip(7) <= agg_shift_reg_ip(6);
				agg_shift_reg_ip(6) <= agg_shift_reg_ip(5);
				agg_shift_reg_ip(5) <= agg_shift_reg_ip(4);
				agg_shift_reg_ip(4) <= agg_shift_reg_ip(3);
            agg_shift_reg_ip(3) <= agg_shift_reg_ip(2);
				agg_shift_reg_ip(2) <= agg_shift_reg_ip(1);
				agg_shift_reg_ip(1) <= agg_shift_reg_ip(0);
				agg_shift_reg_ip(0) <= ip_hdr_in;
            
        end if;
    end process;
	 
	 process(clk, reset)
    begin
        if reset = '1' then
				agg_shift_reg_udp(7) <= (others => '0');
				agg_shift_reg_udp(6) <= (others => '0');
				agg_shift_reg_udp(5) <= (others => '0');
				agg_shift_reg_udp(4) <= (others => '0');
            agg_shift_reg_udp(3) <= (others => '0');
				agg_shift_reg_udp(2) <= (others => '0');
				agg_shift_reg_udp(1) <= (others => '0');
				agg_shift_reg_udp(0) <= (others => '0');
            --data_out    <= (others => '0');
            

        elsif rising_edge(clk) then				
				agg_shift_reg_udp(7) <= agg_shift_reg_udp(6);
				agg_shift_reg_udp(6) <= agg_shift_reg_udp(5);
				agg_shift_reg_udp(5) <= agg_shift_reg_udp(4);
				agg_shift_reg_udp(4) <= agg_shift_reg_udp(3);
            agg_shift_reg_udp(3) <= agg_shift_reg_udp(2);
				agg_shift_reg_udp(2) <= agg_shift_reg_udp(1);
				agg_shift_reg_udp(1) <= agg_shift_reg_udp(0);
				agg_shift_reg_udp(0) <= udp_hdr_in;
            
        end if;
    end process;
	 
	 process(clk, reset)
	 begin
		if reset = '1' then 
			data_out    <= (others => '0');
			state <= IDLE;
			
		elsif rising_edge(clk) then
			case state is
				when IDLE =>
					if enable = '1' then
						if agg_shift_reg_udp(6) /= std_logic_vector(to_unsigned(0, 64)) then
							state <= MAC;
						end if;
					end if;
				when MAC =>
					data_out <= agg_shift_reg_mac(7);
					state <= IP;
					
				when IP  =>
					data_out <= agg_shift_reg_ip(7);
					state <= UDP;
					
				when UDP =>
					data_out <= agg_shift_reg_udp(7);
					state <= MAC;

			end case;
		 end if;
	 end process;
				 
	 --data_out <= data_out_s;

end Behavioral;
















