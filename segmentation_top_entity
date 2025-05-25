library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity segmentation_top_entity is
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

        mac_hdr_out  : out std_logic_vector(63 downto 0);
        ip_hdr_out   : out std_logic_vector(63 downto 0);
        udp_hdr_out  : out std_logic_vector(63 downto 0);

        mac_hdr_len_out : out std_logic_vector(7 downto 0);
        ip_hdr_len_out  : out std_logic_vector(7 downto 0);
        udp_hdr_len_out : out std_logic_vector(7 downto 0)
    );
end segmentation_top_entity;

architecture Behavioral of segmentation_top_entity is

begin

    seg_inst : entity work.segmentation
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            rdy_for_packet => rdy_for_packet,
            rdy_to_receive => rdy_to_receive,

            mac_hdr_in => mac_hdr_in,
            ip_hdr_in => ip_hdr_in,
            udp_hdr_in => udp_hdr_in,

            mac_hdr_len => mac_hdr_len,
            ip_hdr_len => ip_hdr_len,
            udp_hdr_len => udp_hdr_len,

            mac_hdr_out => mac_hdr_out,
            ip_hdr_out => ip_hdr_out,
            udp_hdr_out => udp_hdr_out,

            mac_hdr_len_out => mac_hdr_len_out,
            ip_hdr_len_out => ip_hdr_len_out,
            udp_hdr_len_out => udp_hdr_len_out
        );

end Behavioral;
