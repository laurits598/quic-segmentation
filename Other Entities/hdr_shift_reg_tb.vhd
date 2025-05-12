library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdr_shift_reg_tb is
end hdr_shift_reg_tb;


architecture Behavioral of hdr_shift_reg_tb is

    -- Clock and reset
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '1';
    signal enable      : std_logic := '0';
    signal data_valid  : std_logic;
    signal done        : std_logic;
    signal data_out    : std_logic_vector(63 downto 0);
	
	 
	
    signal read_addr_hdr : unsigned(2 downto 0) := "000";

    -- Internal connections to registers
    signal mac_hdr_out, ip_hdr_out, udp_hdr_out : std_logic_vector(63 downto 0);

    -- Register file interface (write side)
    signal we_mac, we_ip, we_udp : std_logic := '0';
    signal wr_addr_mac, wr_addr_ip, wr_addr_udp : unsigned(2 downto 0) := (others => '0');
    signal d_mac, d_ip, d_udp : std_logic_vector(63 downto 0) := (others => '0');
	 
	 
	 constant clk_period : time := 10 ns;
	 
	 
	 type packet_array is array (0 to 4) of std_logic_vector(63 downto 0);
	 constant packets1 : packet_array := (
	 	 0  => x"0000000000000001",
	 	 1  => x"0000000000000002",
	 	 2  => x"0000000000000003",
	 	 3  => x"0000000000000004",
	 	 4  => x"0000000000000005"
		);
		
		constant packets2 : packet_array := (
	 	 0  => x"0000000000000006",
	 	 1  => x"0000000000000007",
	 	 2  => x"0000000000000008",
	 	 3  => x"0000000000000009",
	 	 4  => x"000000000000000A"
		);
		constant packets3 : packet_array := (
	 	 0  => x"000000000000000B",
	 	 1  => x"000000000000000C",
	 	 2  => x"000000000000000D",
	 	 3  => x"000000000000000E",
	 	 4  => x"000000000000000F"
		);
		
		
		
		
		constant mac_packet : packet_array := packets1;
		constant ip_packet  : packet_array := packets2;
		constant udp_packet : packet_array := packets3;

	 	
	 

begin

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period;
            clk <= '1';
            wait for clk_period;
        end loop;
    end process;

    -- Instantiate MAC header register
    mac_inst : entity work.mac_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_mac,
            wr_addr  => wr_addr_mac,
            rd_addr  => read_addr_hdr,
            d        => d_mac,
            q        => mac_hdr_out
        );

    -- Instantiate IP header register
    ip_inst : entity work.ip_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_ip,
            wr_addr  => wr_addr_ip,
            rd_addr  => read_addr_hdr,
            d        => d_ip,
            q        => ip_hdr_out
        );

    -- Instantiate UDP header register
    udp_inst : entity work.udp_hdr_reg_8x64
        port map (
            clk      => clk,
            rst      => reset,
            we       => we_udp,
            wr_addr  => wr_addr_udp,
            rd_addr  => read_addr_hdr,
            d        => d_udp,
            q        => udp_hdr_out
        );

    -- Instantiate the hdr_shift_reg under test
    dut : entity work.hdr_shift_reg
        port map (
            clk           => clk,
            reset         => reset,
            enable         => enable,
            mac_hdr_in    => mac_hdr_out,
				ip_hdr_in     => ip_hdr_out,
				udp_hdr_in    => udp_hdr_out,
            data_out      => data_out,
            data_valid    => data_valid,
            done          => done
        );
		  
	

    -- Test procedure
    stim_proc : process
    begin
        -- Hold reset
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;
			
		  --enable <= '1';
        -- Write headers into registers at address 0
        wr_addr_mac <= "000";
        wr_addr_ip  <= "000";
        wr_addr_udp <= "000";

        --d_mac <= x"AA_BB_CC_DD_00_11_22_33";
        --d_ip  <= x"C0_A8_01_01_08_00_45_00";
        --d_udp <= x"12_34_00_00_00_08_00_00";
		  we_mac <= '1';
        we_ip  <= '1';
        we_udp <= '1';
			
			for i in 0 to 4 loop
				d_mac <= mac_packet(i);
				d_ip <= ip_packet(i);
				d_udp <= udp_packet(i);
				
				if i = 0 then
					wr_addr_mac <= "000";
				   wr_addr_ip  <= "000";
				   wr_addr_udp <= "000";
					wait for 2 * clk_period;
				else
					wr_addr_mac <= wr_addr_mac + 1;
					wr_addr_ip <= wr_addr_ip + 1;
					wr_addr_udp <= wr_addr_udp + 1;
					wait for 2 * clk_period;
				end if;
			end loop;
		
		
		  
        we_mac <= '0';
        we_ip  <= '0';
        we_udp <= '0';
		  enable <= '1';
		  
		  
        wait for 2 * clk_period;
		  
		  
		  for i in 0 to 4 loop
				read_addr_hdr <= read_addr_hdr + 1;
				
				if i = 0 then
					read_addr_hdr <= "000";
					wait for 2 * clk_period;
				else
					read_addr_hdr <= read_addr_hdr + 1;
					wait for 2 * clk_period;
				end if;
				
				
				wait for 2 * clk_period;
		  end loop;
        
		  
		  
		  
		  
		  wait for clk_period;
        --enable <= '0';

        -- Wait for done
        wait until done = '1';
        wait for clk_period;

        -- End simulation
        assert false report "Simulation finished." severity note;
        wait;
    end process;

end Behavioral;





