# Synchronous FIFO in VHDL

This is a simple synchronous FIFO implementation in VHDL.

## Key Features
- **Synchronous Read and Write**: Operates on the rising edge of the same clock.  
- **Configurable Depth and Width**: Set data width and FIFO depth via **generics**.  
- **Status Flags**: Provides `full`, `almost_full`, `empty`, and `almost_empty` flags

## Generic Parameters
| Parameter | Type    | Default | Description                                |
|-----------|---------|---------|--------------------------------------------|
| `WIDTH`   | integer | 8       | The bit-width of each FIFO data entry.     |
| `DEPTH`   | integer | 16      | The total number of entries in the FIFO.   |

- **WIDTH**: Determines the size of each data word.  
- **DEPTH**: Determines how many data words can be stored.

## Port Descriptions
| Port Name      | Direction | Width                    | Description                                                                                           |
|----------------|-----------|--------------------------|-------------------------------------------------------------------------------------------------------|
| **clk**        | in        | 1 bit (`std_logic`)      | System clock signal. All operations occur on the rising edge of this clock.                           |
| **reset**      | in        | 1 bit (`std_logic`)      | Asynchronous reset. Active High. Resets internal registers, pointers, and output data.                |
| **data_in**    | in        | `WIDTH` bits             | Data to be written into the FIFO.                                                                     |
| **data_out**   | out       | `WIDTH` bits             | Data read out from the FIFO.                                                                          |
| **write_en**   | in        | 1 bit (`std_logic`)      | Write enable. When `1` and FIFO is not full, the `data_in` is stored in the FIFO on the rising edge.  |
| **read_en**    | in        | 1 bit (`std_logic`)      | Read enable. When `1` and FIFO is not empty, the next data word is output on the rising edge.         |
| **full**       | out       | 1 bit (`std_logic`)      | High when the FIFO is completely full. Additional writes are ignored.                                 |
| **almost_full**| out       | 1 bit (`std_logic`)      | High when the FIFO is about to be full (next write would make it full).                               |
| **empty**      | out       | 1 bit (`std_logic`)      | High when the FIFO is completely empty. Reads return undefined data if attempted while empty.         |
| **almost_empty** | out     | 1 bit (`std_logic`)      | High when the FIFO is about to be empty (next read would make it empty).                              |



