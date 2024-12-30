library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity test is
	port( 
--	clk_slow		: in std_logic;
		  inp 			: in std_logic_vector(9 downto 0);
		  clk			: in  std_logic;
		  rst 			: in  std_logic;
		  lcd_rw 		: out std_logic;                         	--read & write control
     	  lcd_en 		: out std_logic;                         	--enable control
          lcd_rs 		: out std_logic;                         	--data or command control
          lcd1  		: out std_logic_vector(7 downto 0);			--see pin planning in krypton manual 
--		  b11 			: out std_logic;
--		  b12 			: out std_logic;
		  detect 		: out std_logic
		  );
end entity;	

architecture behave of test is

--  LCD Interfacing signals
	signal erase 		: std_logic := '0';                  
	signal put_char 	: std_logic := '1';
	signal write_data 	: std_logic_vector(7 downto 0)  := "00000000";
	signal write_row 	: std_logic_vector( 0 downto 0) := "0";
	signal write_column : std_logic_vector(3 downto 0) := "0000";
	signal ack 			: std_logic;
	signal i 			: integer := 0;
	
-- covid_det signals
	signal ascii_value	: std_logic_vector(79 downto 0);

-- Clock signal for LCD module	
	signal lcd_clk		: std_logic := '0';
	signal clk_slow		: std_logic := '0';

-- Component Declaration
	component inp_detect is
	port(   inp:in std_logic_vector(9 downto 0);
			reset,clock:in std_logic;
			outp: out std_logic;
			out_ascii: out std_logic_vector(79 downto 0));
	end component;

	component lcd_controller is
	port (	clk    : in std_logic;                          --clock i/p
    	 	rst    : in std_logic;                          -- reset
	   		erase : in std_logic;                  			--- clear position
	   		put_char : in std_logic;
	   		write_data : in std_logic_vector(7 downto 0) ;
			write_row : in std_logic_vector(0 downto 0);
			write_column : in std_logic_vector(3 downto 0);
			ack : out std_logic;
    		lcd_rw : out std_logic;                         --read & write control
    		lcd_en : out std_logic;                         --enable control
    		lcd_rs : out std_logic;                         --data or command control
    		lcd1  : out std_logic_vector(7 downto 0);
			b11 : out std_logic;
			b12 : out std_logic);     --data line
	end component lcd_controller;

begin
		
	------------------------------------------------------------------------------------
	process(clk)--50Mhz/200000 = 250Hz
		variable div_clk: integer := 0;
	begin
		if rising_edge(clk) then
			div_clk	:= div_clk + 1;
			if div_clk = 100000 then
				lcd_clk <= '1';
			elsif div_clk = 200000 then
				lcd_clk <= '0';
				div_clk := 0;
			end if;
		end if;	
	end process;
	
	process(clk)--50Mhz/200000 = 250Hz
		variable div_clk_new: integer := 0;
	begin
		if rising_edge(clk) then
			div_clk_new	:= div_clk_new + 1;
			if div_clk_new = 25000 then
				clk_slow <= '1';
			elsif div_clk_new = 50000 then
				clk_slow <= '0';
				div_clk_new := 0;
			end if;
		end if;	
	end process;

	covid_det_instance : inp_detect port map(
					inp			=> inp,
					reset		=> rst,
					clock		=> clk,
					outp		=> detect,
					out_ascii   => ascii_value);

	
	lcd_instance : lcd_controller port map (
					clk 			=> clk_slow, 
					rst 			=> rst, 
					erase 			=> erase ,
					put_char		=> put_char ,
					write_data		=> write_data,
					write_row		=> write_row,
					write_column	=> write_column ,
					ack 			=> ack, 
					lcd_rw 			=> lcd_rw,
					lcd_en 			=> lcd_en,
					lcd_rs 			=> lcd_rs,
					lcd1 			=> lcd1);

	
	process(ack,rst,lcd_clk)
	begin

		if (rising_edge(lcd_clk)) then
		
			-- If reset, then put 1st char in 1st row, 1st column.	
			if (rst = '1') then
				erase <= '0';
				write_row <= "0";
				write_column <= "0000";
				write_data <= "00111110"; -- Denotes > character
				put_char <= '1';
			end if;

			--Put next character only after you have recieve acknowledgment
			--Sequence Position
			--  Column Number		Character
			--		6					c
			--		7					o
			--		8					v
			--		9					i
			--		10					d
			if (ack = '1') then

    -- Sending the first 8 bits (7 downto 0)
    if (i = 0) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0000"; -- Column 0 for first character
        write_row <= "0";       -- Row 0 for all characters
        write_data <= ascii_value(79 downto 72); -- Send the first 8 bits (ASCII character 1)
        
    -- Sending the second 8 bits (15 downto 8)
    elsif (i = 1) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0001"; -- Column 1 for second character
        write_row <= "0";
        write_data <= ascii_value(71 downto 64); -- Send the second 8 bits (ASCII character 2)

    -- Sending the third 8 bits (23 downto 16)
    elsif (i = 2) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0010"; -- Column 2 for third character
        write_row <= "0";
        write_data <= ascii_value(63 downto 56); -- Send the third 8 bits (ASCII character 3)

    -- Sending the fourth 8 bits (31 downto 24)
    elsif (i = 3) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0011"; -- Column 3 for fourth character
        write_row <= "0";
        write_data <= ascii_value(55 downto 48); -- Send the fourth 8 bits (ASCII character 4)

    -- Sending the fifth 8 bits (39 downto 32)
    elsif (i = 4) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0100"; -- Column 4 for fifth character
        write_row <= "0";
        write_data <= ascii_value(47 downto 40); -- Send the fifth 8 bits (ASCII character 5)

    -- Sending the sixth 8 bits (47 downto 40)
    elsif (i = 5) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0101"; -- Column 5 for sixth character
        write_row <= "0";
        write_data <= ascii_value(39 downto 32); -- Send the sixth 8 bits (ASCII character 6)

    -- Sending the seventh 8 bits (55 downto 48)
    elsif (i = 6) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0110"; -- Column 6 for seventh character
        write_row <= "0";
        write_data <= ascii_value(31 downto 24); -- Send the seventh 8 bits (ASCII character 7)

    -- Sending the eighth 8 bits (63 downto 56)
    elsif (i = 7) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "0111"; -- Column 7 for eighth character
        write_row <= "0";
        write_data <= ascii_value(23 downto 16); -- Send the eighth 8 bits (ASCII character 8)

    -- Sending the ninth 8 bits (71 downto 64)
    elsif (i = 8) then
        i <= i + 1;
        put_char <= '1';
        write_column <= "1000"; -- Column 8 for ninth character
        write_row <= "0";
        write_data <= ascii_value(15 downto 8); -- Send the ninth 8 bits (ASCII character 9)

    -- Sending the tenth 8 bits (79 downto 72)
    elsif (i = 9) then
        i <= 0; -- Reset the index after sending all 10 characters
        put_char <= '1';
        write_column <= "1001"; -- Column 9 for tenth character
        write_row <= "0";
        write_data <= ascii_value(7 downto 0); -- Send the tenth 8 bits (ASCII character 10)

    end if;
end if;
		end if;
	end process;

end behave;




