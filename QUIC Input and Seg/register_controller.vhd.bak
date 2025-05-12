library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_controller is
    port (
        clk          : in std_logic;
        reset        : in std_logic;
        enable       : in std_logic;
		  	  
        mac_hdr_in   	: in std_logic_vector(63 downto 0);
		  ip_hdr_in   		: in std_logic_vector(63 downto 0);
		  udp_hdr_in   	: in std_logic_vector(63 downto 0);
		  
		  mac_hdr_len  	: in std_logic_vector(7 downto 0);
        ip_hdr_len   	: in std_logic_vector(7 downto 0);
        udp_hdr_len  	: in std_logic_vector(7 downto 0);
		  
		 
		  read_enable, write_enable : in std_logic;
		  
        mac_hdr_out  	: out std_logic_vector(63 downto 0);
        ip_hdr_out  		: out std_logic_vector(63 downto 0);
        udp_hdr_out  	: out std_logic_vector(63 downto 0)
		  
		     
    );
end register_controller;

architecture Behavioral of register_controller is

    signal we_mac, we_ip, we_udp          : std_logic;
    
	 signal write_addr_mac, write_addr_ip, write_addr_udp : unsigned(2 downto 0); --:= (others => '0');
    
	 signal read_addr_mac, read_addr_ip, read_addr_udp   : unsigned(2 downto 0) := "111"; -- If it starts as "000", it will read too soon, bc 000 is assigned.

    signal write_done_mac, write_done_ip, write_done_udp  : std_logic := '0';
    
	 signal read_done_mac, read_done_ip, read_done_udp   : std_logic := '0';
		
		
	 signal mac_hdr_words_remaining : unsigned(7 downto 0) := (others => '0');
	 signal ip_hdr_words_remaining  : unsigned(7 downto 0) := (others => '0');
    signal udp_hdr_words_remaining : unsigned(7 downto 0) := (others => '0');
	 
	 

	 
	 

begin

    -- Enable write only during write phase
    we_mac 	<= enable when write_done_mac 	= '0' else '0';
    we_ip 	<= enable when write_done_ip 		= '0' else '0';
	 we_udp 	<= enable when write_done_udp 	= '0' else '0';
	 
    -- Instantiate MAC header register file
    mac_reg_inst : entity work.mac_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_mac,
            wr_addr  => write_addr_mac,
            rd_addr  => read_addr_mac,
            d        => mac_hdr_in,
            q        => mac_hdr_out
        );
		  
	 ip_reg_inst : entity work.ip_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_ip,
            wr_addr  => write_addr_ip,
            rd_addr  => read_addr_ip,
            d        => ip_hdr_in,
            q        => ip_hdr_out
        );
		  
	  udp_reg_inst : entity work.udp_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_udp,
            wr_addr  => write_addr_udp,
            rd_addr  => read_addr_udp,
            d        => udp_hdr_in,
            q        => udp_hdr_out
        );
		  
	 
    process(clk, reset)
    begin
        if reset = '1' then
            write_addr_mac <= (others => '0');
				mac_hdr_words_remaining  <= unsigned(mac_hdr_len) / 8;
		  elsif rising_edge(clk) then
		  
            if write_enable = '1' then

					if mac_hdr_words_remaining > 1 then
						mac_hdr_words_remaining <= mac_hdr_words_remaining - 1;
						write_addr_mac <= write_addr_mac + 1;
					else

						mac_hdr_words_remaining <= (others => '0');
						write_done_mac <= '1';
						
						
						
					end if;
					
				end if;
		  end if;
	  end process;
	  
	  process(clk, reset)
		 begin
			  if reset = '1' then
					write_addr_ip <= (others => '0');
					ip_hdr_words_remaining  <= unsigned(ip_hdr_len) / 8;

			  elsif rising_edge(clk) then
					if write_enable = '1' then
						if ip_hdr_words_remaining > 1 then
							ip_hdr_words_remaining <= ip_hdr_words_remaining - 1;
							write_addr_ip <= write_addr_ip + 1;

							
						else
							ip_hdr_words_remaining <= (others => '0');
							write_done_ip <= '1';
						end if;
						
					end if;
			  end if;
		end process;
		
		process(clk, reset)
		 begin
			  if reset = '1' then
					write_addr_udp <= (others => '0');
					udp_hdr_words_remaining  <= unsigned(udp_hdr_len) / 8;

			  elsif rising_edge(clk) then
					if write_enable = '1' then
						if udp_hdr_words_remaining > 1 then
							udp_hdr_words_remaining <= udp_hdr_words_remaining - 1;
							write_addr_udp <= write_addr_udp + 1;
						else
							udp_hdr_words_remaining <= (others => '0');
							write_done_udp <= '1';
						end if;
						
					end if;
			  end if;
		end process;	
		  
	 
end Behavioral;










