library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_controller is
    port (
        clk          : in std_logic;
        reset        : in std_logic;
        enable       : in std_logic;

        mac_hdr_in   : in std_logic_vector(63 downto 0);
        ip_hdr_in    : in std_logic_vector(63 downto 0);
        udp_hdr_in   : in std_logic_vector(63 downto 0);

        mac_hdr_len  : in std_logic_vector(7 downto 0);
        ip_hdr_len   : in std_logic_vector(7 downto 0);
        udp_hdr_len  : in std_logic_vector(7 downto 0);

        read_enable, write_enable : in std_logic;

        mac_hdr_out  : out std_logic_vector(63 downto 0);
        ip_hdr_out   : out std_logic_vector(63 downto 0);
        udp_hdr_out  : out std_logic_vector(63 downto 0)
    );
end register_controller;

architecture Behavioral of register_controller is

    signal we_mac, we_ip, we_udp : std_logic;

    signal write_addr_mac, write_addr_ip, write_addr_udp : unsigned(2 downto 0) := (others => '0');
    signal read_addr_mac, read_addr_ip, read_addr_udp   : unsigned(2 downto 0) := (others => '0');

    signal write_done_mac, write_done_ip, write_done_udp : std_logic := '0';
    signal read_done_mac, read_done_ip, read_done_udp    : std_logic := '0';

    signal mac_hdr_words_remaining        : unsigned(7 downto 0) := (others => '0');
    signal ip_hdr_words_remaining         : unsigned(7 downto 0) := (others => '0');
    signal udp_hdr_words_remaining        : unsigned(7 downto 0) := (others => '0');
    signal mac_hdr_words_remaining_read   : unsigned(7 downto 0) := (others => '0');
    signal ip_hdr_words_remaining_read    : unsigned(7 downto 0) := (others => '0');
    signal udp_hdr_words_remaining_read   : unsigned(7 downto 0) := (others => '0');
    

    
    type state_type is (IDLE, WRITE_E, READ_E);
    signal fsm_state_mac, fsm_state_ip, fsm_state_udp : state_type := IDLE;

	 
	 
	 
	 
begin

    -- Enable write only during write phase
    we_mac <= enable when write_done_mac = '0' else '0';
    we_ip  <= enable when write_done_ip  = '0' else '0';
    we_udp <= enable when write_done_udp = '0' else '0';
    

	 
    -- Instantiate MAC header register file
    mac_reg_inst : entity work.hdr_reg_8x64
        port map (
            clk     => clk,
            rst     => reset,
            we      => we_mac,
            wr_addr => write_addr_mac,
            rd_addr => read_addr_mac,
            d       => mac_hdr_in,
            q       => mac_hdr_out
        );

    ip_reg_inst : entity work.hdr_reg_8x64
        port map (
            clk     => clk,
            rst     => reset,
            we      => we_ip,
            wr_addr => write_addr_ip,
            rd_addr => read_addr_ip,
            d       => ip_hdr_in,
            q       => ip_hdr_out
        );

    udp_reg_inst : entity work.hdr_reg_8x64
        port map (
            clk     => clk,
            rst     => reset,
            we      => we_udp,
            wr_addr => write_addr_udp,
            rd_addr => read_addr_udp,
            d       => udp_hdr_in,
            q       => udp_hdr_out
        );
	
    process(clk, reset)
    begin
        if reset = '1' then
            mac_hdr_words_remaining <= unsigned(mac_hdr_len) / 8;
            mac_hdr_words_remaining_read <= unsigned(mac_hdr_len) / 8;
            read_addr_mac <= "111";
            write_done_mac <= '0';
        elsif rising_edge(clk) then
            case fsm_state_mac is
                when WRITE_E =>
                    if mac_hdr_words_remaining > 1 then
								write_addr_mac <= write_addr_mac + 1;
                        mac_hdr_words_remaining <= mac_hdr_words_remaining - 1;
                    else
                        write_addr_mac <= write_addr_mac + 1;
                        write_done_mac <= '1';
                    end if;

                when READ_E =>
                    if mac_hdr_words_remaining_read > 1 then
                        mac_hdr_words_remaining_read <= mac_hdr_words_remaining_read - 1;
                        read_addr_mac <= read_addr_mac + 1;
                    else
                        read_addr_mac <= read_addr_mac + 1;
                        read_done_mac <= '1';
                    end if;

                when others =>
            end case;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            ip_hdr_words_remaining <= unsigned(ip_hdr_len) / 8;
            ip_hdr_words_remaining_read <= unsigned(ip_hdr_len) / 8;
            read_addr_ip <= "111";
            write_done_ip <= '0';
        elsif rising_edge(clk) then
            case fsm_state_ip is
                when WRITE_E =>
                    if ip_hdr_words_remaining > 1 then
                        ip_hdr_words_remaining <= ip_hdr_words_remaining - 1;
                        write_addr_ip <= write_addr_ip + 1;
                    else
                        write_addr_ip <= write_addr_ip + 1;
                        write_done_ip <= '1';
                    end if;

                when READ_E =>
                    if ip_hdr_words_remaining_read > 1 then
                        ip_hdr_words_remaining_read <= ip_hdr_words_remaining_read - 1;
                        read_addr_ip <= read_addr_ip + 1;
                    else
                        read_addr_ip <= read_addr_ip + 1;
                        read_done_ip <= '1';
                    end if;

                when others =>
            end case;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            udp_hdr_words_remaining <= unsigned(udp_hdr_len) / 8;
            udp_hdr_words_remaining_read <= unsigned(udp_hdr_len) / 8;
            read_addr_udp <= "111";
            write_done_udp <= '0';
        elsif rising_edge(clk) then
            case fsm_state_udp is
                when WRITE_E =>
                    if udp_hdr_words_remaining > 1 then
                        udp_hdr_words_remaining <= udp_hdr_words_remaining - 1;
                        write_addr_udp <= write_addr_udp + 1;
                    else
                        write_addr_udp <= write_addr_udp + 1;
                        write_done_udp <= '1';
                    end if;

                when READ_E =>
                    if udp_hdr_words_remaining_read > 1 then
                        udp_hdr_words_remaining_read <= udp_hdr_words_remaining_read - 1;
                        read_addr_udp <= read_addr_udp + 1;
                    else
                        read_addr_udp <= read_addr_udp + 1;
                        read_done_udp <= '1';
                    end if;

                when others =>
            end case;
        end if;
    end process;

    process(clk, write_enable)
    begin
        if write_enable = '1' then
            fsm_state_mac <= WRITE_E;
            fsm_state_ip  <= WRITE_E;
            fsm_state_udp <= WRITE_E;
	    

        elsif read_enable = '1' then
            fsm_state_mac <= READ_E;
            fsm_state_ip  <= READ_E;
            fsm_state_udp <= READ_E;

        elsif rising_edge(clk) then
            if write_enable = '1' then
                fsm_state_mac <= WRITE_E;
                fsm_state_ip  <= WRITE_E;
                fsm_state_udp <= WRITE_E;

            elsif read_enable = '1' then
                fsm_state_mac <= READ_E;
                fsm_state_ip  <= READ_E;
                fsm_state_udp <= READ_E;
            end if;
        end if;
    end process;

end Behavioral;
