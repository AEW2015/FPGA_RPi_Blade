----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2021 10:53:43 AM
-- Design Name: 
-- Module Name: bram_top - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsp_top is
  generic (
         NUM_DSPS : natural := 200
    );
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end dsp_top;

architecture Behavioral of dsp_top is
component dsp_tester is
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end component;

constant REG1_LEN : integer := 5;
constant REG2_LEN : integer := 20;

signal enb_reg1 : std_logic_vector (REG1_LEN downto 0);
type fanout is array (REG2_LEN downto 0) of std_logic_vector(NUM_DSPS-1 downto 0);
signal enb_reg2 : fanout;
signal valid_reg2 : fanout;
signal valid_reg1 : std_logic_vector (REG1_LEN downto 0);

attribute dont_touch : string;
attribute dont_touch of enb_reg1 : signal is "true";
attribute dont_touch of enb_reg2 : signal is "true";
attribute dont_touch of valid_reg2 : signal is "true";
attribute dont_touch of valid_reg1 : signal is "true";

attribute syn_slrstyle : string;
attribute syn_slrstyle of enb_reg1 : signal is "registers";
attribute syn_slrstyle of enb_reg2 : signal is "registers";
attribute syn_slrstyle of valid_reg2 : signal is "registers";
attribute syn_slrstyle of valid_reg1 : signal is "registers";

begin

enb_reg1(0) <= enb;
valid <= valid_reg1(REG1_LEN);

GEN_REG1: for I in 1 to REG1_LEN generate
process(clk)
begin
    if rising_edge(clk) then
        enb_reg1(I) <= enb_reg1(I-1);
        valid_reg1(I) <= valid_reg1(I-1);
    end if;
end process;
end generate GEN_REG1;


REG1_REG2: for I in 0 to NUM_DSPS-1 generate
    enb_reg2(0)(I) <= enb_reg1(REG1_LEN);
end generate REG1_REG2;

valid_reg1(0) <= and (valid_reg2(REG2_LEN));

GEN_REG2: for I in 1 to REG2_LEN generate
process(clk)
begin
    if rising_edge(clk) then
        enb_reg2(I) <= enb_reg2(I-1);
        valid_reg2(I) <= valid_reg2(I-1);
    end if;
end process;
end generate GEN_REG2;

GEN_DSPS: for I in 0 to NUM_DSPS-1 generate
    dsp_wrap_i: component dsp_tester
     port map (
      clk => clk,
      enb => enb_reg2(REG2_LEN)(I),
      valid => valid_reg2(0)(I)
    );
end generate GEN_DSPS;

end Behavioral;
