library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity slave_module is
port(
		chip_select :in std_logic;
		sclk : in std_logic;
		mosi : in std_logic;
		miso : out std_logic :='Z';
		slave_out : out std_logic_vector(2 downto 0)
	);
end entity;

architecture archi_slave_module of slave_module is
	signal buffer_data :std_logic_vector(2 downto 0) :="ZZZ";
	signal required_outp : std_logic_vector(2 downto 0) :="101";
	
	signal miso_error : std_logic := required_outp(2);
	type state is (initial,s1,s2,s3,s4);
	signal s_present, s_next : state:= initial;
	
	begin
	
	receiving : process(chip_select, sclk)
	begin
		if rising_edge(sclk) then
			case s_present is
				when initial =>
					if chip_select <='0' then
						s_next <=s1;
					else
						s_next <= initial;
					end if;
				when s1 =>
					buffer_data(2) <= mosi;
					s_next <=s2;
				
				when s2 =>
					buffer_data(1) <= mosi;
					s_next <=s3;
				
				when s3 =>
					buffer_data(0) <= mosi;
					s_next <=s4;
				
				when s4 => s_next <= s4;
			end case;
		end if;
	end process;
	
	sending : process(sclk)
	begin
	
		if falling_edge(sclk) then
			miso <= miso_error;
			case s_present is
				when s1 =>
					miso_error <= required_outp(1);
				when s2 =>
					miso_error <= required_outp(0);
				when others => null;
			end case;
		end if;
	end process;
	
	print : process(s_next)
	begin
		s_present <= s_next;
		slave_out <= buffer_data;
	end process;
	
end architecture;