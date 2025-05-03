module top(
    //system
    input i_clk50,
    //-----------------------------
    input i_pclk,
    input i_vsync,
    input i_href,
    input [7:0] i_data,
    input i_reset,
    output o_clkCam,
    //-----------------------------
    output [12:0]   sdram_addr,
    output [1:0]    sdram_ba,
    output          sdram_cas_n,
    output          sdram_ras_n,
    output          sdram_we_n,
    output          sdram_cke,
    output          sdram_cs_n,
    output [15:0]   sdram_dq,
    output          sdram_clk,
    output          sdram_maskLow,
    output          sdram_maskHigh,
    //-----------------------------
    output led
);

//--------------------read-cam-------------------
wire [15:0] dataPixelFromCam;
wire sdramBusy;
assign sdramReady = ~sdramBusy;
wire pixelValidCam;
wire [9:0] o_xIndex, o_yIndex;
wire pixelClock;
wire enableWriteFifoMaster;
wire i_get; //signal to start capature frame
wire completeCaptureFrame; //signal notice complete frame
wire processCaptureFrame; //signal notice processing frame
wire [9:0] remainWordFifo;
wire enableReadFifo;
wire [15:0] dataFromFifo;
wire [15:0] dataToSdram;
wire [18:0] addressToSdram;
wire rdClkFifo;
wire enableWrSdram;
wire flagFinish_StCam;
wire sdramReady;
wire startStCam;
cameraRead cameraReadBlock(
    .i_pclk(i_pclk),
    .i_vsync(i_vsync),
    .i_href(i_href),
    .i_data(i_data),
    .i_reset(i_reset),
    .o_pixelOut(dataPixelFromCam),
    .o_pixelValid(pixelValidCam),
    .o_xIndex(o_xIndex),
    .o_yIndex(o_yIndex),
    .o_pixelClk(pixelClock)
);
controlWriteToFifo controlWriteFifoBlock(
    .i_xIndex(o_xIndex),
    .i_yIndex(o_yIndex),
    .i_clk(pixelClock),
    .i_reset(i_reset),
    .i_get(i_get),
    .o_eWriteFifo(enableWriteFifoMaster),
    .o_complete(completeCaptureFrame),
    .o_process(processCaptureFrame)
);
storeCamControl controlStoreToSdramBlock(
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(startStCam),
    .i_remainOnFifo(remainWordFifo),
    .i_process(processCaptureFrame),
    .i_sdramReady(sdramReady),
    .i_complete(completeCaptureFrame),
    .i_dataFifo(dataFromFifo),
    .o_get(i_get),
    .o_EnReadFifo(enableReadFifo),
    .o_RdClkFifo(rdClkFifo),
    .o_dataSdram(dataToSdram),
    .o_addressToSdram(addressToSdram),
    .o_wrSdram(enableWrSdram),
    .o_finish(flagFinish_StCam)
); 
fifoMem fifoBlock(
    .aclr(~i_reset),
    .data(dataPixelFromCam),
    .rdclk(rdClkFifo),
    .rdreq(enableReadFifo),
    .wrclk(pixelClock),
    .wrreq(enableWriteFifoMaster & pixelValidCam),
    .q(dataFromFifo),
    .rdempty(), //unuse
    .rdusedw(remainWordFifo),
    .wrfull(), //unuse
    .wrusedw() //unuse
);
//-------------------SDRAM control-----------------------
wire [15:0] dataWriteToSdram;
wire [18:0] addrWrireToSdram;
wire [18:0] addrFromWriteBackToSdram;
wire [15:0] dataFromWriteBack;
wire wrActiveCam;
wire enableWriteSdram;
wire enableReadSdram;
wire enableWrSdramFromWriteback;
wire [18:0] addrReadToSdram;
wire [15:0] dataReadFromSdram;
wire [23:0] addrWriteToSdram24;
wire [23:0] addrReadToSdram24;
assign addrWriteToSdram24 = {5'd0,addrWrireToSdram};
assign addrReadToSdram24 = {5'd0, addrReadToSdram};
dataSteamingSdramWrite dataStreamingWriteSdram(
    .i_dataA(dataFromWriteBack), //write back //0
    .i_dataB(dataToSdram), //camera // 1 
    .i_addrA(addrFromWriteBackToSdram),
    .i_addrB(addressToSdram),
    .i_enableWriteA(enableWrSdramFromWriteback),
    .i_enableWriteB(enableWrSdram),
    .i_sel(wrActiveCam),
    .o_data(dataWriteToSdram),
    .o_addr(addrWrireToSdram),
    .o_enableWrite(enableWriteSdram)
);
sdram_controller sdramControlBlock(
    .wr_addr(addrWrireToSdram24),
    .wr_data(dataWriteToSdram),
    .wr_enable(enableWriteSdram),
    .rd_addr(addrReadToSdram24),
    .rd_data(dataReadFromSdram),
    .rd_ready(), //unuse use busy instant
    .rd_enable(enableReadSdram),
    .busy(sdramBusy),
    .rst_n(i_reset),
    .clk(i_clk100),
    //----------sdram out------------
    .addr(sdram_addr),
    .bank_addr(sdram_ba),
    .data(sdram_dq),
    .clock_enable(sdram_cke),
    .cs_n(sdram_cs_n),
    .ras_n(sdram_ras_n),
    .cas_n(sdram_cas_n),
    .we_n(sdram_we_n),
    .data_mask_low(sdram_maskLow),
    .data_mask_high(sdram_maskHigh)
);
assign sdram_clk = i_clk100;  //clock supply for SDRAM synchronous with control module
//-----------------------Memory fectching---------------------
wire startFeching;
wire [5:0] opcode;
wire [18:0] baseAddr0, baseAddr1, baseAddr2;
wire [11:0] addrToSourceRam;
wire enableWrSourceRam0, enableWrSourceRam1, enableWrSourceRam2;
wire flagFinish_Fet;

baseAddrFetDecode baseAddressFetchingDescodeBlock(
    .i_opcode(opcode),
    .o_baseAddr0(baseAddr0),
    .o_baseAddr1(baseAddr1),
    .o_baseAddr2(baseAddr2)
);

fetchingControl fetchingControlBlock(
    .i_baseAddr0(baseAddr0),
    .i_baseAddr1(baseAddr1),
    .i_baseAddr2(baseAddr2),
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_sdramReady(sdramReady),
    .i_start(startFeching),
    .o_rdSdram(enableReadSdram),
    .o_addrToSdram(addrReadToSdram),
    .o_finish(flagFinish_Fet),
    .o_wrRam0(enableWrSourceRam0),
    .o_wrRam1(enableWrSourceRam1),
    .o_wrRam2(enableWrSourceRam2),
    .o_addrToRam(addrToSourceRam)
);

//-------------------Source Ram--------------
wire startReadSourceRam;
wire startReadSourceFromAve;
wire startReadSource;
wire rdActiveConvolution;
wire [89:0] dataForConvFromSourceRam0, dataForConvFromSourceRam1, dataForConvFromSourceRam2;
wire [107:0] addrReadDataForConvFromSourceRam0, addrReadDataForConvFromSourceRam1, addrReadDataForConvFromSourceRam2;
wire dataForConvFromSourceRamValid;
wire [107:0] addrReadDataForAveFromSourceRam0, addrReadDataForAveFromSourceRam1, addrReadDataForAveFromSourceRam2;
wire [107:0] addrReadSource0, addrReadSource1, addrReadSource2;
selAddrSourceRam selAddrSource0(
    .i_sel(rdActiveConvolution),
    .i_addrConv(addrReadDataForConvFromSourceRam0),
    .i_addrAve(addrReadDataForAveFromSourceRam0),
    .i_startReadFromConv(startReadSourceRam),
    .i_startReadFromAve(startReadSourceFromAve),
    .o_addr(addrReadSource0),
    .o_startRead(startReadSource)
);
selAddrSourceRam selAddrSource1(
    .i_sel(rdActiveConvolution),
    .i_addrConv(addrReadDataForConvFromSourceRam1),
    .i_addrAve(addrReadDataForAveFromSourceRam1),
    .i_startReadFromConv(startReadSourceRam),
    .i_startReadFromAve(startReadSourceFromAve),
    .o_addr(addrReadSource1),
    .o_startRead()
);
selAddrSourceRam selAddrSource2(
    .i_sel(rdActiveConvolution),
    .i_addrConv(addrReadDataForConvFromSourceRam2),
    .i_addrAve(addrReadDataForAveFromSourceRam2),
    .i_startReadFromConv(startReadSourceRam),
    .i_startReadFromAve(startReadSourceFromAve),
    .o_addr(addrReadSource2),
    .o_startRead()
);
ramControl sourceRam0Block(
    .i_addrOut(addrReadSource0), //addr read data
    .i_addrIn(addrToSourceRam),
    .i_data(dataReadFromSdram),     // Đầu vào dữ liệu
    .i_wrEnable(enableWrSourceRam0),
    .i_quickGet(1'd0), //dont need to read mode quick
    .i_addrOutQuick(12'd0), //dont need to use quick mode
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(startReadSource),
    .o_data(dataForConvFromSourceRam0),     // Đầu ra dữ liệu
    .o_quickData(), //dont use read quick mode 
    .o_valid(dataForConvFromSourceRamValid),
    .o_ready() //dont use
);
ramControl sourceRam1Block(
    .i_addrOut(addrReadSource1), //addr read data
    .i_addrIn(addrToSourceRam),
    .i_data(dataReadFromSdram),     // Đầu vào dữ liệu
    .i_wrEnable(enableWrSourceRam1),
    .i_quickGet(1'd0), //dont need to read mode quick
    .i_addrOutQuick(12'd0), //dont need to use quick mode
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(startReadSource),
    .o_data(dataForConvFromSourceRam1),     // Đầu ra dữ liệu
    .o_quickData(), //dont use read quick mode 
    .o_valid(), //only use at source ram 0
    .o_ready() //dont use
);
ramControl sourceRam2Block(
    .i_addrOut(addrReadSource2), //addr read data
    .i_addrIn(addrToSourceRam),
    .i_data(dataReadFromSdram),     // Đầu vào dữ liệu
    .i_wrEnable(enableWrSourceRam2),
    .i_quickGet(1'd0), //dont need to read mode quick
    .i_addrOutQuick(12'd0), //dont need to use quick mode
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(startReadSource),
    .o_data(dataForConvFromSourceRam2),     // Đầu ra dữ liệu
    .o_quickData(), //dont use read quick mode 
    .o_valid(), //only use at source ram 0
    .o_ready() //dont use
);
//---------------------Convolution control--------------
wire startConvolution;
wire opcodeConv;
wire opcodeSelConv;
wire enableWriteDestinationRam;
wire flagFinish_Conv;
wire [11:0] locationAddrConv;
wire [11:0] addrDestinationRamForConv0, addrDestinationRamForConv1, addrDestinationRamForConv2;
convolutionControl convControlBlock(
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(startConvolution),
    .i_opcode(opcodeConv),
    .i_validRam(dataForConvFromSourceRamValid),
    .o_addrRead0(addrReadDataForConvFromSourceRam0),
    .o_addrRead1(addrReadDataForConvFromSourceRam1),
    .o_addrRead2(addrReadDataForConvFromSourceRam2),
    .o_startRam(startReadSourceRam),
    .o_selRamD0(opcodeSelConv),
    .o_addrWrite0(addrDestinationRamForConv0),
    .o_addrWrite1(addrDestinationRamForConv1),
    .o_addrWrite2(addrDestinationRamForConv2),
    .o_wrEnable(enableWriteDestinationRam),
    .o_finish(flagFinish_Conv),
    .o_localAddr(locationAddrConv) 
);
//-----------------------Convolution-------------------------------
wire [89:0] weight0, weight1, weight2;
wire [9:0] dataOutConv0, dataOutConv1, dataOutConv2;
wire paddingSel0, paddingSel1, paddingSel2, paddingSel3, paddingSel4, paddingSel5, paddingSel6, paddingSel7, paddingSel8;
wire [8:0] selPadding;
assign selPadding = {paddingSel8, paddingSel7, paddingSel6, paddingSel5, paddingSel4, paddingSel3, paddingSel2, paddingSel1, paddingSel0};
wire [89:0] dataToConv0, dataToConv1, dataToConv2;
zeroPadding zeropaddingBlock0(
    .i_sel(selPadding),
    .i_data(dataForConvFromSourceRam0),
    .o_data(dataToConv0)
);
zeroPadding zeropaddingBlock1(
    .i_sel(selPadding),
    .i_data(dataForConvFromSourceRam1),
    .o_data(dataToConv1)
);
zeroPadding zeropaddingBlock2(
    .i_sel(selPadding),
    .i_data(dataForConvFromSourceRam2),
    .o_data(dataToConv2)
);
conv ConvolutionBlock(
    .i_busData0(dataToConv0),
    .i_busData1(dataToConv1),
    .i_busData2(dataToConv2),
    .i_busWeight0(weight0),
    .i_busWeight1(weight1),
    .i_busWeight2(weight2),
    .i_opcode(opcodeSelConv),
    .o_data0(dataOutConv0),
    .o_data1(dataOutConv1),
    .o_data2(dataOutConv2)
);
paddingControl paddingControlBlock(
    .i_localAddr(locationAddrConv),
    .o_sel0(paddingSel0),
    .o_sel1(paddingSel1),
    .o_sel2(paddingSel2),
    .o_sel3(paddingSel3),
    .o_sel4(paddingSel4),
    .o_sel5(paddingSel5),
    .o_sel6(paddingSel6),
    .o_sel7(paddingSel7),
    .o_sel8(paddingSel8)
);
//----------------------Weight Genneration-------------------------
weightGen weightGennerationBlock(
    .i_opcode(opcode),
    .o_weight0(weight0),
    .o_weight1(weight1),
    .o_weight2(weight2)
);
//------------------------Average Control--------------------------
wire enableWriteAdd;
wire resetValueAve;
wire maskAve;
wire flagFinish_Average;
averageControl averageControlBlock(
    input           .i_clk(i_clk100),
    input           .i_reset(i_reset),
    input           .i_start(startAve),
    input           .i_validRam(dataForConvFromSourceRamValid),
    output [107:0]  .o_addrRead0(addrReadDataForAveFromSourceRam0),
    output [107:0]  .o_addrRead1(addrReadDataForAveFromSourceRam1),
    output [107:0]  .o_addrRead2(addrReadDataForAveFromSourceRam2),
    output reg      .o_writeEnable(enableWriteAdd),
    output reg      .o_resetAverage(resetValueAve),
    output reg      .o_mask(maskAve),
    output reg      .o_startRam(startReadSourceFromAve),
    output reg      .o_finish(flagFinish_Average)
);
//----------------------Average-------------------
wire [89:0] dataToAve0, dataToAve1, dataToAve2;
wire [9:0] dataOutAve0, dataOutAve1, dataOutAve2;
mask MaseBlock0(
    .i_mask(maskAve),
    .i_data(dataForConvFromSourceRam0),
    .o_data(dataToAve0)
);
mask MaseBlock1(
    .i_mask(maskAve),
    .i_data(dataForConvFromSourceRam1),
    .o_data(dataToAve1)
);
mask MaseBlock2(
    .i_mask(maskAve),
    .i_data(dataForConvFromSourceRam2),
    .o_data(dataToAve2)
);
average AverageBlock0(
    .i_data(dataToAve0),
    .i_clk(i_clk100),
    .i_reset(resetValueAve),
    .i_writeAdd(enableWriteAdd),
    .o_data(dataOutAve0)
);
average AverageBlock1(
    .i_data(dataToAve1),
    .i_clk(i_clk100),
    .i_reset(resetValueAve),
    .i_writeAdd(enableWriteAdd),
    .o_data(dataOutAve1)
);
average AverageBlock2(
    .i_data(dataToAve2),
    .i_clk(i_clk100),
    .i_reset(resetValueAve),
    .i_writeAdd(enableWriteAdd),
    .o_data(dataOutAve2)
);
//--------------------Average control write register---------------
wire [15:0] selWriteRegister;
averageWriteControl controlWriteToRegister(
    .i_opcode(opcode),
    .o_selWrite(selWriteRegister)
);
//-------------------------Register Ave----------------------------
wire [159:0] dataOutFromRegisterAve;
registerAverage RegisterStoreAverageBlock(
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_enableWrite(flagFinish_Average),
    .i_selWrite(selWriteRegister),
    .i_data0(dataOutAve0),
    .i_data1(dataOutAve1),
    .i_data2(dataOutAve2),
    .o_ave(dataOutFromRegisterAve)
);
//---------------------Fully Connected-----------------------------
wire enableFullyConnected;
wire [31:0] resultFullyConnected;
fullyConnected fullyConnectedBlock(
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_enable(enableFullyConnected),
    .i_data(dataOutFromRegisterAve),
    .o_result(resultFullyConnected)
);
assign led = resultFullyConnected[31]; //activation function
//-----------------------Destination RAM---------------------------
wire quickModeEnable;
wire [18:0] quickModeAddr0, quickModeAddr1, quickModeAddr2;
wire [11:0] quickModeAddr0_12, quickModeAddr1_12, quickModeAddr2_12;
assign quickModeAddr0_12 = quickModeAddr0[11:0];
assign quickModeAddr1_12 = quickModeAddr1[11:0];
assign quickModeAddr2_12 = quickModeAddr2[11:0];
wire [9:0] dataOutQuickMode0, dataOutQuickMode1, dataOutQuickMode2;
ramControl destinationRam0Block(
    .i_addrOut(108'd0), //Dont use this read mode
    .i_addrIn(addrDestinationRamForConv0),
    .i_data(dataOutConv0),     // Đầu vào dữ liệu
    .i_wrEnable(enableWriteDestinationRam),
    .i_quickGet(quickModeEnable), 
    .i_addrOutQuick(quickModeAddr0_12), 
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(1'd0), //dont use this read mode
    .o_data(),     // dont use this read mode
    .o_quickData(dataOutQuickMode0), //dont use read quick mode 
    .o_valid(), //dont use this mode
    .o_ready() //dont use
);
ramControl destinationRam1Block(
    .i_addrOut(108'd0), //Dont use this read mode
    .i_addrIn(addrDestinationRamForConv1),
    .i_data(dataOutConv1),     // Đầu vào dữ liệu
    .i_wrEnable(enableWriteDestinationRam),
    .i_quickGet(quickModeEnable), 
    .i_addrOutQuick(quickModeAddr1_12), 
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(1'd0), //dont use this read mode
    .o_data(),     // dont use this read mode
    .o_quickData(dataOutQuickMode1), //dont use read quick mode 
    .o_valid(), //dont use this mode
    .o_ready() //dont use
);
ramControl destinationRam2Block(
    .i_addrOut(108'd0), //Dont use this read mode
    .i_addrIn(addrDestinationRamForConv2),
    .i_data(dataOutConv2),     // Đầu vào dữ liệu
    .i_wrEnable(enableWriteDestinationRam),
    .i_quickGet(quickModeEnable), 
    .i_addrOutQuick(quickModeAddr2_12), 
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_start(1'd0), //dont use this read mode
    .o_data(),     // dont use this read mode
    .o_quickData(dataOutQuickMode2), //dont use read quick mode 
    .o_valid(), //dont use this mode
    .o_ready() //dont use
);
//-------------------------Write back-------------------------------
wire [18:0] baseAddrWriteBack0, baseAddrWriteBack1, baseAddrWriteBack2;
wire startWriteBack;
wire [1:0] selDataForWriteBack;
wire flagFinish_WriteBack;
baseAddrWriteBackDecode writeBackDecodeAddrBlock(
    .i_opcode(opcode),
    .o_baseAddr0(baseAddrWriteBack0),
    .o_baseAddr1(baseAddrWriteBack1),
    .o_baseAddr2(baseAddrWriteBack2)
);
writeBackControl writeBackControlBlock(
    input               .i_clk(i_clk100),
    input               .i_reset(i_reset),
    input               .i_sdramReady(sdramReady),
    input [18:0]        .i_baseAddr0(baseAddrWriteBack0),
    input [18:0]        .i_baseAddr1(baseAddrWriteBack1),
    input [18:0]        .i_baseAddr2(baseAddrWriteBack2),
    input               .i_start(startWriteBack),
    output [18:0]       .o_addrToRam0(quickModeAddr0),
    output [18:0]       .o_addrToRam1(quickModeAddr1),
    output [18:0]       .o_addrToRam2(quickModeAddr2),
    output reg          .o_quickRam(quickModeEnable),
    output reg [18:0]   .o_addrToSdram(addrFromWriteBackToSdram),
    output reg          .o_wrSdram(enableWrSdramFromWriteback),
    output reg [1:0]    .o_selData(selDataForWriteBack),
    output reg          .o_finish(flagFinish_WriteBack)
);
selDataForWriteBack selDataForWriteBackBlock(
    .i_sel(selDataForWriteBack),
    .i_data0({5'd0, dataOutConv0}),
    .i_data1({5'd0, dataOutConv1}),
    .i_data2({5'd0, dataOutConv2}),
    .o_data(dataFromWriteBack)
);
//-------------------------Master control------------------------------
masterControl masterControlBlock(
    .i_clk(i_clk100),
    .i_reset(i_reset),
    .i_finish_cam(flagFinish_StCam),
    .i_finish_fet(flagFinish_Fet),
    .i_finish_conv(flagFinish_Conv),
    .i_finish_writeBack(flagFinish_WriteBack),
    .i_finish_ave(),
    .o_startCam(startStCam),
    .o_startFet(startFeching), 
    .o_startConvolution(startConvolution),
    .o_startAve(),
    .o_startWriteBack(startWriteBack),
    .o_wrActiveCam(wrActiveCam),
    .o_rdActiveConvolution(rdActiveConvolution),
    .o_opConv(opcodeConv),
    .o_opcode(opcode),
    .o_enableFullyConnected(enableFullyConnected)
);
endmodule