----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2025 16:41:07
-- Design Name: 
-- Module Name: mult - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity band_filter is
  Port (    clk  : std_logic;
            rst  : std_logic;
            tempo_f : std_logic;
            x_adc  : in std_logic_vector(11 downto 0);  
            y_adc  : out std_logic_vector(11 downto 0)  
       );
end band_filter;

architecture Behavioral of band_filter is

    constant N : integer := 40; --12 bits partie entière + 28 bits partie decimale   
    constant FRAC : integer := 28; -- il faut 28 bits pour la partie frac pour avoir 6 chiffres apres la virgule 
     
    -- coeff du filtre d'ordre 2
    constant B0 : signed(N-1 downto 0) := TO_SIGNED(10504, N);  
    constant B1 : signed(N-1 downto 0) := TO_SIGNED(0, N);
    constant B2 : signed(N-1 downto 0) := TO_SIGNED(-21008, N);
    constant B3 : signed(N-1 downto 0) := TO_SIGNED(0, N);
    constant B4 : signed(N-1 downto 0) := TO_SIGNED(10504, N);
    
    constant A1 : signed(N-1 downto 0) := TO_SIGNED(-1066883130, N);
    constant A2 : signed(N-1 downto 0) := TO_SIGNED(1592189510, N);
    constant A3 : signed(N-1 downto 0) := TO_SIGNED(-1057444860, N);
    constant A4 : signed(N-1 downto 0) := TO_SIGNED(263707086, N);
    
    
    -- signaux intermediaires
    signal x1, x2, x3, x4 : signed(N-1 downto 0);
    signal y1, y2, y3, y4 : signed(N-1 downto 0);
    
    
    signal y_full : signed(2*N+2 downto 0);
    signal y_int  : signed(N-1 downto 0);

begin
    process(clk, rst)
    begin
        if rst = '1' then
            x1 <= (others => '0');
            x2 <= (others => '0');
            x3 <= (others => '0');
            x4 <= (others => '0');
            y1 <= (others => '0');
            y2 <= (others => '0');
            y3 <= (others => '0');
            y4 <= (others => '0');
            y_adc <= (others => '0');
    
        elsif rising_edge(clk) then
            if tempo_f = '1' then     
                
                x1 <= ((signed(resize(unsigned(x_adc),N))) - 2048) sll FRAC ; 
                -- x_adc est sur 12 bits entre 0 et 4095 centré sur 2048 on le transforme 
                -- dans le format int=12/FRAC=20 et centré sur 0
                x2 <= x1;
                x3 <= x2;
                x4 <= x3;
                y1 <= y_int; 
                y2 <= y1;
                y3 <= y2;
                y4 <= y3;
               
               -- on récupère seulement la partie entière 
                -- puis on recentre autour de 2048
                -- on est donc a nouveau sur 12 bits entre 0 et 4095 centré sur 2048
                y_adc <= std_logic_vector(y_int(N-1 downto FRAC) + 2048);
                                         
            end if;
        end if;
    end process;
    
y_full<= resize(B0*(((signed(resize(unsigned(x_adc),N)))- 2048) sll FRAC), 2*N+3) 
        + resize(B1*x1,2*N+3) 
        + resize(B2*x2, 2*N+3) 
        + resize(B3*x3,2*N+3) 
        + resize(B4*x4, 2*N+3) 
        - resize(A1*y1,2*N+3) 
        - resize(A2*y2,2*N+3)
        - resize(A3*y3,2*N+3) 
        - resize(A4*y4,2*N+3) ;
        
y_int<= y_full(N + FRAC - 1 downto FRAC);


   
   
end Behavioral;