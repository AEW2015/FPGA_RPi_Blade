----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2023 12:21:40 PM
-- Design Name: 
-- Module Name: bram_top_wrapper - Behavioral
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

entity dsp_top_wrapper is
  generic (
         NUM_DSPS : natural := 200
    );
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end dsp_top_wrapper;

architecture Behavioral of dsp_top_wrapper is
component dsp_top is
  generic (
         NUM_DSPS : natural := 200
    );
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end component;

begin

    dsp_top_wrap: component dsp_top
    generic map (
        NUM_DSPS => NUM_DSPS
    )
     port map (
      clk => clk,
      enb => enb,
      valid => valid
    );
    
end Behavioral;
