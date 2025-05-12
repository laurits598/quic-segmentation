library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdr_shift_reg is
    Port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        enable          : in  std_logic;
        --read_addr_hdr  : in  unsigned(2 downto 0);  -- external read address selector
		  mac_hdr_in   : in std_logic_vector(63 downto 0);
		  ip_hdr_in    : in std_logic_vector(63 downto 0);
		  udp_hdr_in   : in std_logic_vector(63 downto 0);
        -- Output
        data_out       : out std_logic_vector(63 downto 0);
        data_valid     : out std_logic;
        done           : out std_logic
    );
end hdr_shift_reg;

architecture Behavioral of hdr_shift_reg is

    type state_type is (IDLE, SEND_MAC, SEND_IP, SEND_UDP, FINISH);
    signal state : state_type := IDLE;
	 
	 signal mac_hdr_out : std_logic_vector(63 downto 0);
    signal ip_hdr_out  : std_logic_vector(63 downto 0);
    signal udp_hdr_out : std_logic_vector(63 downto 0);
	 signal read_addr_hdr : unsigned(2 downto 0) := (others => '0');
	 
	 signal data_out_s : std_logic_vector(63 downto 0);
	 
	 

begin

    
    -- FSM Process
    process(clk, reset)
    begin
        if reset = '1' then
            --state       <= IDLE;
            data_out    <= (others => '0');
            data_valid  <= '0';
            done        <= '0';

        elsif rising_edge(clk) then
            -- Default signals
            data_valid <= '0';
            done       <= '0';
				
				--if enable = '1' then
					--read_addr_hdr <= read_addr_hdr + 1;
					case state is
						 when IDLE =>
							  --data_out    <= (others => '0');
							  if enable = '1' then
									state <= SEND_MAC;
							  end if;

						 when SEND_MAC =>
							  data_out   <= mac_hdr_in;
							  data_valid <= '1';
							  state      <= SEND_IP;

						 when SEND_IP =>
							  data_out   <= ip_hdr_in;
							  data_valid <= '1';
							  state      <= SEND_UDP;

						 when SEND_UDP =>
							  data_out   <= udp_hdr_in;
							  data_valid <= '1';
							  state      <= SEND_MAC;

						 when FINISH =>
							  done  <= '1';
							  state <= SEND_MAC;
							  --data_out    <= (others => '0');
						 when others =>
							  state <= IDLE;
					end case;
				--end if;
        end if;
    end process;

end Behavioral;


