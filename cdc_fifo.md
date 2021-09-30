# Entity: cdc_fifo

- **File**: cdc_fifo.vhd
## Diagram

![Diagram](cdc_fifo.svg "Diagram")
## Description

 Bidirectional CDC fifo

 AE/AF flags can be disabled

 Data width, fifo depth and AE/AF thresholds can be parameterized
## Generics

| Generic name       | Type    | Value | Description                                                    |
| ------------------ | ------- | ----- | -------------------------------------------------------------- |
| DWIDTH_g           | natural | 32    |  Data width|
| H_L_CLK_RELATION_g | natural | 2     |  Relation of the clock frequencies (x * low_freq = high_freq)|
| DEPTH_H2L_H_g      | natural | 8     |  Depth of high to low fifo, high side|
| DEPTH_H2L_L_g      | natural | 8     |  Depth of high to low fifo, low side|
| DEPTH_L2H_H_g      | natural | 8     |  Depth of low to high fifo, high side|
| DEPTH_L2H_L_g      | natural | 8     |  Depth of low to high fifo, low side|
| H_ENABLE_AE_FLAG_g | natural | 1     |  Enable high fifo almost empty flag|
| H_AE_DISTANCE_g    | natural | 1     |  Distance for high fifo almost empty flag|
| H_ENABLE_AF_FLAG_g | natural | 1     |  Enable high fifo almost full flag|
| H_AF_DISTANCE_g    | natural | 1     |  Distance for high fifo almost full flag|
| L_ENABLE_AE_FLAG_g | natural | 1     |  Enable low fifo almost empty flag|
| L_AE_DISTANCE_g    | natural | 1     |  Distance for low fifo almost empty flag|
| L_ENABLE_AF_FLAG_g | natural | 1     |  Enable low fifo almost full flag|
| L_AF_DISTANCE_g    | natural | 1     |  Distance for low fifo almost full flag|
## Ports

| Port name | Direction | Type                                    | Description            |
| --------- | --------- | --------------------------------------- | ---------------------- |
| h_clk     | in        | std_logic                               |  HCD clock             |
| h_rstn    | in        | std_logic                               |  HCD active low reset  |
| h_din_i   | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  HCD data in           |
| h_dout_o  | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  HCD data out          |
| h_we_i    | in        | std_logic                               |  HCD write enable      |
| h_re_i    | in        | std_logic                               |  HCD read enable       |
| h_E_o     | out       | std_logic                               |  HCD empty flag        |
| h_F_o     | out       | std_logic                               |  HCD full flag         |
| h_AE_o    | out       | std_logic                               |  HCD almost empty flag |
| h_AF_o    | out       | std_logic                               |  HCD almost full flag  |
| l_clk     | in        | std_logic                               |  LCD clock             |
| l_rstn    | in        | std_logic                               |  LCD active low reset  |
| l_din_i   | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  LCD data in           |
| l_dout_o  | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  LCD data out          |
| l_we_i    | in        | std_logic                               |  LCD write enable      |
| l_re_i    | in        | std_logic                               |  LCD read enable       |
| l_E_o     | out       | std_logic                               |  LCD empty flag        |
| l_F_o     | out       | std_logic                               |  LCD full flag         |
| l_AE_o    | out       | std_logic                               |  LCD almost empty flag |
| l_AF_o    | out       | std_logic                               |  LCD almost full flag  |
## Instantiations

- l2h_cdc_fifo_inst: l2h_cdc_fifo
- h2l_cdc_fifo_inst: h2l_cdc_fifo
  - **Description**
  High to low CD fifo

