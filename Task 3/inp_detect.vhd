library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inp_detect is
    port(
        inp: in std_logic_vector(9 downto 0); -- 10-bit input
        reset, clock: in std_logic;
        outp: out std_logic;
        out_ascii: out std_logic_vector(79 downto 0) := (others=>'0') -- 8-bit ASCII for LCD (single character at a time)
    );
end inp_detect;

architecture rch of inp_detect is

    -- Define state type
--    type state is (init, check_bits, done);
--
--    -- Define signals of state type
--    signal y_present, y_next: state := init;
    signal out_sig: std_logic := '0';
	 signal out_ascii_new: std_logic_vector(7 downto 0);
	signal out_ascii_new2: std_logic_vector(79 downto 0) := (others=>'0');
	 signal out_ascii_store: std_logic_vector(79 downto 0) := (others=>'0');
    signal bit_index: std_logic_vector(3 downto 0); -- To track the current bit index

begin
    -- Clock process for state transition
    clock_proc: process(clock, reset)
    begin
        if reset = '1' then
--           y_present <= init;
			  bit_index <= "0000"; -- Start with the first bit
        elsif rising_edge(clock) then
--            y_present <= y_next;
				-- Move to the next bit
				if bit_index < "1001" then
				bit_index <= std_logic_vector(unsigned(bit_index) + to_unsigned(1, bit_index'length));
          --  bit_index <= Bit_index_store;
				end if;
        end if;
    end process;

    -- State transition process
    process(inp,bit_index)
    begin
--        case y_present is
--            -- Initial state
--            when init =>
--					 Bit_index_store<=0;
--                out_ascii <= (others => '0'); -- Clear out_ascii at the start
--                y_next <= check_bits; -- Move to checking the bits
--
--            -- Check each bit of the 10-bit input
--            when check_bits =>
--                if bit_index < 10 then
                    -- Check if the current bit is '1'
                    if inp(to_integer(unsigned(bit_index))) = '1' then
                        out_sig <= '1';
                        -- Assign the corresponding 8-bit ASCII for '1' to the right slice of out_ascii
                        out_ascii_new <= std_logic_vector(to_unsigned(49, 8)); -- ASCII '1'
                    elsif inp(to_integer(unsigned(bit_index))) = '0' then
                        out_sig <= '0';
                        -- Assign the corresponding 8-bit ASCII for '0' to the right slice of out_ascii
                        out_ascii_new <= std_logic_vector(to_unsigned(48, 8)); -- ASCII '0'
								else 
								out_sig <= '0';
								out_ascii_new <= std_logic_vector(to_unsigned(0, 8));
                    end if;
--                    Bit_index_store<=Bit_index_store+1;
--                else
--                    -- All bits processed, go to the done state
--                    out_sig<='0';
--                end if;

            -- Done state, reset or stay in done state
--            when done =>
--                out_sig <= '0'; -- Signal output is reset
--                y_next <= done; -- Reset to the initial state
--
--            -- Default case to avoid latches
--            when others =>
--                y_next <= init;
--
--        end case;
    end process;

    -- Assign the output signal
    outp <= out_sig;
	  out_ascii_store<=out_ascii_new2;
	 out_ascii<=out_ascii_new2;
	 
	 process (bit_index,out_ascii_store,out_ascii_new)
	 begin
	 out_ascii_new2<=out_ascii_store;
	 if(bit_index = "0000") then
	 out_ascii_new2(7 downto 0) <= out_ascii_new;
	 elsif  (bit_index = "0001") then
	 out_ascii_new2(15 downto 8) <= out_ascii_new;
	  elsif  (bit_index = "0010") then
	 out_ascii_new2(23 downto 16) <= out_ascii_new;
	  elsif  (bit_index = "0011") then
	 out_ascii_new2(31 downto 24) <= out_ascii_new;
	  elsif  (bit_index = "0100") then
	 out_ascii_new2(39 downto 32) <= out_ascii_new;
	  elsif  (bit_index = "0101") then
	 out_ascii_new2(47 downto 40) <= out_ascii_new;
	  elsif  (bit_index = "0110") then
	 out_ascii_new2(55 downto 48) <= out_ascii_new;
	  elsif  (bit_index = "0111") then
	 out_ascii_new2(63 downto 56) <= out_ascii_new;
	  elsif  (bit_index = "1000") then
	 out_ascii_new2(71 downto 64) <= out_ascii_new;
	  elsif  (bit_index = "1001") then
	 out_ascii_new2(79 downto 72) <= out_ascii_new;
end if;
end process;

--	 out_ascii((to_integer(unsigned(bit_index)) * 8 + 7) downto (to_integer(unsigned(bit_index)) * 8)) <= out_ascii_new;

end rch;