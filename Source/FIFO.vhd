--------------------------------------------------------------------------------
--  File Name     UART.vhd
--  Author        Jean-Stephane Cote
--  Date          2025-01-11
--  Version       1.0
--
--  Description   Registered based FIFO
--
--  Dependencies  ieee.std_logic_1164.all 
--
--  Revision History
--    Ver  Date         Author               Description
--    ---  -----------  ------------------  ------------------------------------------
--    1.0  2025-01-11   Jean-Stephane Cote   Initial Revision
--
--------------------------------------------------------------------------------
--  The MIT License (MIT)
--
--  Copyright (c) 2025 Jean-Stphane Cote
--
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the Software), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, andor sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions
--
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Reg_FIFO is
    generic (
        WIDTH : integer := 8;
        DEPTH : integer := 16
    );
    port (
        -- General System Signals
        clk         : in  std_logic;
        reset       : in  std_logic;

        -- Data Signals
        data_in     : in  std_logic_vector(WIDTH-1 downto 0);
        data_out    : out std_logic_vector(WIDTH-1 downto 0);

        -- Flags
        full        : out std_logic;
        almost_full : out std_logic;
        empty       : out std_logic;
        almost_empty: out std_logic;

        -- Control Signals
        write_en    : in  std_logic;
        read_en     : in  std_logic
    );
end Reg_FIFO;

architecture rtl of Reg_FIFO is

    -- Generates the data array, Most likely to be synthesized as a register file in LUTs
    type data_array is array(0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    signal fifo_matrix : data_array := (others => (others => '0'));

    -- Pointers
    signal write_pointer : integer range 0 to DEPTH-1 := 0;
    signal read_pointer  : integer range 0 to DEPTH-1 := 0;
    signal next_write_pointer : integer range 0 to DEPTH-1;
    signal next_read_pointer  : integer range 0 to DEPTH-1;

    -- internal
    signal buff_full : std_logic := '0';
    signal buff_empty : std_logic := '1';
    signal count      : integer range 0 to DEPTH-1 := 0;

begin

    -- Calculate next pointers (mod DEPTH)
    next_write_pointer <= (write_pointer + 1) mod DEPTH;
    next_read_pointer  <= (read_pointer  + 1) mod DEPTH;

    ------------------------------------------------------------------------
    -- Write Logic
    ------------------------------------------------------------------------
    Write_to_FIFO : process(clk, reset)
    begin
        if reset = '1' then
            write_pointer <= 0;
            fifo_matrix <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if (write_en = '1') and (Buff_full = '0') then
                fifo_matrix(write_pointer) <= data_in;
                write_pointer <= next_write_pointer;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Read Logic
    ------------------------------------------------------------------------
    Read_from_FIFO : process(clk, reset)
    begin
        if reset = '1' then
            read_pointer <= 0;
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if (read_en = '1') and (buff_empty = '0') then
                data_out <= fifo_matrix(read_pointer);
                read_pointer <= next_read_pointer;
            end if;
        end if;
    end process;
    
    Position : process(clk,reset)
    begin
        if reset ='1' then
            count <= 0;
        elsif (rising_edge(clk)) then
            if (read_en = '1') and (buff_empty = '0') then
                count <= count - 1;
            elsif (write_en = '1') and (Buff_full = '0') then 
                count <= count + 1;
            else 
                count <= count;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Status Flags
    ------------------------------------------------------------------------

    buff_empty <= '1' when (count = 0) else '0';

    Buff_full <= '1' when (count = DEPTH) else '0';

    almost_full <= '1' when ((write_pointer + 1) mod DEPTH) = read_pointer else '0';

    almost_empty <= '1' when ((read_pointer + 1) mod DEPTH) = write_pointer else '0';

    full <= buff_full;

    empty <= buff_empty;

end rtl;