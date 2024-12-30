library ieee;
use ieee.std_logic_1164.all;

entity master is
	port(
		clk : in std_logic;
		reset : in std_logic;
		miso : in std_logic;
		mosi : out std_logic;
		reg_a : out std_logic_vector(9 downto 0) :="1101000111";
		sclk : out std_logic;
		cs : out std_logic;
	
		mosi_dac : out std_logic;
		cs_dac : out std_logic;
		sclk_dac : out std_logic
	);
end entity;

architecture archi_master of master is

signal temp_sclk, temp_cs,temp_cs_dac : std_logic;
constant divider_value : integer := 25;
signal clk_counter : integer := 0;
signal adc_initial : std_logic_vector(4 downto 0) :="11000";
signal counter_rise, counter_fall,counter_dac : integer :=0;
signal temp_reg : std_logic_vector(9 downto 0):="0101101111";

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
		temp_cs <= '1';
		temp_cs_dac <='1';
		mosi <= 'Z';
		mosi_dac <='Z';
	
	else

		if rising_edge(temp_sclk) then
			counter_rise <= counter_rise +1;

			if temp_cs = '0' then
				case counter_rise is
					when 7 =>  temp_reg(9) <= miso;
					when 8 =>  temp_reg(8) <= miso;
					when 9 =>  temp_reg(7) <= miso;
					when 10 => temp_reg(6) <= miso;
					when 11 => temp_reg(5) <= miso;
					when 12 => temp_reg(4) <= miso;
					when 13 => temp_reg(3) <= miso;
					when 14 => temp_reg(2) <= miso;
					when 15 => temp_reg(1) <= miso;
					when 16 => temp_reg(0) <= miso;
--					when 34 => counter_rise <=0;
					when others => null;
				end case;
			end if;
		
		elsif falling_edge(temp_sclk) then
			counter_fall <= counter_fall +1;
				if counter_rise < 17 then temp_cs <= '0'; temp_cs_dac <= '1';
				elsif counter_rise > 17 then temp_cs <= '1'; end if;
				
				if counter_fall>17 then temp_cs_dac <='0';
				elsif counter_fall>33 then temp_cs_dac <='1'; end if;
				--if counter_rise =0 then temp_cs <= '0'; end if;
				
				case counter_fall is
					when 0 => mosi <= adc_initial(4); 
					when 1 => mosi <= adc_initial(3); 
					when 2 => mosi <= adc_initial(2);
					when 3 => mosi <= adc_initial(1);
					when 4 => mosi <= adc_initial(0);
					
					when 18 => mosi_dac <= '0';
					when 19 => mosi_dac <= '1';
					when 20 => mosi_dac <= '1';
					when 21 => mosi_dac <= '1';
					when 22 => mosi_dac <= temp_reg(9);
					when 23 => mosi_dac <= temp_reg(8);
					when 24 => mosi_dac <= temp_reg(7);
					when 25 => mosi_dac <= temp_reg(6);
					when 26 => mosi_dac <= temp_reg(5);
					when 27 => mosi_dac <= temp_reg(4);
					when 28 => mosi_dac <= temp_reg(3);
					when 29 => mosi_dac <= temp_reg(2);
					when 30 => mosi_dac <= temp_reg(1);
					when 31 => mosi_dac <= temp_reg(0);
					when 32 => mosi_dac <= '1';
					when 33 => mosi_dac <= '1';
								  
					when others => mosi <= '0';
					
					
				end case;
			end if;
		
		end if;
		if counter_fall = 34 or counter_rise = 34 then
			counter_rise <=0;
			counter_fall <=0;
		end if;
end process;

cs <= temp_cs;
sclk <= temp_sclk;
cs_dac <= temp_cs_dac;
sclk_dac <=temp_sclk;
reg_a <=temp_reg;

end architecture;