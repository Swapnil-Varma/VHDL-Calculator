library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_core is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;

        operand_a  : in  std_logic_vector(7 downto 0);
        operand_b  : in  std_logic_vector(7 downto 0);

        op_add     : in  std_logic;
        op_sub     : in  std_logic;
        op_mul     : in  std_logic;
        op_div     : in  std_logic;

        result     : out std_logic_vector(15 downto 0);
        error      : out std_logic
    );
end entity;

architecture rtl of calculator_core is
    signal result_reg : signed(15 downto 0) := (others => '0');
    signal error_reg  : std_logic := '0';
begin
    result <= std_logic_vector(result_reg);
    error  <= error_reg;

    process(clk)
        variable a_u  : integer range 0 to 255;
        variable b_u  : integer range 0 to 255;
        variable calc : integer range -32768 to 65535;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                result_reg <= (others => '0');
                error_reg  <= '0';
            else
                if op_add = '1' then
                    a_u := to_integer(unsigned(operand_a));
                    b_u := to_integer(unsigned(operand_b));
                    calc := a_u + b_u;
                    result_reg <= to_signed(calc, 16);
                    error_reg <= '0';

                elsif op_sub = '1' then
                    a_u := to_integer(unsigned(operand_a));
                    b_u := to_integer(unsigned(operand_b));
                    calc := a_u - b_u;
                    result_reg <= to_signed(calc, 16);
                    error_reg <= '0';

                elsif op_mul = '1' then
                    a_u := to_integer(unsigned(operand_a));
                    b_u := to_integer(unsigned(operand_b));
                    calc := a_u * b_u;
                    result_reg <= to_signed(calc, 16);
                    error_reg <= '0';

                elsif op_div = '1' then
                    a_u := to_integer(unsigned(operand_a));
                    b_u := to_integer(unsigned(operand_b));

                    if b_u = 0 then
                        result_reg <= (others => '0');
                        error_reg <= '1';
                    else
                        calc := a_u / b_u;
                        result_reg <= to_signed(calc, 16);
                        error_reg <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
