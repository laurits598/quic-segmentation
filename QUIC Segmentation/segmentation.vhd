library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity segmentation is
    port (
        clk          : in std_logic;
        reset        : in std_logic;
        enable       : in std_logic;
		  	  
        mac_hdr_in   : in std_logic_vector(63 downto 0);
		  ip_hdr_in   : in std_logic_vector(63 downto 0);
		  udp_hdr_in   : in std_logic_vector(63 downto 0);
		  quic_hdr_in   : in std_logic_vector(63 downto 0);
		  
		  mac_hdr_len  : in std_logic_vector(7 downto 0);
        ip_hdr_len  : in std_logic_vector(7 downto 0);
        udp_hdr_len  : in std_logic_vector(7 downto 0);
        quic_hdr_len  : in std_logic_vector(7 downto 0);
		  
		  
        mac_hdr_out  : out std_logic_vector(63 downto 0);
        ip_hdr_out  : out std_logic_vector(63 downto 0);
        udp_hdr_out  : out std_logic_vector(63 downto 0);
        quic_hdr_out  : out std_logic_vector(63 downto 0)
		  
		     
    );
end segmentation;

architecture Behavioral of segmentation is

    signal we_quic, we_mac, we_ip, we_udp          : std_logic;
    signal write_addr_quic, write_addr_mac, write_addr_ip, write_addr_udp : unsigned(2 downto 0) := (others => '0');
    signal read_addr_quic, read_addr_mac, read_addr_ip, read_addr_udp   : unsigned(2 downto 0) := "111"; -- If it starts as "000", it will read too soon, bc 000 is assigned.

    signal write_done_mac, write_done_ip, write_done_udp, write_done_quic   : std_logic := '0';
    signal read_done_mac, read_done_ip, read_done_udp, read_done_quic   : std_logic := '0';

    type state_type is (IDLE, WRITE_E, READ_E);
    signal fsm_state_mac, fsm_state_ip, fsm_state_udp, fsm_state_quic : state_type := IDLE;
	 
	 
	 
	 

begin

    -- Enable write only during write phase
    we_mac <= enable when write_done_mac = '0' else '0';
    we_ip <= enable when write_done_ip = '0' else '0';
	 we_udp <= enable when write_done_udp = '0' else '0';
    we_quic <= enable when write_done_quic = '0' else '0';
	 
	 
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
		  
		quic_reg_inst : entity work.quic_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_quic,
            wr_addr  => write_addr_quic,
            rd_addr  => read_addr_quic,
            d        => quic_hdr_in,
            q        => quic_hdr_out
        );
		  
		  

    process(clk, reset)
    begin
        if reset = '1' then
            fsm_state_mac <= IDLE;
        elsif rising_edge(clk) then
            case fsm_state_mac is
                when WRITE_E =>
                    if write_addr_mac = "111" then  -- 011 address 3 = 4th write.   100: 5, 101: 6, 110: 7, 111. 
								
								--write_addr <= "000";
								write_done_mac <= '1';
                        read_addr_mac  <= read_addr_mac + 1;
                        fsm_state_mac <= READ_E;
                    else
                        write_addr_mac <= write_addr_mac + 1;
                    end if;

                when READ_E =>
						  if read_addr_mac = "111" then
								read_done_mac <= '1';
							   fsm_state_mac <= IDLE;
						  else 
							   read_addr_mac <= read_addr_mac + 1;
						  end if;
						  
                when others =>
                    write_done_mac  <= '0';
                    fsm_state_mac <= WRITE_E;
            end case;
        end if;
    end process;
	 
	 process(clk, reset)
    begin
        if reset = '1' then
            fsm_state_ip <= IDLE;
        elsif rising_edge(clk) then
            case fsm_state_ip is
                when WRITE_E =>
                    if write_addr_ip = "111" then  -- 011 address 3 = 4th write.   100: 5, 101: 6, 110: 7, 111. 
								
								--write_addr <= "000";
								write_done_ip <= '1';
                        read_addr_ip  <= read_addr_ip + 1;
                        fsm_state_ip <= READ_E;
                    else
                        write_addr_ip <= write_addr_ip + 1;
                    end if;

                when READ_E =>
						  if read_addr_ip = "111" then
								read_done_ip <= '1';
							   fsm_state_ip <= IDLE;
						  else 
							   read_addr_ip <= read_addr_ip + 1;
						  end if;
						  
                when others =>
                    write_done_ip  <= '0';
                    fsm_state_ip <= WRITE_E;
            end case;
        end if;
    end process;
	 
	 process(clk, reset)
    begin
        if reset = '1' then
            fsm_state_udp <= IDLE;
        elsif rising_edge(clk) then
            case fsm_state_udp is
                when WRITE_E =>
                    if write_addr_udp = "111" then  -- 011 address 3 = 4th write.   100: 5, 101: 6, 110: 7, 111. 
                        
                        --write_addr <= "000";
                        write_done_udp <= '1';
                        read_addr_udp  <= read_addr_udp + 1;
                        fsm_state_udp <= READ_E;
                    else
                        write_addr_udp <= write_addr_udp + 1;
                    end if;

                when READ_E =>
                    if read_addr_udp = "111" then
                        read_done_udp <= '1';
                        fsm_state_udp <= IDLE;
                    else 
                        read_addr_udp <= read_addr_udp + 1;
                    end if;
                          
                when others =>
                    write_done_udp  <= '0';
                    fsm_state_udp <= WRITE_E;
            end case;
        end if;
    end process;
	 
	 process(clk, reset)
    begin
        if reset = '1' then
            fsm_state_quic <= IDLE;
        elsif rising_edge(clk) then
            case fsm_state_quic is
                when WRITE_E =>
                    if write_addr_quic = "111" then  -- 011 address 3 = 4th write.   100: 5, 101: 6, 110: 7, 111. 
                        
                        --write_addr <= "000";
                        write_done_quic <= '1';
                        read_addr_quic  <= read_addr_quic + 1;
                        fsm_state_quic <= READ_E;
                    else
                        write_addr_quic <= write_addr_quic + 1;
                    end if;

                when READ_E =>
                    if read_addr_quic = "111" then
                        read_done_quic <= '1';
                        fsm_state_quic <= IDLE;
                    else 
                        read_addr_quic <= read_addr_quic + 1;
                    end if;
                          
                when others =>
                    write_done_quic  <= '0';
                    fsm_state_quic <= WRITE_E;
            end case;
        end if;
    end process;
	 
end Behavioral;










