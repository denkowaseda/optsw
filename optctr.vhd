library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity optctr is
	port(
		CLK : in std_logic;
		RESET : in std_logic;
		scale	: in std_logic;
		selsw : in std_logic;
		swi : in std_logic_vector(3 downto 0);
		swstat : in std_logic_vector(2 downto 0);
		opt1_sc1 : out std_logic;
		opt1_sc2 : out std_logic;
		opt2_sc1 : out std_logic;
		opt2_sc2 : out std_logic;
		opt3_sc1 : out std_logic;
		opt3_sc2 : out std_logic);
end optctr;
	
architecture rtl of optctr is

signal cnt : std_logic_vector(4 downto 0);
signal opt1_sc1_reg,opt1_sc2_reg,opt2_sc1_reg,opt2_sc2_reg,opt3_sc1_reg,opt3_sc2_reg : std_logic;

begin

	opt1_sc1 <= opt1_sc1_reg; opt1_sc2 <= opt1_sc2_reg;
	opt2_sc1 <= opt2_sc1_reg; opt2_sc2 <= opt2_sc2_reg;
	opt3_sc1 <= opt3_sc1_reg; opt3_sc2 <= opt3_sc2_reg;
	
	process(reset,clk) begin
		if reset = '0' then
			opt1_sc1_reg <= '0'; opt1_sc2_reg <= '0';
			opt2_sc1_reg <= '0'; opt2_sc2_reg <= '0';
			opt3_sc1_reg <= '0'; opt3_sc2_reg <= '0';
		elsif selsw = '1' then
			opt1_sc1_reg <= '0'; opt1_sc2_reg <= '0';
			opt2_sc1_reg <= '0'; opt2_sc2_reg <= '0';
			opt3_sc1_reg <= '0'; opt3_sc2_reg <= '0';		
		elsif clk'event and clk='1' then
			if swi = "0001" then
				if swstat(0) = '1' then
					opt1_sc2_reg <= '1';
				else
					opt1_sc1_reg <= '1';
				end if;
			elsif cnt = "10110" then
				opt1_sc1_reg <= '0'; opt1_sc2_reg <= '0';
			else
				opt1_sc1_reg <= opt1_sc1_reg; opt1_sc2_reg <= opt1_sc2_reg;
			end if;
			
			if swi = "0010" then
				if swstat(1) = '1' then
					opt2_sc2_reg <= '1';
				else
					opt2_sc1_reg <= '1';
				end if;
			elsif cnt = "10110" then
				opt2_sc1_reg <= '0'; opt2_sc2_reg <= '0';
			else
				opt2_sc1_reg <= opt2_sc1_reg; opt2_sc2_reg <= opt2_sc2_reg;
			end if;
			if swi = "0100" then
				if swstat(2) = '1' then
					opt3_sc2_reg <= '1';
				else
					opt3_sc1_reg <= '1';
				end if;
			elsif cnt = "10110" then
				opt3_sc1_reg <= '0'; opt3_sc2_reg <= '0';
			else
				opt3_sc1_reg <= opt3_sc1_reg; opt3_sc2_reg <= opt3_sc2_reg;
			end if;
		end if;
	end process;
				
	process(reset,clk) begin
		if reset = '0' then
			cnt <= "00000";
		elsif clk'event and clk='1' then
			if swi /= "0000" then
				cnt <= "00000";
			elsif scale = '1' then
				cnt <= cnt + '1';
			else
				cnt <= cnt;
			end if;
		end if;
	end process;
	
end  rtl;