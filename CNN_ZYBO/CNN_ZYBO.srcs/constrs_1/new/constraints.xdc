create_clock -period 40.000 -name clk_40 -waveform {0.000 20.000} -add [get_ports clk]
set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports clk]