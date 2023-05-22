----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2021 09:28:09 AM
-- Design Name: 
-- Module Name: bram_tester - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsp_tester is
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end dsp_tester;

architecture Behavioral of dsp_tester is
COMPONENT dsp_macro
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    D : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(47 DOWNTO 0) 
  );
END COMPONENT;



signal dsp_a: std_logic_vector(24 downto 0);
signal dsp_b: std_logic_vector(17 downto 0);
signal dsp_c: std_logic_vector(47 downto 0);
signal dsp_d: std_logic_vector(24 downto 0);
signal dsp0_p: std_logic_vector(47 downto 0);
signal dsp1_p: std_logic_vector(47 downto 0);

signal addr_count      : unsigned(3 downto 0) := (others=>'0');
signal addr_count_next : unsigned(3 downto 0) := (others=>'0');

signal test_input: std_logic_vector(47 downto 0);


signal mux_write : std_logic;
signal counter_reset : std_logic;
signal verify_comp_0   :std_logic_vector(47 downto 0);
signal verify_comp_0_reg   : std_logic_vector(47 downto 0);
signal verify_comp_1   : std_logic;
signal verify_comp_1_reg   : std_logic;
signal verify_flag   : std_logic:= '1';
signal verify_reset  : std_logic;

begin



addr_count_next <= addr_count+1;


test_input <= (others=>addr_count(0));

verify_comp_0 <= ( dsp0_p xor dsp1_p);
verify_comp_1 <= or ( verify_comp_0_reg);
valid <= verify_flag;

process (clk)
begin
    if rising_edge(clk) then       
        verify_comp_0_reg <=verify_comp_0;
        verify_comp_1_reg <=verify_comp_1;
        addr_count<= addr_count_next;
        if (enb = '0') then
            verify_flag <= '1';
        elsif (verify_comp_1_reg = '1') then
            verify_flag <= '0';
        end if;
    end if;
end process;

dsp_a <= std_logic_vector(test_input(24 downto 0));
dsp_b <= std_logic_vector(test_input(17 downto 0));
dsp_c <= std_logic_vector(test_input(47 downto 0));
dsp_d <= std_logic_vector(test_input(24 downto 0));

dsp0 : dsp_macro
  PORT MAP (
    CLK => CLK,
    A => dsp_a,
    B => dsp_b,
    C => dsp_c,
    D => dsp_d,
    P => dsp0_p
  );

dsp1 : dsp_macro
  PORT MAP (
    CLK => CLK,
    A => dsp_a,
    B => dsp_b,
    C => dsp_c,
    D => dsp_d,
    P => dsp1_p
  );
  
  
end Behavioral;
