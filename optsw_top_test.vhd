Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY optsw_top_test IS
END optsw_top_test;

ARCHITECTURE test_bench OF optsw_top_test IS

COMPONENT optsw_top
	port (
		reset : in std_logic;
		clk : in std_logic;
		selsw : in std_logic;
		swi : in std_logic_vector(3 downto 0);
		swstat : in std_logic_vector(2 downto 0);
		opt1_sc1 : out std_logic;
		opt1_sc2 : out std_logic;
		opt2_sc1 : out std_logic;
		opt2_sc2 : out std_logic;
		opt3_sc1 : out std_logic;
		opt3_sc2 : out std_logic;
		opt1a : out std_logic;
		opt1b : out std_logic;
		opt2a : out std_logic;
		opt2b : out std_logic;
		opt3a : out std_logic;
		opt3b : out std_logic;
		mode_led : out std_logic_vector(4 downto 0));
END COMPONENT;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant stb	: Time := 2ns;

signal clk,reset,selsw :std_logic;
signal swi : std_logic_vector(3 downto 0);
signal swstat : std_logic_vector(2 downto 0);
signal opt1_sc1,opt1_sc2,opt2_sc1,opt2_sc2,opt3_sc1,opt3_sc2 : std_logic;
signal opt1a,opt1b,opt2a,opt2b,opt3a,opt3b : std_logic;
signal mode_led : std_logic_vector(4 downto 0);

BEGIN
	sm1: optsw_top port map (reset => reset,clk => clk,selsw => selsw,swi => swi,swstat => swstat,
	opt1_sc1 => opt1_sc1,opt1_sc2 => opt1_sc2,opt2_sc1 => opt2_sc1,opt2_sc2 => opt2_sc2,
	opt3_sc1 => opt3_sc1,opt3_sc2 => opt3_sc2,opt1a => opt1a,opt1b => opt1b,opt2a => opt2a,
	opt2b => opt2b,opt3a => opt3a,opt3b => opt3b,mode_led => mode_led);
	
	PROCESS BEGIN
		CLK <= '0';
		wait for half_cycle;
		CLK <= '1';
		wait for half_cycle;
	end PROCESS;
	
	process begin
		swstat <= "001";
		
--		wait for cycle*1550;
		wait for cycle*800;
		swstat <= "010";
		
		wait for cycle*500;
		swstat <= "110";
		
		wait for cycle*500;
		swstat <= "011";
		
		wait for cycle*500;
		swstat <= "001";
		
		wait;
		
	end process;
		
	PROCESS BEGIN
		reset <= '0';
		swi <= "1111";
		selsw <= '0';
		
		wait for cycle*10;
		reset <= '1';
		
		wait for cycle*10;
		selsw <= '1';
		
		wait for cycle*200;
		swi <= "1111";
--
-- S1 state		
		wait for cycle*300;
		swi <= "0111";
		wait for cycle*200;
		swi <= "1111";

-- S2 state		
		wait for cycle*300;
		swi <= "0111";
		wait for cycle*200;
		swi <= "1111";

-- S3 state		
		wait for cycle*300;
		swi <= "0111";
		wait for cycle*200;
		swi <= "1111";

-- S4 state
		wait for cycle*300;
		swi <= "0111";
		wait for cycle*200;
		swi <= "1111";

		wait for cycle*300;
		swi <= "0111";
		wait for cycle*200;
		swi <= "1111";
		
		
--		wait for cycle*200;	-- Chatering start from here
--		swi <= "1110";
--		
--		wait for cycle*10;
--		swi <= "1111";
--		
--		wait for cycle*10;	-- to here
--		swi <= "1110";
--		
--		wait for cycle*200;
--		swi <= "1111";
--		
--		wait for cycle*300;
--		swi <= "1110";
--
--		wait for cycle*50;
--		swi <= "1111";
--				
--		wait for cycle*200;
--		swi <= "1110";
--
--		wait for cycle*200;
--		swi <= "1111";
--
--		wait for cycle*300;
--		swi <= "1110";
--
--		wait for cycle*5;
--		swi <= "1111";
--
--		wait for cycle*200;
--		swi <= "1011";	
--		
--		wait for cycle*300;
--		swi <= "1111";
--		
--		wait for cycle*200;
--		swi <= "1101";
--		
--		wait for cycle*300;
--		swi <= "1111";
--
--		wait for cycle*200;
--		swi <= "1110";
--		
--		wait for cycle*5;
		swi <= "1111";

		wait;
		
	END PROCESS;
end test_bench;

CONFIGURATION cfg_test of optsw_top_test IS
	for test_bench
	end for;
end cfg_test;