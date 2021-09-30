# Entity: l2h_cdc_fifo

- **File**: l2h_cdc_fifo.vhd
## Diagram

![Diagram](l2h_cdc_fifo.svg "Diagram")
## Description

 CDC fifo for transfer from low to high frequency clock domain

 AE/AF flags can be disabled

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
| h_dout_o  | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  High clock domain data in          |
| h_re_i    | in        | std_logic                               |  High clock domain write enable     |
| h_E_o     | out       | std_logic                               |  High clock domain full flag        |
| h_AE_o    | out       | std_logic                               |  High clock domain almost full flag |
| l_clk     | in        | std_logic                               |  Low clock domain clock             |
| l_rstn    | in        | std_logic                               |  Low clock domain active low reset  |
| l_din_i   | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  Low clock domain data out          |
| l_we_i    | in        | std_logic                               |  Low clock domain read enable       |
| l_F_o     | out       | std_logic                               |  Low clock domain empty flag        |
| l_AF_o    | out       | std_logic                               |  Low clock domain almost empty flag |
## Signals

| Name             | Type                                      | Description                                  |
| ---------------- | ----------------------------------------- | ------------------------------------------- 
| h_tick_counter_s | std_logic_vector(COUNTER_SIZE_c downto 0) |  Counter for high-low freq relation|
| h_we_s           | std_logic                                 |  High fifo write enable|
| h_F_s            | std_logic                                 |  High fifo full|
| h_AF_s           | std_logic                                 |  High fifo almost full|
| l_re_s           | std_logic                                 |  Low fifo read enable|
| l_lE_s           | std_logic                                 |  Low fifo empty in low clock domain|
| h_lE_s           | std_logic                                 |  Low fifo empty in high clock domain|
| l_lAE_s          | std_logic                                 |  Low fifo almost empty in low clock domain|
| h_lAE_s          | std_logic                                 |  Low fifo almost emtpy in high clock domain|
| h_lclk_s         | std_logic                                 |  Low clock in high clock domain|
| h_lclk_old_s     | std_logic                                 |  Low clock in high clock domain buffer|
| wait_low_fifo_s  | std_logic                                 |  Signal to sync with low fifo|
| l_ldout_s        | std_logic_vector(DWIDTH_g - 1 downto 0)   |  Low fifo data out|
| h_ldout_s        | std_logic_vector(DWIDTH_g - 1 downto 0)   |  Low fifo data out|
| lh_data_s        | std_logic_vector(DWIDTH_g - 1 downto 0)   |                   |
## Constants

| Name           | Type    | Value                                          | Description                               |
| -------------- | ------- | ---------------------------------------------- | ----------------------------------------- |
| COUNTER_SIZE_c | natural |  natural(ceil(log2(real(H_L_CLK_RELATION_g)))) |  Counter size for high-low freq relation|
## Processes
- transfer_data_p: ( h_clk, h_rstn )
  - **Description**
  Process to transfer the data from low freq clk to high freq clk
 
## Instantiations

- h_fifo: fifo
- l_fifo: fifo
  - **Description**
  Low clock domain FIFO
 Fifo for outgoing data to low clock domain

- l_fifo_dout_double_ff: double_ff
  - **Description**
  Double flop the low fifo data

- l_fifo_F_double_ff: double_ff
  - **Description**
  Double flop the low fifo full signal

- l_fifo_AF_double_ff: double_ff
  - **Description**
  Double flop the low fifo almost full signal

- l_clk_double_ff: double_ff
  - **Description**
  Double flop the low clock

