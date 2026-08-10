# Specify root clocks
# The Chameleon96 has no FPGA-side oscillator: all 50 MHz refclks are
# derived from the HPS h2f_user1_clk (exposed by sys_top as clk_50m).
create_clock -period "50.0 MHz"  [get_pins -compatibility_mode *|h2f_user1_clk] -name h2f_user1_clk
create_clock -period "100.0 MHz" [get_pins -compatibility_mode *|h2f_user0_clk]
create_clock -period "10.0 MHz"  [get_pins -compatibility_mode *|hdmi_i2c|out_clk] -name hdmi_sck

derive_pll_clocks
derive_clock_uncertainty

# Decouple different clock groups (to simplify routing)
set_clock_groups -exclusive \
   -group [get_clocks { *|pll|pll_inst|altera_pll_i|*[*].*|divclk}] \
   -group [get_clocks { *|pll_hdmi|pll_hdmi_inst|altera_pll_i|*|*[*].*|divclk}] \
   -group [get_clocks { *|pll_audio|pll_audio_inst|altera_pll_i|*[*].*|divclk}] \
   -group [get_clocks { hdmi_sck}] \
   -group [get_clocks { *|h2f_user0_clk}] \
   -group [get_clocks { h2f_user1_clk}]

set_false_path -to   [get_ports {LED_}]

set_false_path -to   {sys_top|cfg[*]}
set_false_path -from {sys_top|cfg[*]}
set_false_path -from {sys_top|VSET[*]}
set_false_path -to   {sys_top|wcalc[*] sys_top|hcalc[*]}
set_false_path -to   {sys_top|hdmi_width[*] sys_top|hdmi_height[*]}
set_false_path -to   {sys_top|deb_* sys_top|btn_en sys_top|btn_up}

set_multicycle_path -to {*_osd|osd_vcnt*} -setup 2
set_multicycle_path -to {*_osd|osd_vcnt*} -hold 1

set_false_path -to   {*_osd|v_cnt*}
set_false_path -to   {*_osd|v_osd_start*}
set_false_path -to   {*_osd|v_info_start*}
set_false_path -to   {*_osd|h_osd_start*}
set_false_path -from {*_osd|v_osd_start*}
set_false_path -from {*_osd|v_info_start*}
set_false_path -from {*_osd|h_osd_start*}
set_false_path -from {*_osd|rot*}
set_false_path -from {*_osd|dsp_width*}
set_false_path -to   {*_osd|half}

set_false_path -to   {sys_top|WIDTH[*] sys_top|HFP[*] sys_top|HS[*] sys_top|HBP[*] sys_top|HEIGHT[*] sys_top|VFP[*] sys_top|VS[*] sys_top|VBP[*]}
set_false_path -from {sys_top|WIDTH[*] sys_top|HFP[*] sys_top|HS[*] sys_top|HBP[*] sys_top|HEIGHT[*] sys_top|VFP[*] sys_top|VS[*] sys_top|VBP[*]}
set_false_path -to   {sys_top|FB_BASE[*] sys_top|FB_WIDTH[*] sys_top|FB_HEIGHT[*] sys_top|LFB_HMIN[*] sys_top|LFB_HMAX[*] sys_top|LFB_VMIN[*] sys_top|LFB_VMAX[*]}
set_false_path -from {sys_top|FB_BASE[*] sys_top|FB_WIDTH[*] sys_top|FB_HEIGHT[*] sys_top|LFB_HMIN[*] sys_top|LFB_HMAX[*] sys_top|LFB_VMIN[*] sys_top|LFB_VMAX[*]}
set_false_path -to   {sys_top|vol_att[*] sys_top|scaler_flt[*] sys_top|led_overtake[*] sys_top|led_state[*]}
set_false_path -from {sys_top|vol_att[*] sys_top|scaler_flt[*] sys_top|led_overtake[*] sys_top|led_state[*]}
set_false_path -from {sys_top|aflt_* sys_top|acx* sys_top|acy* sys_top|areset* sys_top|arc*}
set_false_path -from {sys_top|arx* sys_top|ary*}
set_false_path -from {sys_top|vs_line*}
set_false_path -from {sys_top|ColorBurst_Range* sys_top|PhaseInc* sys_top|pal_en sys_top|cvbs sys_top|yc_en}

set_false_path -from {sys_top|ascal|o_ihsize*}
set_false_path -from {sys_top|ascal|o_ivsize*}
set_false_path -from {sys_top|ascal|o_format*}
set_false_path -from {sys_top|ascal|o_hdown}
set_false_path -from {sys_top|ascal|o_vdown}
set_false_path -from {sys_top|ascal|o_hmin* sys_top|ascal|o_hmax* sys_top|ascal|o_vmin* sys_top|ascal|o_vmax* sys_top|ascal|o_vrrmax* sys_top|ascal|o_vrr}
set_false_path -from {sys_top|ascal|o_hdisp* sys_top|ascal|o_vdisp*}
set_false_path -from {sys_top|ascal|o_htotal* sys_top|ascal|o_vtotal*}
set_false_path -from {sys_top|ascal|o_hsstart* sys_top|ascal|o_vsstart* sys_top|ascal|o_hsend* sys_top|ascal|o_vsend*}
set_false_path -from {sys_top|ascal|o_hsize* sys_top|ascal|o_vsize*}

set_false_path -from {sys_top|mcp23009|flg_*}
set_false_path -to   {sys_top|sysmem|fpga_interfaces|clocks_resets|f2h*}
