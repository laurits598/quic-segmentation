library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity metadata_parser is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        enable      : in  std_logic;
        metadata_in : in  std_logic_vector(63 downto 0);

        -- Output ports for parsed metadata
        preamble        : out std_logic_vector(7 downto 0);
        total_len       : out std_logic_vector(15 downto 0);
        seg_len         : out std_logic_vector(7 downto 0);
        seg_count       : out std_logic_vector(7 downto 0);
        mac_hdr_len     : out std_logic_vector(7 downto 0);
        ip_hdr_len      : out std_logic_vector(7 downto 0);
        udp_hdr_len     : out std_logic_vector(7 downto 0)
        -- quic_hdr_form   : out std_logic;
        -- reserved_bits   : out std_logic_vector(6 downto 0)
    );
end metadata_parser;

architecture metadata_parser_arch of metadata_parser is
begin

    process(clk, reset)
    begin
        if reset = '1' then
            preamble        <= (others => '0');
            total_len       <= (others => '0');
            seg_len         <= (others => '0');
            seg_count       <= (others => '0');
            mac_hdr_len     <= (others => '0');
            ip_hdr_len      <= (others => '0');
            udp_hdr_len     <= (others => '0');
            -- quic_hdr_form   <= '0';
            -- reserved_bits   <= (others => '0');

        elsif rising_edge(clk) then
            if enable = '1' then
                preamble        <= metadata_in(63 downto 56);
                total_len       <= metadata_in(55 downto 40);
                seg_count       <= metadata_in(39 downto 32);
                mac_hdr_len     <= metadata_in(31 downto 24);
                ip_hdr_len      <= metadata_in(23 downto 16);
                udp_hdr_len     <= metadata_in(15 downto 8);
                seg_len         <= metadata_in(39 downto 32);  -- ← Temporary mapping to same as seg_count
                -- quic_hdr_form   <= metadata_in(7);
                -- reserved_bits   <= metadata_in(6 downto 0);
            end if;
        end if;
    end process;

end architecture;




