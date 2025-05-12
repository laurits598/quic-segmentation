library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity metadata_parser_tb is
end metadata_parser_tb;

architecture metadata_parser_tb_arch of metadata_parser_tb is

    component metadata_parser is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            enable      : in std_logic;
            metadata_in : in std_logic_vector(63 downto 0);
            
            preamble        : out std_logic_vector(7 downto 0);
            total_len       : out std_logic_vector(15 downto 0);
            seg_len         : out std_logic_vector(7 downto 0);
            seg_count       : out std_logic_vector(7 downto 0);
            mac_hdr_len     : out std_logic_vector(7 downto 0);
            ip_hdr_len      : out std_logic_vector(7 downto 0);
            udp_hdr_len     : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals
    signal clk           : std_logic;
    signal reset         : std_logic;
    signal enable        : std_logic;
    signal metadata_in   : std_logic_vector(63 downto 0);

    signal preamble      : std_logic_vector(7 downto 0);
    signal total_len     : std_logic_vector(15 downto 0);
    signal seg_len       : std_logic_vector(7 downto 0);
    signal seg_count     : std_logic_vector(7 downto 0);
    signal mac_hdr_len   : std_logic_vector(7 downto 0);
    signal ip_hdr_len    : std_logic_vector(7 downto 0);
    signal udp_hdr_len   : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- UUT instantiation
    uut: metadata_parser
        port map (
            clk           => clk,
            reset         => reset,
            enable        => enable,
            metadata_in   => metadata_in,

            preamble      => preamble,
            total_len     => total_len,
            seg_len       => seg_len,
            seg_count     => seg_count,
            mac_hdr_len   => mac_hdr_len,
            ip_hdr_len    => ip_hdr_len,
            udp_hdr_len   => udp_hdr_len
        );

    -- Stimulus
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        enable <= '0';
        wait for 20 ns;

        reset <= '0';
        wait for clk_period;

        -- Apply test vector
        enable <= '1';
        metadata_in <= x"AB1234080E140880";  -- example 64-bit packet

        wait for 50 ns;

        enable <= '0';
        wait;
    end process;

end architecture;
