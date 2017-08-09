library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity optsw_top is 
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
end optsw_top;

architecture rtl of optsw_top is

signal scale : std_logic;
signal opt1sw1,opt1o1 : std_logic;
signal opt1sw2,opt1o2 : std_logic;
signal opt2sw1,opt2o1 : std_logic;
signal opt2sw2,opt2o2 : std_logic;
signal opt3sw1,opt3o1 : std_logic;
signal opt3sw2,opt3o2 : std_logic;
signal swo,keyi : std_logic_vector(3 downto 0);

component swctr
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : in std_logic;
		swi : in std_logic_vector(3 downto 0);
		swo : out std_logic_vector(3 downto 0));
end component;

component sel_contents
	port(
		CLK : in std_logic;
		RESET : in std_logic;
		scale : in std_logic;
		selsw : in std_logic;
		swi : in std_logic_vector(3 downto 0);
		swstat : in std_logic_vector(2 downto 0);
		opt1_sc1 : out std_logic;
		opt1_sc2 : out std_logic;
		opt2_sc1 : out std_logic;
		opt2_sc2 : out std_logic;
		opt3_sc1 : out std_logic;
		opt3_sc2 : out std_logic;
		led : out std_logic_vector(4 downto 0));
end component;

component clkgen
	port (
		reset : in std_logic;
		clk : in std_logic;
		scale : out std_logic);
end component;

component optctr
	port(
		CLK : in std_logic;
		RESET : in std_logic;
		scale : in std_logic;
		selsw : in std_logic;
		swi : in std_logic_vector(3 downto 0);
		swstat : in std_logic_vector(2 downto 0);
		opt1_sc1 : out std_logic;
		opt1_sc2 : out std_logic;
		opt2_sc1 : out std_logic;
		opt2_sc2 : out std_logic;
		opt3_sc1 : out std_logic;
		opt3_sc2 : out std_logic);
end component;

begin
	U1 : swctr port map(reset => reset,clk => clk,scale => scale,swi => swi,swo => swo);
	
	U2 : optctr port map(CLK => clk,RESET => reset,scale => scale,selsw => selsw,
							swi => keyi,swstat => swstat,
							opt1_sc1 => opt1o1,opt1_sc2 => opt1o2,opt2_sc1 => opt2o1,
							opt2_sc2 => opt2o2,opt3_sc1 => opt3o1,opt3_sc2 => opt3o2);
	
	U3 : clkgen port map(reset => reset,clk => clk,scale => scale);
	
	U4 : sel_contents port map(CLK => clk,RESET => reset,scale => scale,selsw => selsw,
							swi => keyi,swstat => swstat,opt1_sc1 => opt1sw1,opt1_sc2 => opt1sw2,
							opt2_sc1 => opt2sw1,opt2_sc2 => opt2sw2,opt3_sc1 => opt3sw1,opt3_sc2 => opt3sw2,
							led => mode_led);

	keyi <= swo;

	opt1_sc1 <= opt1sw1 when selsw = '1' else opt1o1;
	opt1_sc2 <= opt1sw2 when selsw = '1' else opt1o2;
	opt2_sc1 <= opt2sw1 when selsw = '1' else opt2o1;
	opt2_sc2 <= opt2sw2 when selsw = '1' else opt2o2;
	opt3_sc1 <= opt3sw1 when selsw = '1' else opt3o1;
	opt3_sc2 <= opt3sw2 when selsw = '1' else opt3o2;

	opt1a <= not swstat(0);
	opt1b <= swstat(0);
	opt2a <= not swstat(1);
	opt2b <= swstat(1);
	opt3a <= not swstat(2);
	opt3b <= swstat(2);
	
	
	
end rtl;
				
	