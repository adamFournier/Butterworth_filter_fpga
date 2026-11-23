
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2025 09:47:19
-- Design Name: 
-- Module Name: adc_filt - struct
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

entity adc_filt is
    Port (
        clk    : std_logic;
        rst  : std_logic;
        vauxp3 : IN std_logic;
        vauxn3 : IN std_logic;
        y_adc  : out std_logic_vector(11 downto 0)
    );
end adc_filt;

architecture struct of adc_filt is

    signal tempo_int  : std_logic;
    signal tempo_adc  : std_logic;
    signal do_out_16  : std_logic_vector(15 downto 0);

    COMPONENT xadc_wiz_0
        PORT (
            di_in               : IN std_logic_vector(15 downto 0);
            daddr_in            : IN std_logic_vector(6 downto 0);
            den_in              : IN std_logic;
            dwe_in              : IN std_logic;
            drdy_out            : OUT std_logic;
            do_out              : OUT std_logic_vector(15 downto 0);
            dclk_in             : IN std_logic;
            reset_in            : IN std_logic;
            convst_in           : IN std_logic;
            vp_in               : IN std_logic;
            vn_in               : IN std_logic;
            vauxp3              : IN std_logic;
            vauxn3              : IN std_logic;
            channel_out         : OUT std_logic_vector(4 downto 0);
            eoc_out             : OUT std_logic;
            alarm_out           : OUT std_logic;
            eos_out             : OUT std_logic;
            busy_out            : OUT std_logic
        );
    END COMPONENT;

    COMPONENT tempo_1us
        port (
            rst   : in std_logic;
            clk   : in std_logic;
            tempo : out std_logic
        );
    END COMPONENT;

    COMPONENT filter
        Port (
            clk    : std_logic;
            rst  : std_logic;
            tempo_f : std_logic;
            x_adc  : in std_logic_vector(11 downto 0);
            y_adc  : out std_logic_vector(11 downto 0)
        );
    END COMPONENT;

begin

    insttempo : tempo_1us
        PORT MAP (
            rst   => rst,
            clk   => clk,
            tempo => tempo_int
        );

    INST: xadc_wiz_0
        PORT MAP (
            di_in               => (others => '0'),
            daddr_in            => "0010011",
            den_in              => '1',
            dwe_in              => '0',
            drdy_out            => open,
            do_out              => do_out_16,
            dclk_in             => clk,
            reset_in            => rst,
            convst_in           => tempo_int,
            vp_in               => '0',
            vn_in               => '0',
            vauxp3              => vauxp3,
            vauxn3              => vauxn3,
            channel_out         => open,
            eoc_out             => tempo_adc,
            alarm_out           => open,
            eos_out             => open,
            busy_out            => open
        );

    instfiltre : filter
        PORT MAP (
            rst  => rst,
            clk    => clk,
            tempo_f => tempo_adc,
            x_adc  => do_out_16(15 downto 4),
            y_adc  => y_adc
        );

end struct;
