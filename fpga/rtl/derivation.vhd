----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2025 14:58:09
-- Design Name: 
-- Module Name: derive - Behavioral
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

entity derivation is
     port ( clk      : in std_logic;
            rst    : in std_logic;
            tempo_d  : in std_logic;
            y        : in std_logic_vector(11 downto 0);  
            y_d      : out std_logic_vector(11 downto 0)  
       );
end derivation;

architecture Behavioral of derivation  is

    signal y_prev : signed(11 downto 0); 
    

begin
    process(clk, rst)
    begin
        if rst = '1' then
            y_prev <= (others => '0');
            y_d <= (others => '0');
        elsif rising_edge(clk) then
            if tempo_d = '1' then
                     
                y_prev <= signed(y);        
                y_d <= std_logic_vector(signed(y) - y_prev); 
                  
            end if;           
        end if;
    end process;
    


 
end Behavioral;
