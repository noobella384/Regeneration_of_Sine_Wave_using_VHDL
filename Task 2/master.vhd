library ieee;
use ieee.std_logic_1164.all;

entity master is
	port(
		clk : in std_logic;
		reset : in std_logic;
		miso : in std_logic;
		mosi : out std_logic;
		reg_a : out std_logic_vector(9 downto 0) :="ZZZZZZZZZZ";
		sclk : out std_logic;
		cs : out std_logic	
	);
end entity;

architecture archi_master of master is

signal temp_sclk, temp_cs : std_logic;
constant divider_value : integer := 25;
signal clk_counter : integer := 0;
signal adc_initial : std_logic_vector(4 downto 0) :="11000";
signal counter_rise, counter_fall : integer :=0;

begin

clk_process : process(clk, reset)
begin
	if reset='1' then
		clk_counter <= 0;
		temp_sclk <='0';
	elsif rising_edge(clk) then
		if clk_counter = divider_value - 1 then
			temp_sclk <= NOT temp_sclk;
			clk_counter <=0;
		else
			clk_counter <= clk_counter +1;
		end if;
	end if;
end process;

communication : process(temp_sclk,reset)
begin
	if reset ='1' then
		counter_rise <=0;
		counter_fall <=0;
		reg_a <= "ZZZZZZZZZZ";
		temp_cs <= '1';
		mosi <= 'Z';
	
	else
		if rising_edge(temp_sclk) then
			if temp_cs = '0' then
				counter_rise <= counter_rise +1;
				case counter_rise is
					when 7 =>  reg_a(9) <= miso;
					when 8 =>  reg_a(8) <= miso;
					when 9 =>  reg_a(7) <= miso;
					when 10 => reg_a(6) <= miso;
					when 11 => reg_a(5) <= miso;
					when 12 => reg_a(4) <= miso;
					when 13 => reg_a(3) <= miso;
					when 14 => reg_a(2) <= miso;
					when 15 => reg_a(1) <= miso;
					when 16 => reg_a(0) <= miso;
					when others => null;
				end case;
			end if;
		
		elsif falling_edge(temp_sclk) then
			counter_fall <= counter_fall +1;
				if counter_rise < 17 then temp_cs <= '0';
				elsif counter_rise > 17 then temp_cs <= '1'; end if;
				--if counter_rise =0 then temp_cs <= '0'; end if;
				
				case counter_fall is
					when 0 => mosi <= adc_initial(4);
					when 1 => mosi <= adc_initial(3);
					when 2 => mosi <= adc_initial(2);
					when 3 => mosi <= adc_initial(1);
					when 4 => mosi <= adc_initial(0);
					when others => mosi <= '0';
					
				end case;
			end if;
		end if;
end process;

cs <= temp_cs;
sclk <= temp_sclk;

end architecture;
				
				
			
			
	

			