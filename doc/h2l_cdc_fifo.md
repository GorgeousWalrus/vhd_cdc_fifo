# Entity: h2l_cdc_fifo

- **File**: h2l_cdc_fifo.vhd
## Diagram

![Diagram](h2l_cdc_fifo.svg "Diagram")
## Description

 CDC fifo for transfer from high to low frequency clock domain

 AE/AF Flags can be disabled

 Data width, fifo depth and AE/AF thresholds can be parameterized
## Generics

| Generic name       | Type    | Value | Description                                                    |
| ------------------ | ------- | ----- | -------------------------------------------------------------- |
| DWIDTH_g           | natural | 32    |  Data width|
| DEPTH_H_g          | natural | 8     |  High clock domain fifo depth|
| DEPTH_L_g          | natural | 8     |  Low clock domain fifo depth|
| ENABLE_AE_FLAG_g   | natural | 1     |  Enable almost empty flag|
| ENABLE_AF_FLAG_g   | natural | 1     |  Enable almost full flag|
| AF_DISTANCE_g      | natural | 1     |  Distance for almost full flag|
| AE_DISTANCE_g      | natural | 1     |  Distance for almost empty flag|
| H_L_CLK_RELATION_g | natural | 2     |  Relation of the clock frequencies (x * low_freq = high_freq)|
## Ports

| Port name | Direction | Type                                    | Description                         |
| --------- | --------- | --------------------------------------- | ----------------------------------- |
| h_clk     | in        | std_logic                               |  High clock domain clock            |
| h_rstn    | in        | std_logic                               |  High clock domain active low reset |
| h_din_i   | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  High clock domain data in          |
| h_we_i    | in        | std_logic                               |  High clock domain write enable     |
| h_F_o     | out       | std_logic                               |  High clock domain full flag        |
| h_AF_o    | out       | std_logic                               |  High clock domain almost full flag |
| l_clk     | in        | std_logic                               |  Low clock domain clock             |
| l_rstn    | in        | std_logic                               |  Low clock domain active low reset  |
| l_dout_o  | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  Low clock domain data out          |
| l_re_i    | in        | std_logic                               |  Low clock domain read enable       |
| l_E_o     | out       | std_logic                               |  Low clock domain empty flag        |
| l_AE_o    | out       | std_logic                               |  Low clock domain almost empty flag |
## Signals

| Name             | Type                                      | Description                                      |
| ---------------- | ----------------------------------------- | ----------------------------------------------- |
| h_read_s         | std_logic                                 |  Read signal from low to high fifo|
| l_write_s        | std_logic                                 |  Write signal from high to low fifo|
| h_fifo_E_s       | std_logic                                 |  High fifo empty flag|
| h_fifo_AE_s      | std_logic                                 |  High fifo empty flag|
| l_lfifo_F_s      | std_logic                                 |  Low fifo full flag|
| l_lfifo_AF_s     | std_logic                                 |  Low fifo full flag|
| h_lfifo_F_s      | std_logic                                 |  Low fifo full flag|
| h_lfifo_AF_s     | std_logic                                 |  Low fifo full flag|
| wait_response_s  | std_logic                                 |  Wait for low fifo to complete request|
| hl_data_s        | std_logic_vector(DWIDTH_g - 1 downto 0)   |  Data from high to low fifo|
| h_dout_s         | std_logic_vector(DWIDTH_g - 1 downto 0)   |  Data from high to low fifo|
| h_tick_counter_s | std_logic_vector(COUNTER_SIZE_c downto 0) |  Counter for high-low freq relation|
| hl_clk_s         | std_logic                                 |  Low clock signal sampled for high clock domain|
| hl_clk_old_s     | std_logic                  |                                                  |
## Constants

| Name           | Type    | Value                                          | Description                               |
| -------------- | ------- | ---------------------------------------------- | ----------------------------------------- |
| COUNTER_SIZE_c | natural |  natural(ceil(log2(real(H_L_CLK_RELATION_g)))) |  Counter size for high-low freq relation
 |
## Processes
- transfer_data_p: ( h_clk, h_rstn )
  - **Description**
  Process to transfer the data from high freq clk to low freq clk
 
## Instantiations

- h_fifo: fifo
- l_fifo: fifo
  - **Description**
  Low clock domain FIFO
 Fifo for outgoing data to low clock domain

- l_fifo_F_double_ff: double_ff
  - **Description**
  Double flop the low fifo full signal

- l_fifo_AF_double_ff: double_ff
  - **Description**
  Double flop the low fifo almost full signal

- l_clk_double_ff: double_ff
  - **Description**
  Double flop the low clock

