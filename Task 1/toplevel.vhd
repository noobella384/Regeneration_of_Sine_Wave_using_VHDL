library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity toplevel is
port (
	   initial_comm : in std_logic;
		clk : in std_logic;
		sclk : out std_logic;
		mosi, miso : out std_logic;
		chip_select : out std_logic;
			
		master_out : out std_logic_vector(2 downto 0);
		slave_out : out std_logic_vector(2 downto 0)
		);
end entity;

architecture archi_toplevel of toplevel is
	
	component master_module is
	port (
			initial_comm : in std_logic;
			clk : in std_logic;
			chip_select :out std_logic;
			sclk : out std_logic;
			mosi : out std_logic;
			miso : in std_logic;
			master_out : out std_logic_vector(2 downto 0)
			);
	end component;
	
	component slave_module is
	port (
			chip_select :in std_logic;
			sclk : in std_logic;
			mosi : in std_logic;
			miso : out std_logic;
			slave_out : out std_logic_vector(2 downto 0)
			);
	end component;
	
	signal miso_temp, mosi_temp, chip_select_temp, sclk_temp : std_logic;
	
begin
inst1: master_module port map(initial_comm, clk, chip_select_temp, sclk_temp, mosi_temp, miso_temp, master_out);
inst2: slave_module  port map(chip_select_temp, sclk_temp, mosi_temp, miso_temp, slave_out);

sclk <= sclk_temp;
miso <= miso_temp;
mosi <= mosi_temp;
chip_select <= chip_select_temp;

end architecture;
	
