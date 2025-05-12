library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity autonomous_fifo is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        rd_en    : in  std_logic;
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(63 downto 0);
        full     : out std_logic;
        empty    : out std_logic
    );
end autonomous_fifo;

architecture Behavioral of autonomous_fifo is

    type memory_array is array (0 to 7) of std_logic_vector(63 downto 0);
    signal fifo      : memory_array := (others => (others => '0'));

    signal wr_ptr    : integer range 0 to 7 := 0;
    signal rd_ptr    : integer range 0 to 7 := 0;
    signal fifo_cnt  : integer range 0 to 8 := 1;

    signal dout      : std_logic_vector(63 downto 0) := (others => '0');
    signal full_int  : std_logic := '0';
    signal empty_int : std_logic := '0';
    
	 --signal rd_en_signal  : std_logic;
	 --signal wr_en_signal  : std_logic;
	 
	 signal write_cnt	: integer range 0 to 8 := 0;
	 signal total_cnt	: integer range 0 to 8 := 0;	
 
	 
	 signal read_begin : std_logic := '0';
	 
	 signal wr_en_i : std_logic := '0';  -- internal copy of wr_en
    signal rd_en_i : std_logic := '0';  -- internal copy of rd_en
	 
	
	 
	 

begin

	wr_en_i <= wr_en;
	rd_en_i <= rd_en;
	
	
		-- WRITE Process
	write_proc : process(clk)
	begin
		 if rising_edge(clk) then
			  if rst = '1' then
					wr_ptr    <= 0;
			  elsif wr_en_i = '1' and full_int = '0' then
					fifo(wr_ptr) <= data_in;
					wr_ptr <= (wr_ptr + 1) mod 8;
					
			  end if;
		 end if;
	end process;

	-- READ Process
	read_proc : process(clk)
	begin
		
		 if rising_edge(clk) then
			  if rst = '1' then
					rd_ptr <= 0;
					dout   <= (others => '0');			  
			  
			  elsif rd_en_i = '1' and empty_int = '0' then
					dout <= fifo(rd_ptr);
					rd_ptr <= (rd_ptr + 1) mod 8;
					--fifo(rd_ptr) <= (others => '0');  -- Clear that memory slot
			  end if;
		 end if;
	end process;
	
	
	fifo_cnt_proc : process(clk)
	begin
		 if rising_edge(clk) then
			  if rst = '1' then
					fifo_cnt <= 0;
			  else
					if wr_en_i = '1' and rd_en_i = '0' then
						if full_int = '0' then
                        fifo_cnt <= fifo_cnt + 1;
                    end if;
					elsif wr_en_i = '0' and rd_en_i = '1' then
						if empty_int = '0' then
                        fifo_cnt <= fifo_cnt - 1;
                    end if;
					elsif wr_en_i = '1' and rd_en_i = '1' then
						 fifo_cnt <= fifo_cnt;
					end if;
			  end if;
		 end if;
	end process;

	
	rd_en_control_proc : process(clk)
	begin
		 if rising_edge(clk) then
			  if rst = '1' then
					rd_en_i <= '0';
			  else
					if fifo_cnt = 7 then
						 rd_en_i <= '1';
					else
						 rd_en_i <= '0';
					end if;
			  end if;
		 end if;
	end process;
	
	wr_en_control_proc : process(clk)
	begin
		 if rising_edge(clk) then
			  if rst = '1' then
					wr_en_i <= '0';
			  else
					if fifo_cnt < 8 then  -- simulate writing while not full
						 wr_en_i <= '1';
					else
						 wr_en_i <= '0';
					end if;
			  end if;
		 end if;
	end process;

	
	
	
	 -- Update flags based on fifo_cnt directly
	full_int  <= '1' when fifo_cnt = 8 else '0';
	--empty_int <= '1' when fifo_cnt = 0 else '0';
	empty_int <= '0';
	
   data_out <= dout;
   full     <= full_int;
   empty    <= empty_int;

end Behavioral;







