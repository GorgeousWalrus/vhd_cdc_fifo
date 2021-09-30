# Entity: fifo

- **File**: fifo.vhd
## Diagram

![Diagram](fifo.svg "Diagram")
## Description

 Fifo with single clock.
 
 Almost empty/full flags can be enabled/disabled
## Generics

| Generic name         | Type    | Value | Description                                                  |
| -------------------- | ------- | ----- | ------------------------------------------------------------ |
| DWIDTH_g             | natural | 32    |  Data width|
| DEPTH_g              | natural | 16    |  Depth of the FIFO (minimum: 1, suggested to be power of 2)|
| ENABLE_ALMOST_FLAG_g | natural | 1     |  Enable/Disable almost empty/full flags|
| AF_DISTANCE_g        | natural | 1     |  Distance for almost full flag|
| AE_DISTANCE_g        | natural | 1     |  Distance for almost empty flag|
## Ports

| Port name | Direction | Type                                    | Description                   |
| --------- | --------- | --------------------------------------- | ----------------------------- |
| clk       | in        | std_logic                               |  Clock in                     |
| rstn      | in        | std_logic                               |  Active low reset             |
| din_i     | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  Data in                      |
| we_i      | in        | std_logic                               |  Write enable (want to write) |
| re_i      | in        | std_logic                               |  Read enable (want to read)   |
| dout_o    | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  Data out                     |
| E_o       | out       | std_logic                               |  Empty flag                   |
| F_o       | out       | std_logic                               |  Full flag                    |
| AE_o      | out       | std_logic                               |  Almost empty flag            |
| AF_o      | out       | std_logic                               |  Almost full flag             |
## Signals

| Name            | Type                                      | Description                    |
| --------------- | ----------------------------------------- | ------------------------------ |
| write_pointer_s | std_logic_vector(POINTER_SIZE_c downto 0) |  Pointer of write address|
| empty_s         | std_logic                                 |  internal empty signal|
| full_s          | std_logic                                 |  internal full signal|
| almost_empty_s  | std_logic                                 |  internal almost empty signal|
| almost_full_s   | std_logic                                 |  internal almost full signal|
| fifo_mem        | t_fifo_mem                                |                                |
## Constants

| Name           | Type    | Value                               | Description                                 |
| -------------- | ------- | ----------------------------------- | ------------------------------------------- |
| POINTER_SIZE_c | natural |  natural(ceil(log2(real(DEPTH_g)))) |  Size of the write pointer (log2 of depth)|
| FULL_c         | integer |  (DEPTH_g)                          |  FIFO end|
| EMPTY_c        | integer |  0                                  |  FIFO start|
| ALMOST_FULL_c  | integer |  (DEPTH_g - AF_DISTANCE_g)          |  FIFO almost full|
| ALMOST_EMPTY_c | integer |  (AE_DISTANCE_g)                    |  FIFO almost empty|
## Types

| Name       | Type | Description        |
| ---------- | ---- | ------------------ |
| t_fifo_mem |      |  FIFO memory type
 |
## Processes
- E_F_AE_AF_process: ( write_pointer_s )
  - **Description**
  Sets the empty/full/almost empty/almost full flags
  Only sets almost empty and almost full flags if enabled by generic
 
- read_write_process: ( clk, rstn )
  - **Description**
  Handles read and write actions:
   * Simultaneous read&write
   * Only write
   * Only read
 
