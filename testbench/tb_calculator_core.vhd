library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_calculator_core is
end entity;

architecture sim of tb_calculator_core is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal a, b : std_logic_vector(7 downto 0) := (others => '0');
    signal add_s, sub_s, mul_s, div_s : std_logic := '0';

    signal result : std_logic_vector(15 downto 0);
    signal error_s : std_logic;
begin
    clk <= not clk after 5 ns;

    dut : entity work.calculator_core
        port map (
            clk => clk,
            rst => rst,
            operand_a => a,
            operand_b => b,
            op_add => add_s,
            op_sub => sub_s,
            op_mul => mul_s,
            op_div => div_s,
            result => result,
            error => error_s
        );

    process
    begin
        wait for 20 ns;
        rst <= '0';

        -- 25 + 13 = 38
        a <= std_logic_vector(to_unsigned(25, 8));
        b <= std_logic_vector(to_unsigned(13, 8));
        add_s <= '1';
        wait until rising_edge(clk);
        add_s <= '0';
        wait for 1 ns;
        assert to_integer(signed(result)) = 38 report "Addition failed" severity error;

        -- 25 - 13 = 12
        sub_s <= '1';
        wait until rising_edge(clk);
        sub_s <= '0';
        wait for 1 ns;
        assert to_integer(signed(result)) = 12 report "Subtraction failed" severity error;

        -- 25 * 13 = 325
        mul_s <= '1';
        wait until rising_edge(clk);
        mul_s <= '0';
        wait for 1 ns;
        assert to_integer(signed(result)) = 325 report "Multiplication failed" severity error;

        -- 25 / 13 = 1
        div_s <= '1';
        wait until rising_edge(clk);
        div_s <= '0';
        wait for 1 ns;
        assert to_integer(signed(result)) = 1 report "Division failed" severity error;

        -- 13 - 25 = -12
        a <= std_logic_vector(to_unsigned(13, 8));
        b <= std_logic_vector(to_unsigned(25, 8));
        sub_s <= '1';
        wait until rising_edge(clk);
        sub_s <= '0';
        wait for 1 ns;
        assert to_integer(signed(result)) = -12 report "Negative subtraction failed" severity error;

        -- divide by zero
        a <= std_logic_vector(to_unsigned(5, 8));
        b <= (others => '0');
        div_s <= '1';
        wait until rising_edge(clk);
        div_s <= '0';
        wait for 1 ns;
        assert error_s = '1' report "Divide-by-zero detection failed" severity error;

        report "All calculator tests passed." severity note;
        wait;
    end process;
end architecture;
