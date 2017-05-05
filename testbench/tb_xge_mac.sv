`include "timescale.v"
`include "defines.v"
module tb;

    bit           clk_156m25;
    bit           clk_312m50;
    bit           clk_xgmii_rx;
    bit           clk_xgmii_tx;

    task WaitNS;
      input [31:0] delay;
        begin
            #(1000*delay);
        end
    endtask

    task WaitPS;
      input [31:0] delay;
        begin
            #(delay);
        end
    endtask

    // Clock generation
    always begin
        WaitPS(3200);
        clk_156m25 = ~clk_156m25;
    end
    assign clk_xgmii_rx = clk_156m25;
    assign clk_xgmii_tx = clk_156m25;

    xge_mac_interface xmi(
        .clk_156m25 (clk_156m25),
        .clk_xgmii_rx (clk_xgmii_rx),
        .clk_xgmii_tx (clk_xgmii_tx)
        );

    xge_mac dut(/*AUTOINST*/
            // Outputs
            .pkt_rx_avail               (xmi.pkt_rx_avail),
            .pkt_rx_data                (xmi.pkt_rx_data[63:0]),
            .pkt_rx_eop                 (xmi.pkt_rx_eop),
            .pkt_rx_err                 (xmi.pkt_rx_err),
            .pkt_rx_mod                 (xmi.pkt_rx_mod[2:0]),
            .pkt_rx_sop                 (xmi.pkt_rx_sop),
            .pkt_rx_val                 (xmi.pkt_rx_val),
            .pkt_tx_full                (xmi.pkt_tx_full),
            .wb_ack_o                   (xmi.wb_ack_o),
            .wb_dat_o                   (xmi.wb_dat_o[31:0]),
            .wb_int_o                   (xmi.wb_int_o),
            .xgmii_txc                  (xmi.xgmii_txc[7:0]),
            .xgmii_txd                  (xmi.xgmii_txd[63:0]),
            // Inputs
            .clk_156m25                 (xmi.clk_156m25),
            .clk_xgmii_rx               (xmi.clk_xgmii_rx),
            .clk_xgmii_tx               (xmi.clk_xgmii_tx),
            .pkt_rx_ren                 (xmi.pkt_rx_ren),
            .pkt_tx_data                (xmi.pkt_tx_data[63:0]),
            .pkt_tx_eop                 (xmi.pkt_tx_eop),
            .pkt_tx_mod                 (xmi.pkt_tx_mod[2:0]),
            .pkt_tx_sop                 (xmi.pkt_tx_sop),
            .pkt_tx_val                 (xmi.pkt_tx_val),
            .reset_156m25_n             (xmi.reset_156m25_n),
            .reset_xgmii_rx_n           (xmi.reset_xgmii_rx_n),
            .reset_xgmii_tx_n           (xmi.reset_xgmii_tx_n),
            .wb_adr_i                   (xmi.wb_adr_i[7:0]),
            .wb_clk_i                   (xmi.wb_clk_i),
            .wb_cyc_i                   (xmi.wb_cyc_i),
            .wb_dat_i                   (xmi.wb_dat_i[31:0]),
            .wb_rst_i                   (xmi.wb_rst_i),
            .wb_stb_i                   (xmi.wb_stb_i),
            .wb_we_i                    (xmi.wb_we_i),
            .xgmii_rxc                  (xmi.xgmii_rxc[7:0]),
            .xgmii_rxd                  (xmi.xgmii_rxd[63:0]));

    testcase tc0(xmi);
    assign xmi.xgmii_rxc = xmi.xgmii_txc;
    assign xmi.xgmii_rxd = xmi.xgmii_txd;

endmodule
