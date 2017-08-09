library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity clkgen is 
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : out std_logic);
end clkgen;

architecture rtl of clkgen is

signal cnt_ms : std_logic_vector(15 downto 0);
signal scale_int : std_logic;

begin

-- Systme clock is 40MHz
-- Generate 1ms event signal
	process(clk,reset) begin
		if reset = '0' then
			cnt_ms <= "0000000000000000";
		elsif clk'event and clk = '1' then
			if cnt_ms = "1001110001000000" then		-- 25ns*40000 times count
--			if cnt_ms = "0000000000001001" then		-- for simulation
				cnt_ms <= "0000000000000000";
			else
				cnt_ms <= cnt_ms + 1;
			end if;
		end if;
	end process;

	scale <= '1' when cnt_ms = "1001110001000000" else '0';
--	scale <= '1' when cnt_ms = "0000000000001001" else '0';	-- for simulation
	
end rtl;
				
	