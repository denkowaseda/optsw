library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity sel_contents is
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
end sel_contents;
	
architecture rtl of sel_contents is

type states is (RST,S0,S1,S2,S3);
signal state : states;
signal timer_cnt,iled : std_logic_vector(4 downto 0);
signal rst_flag,timer_carry : std_logic;

signal op1_sc1,op1_sc2,op2_sc1,op2_sc2,op3_sc1,op3_sc2 : std_logic;
signal ot1_sc1,ot1_sc2,ot2_sc1,ot2_sc2,ot3_sc1,ot3_sc2 : std_logic;
signal init : std_logic;
signal cnt : std_logic_vector(5 downto 0);

begin

led <= iled;

--	Initialize Optical switches
	process(selsw,clk) begin
		if selsw = '0' then
			op1_sc1 <= '0'; op1_sc2 <= '0';
			op2_sc1 <= '0'; op2_sc2 <= '0';
			op3_sc1 <= '0'; op3_sc2 <= '0';
		elsif init = '1' then
			if swstat(0) = '0' then
				op1_sc1 <= '1';
			else
				op1_sc1 <= op1_sc1;
			end if;
			if swstat(1) = '1' then
				op2_sc2 <= '1';
			else
				op2_sc2 <= op2_sc2;
			end if;
			if swstat(2) = '1' then
				op3_sc2 <= '1';
			else
				op3_sc2 <= op3_sc2;
			end if;
		end if;
	end process;

	process(reset,clk) begin
		if reset = '0' then
			init <= '0';
		elsif clk'event and clk = '1' then
			if cnt = "000001" then
				init <= '1';
			elsif cnt = "101100" then
				init <= '0';
			else
				init <= init;
			end if;
		end if;
	end process;
	
	process(selsw,clk) begin
		if selsw = '0' then
			cnt <= "000000";
		elsif clk'event and clk = '1' then
			if scale = '1' then
				if cnt = "101100" then
					cnt <= "101110";
				elsif cnt > "101110" then
					cnt <= cnt;
				else
					cnt <= cnt + '1';
				end if;
			else
				cnt <= cnt;
			end if;
		end if;
	end process;
--	End of initialize	optcal switches		
			
	process(selsw,clk) begin
		if selsw = '0' then
			state <= RST;
		elsif clk'event and clk = '1' then
			case state is
				when S0 => 
					if swi(3) = '1' then
						if swstat = "001" then
							state <= S1;
						elsif swstat = "010" then
							state <= S2;
						elsif swstat = "110" then
							state <= S3;
						else
							state <= S0;
						end if;
					end if;
				when S1 =>
					if timer_carry = '1' then
						state <= S0; 
					else
						state <= S1;
					end if;
				when S2 =>
					if timer_carry = '1' then
						state <= S0; 
					else
						state <= S2;
					end if;
				when S3 =>
					if timer_carry = '1' then
						state <= S0; 
					else
						state <= S3;
					end if;
				when RST =>
					if timer_carry = '1' then
						state <= S0;
					else
						state <= RST;
					end if;
				when others =>	state <= S0;
			end case;
		end if;
	end process;

	process(state) begin
		case state is
			when RST => 
				ot1_sc1 <= '0'; ot1_sc2 <= '0';
				ot2_sc1 <= '0'; ot2_sc2 <= '0';
				ot3_sc1 <= '0'; ot3_sc2 <= '0';
				rst_flag <= '1';
			when S0 =>
				ot1_sc1 <= '0'; ot1_sc2 <= '0';
				ot2_sc1 <= '0'; ot2_sc2 <= '0';
				ot3_sc1 <= '0'; ot3_sc2 <= '0';
			when S1 =>
				ot1_sc1 <= '0'; ot1_sc2 <= '1';
				ot2_sc1 <= '1'; ot2_sc2 <= '0';
				ot3_sc1 <= '0'; ot3_sc2 <= '0';
				rst_flag <= '0';
			when S2 =>
				ot1_sc1 <= '0'; ot1_sc2 <= '0';
				ot2_sc1 <= '0'; ot2_sc2 <= '0';
				ot3_sc1 <= '1'; ot3_sc2 <= '0';
			when S3 =>
				ot1_sc1 <= '1'; ot1_sc2 <= '0';
				ot2_sc1 <= '0'; ot2_sc2 <= '1';
				ot3_sc1 <= '0'; ot3_sc2 <= '1';
			when others =>
				ot1_sc1 <= '0'; ot1_sc2 <= '0';
				ot2_sc1 <= '0'; ot2_sc2 <= '0';
				ot3_sc1 <= '0'; ot3_sc2 <= '0';
		end case;
	end process;
		

	process(reset,clk) begin
		if reset = '0' then
			iled <= "11111";
		elsif clk'event and clk='1' then
			if selsw = '0' then
				iled <= "11111";
			elsif state = RST then
				iled <= "11110";
			elsif state = S1 then
				iled <= "11101";
			elsif state = S2 then
				iled <= "11011";
			elsif state = S3 then
				iled <= "10111";
			else
				iled <= iled;
			end if;
		end if;
	end process;
	
	process(reset,clk) begin
		if reset = '0' then
			timer_cnt <= "00000";
		elsif clk'event and clk='1' then
			if init = '0' then
				if swi(3) ='1' then
					timer_cnt <= "00000";
				elsif scale = '1' then
					timer_cnt <= timer_cnt + '1';
				else
					timer_cnt <= timer_cnt;
				end if;
			else 
				timer_cnt <= timer_cnt;
			end if;
		end if;
	end process;
	
	timer_carry <= '1' when timer_cnt = "10110" else '0';
	
	opt1_sc1 <= op1_sc1 when init = '1' else ot1_sc1;
	opt1_sc2 <= op1_sc2 when init = '1' else ot1_sc2;
	opt2_sc1 <= op2_sc1 when init = '1' else ot2_sc1;
	opt2_sc2 <= op2_sc2 when init = '1' else ot2_sc2;
	opt3_sc1 <= op3_sc1 when init = '1' else ot3_sc1;
	opt3_sc2 <= op3_sc2 when init = '1' else ot3_sc2;
	
end  rtl;