library ieee;
use ieee.std_logic_1164.all;


entity testbench is
end entity;

architecture archi_testbench of testbench is

	component toplevel is
	port (
			initial_comm : in std_logic;
			clk : in std_logic;
			sclk : out std_logic;
			mosi, miso : out std_logic;
			chip_select : out std_logic;
			
			master_out : out std_logic_vector(2 downto 0);
			slave_out : out std_logic_vector(2 downto 0)
	
			);
	end component;
	
	signal initial_comm, sclk : std_logic := '1';
	signal clk : std_logic := '0';
	signal miso,mosi,chip_select : std_logic;
	
	signal master_out, slave_out : std_logic_vector( 2 downto 0);
	
	constant clk_proc : time := 100 ns;
	
begin
inst1: toplevel port map(initial_comm, clk, sclk, mosi, miso, chip_select, master_out, slave_out);

clock_process : process
begin
 clk <= not clk after clk_proc /2;
 wait for clk_proc /2;
 end process;
end architecture;
		
