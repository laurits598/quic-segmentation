library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_1164.STD_LOGIC_VECTOR;
entity segmentation is
    port (
        clk          : in std_logic;
        reset        : in std_logic;
        enable       : in std_logic;
		  
		  rdy_for_packet : in std_logic;
		  rdy_to_receive : out std_logic;
		  
        mac_hdr_in   : in std_logic_vector(63 downto 0);
		  ip_hdr_in    : in std_logic_vector(63 downto 0);
		  udp_hdr_in   : in std_logic_vector(63 downto 0);
		  
		  mac_hdr_len  : in std_logic_vector(7 downto 0);
        ip_hdr_len   : in std_logic_vector(7 downto 0);
        udp_hdr_len  : in std_logic_vector(7 downto 0);
		  
		  
        mac_hdr_out  	: out std_logic_vector(63 downto 0);
        ip_hdr_out  		: out std_logic_vector(63 downto 0);
        udp_hdr_out  	: out std_logic_vector(63 downto 0);
		  
		  mac_hdr_len_out  	: out std_logic_vector(7 downto 0);
        ip_hdr_len_out  		: out std_logic_vector(7 downto 0);
        udp_hdr_len_out  	: out std_logic_vector(7 downto 0)
		  
		     
    );
end segmentation;

architecture Behavioral of segmentation is
	
	signal mac_hdr_len_s, ip_hdr_len_s, udp_hdr_len_s : std_logic_vector(7 downto 0) := (others => '0');
	
	signal mac_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
   signal  ip_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
   signal udp_hdr_out_s    : std_logic_vector(63 downto 0) := (others => '0');
	
	signal mac_hdr_in_s    : std_logic_vector(63 downto 0) := (others => '0');
   signal  ip_hdr_in_s    : std_logic_vector(63 downto 0) := (others => '0');
   signal udp_hdr_in_s    : std_logic_vector(63 downto 0) := (others => '0');
   
	signal enable_s, write_enable_s, read_enable_s : std_logic := '0'; 
	
	signal cnt_int : integer range 0 to 63;
	signal cnt_s	: std_logic_vector(15 downto 0);
	
	signal cnt_done : std_logic := '0'; 
	
	

	

begin
	
	rdy_to_receive <= cnt_done;
	
	mac_hdr_in_s 	<= mac_hdr_in;
	 ip_hdr_in_s 	<=  ip_hdr_in;
	udp_hdr_in_s	<= udp_hdr_in;
	
	mac_hdr_len_s 	<= mac_hdr_len;
	 ip_hdr_len_s	<=  ip_hdr_len;
	udp_hdr_len_s	<= udp_hdr_len;
	
	register_inst : entity work.register_controller
		port map (
			clk         	=> clk,
			reset       	=> reset,
			enable      	=> enable_s,
			read_enable 	=> read_enable_s,
			write_enable 	=> write_enable_s,
			
			mac_hdr_len 	=> mac_hdr_len_s,
			 ip_hdr_len  	=> ip_hdr_len_s,
			udp_hdr_len  	=> udp_hdr_len_s,
			
			mac_hdr_in  	=> mac_hdr_in_s,
			 ip_hdr_in  	=> ip_hdr_in_s,
			udp_hdr_in  	=> udp_hdr_in_s,
			
			mac_hdr_out 	=> mac_hdr_out,--open,
			 ip_hdr_out 	=> ip_hdr_out,--open,
			udp_hdr_out 	=> udp_hdr_out--open	
        );
	
	--counter_inst : entity work.Counter_8bit_int
	--	port map (
	--		clk	=>	clk,
	--		reset	=> reset,
	--		en 	=> enable,
	--		cnt 	=>	cnt_s
	--		);
	
	counter_inst : entity work.Counter
			port map(
				clk 		=> clk,
				reset 	=> reset,
				en			=> enable,
				--len		=> open,
				cnt		=> cnt_s
			);
	

	process(clk, reset)
   begin
		if reset = '1' then  					
			
			
		elsif rising_edge(clk) then
		
			if cnt_s = "0000000000000111" then
				cnt_done <= '1';
				enable_s <= '1';
				write_enable_s <= '1';
			elsif cnt_s = "0000000000001111" then
				write_enable_s <= '0';	
			elsif cnt_s = "0000000000011111" then
				read_enable_s <= '1';
			
			end if;
		end if;
    end process;


				

    



	 
end Behavioral;

















