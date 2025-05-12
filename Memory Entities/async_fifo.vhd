library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity async_fifo is
    Port (
        wr_clk   : in  std_logic;
        rd_clk   : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        rd_en    : in  std_logic;
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(63 downto 0);
        full     : out std_logic;
        empty    : out std_logic
    );
end async_fifo;

architecture Behavioral of async_fifo is

    type mem_array is array (0 to 7) of std_logic_vector(63 downto 0);
    signal mem : mem_array := (others => (others => '0'));

    signal wr_ptr_bin : unsigned(2 downto 0) := (others => '0');
    signal rd_ptr_bin : unsigned(2 downto 0) := (others => '0');

    signal wr_ptr_gray : unsigned(2 downto 0);
    signal rd_ptr_gray : unsigned(2 downto 0);

    signal wr_ptr_gray_sync : unsigned(2 downto 0) := (others => '0');
    signal rd_ptr_gray_sync : unsigned(2 downto 0) := (others => '0');

    signal dout : std_logic_vector(63 downto 0) := (others => '0');

    -- Synthesis-safe versions of status flags
    signal full_int  : std_logic := '0';
    signal empty_int : std_logic := '1';

    -- Convert binary to gray
    function bin2gray(b : unsigned) return unsigned is
    begin
        return b xor (b srl 1);
    end function;

    -- Convert gray to binary
    function gray2bin(g : unsigned) return unsigned is
        variable b : unsigned(g'range);
    begin
        b(g'high) := g(g'high);
        for i in g'high-1 downto g'low loop
            b(i) := g(i) xor b(i+1);
        end loop;
        return b;
    end function;

begin

    -- Write logic
    process(wr_clk)
    begin
        if rising_edge(wr_clk) then
		  
            if rst = '1' then
                wr_ptr_bin  <= (others => '0');
                wr_ptr_gray <= (others => '0');
					 
            elsif wr_en = '1' and full_int = '0' then
                mem(to_integer(wr_ptr_bin)) <= data_in;
                wr_ptr_bin  <= wr_ptr_bin + 1;
                wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
					 
            end if;
        end if;
    end process;

    -- Read logic
    process(rd_clk)
    begin
        if rising_edge(rd_clk) then
		  
            if rst = '1' then
                rd_ptr_bin  <= (others => '0');
                rd_ptr_gray <= (others => '0');
                dout <= (others => '0');
					 
            --elsif rd_en = '1' and empty_int = '0' then
				elsif full_int = '0' then
                dout <= mem(to_integer(rd_ptr_bin));
                rd_ptr_bin  <= rd_ptr_bin + 1;
                rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
					 
            end if;
        end if;
    end process;

    data_out <= dout;

    -- Pointer synchronization (1-stage for simplicity; 2-stage recommended in real designs)
    process(wr_clk)
    begin
        if rising_edge(wr_clk) then
            rd_ptr_gray_sync <= rd_ptr_gray;
        end if;
    end process;

    process(rd_clk)
    begin
        if rising_edge(rd_clk) then
            wr_ptr_gray_sync <= wr_ptr_gray;
        end if;
    end process;

    -- Status flags logic
    full_int  <= '1' when (bin2gray(wr_ptr_bin + 1) = rd_ptr_gray_sync) else '0';
    empty_int <= '1' when (wr_ptr_gray_sync = rd_ptr_gray) else '0';

    full  <= full_int;
    empty <= empty_int;

end Behavioral;




