library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- <-- This is required for 'unsigned'


-- (?): I don't understand what clr_regs does.


entity segmentation_controller is
	port (
		clk      				: in std_logic;
		reset    				: in std_logic;
		enable   				: in std_logic;
		rdy_to_send				: in std_logic;
		
		rdy_mac, rdy_quic, rdy_icv, rdy_udp, rdy_ip : in std_logic;
		
		seg_len					: in unsigned(2 downto 0);
		seg_cnt					: in unsigned(2 downto 0);
		from_meta_parser		: in unsigned(2 downto 0);
		output_buffer_full 	: in std_logic;
		
		
		seg_done		: out std_logic;
		rdy_for_pld : out std_logic;							-- Goes to input_buffers "rdy_for_payload" port
		rdy			: out std_logic;							-- Goes to output_buffers "BUFF_CONTROL"
		mode			: out std_logic_vector(1 downto 0); -- Goes to output_buffers "BUFF_CONTROL"
		clr_regs 	: out std_logic;							-- Goes to segmentations hdr_agg_sft_reg
		ofpt_sel		: out std_logic							-- Goes to segmentations output_multiplexer.		Determines output from multiplexer
		
		
	);
end segmentation_controller;

architecture Behavioral of segmentation_controller is
begin 
	
end architecture;















