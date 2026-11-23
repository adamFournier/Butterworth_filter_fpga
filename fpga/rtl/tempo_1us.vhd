
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2025 16:54:27
-- Design Name: 
-- Module Name: tempo1us - Behavioral
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

entity tempo_1us is
    Port(
        clk   : in  std_logic; 
        rst   : in  std_logic; 
        tempo : out std_logic 
    );
end tempo_1us;

architecture Behavioral of tempo_1us is
    signal count : integer range 0 to 99 ;
    signal tmp   : std_logic ;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count <= 0;
            tmp <= '0';
        elsif rising_edge(clk) then
            if count = 99 then
                tmp <= '1';       
                count <= 0;     
            else
                count <= count + 1;
                tmp <= '0';
            end if;
        end if;
    end process;

    tempo <= tmp; 

end Behavioral;
