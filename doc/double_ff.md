# Entity: double_ff

- **File**: double_ff.vhd
## Diagram

![Diagram](double_ff.svg "Diagram")
## Description

 Double Flipflopping for CDC low -> high clock domain
## Generics

| Generic name | Type    | Value | Description                    |
| ------------ | ------- | ----- | ------------------------------ |
| DWIDTH_g     | natural | 1     |  Width of the double flopping|
## Ports

| Port name | Direction | Type                                    | Description                    |
| --------- | --------- | --------------------------------------- | ------------------------------ |
| clk       | in        | std_logic                               |  High clock domain clock input |
| d         | in        | std_logic_vector(DWIDTH_g - 1 downto 0) |  Data input                    |
| q         | out       | std_logic_vector(DWIDTH_g - 1 downto 0) |  Data output                   |
## Signals

| Name  | Type                                    | Description |
| ----- | --------------------------------------- | ----------- |
| d_buf | std_logic_vector(DWIDTH_g - 1 downto 0) |             |
## Processes
- unnamed: ( clk )
