library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_level is
    port (
        clk                   : in std_logic;
		  miso                  : in std_logic;
		  lcd_rst       : in std_logic;
		  master_rst    : in std_logic;
		  cs_bar        : out std_logic := '1';
		  sclk          : out std_logic := '0';
		  mosi  : out std_logic := 'Z';
		  lcd_rw                : out std_logic;                         	
     	  lcd_en                : out std_logic;                         	
        lcd_rs                : out std_logic;                         	
        lcd1: out std_logic_vector(7 downto 0);			 
		  detect: out std_logic;
		  data_out_led: out std_logic_vector(7 downto 0)
    );
end entity;

architecture archi_top_level of top_level is
	
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
	
	component test is
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
	end component;	
	
	signal data_out_master: STD_LOGIC_VECTOR(9 downto 0);
	signal clk_counter: integer := 0;
	begin
			inst1: master port map (clk=>clk,miso=>miso,reset=>master_rst,cs=>cs_bar,sclk=>sclk,mosi=>mosi,reg_a=>data_out_master);
			LCD: test port map(inp=>data_out_master,clk=>clk,rst=>lcd_rst,lcd_rw=>lcd_rw,lcd_en=>lcd_en,lcd_rs=>lcd_rs,lcd1=>lcd1,detect=>detect);
			
			led_process: process(clk)
				begin
				if rising_edge(clk) then
					if clk_counter = 50000000 then
						data_out_led <= "00000001";
						if master_rst = '1' then
							clk_counter <= 0;
						end if;
					else
						data_out_led <= data_out_master(9 downto 2);
						clk_counter <= clk_counter + 1;
					end if;
				end if;
			end process;
end architecture;	