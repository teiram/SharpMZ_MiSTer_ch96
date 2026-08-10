//============================================================================
//  MiSTer on Chameleon96 - top level
//
//  Wraps the MiSTer hardware abstraction module (sys_top) onto the
//  Chameleon96 Cyclone V SoC board (5CSEBA6U19I7).
//
//  Board characteristics handled here:
//  - No FPGA-side oscillator: all 50 MHz refclks (FPGA_CLK1/2/3_50) come
//    from HPS h2f_user1_clk, exposed by sys_top's clk_50m output.
//  - Video: parallel RGB565 on the LCD connector (R[4:0], G[5:0], B[4:0])
//    with DE/HS/VS and pixel clock, driven from the HDMI_TX_* bus.
//  - Audio: I2S on the LCD/HDMI connector (MCLK/TXC/TXD/TXFS).
//  - HPS I2C2 (EMAC0) is FPGA-muxed on this board; the hdmi_i2c atom inside
//    sys_top drives the TDA19988 on pins U7/U10.
//  - VGA / SDIO / analog audio / MCP23009 / ADC / USER_IO are not present on
//    this board and are tied off or left unconnected.
//============================================================================

module ch96_top
(
	//////////// LCD/HDMI RGB565 //////////
	output  [4:0] LCD_R,
	output  [5:0] LCD_G,
	output  [4:0] LCD_B,
	output        LCD_DE,
	output        LCD_HSYNC,
	output        LCD_VSYNC,
	output        LCD_PIXEL_CLK,

	//////////// HDMI I2S audio //////////
	output        I2S_MCLK,
	output        I2S_TXC,
	output        I2S_TXD,
	output        I2S_TXFS,

	//////////// HPS I2C2 (EMAC0) -> TDA19988 //////////
	inout         I2C2_SCL,
	inout         I2C2_SDA
);

	wire clk_50m;

	sys_top sys_top
	(
		/////////// CLOCK //////////
		.FPGA_CLK1_50(clk_50m),
		.FPGA_CLK2_50(clk_50m),
		.FPGA_CLK3_50(clk_50m),
		.clk_50m(clk_50m),

		//////////// HDMI I2C (HPS I2C2 -> TDA19988) //////////
		.HDMI_I2C_SCL(I2C2_SCL),
		.HDMI_I2C_SDA(I2C2_SDA),

		//////////// HDMI I2S audio //////////
		.HDMI_MCLK(I2S_MCLK),
		.HDMI_SCLK(I2S_TXC),
		.HDMI_LRCLK(I2S_TXFS),
		.HDMI_I2S(I2S_TXD),

		//////////// HDMI / LCD parallel RGB565 //////////
		.HDMI_TX_CLK(LCD_PIXEL_CLK),
		.HDMI_TX_DE(LCD_DE),
		.HDMI_TX_D(hdmi_d),
		.HDMI_TX_HS(LCD_HSYNC),
		.HDMI_TX_VS(LCD_VSYNC),
		.HDMI_TX_INT(1'b1),

		//////////// VGA - not present //////////
		.VGA_R(),
		.VGA_G(),
		.VGA_B(),
		.VGA_HS(),
		.VGA_VS(),
		.VGA_EN(1'b1),

		//////////// Analog audio - not present //////////
		.AUDIO_L(),
		.AUDIO_R(),
		.AUDIO_SPDIF(),

		//////////// SDIO - not present //////////
		.SDIO_DAT(),
		.SDIO_CMD(),
		.SDIO_CLK(),

		//////////// LEDs/Buttons - not present //////////
		.LED_USER(),
		.LED_HDD(),
		.LED_POWER(),
		.BTN_USER(1'b1),
		.BTN_OSD(1'b1),
		.BTN_RESET(1'b1),

		//////////// Secondary SD SPI - not present //////////
		.SD_SPI_CS(),
		.SD_SPI_MISO(1'b0),
		.SD_SPI_CLK(),
		.SD_SPI_MOSI(),
		.SDCD_SPDIF(sdcd_spdif),
		.IO_SCL(),
		.IO_SDA(),

		//////////// ADC - not present //////////
		.ADC_SCK(),
		.ADC_SDO(1'b0),
		.ADC_SDI(),
		.ADC_CONVST(),

		//////////// MB KEY/SW/LED - not present //////////
		.KEY(2'b11),
		.SW(4'b0000),
		.LED(),

		//////////// USER IO - not present //////////
		.USER_IO()
	);

	// HDMI_TX_D[23:0] is RGB888 (R[23:16] G[15:8] B[7:0]); the Chameleon96
	// LCD connector takes RGB565: R[4:0]<-D[23:19], G[5:0]<-D[15:10],
	// B[4:0]<-D[7:3].
	wire [23:0] hdmi_d;
	assign LCD_R = hdmi_d[23:19];
	assign LCD_G = hdmi_d[15:10];
	assign LCD_B = hdmi_d[7:3];

	// SD card detect: hold the secondary-SD path "present" so the core SD
	// logic settles; on this board SD is handled by the HPS SDMMC.
	wire sdcd_spdif;
	assign sdcd_spdif = 1'b1;

endmodule
