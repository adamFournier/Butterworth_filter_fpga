library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb_derivation is

end tb_derivation;

architecture Behavioral of tb_derivation is


    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal tempo_d : std_logic := '0';
    signal y   : std_logic_vector(11 downto 0) := (others => '0');
    
    signal y_d   : std_logic_vector(11 downto 0)  ;

   
    signal t : real := 0.0;

begin

    uut: entity work.derivation 
        port map (
            clk     => clk,
            rst     => rst,
            tempo_d => tempo_d,
            y   => y,
            y_d   => y_d
        );

  
    clk <= not clk after 5 ns;

    -- Process principal : Reset + Échantillonnage + Génération du Sinus
    process
        variable ramp_val   : unsigned(11 downto 0);
        variable up : std_logic;
        variable adc_scale : integer;
    begin
        -- Étape A : On applique le Reset au début
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        ramp_val := (others =>'0');
        up :='1';
        -- Étape B : Boucle de simulation pas à pas
        while true loop
            
            -- On attend 1 µs entre chaque échantillon (Fréquence d'échantillonnage = 1000 kHz)
            wait for 1 us;
            
            -- On active le top "tempo_f" pendant exactement 1 coup d'horloge
            wait until rising_edge(clk);
            tempo_d <= '1';
            
            -- signal = 2*sin(2π*1k*t) + 1*sin(2π*10k*t)
           -- sin_val := 1.0 * sin(MATH_2_PI * 10000.0 * t);
           if ramp_val < 4095 then
                ramp_val := ramp_val + 1;
           else                       
                ramp_val := (others =>'0');
                up := not(up);
           end if;
           
           
            -- mise à l'échelle : amplitude max=3.0 → centré sur 2048
          --  adc_scale := integer(sin_val * 2000) + 2048;
            -- on fait *650 car amplitude max = 3*650 + 2048= 3998 < 4095
            if up='1' then
                 y <= std_logic_vector(ramp_val);
            else 
                 y <= std_logic_vector(4095 - signed(ramp_val));
            end if;
            -- On avance le temps virtuel de 1 µs pour le prochain calcul
            t <= t + 1.0e-6;
            
            -- On désactive le top "tempo_f" juste après
            wait until rising_edge(clk);
            tempo_d <= '0';
            
        end loop;
    end process;

end Behavioral;