library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb_filter is

end tb_filter;

architecture Behavioral of tb_filter is


    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal tempo_f : std_logic := '0';
    signal x_adc   : std_logic_vector(11 downto 0) := (others => '0');
    
    signal y_adc   : std_logic_vector(11 downto 0)  ;

   
    signal t : real := 0.0;

begin

    uut: entity work.filter
        port map (
            clk     => clk,
            rst     => rst,
            tempo_f => tempo_f,
            x_adc   => x_adc,
            y_adc   => y_adc
        );

  
    clk <= not clk after 5 ns;

    -- Process principal : Reset + Échantillonnage + Génération du Sinus
    process
        variable sin_val   : real;
        variable adc_scale : integer;
    begin
        -- Étape A : On applique le Reset au début
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        -- Étape B : Boucle de simulation pas à pas
        while true loop
            
            -- On attend 1 µs entre chaque échantillon (Fréquence d'échantillonnage = 1000 kHz)
            wait for 1 us;
            
            -- On active le top "tempo_f" pendant exactement 1 coup d'horloge
            wait until rising_edge(clk);
            tempo_f <= '1';
            
            -- signal = 2*sin(2π*1k*t) + 1*sin(2π*10k*t)
            sin_val := 2.0 * sin(MATH_2_PI * 1000.0  * t)
                     + 1.0 * sin(MATH_2_PI * 20000.0 * t);

            -- mise à l'échelle : amplitude max=3.0 → centré sur 2048
            adc_scale := integer(sin_val * 650.0) + 2048;
            -- on fait *650 car amplitude max = 3*650 + 2048= 3998 < 4095
            
            x_adc <= std_logic_vector(to_unsigned(adc_scale, 12));
            
            -- On avance le temps virtuel de 1 µs pour le prochain calcul
            t <= t + 1.0e-6;
            
            -- On désactive le top "tempo_f" juste après
            wait until rising_edge(clk);
            tempo_f <= '0';
            
        end loop;
    end process;

end Behavioral;