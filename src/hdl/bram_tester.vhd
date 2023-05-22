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

entity bram_tester is
    Port ( clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           valid : out STD_LOGIC);
end bram_tester;

architecture Behavioral of bram_tester is
COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(35 DOWNTO 0)
  );
END COMPONENT;

signal bsleep: std_logic;
signal benb  : std_logic;
signal baddra: std_logic_vector(9 downto 0);
signal baddrb: std_logic_vector(9 downto 0);
signal bdina : std_logic_vector(35 downto 0);
signal bdina_reg : std_logic_vector(35 downto 0);
signal bdouta: std_logic_vector(35 downto 0);
signal bdouta_reg: std_logic_vector(35 downto 0);
signal bdinb : std_logic_vector(35 downto 0);
signal bdinb_reg : std_logic_vector(35 downto 0);
signal bdoutb: std_logic_vector(35 downto 0);
signal bdoutb_reg: std_logic_vector(35 downto 0);

signal addr_count      : unsigned(8 downto 0);
signal addr_count_next : unsigned(8 downto 0);

type state_t is (OFF,WAKE_UP,WRITE,VERIFY);
signal state_reg : state_t;
signal state_next: state_t;

constant WUP_LIMIT : integer:= 4;
signal wup_shift : std_logic_vector (WUP_LIMIT downto 0);
signal wup_next  : std_logic_vector (WUP_LIMIT downto 0);
signal wup_in    : std_logic;
signal wup_out   : std_logic;

signal mux_write : std_logic;
signal counter_reset : std_logic;
signal verify_comp_0   :std_logic_vector(35 downto 0);
signal verify_comp_0_reg   : std_logic_vector(35 downto 0);
signal verify_comp_1   : std_logic;
signal verify_comp_1_reg   : std_logic;
signal verify_flag   : std_logic:= '1';
signal verify_reset  : std_logic;

begin


baddra <= '0' & std_logic_vector(addr_count);
baddrb <= '1' & std_logic_vector(addr_count);
addr_count_next <= "000000001" when counter_reset = '1' else addr_count+1;
wup_next <= wup_shift(WUP_LIMIT-1 downto 0) & wup_in;

counter_reset <= wup_shift(WUP_LIMIT);
wup_out <= wup_shift(WUP_LIMIT);

bdina <= x"555555555" when mux_write='1' else bdoutb_reg;
bdinb <= x"AAAAAAAAA" when mux_write='1' else bdouta_reg;


verify_comp_0 <= ( bdouta_reg xor bdoutb_reg);
verify_comp_1 <= and ( verify_comp_0_reg);
valid <= verify_flag;
process (clk)
begin
    if rising_edge(clk) then
        bdina_reg <= bdina;
        bdinb_reg <= bdinb;
        bdouta_reg <= bdouta;
        bdoutb_reg <= bdoutb;
        verify_comp_0_reg <=verify_comp_0;
        verify_comp_1_reg <=verify_comp_1;
        state_reg <= state_next;
        addr_count<= addr_count_next;
        wup_shift <= wup_next;
        if (verify_reset = '1') then
            verify_flag <= '1';
        elsif (verify_comp_1_reg = '0') then
            verify_flag <= '0';
        end if;
    end if;
end process;


-- State machine
-- State 0 : off
--      Bram in Sleep
-- State 1: wake up
--      Use two cycles to wake
-- State 2: write
--      set LSFR to 1 (reset)
--      set 0x55555555 and 0xAAAAAAAA to bram
-- State 3:  verify
--      BRAM A and B port write to each other
--      XOR and AND reduction of Dout ports
--      Latch if zero?

process (state_reg,enb,addr_count,wup_out)
begin
    --default
        bsleep <= '0';
        benb   <= '0';
        wup_in <= '0';
        mux_write <= '0';
        verify_reset  <= '0';
        state_next <= state_reg;
        
    case state_reg is
        when OFF =>
            bsleep <= '1';
            if (enb = '1') then
                state_next <= WAKE_UP;
                wup_in <= '1';
            end if;
        when WAKE_UP =>
            if (wup_out = '1') then
                state_next <= WRITE;
            end if;
        when WRITE =>
            benb   <= '1';
            mux_write <= '1';
            --wait for counter to cycle
            if (addr_count = 0) then
                wup_in <= '1';
            end if;
            
            if (wup_out = '1') then
                state_next <= VERIFY;
                --reset output latch to '1'
                verify_reset <= '1';
            end if;
        when VERIFY =>
            benb   <= '1';
            --enable verify mux?
            if (enb = '0') then
                state_next <= OFF;
            end if;
        when others =>
            state_next <= OFF;
    end case;
end process;

bram_dut : blk_mem_gen_0
  PORT MAP (
    clka => clk,
    ena => benb,
    wea(0) => benb,
    addra => baddra,
    dina => bdina_reg,
    douta => bdouta,
    clkb => clk,
    enb => benb,
    web(0) => benb,
    addrb => baddrb,
    dinb => bdinb_reg,
    doutb => bdoutb
  );
  
end Behavioral;
