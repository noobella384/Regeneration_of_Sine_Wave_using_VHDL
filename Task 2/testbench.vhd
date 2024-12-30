library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture archi_testbench of testbench is

component master is
	port(
		clk : in std_logic;
		reset : in std_logic;
		miso : in std_logic;
		mosi : out std_logic;
		reg_a : out std_logic_vector(9 downto 0) :="ZZZZZZZZZZ";
		sclk : out std_logic;
		cs : out std_logic	
	);
end component;

signal temp_sclk : std_logic;
signal temp_mosi,temp_cs : std_logic;
signal temp_reg_a : std_logic_vector(9 downto 0);
signal reset,clk : std_logic:='0';
signal miso : std_logic;
constant clock_period : time := 20 ns;
begin
miso<='1';
inst1: master port map (clk, reset, miso, temp_mosi, temp_reg_a, temp_sclk, temp_cs);

clock_process: process
begin
clk <= not clk after clock_period/2;
wait for clock_period/2;
end process;

reset_process: process
begin
	reset <= '1';
	wait for 10 ns;
	reset <='0';
	wait;
end process;
end architecture;

