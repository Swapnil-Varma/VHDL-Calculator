library ieee;
use ieee.std_logic_1164.all;

entity calculator_top is
    port (
        clk100mhz : in  std_logic;
        sw        : in  std_logic_vector(15 downto 0);
        btnC      : in  std_logic;
        btnU      : in  std_logic;
        btnD      : in  std_logic;
        btnL      : in  std_logic;
        btnR      : in  std_logic;

        led       : out std_logic_vector(15 downto 0);
        seg       : out std_logic_vector(6 downto 0);
        dp        : out std_logic;
        an        : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of calculator_top is
    signal result_s : std_logic_vector(15 downto 0);
    signal error_s  : std_logic;
begin
    led <= result_s;

    u_calc : entity work.calculator_core
        port map (
            clk       => clk100mhz,
            rst       => btnC,
            operand_a => sw(15 downto 8),
            operand_b => sw(7 downto 0),
            op_add    => btnU,
            op_sub    => btnD,
            op_mul    => btnL,
            op_div    => btnR,
            result    => result_s,
            error     => error_s
        );

    u_display : entity work.sevenseg_driver
        port map (
            clk   => clk100mhz,
            rst   => btnC,
            value => result_s,
            error => error_s,
            seg   => seg,
            dp    => dp,
            an    => an
        );
end architecture;
