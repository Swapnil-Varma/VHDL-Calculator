library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenseg_driver is
    generic (
        CLK_FREQ_HZ : positive := 100_000_000;
        REFRESH_HZ  : positive := 1000
    );
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        value : in  std_logic_vector(15 downto 0);
        error : in  std_logic;
        seg   : out std_logic_vector(6 downto 0);
        dp    : out std_logic;
        an    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of sevenseg_driver is
    constant DIV_MAX : positive := CLK_FREQ_HZ / (REFRESH_HZ * 4);
    signal div_cnt   : natural range 0 to DIV_MAX-1 := 0;
    signal digit_sel : unsigned(1 downto 0) := (others => '0');
    signal digit_val : integer range 0 to 15 := 0;

    function enc7(d : integer) return std_logic_vector is
    begin
        case d is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when 10 => return "0000110"; -- E
            when 11 => return "0101111"; -- r
            when 12 => return "0111111"; -- -
            when others => return "1111111"; -- blank
        end case;
    end function;
begin
    dp <= '1';

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                div_cnt <= 0;
                digit_sel <= (others => '0');
            elsif div_cnt = DIV_MAX-1 then
                div_cnt <= 0;
                digit_sel <= digit_sel + 1;
            else
                div_cnt <= div_cnt + 1;
            end if;
        end if;
    end process;

    process(digit_sel, value, error)
        variable v : integer;
        variable abs_v : integer;
        variable d0, d1, d2, d3 : integer;
    begin
        an <= "1111";
        digit_val <= 15;

        if error = '1' then
            -- Err_
            case to_integer(digit_sel) is
                when 0 => an <= "0111"; digit_val <= 10;
                when 1 => an <= "1011"; digit_val <= 11;
                when 2 => an <= "1101"; digit_val <= 11;
                when others => an <= "1110"; digit_val <= 15;
            end case;
        else
            v := to_integer(signed(value));

            if v < 0 then
                abs_v := -v;
                d0 := abs_v mod 10;
                d1 := (abs_v / 10) mod 10;
                d2 := (abs_v / 100) mod 10;
                d3 := 12; -- minus sign
            else
                d0 := v mod 10;
                d1 := (v / 10) mod 10;
                d2 := (v / 100) mod 10;
                d3 := (v / 1000) mod 10;
            end if;

            case to_integer(digit_sel) is
                when 0 => an <= "1110"; digit_val <= d0;
                when 1 => an <= "1101"; digit_val <= d1;
                when 2 => an <= "1011"; digit_val <= d2;
                when others => an <= "0111"; digit_val <= d3;
            end case;
        end if;
    end process;

    seg <= enc7(digit_val);
end architecture;
