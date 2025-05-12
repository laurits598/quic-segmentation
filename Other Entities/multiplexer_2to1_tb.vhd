library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexer_2to1_tb is
end multiplexer_2to1_tb;

architecture Behavioral of multiplexer_2to1_tb is
    -- Component Declaration
    component multiplexer_2to1
        port (
            sel      : in std_logic;
            hdr_data_in, payload_data_in : in std_logic_vector(63 downto 0);
            data_out  : out std_logic_vector(63 downto 0)
        );
    end component;

    -- Signals for Simulation
    signal sel      : std_logic := '0';
    signal hdr_data_in : std_logic_vector(63 downto 0) := x"1234567890ABCDEF";
    signal payload_data_in : std_logic_vector(63 downto 0) := x"FEDCBA0987654321";
    signal data_out : std_logic_vector(63 downto 0);

begin
    -- Instantiate Multiplexer
    uut: multiplexer_2to1 port map (
        sel      => sel,
        hdr_data_in => hdr_data_in,
        payload_data_in => payload_data_in,
        data_out  => data_out
    );

    
    -- Test Sequence
    stimulus_process: process
    begin
        -- Test with sel = '0'
        sel <= '0';
        wait for 20 ns;

        -- Test with sel = '1'
        sel <= '1';
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;




