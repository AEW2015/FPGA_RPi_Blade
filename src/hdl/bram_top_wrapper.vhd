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

entity bram_top_wrapper is
  generic (
         NUM_BRAMS : natural := 200
    );
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end bram_top_wrapper;

architecture Behavioral of bram_top_wrapper is
component bram_top is
  generic (
         NUM_BRAMS : natural := 200
    );
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end component;

begin

    bram_top_wrap: component bram_top
    generic map (
        NUM_BRAMS => NUM_BRAMS
    )
     port map (
      clk => clk,
      enb => enb,
      valid => valid
    );
    
end Behavioral;
