library ieee;
use ieee.std_logic_1164.all;

entity TB_FIFO is
end TB_FIFO;

architecture Test_bench of TB_FIFO is 

    constant WIDTH : integer := 8;
    constant DEPTH : integer := 16;

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';

    signal data_in     : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal data_out    : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

    signal full        : std_logic := '0';
    signal almost_full : std_logic := '0';
    signal empty       : std_logic := '0';
    signal almost_empty: std_logic := '0';

    signal write_en    : std_logic := '0';
    signal read_en     : std_logic := '0';



begin

    UUT_FIFO : entity work.Reg_FIFO
        generic map(
            WIDTH => WIDTH,
            DEPTH => DEPTH
        )
        port map(
            clk          => clk,
            reset        => reset,
            data_in      => data_in,
            data_out     => data_out,
            full         => full,
            almost_full  => almost_full,
            empty        => empty,
            almost_empty => almost_empty,
            write_en     => write_en,
            read_en      => read_en
        );

        clk_process : process
        begin
            while true loop 
                clk <= not clk;
                wait for 5ns;
            end loop;
        end process;

        Test_Process : process
        begin
            
            -- Reset 
            reset <= '1';
            wait for 10ns;
            reset <= '0';
            wait for 10ns;


            -- Filling the FIFO with data 

            wait for 20ns;

            data_in <= "00000001"; --#1
            write_en <= '1';
            wait for 10ns;
            data_in <= "00000010"; --#2
            wait for 10ns;
            data_in <= "00000100"; --#3
            wait for 10ns;
            data_in <= "00001000"; --#4
            wait for 10ns;
            data_in <= "00010000"; --#5
            wait for 10ns;
            data_in <= "00100000"; --#6
            wait for 10ns;
            data_in <= "01000000"; --#7
            wait for 10ns;
            data_in <= "10000000"; --#8
            wait for 10ns;
            data_in <= "10000001"; --#9
            wait for 10ns;
            data_in <= "10000011"; --#10
            wait for 10ns;
            data_in <= "10000111"; --#11
            wait for 10ns;
            data_in <= "10001111"; --#12
            wait for 10ns;
            data_in <= "10011111"; --#13
            wait for 10ns;
            data_in <= "10111111"; --#14
            wait for 10ns;
            data_in <= "11111111"; --#15
            wait for 10ns;
            data_in <= "10000001"; --#16
            wait for 10ns;
            write_en <= '0';
            wait for 10ns;

            -- Try to write to a full FIFO
            write_en <= '1';
            data_in <= "01111110";
            wait for 10ns;
            write_en <= '0';
            wait for 10ns;

            -- Read from full to empty
            for i in 0 to 15 loop 
                read_en <= '1';
                wait for 10ns;
                read_en <= '0';
                wait for 10ns;
            end loop;
            
            -- Read form an empty FiFO
            wait for 10ns;
            read_en <= '1';
            wait for 10ns;

            -- Try to write and read at the same time
            write_en <= '1';
            data_in <= "00000000";
            read_en <= '1';
            wait for 10ns;
            write_en <= '0';
            read_en <= '0';
            wait for 10ns;

            -- Fill Fifo half way
            data_in <= "00000000"; --#1
            write_en <= '1';
            wait for 10ns;
            data_in <= "00000010"; --#2
            wait for 10ns;
            data_in <= "00000100"; --#3
            wait for 10ns;
            data_in <= "00001000"; --#4
            wait for 10ns;
            data_in <= "00010000"; --#5
            wait for 10ns;
            data_in <= "00100000"; --#6
            wait for 10ns;
            data_in <= "01000000"; --#7
            wait for 10ns;
            data_in <= "10000000"; --#8
            wait for 10ns;
            write_en <= '0';
            wait for 10ns;
            
            -- read and write 16 times to chck the Wrap around logic
            for i in 0 to 15 loop 
                read_en <= '1';
                wait for 10ns;
                read_en <= '0';
                wait for 10ns;
                write_en <= '1';
                data_in <= "11111111"; --#8
                wait for 10ns;
                write_en <= '0';
                wait for 10ns;
            end loop;
        
            -- Reset when fifo alft full
            reset <= '1';
            wait for 10ns;
            reset <= '0';
            wait for 10ns;
            
             -- Fill Fifo half way
            data_in <= "00000000"; --#1
            write_en <= '1';
            wait for 10ns;
            data_in <= "00000010"; --#2
            wait for 10ns;
            data_in <= "00000100"; --#3
            wait for 10ns;
            data_in <= "00001000"; --#4
            wait for 10ns;
            data_in <= "00010000"; --#5
            wait for 10ns;
            data_in <= "00100000"; --#6
            wait for 10ns;
            data_in <= "01000000"; --#7
            wait for 10ns;
            data_in <= "10000000"; --#8
            wait for 10ns;
            write_en <= '0';
            wait for 10ns;
            
            -- read and write 16 times to chck the Wrap around logic
            for i in 0 to 15 loop 
                read_en <= '1';
                wait for 10ns;
                read_en <= '0';
                wait for 10ns;
                write_en <= '1';
                data_in <= "11111111"; --#8
                wait for 10ns;
                write_en <= '0';
                wait for 10ns;
            end loop;
            
            wait;
            
        end process;

end architecture Test_bench;