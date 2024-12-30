library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity master_module is
port(
		initial_comm : in std_logic;
		clk : in std_logic;
		chip_select :out std_logic := '1';
		sclk : out std_logic;
		mosi : out std_logic :='Z';
		miso : in std_logic;
		master_out : out std_logic_vector(2 downto 0)

	);
end entity;

architecture archi_master_module of master_module is
	signal buffer_data :std_logic_vector(2 downto 0) :="ZZZ";
	signal required_outp : std_logic_vector(2 downto 0) :="111";
	
	type state is (initial, s1,s2,s3,s4);
	signal s_present, s_next : state:= initial;
	
	begin
	sclk <= clk;
	
	receiving : process(initial_comm, clk)
	begin
		if rising_edge(clk) then
			case s_present is
				when initial =>
					if initial_comm = '1' then
						s_next <=s1;
						chip_select <='0';
					else
						s_next <= initial;
						chip_select <= '1';
					end if;
				when s1 =>
					buffer_data(2) <= miso;
					s_next <=s2;
				
				when s2 =>
					buffer_data(1) <= miso;
					s_next <=s3;
				
				when s3 =>
					buffer_data(0) <= miso;
					s_next <=s4;
				
				when s4 =>
					chip_select <= '1';
			end case;
		end if;
	end process;
	
	sending : process(clk)
	begin
	
		if falling_edge(clk) then
			mosi <=required_outp(2);
			case s_present is
				when s1 =>
					mosi <= required_outp(1);
				when s2 =>
					mosi <= required_outp(0);
				when others => null;
			end case;
		end if;
	end process;
	
	print : process(s_next)
	begin
		s_present <= s_next;
		master_out <= buffer_data;
	end process;
	
end architecture;