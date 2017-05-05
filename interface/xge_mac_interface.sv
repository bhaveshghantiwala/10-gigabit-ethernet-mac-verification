interface xge_mac_interface(input bit clk_156m25,
                            input bit clk_xgmii_rx,
                            input bit clk_xgmii_tx
                            );

    logic         reset_156m25_n;
    logic         reset_xgmii_rx_n;
    logic         reset_xgmii_tx_n;

    logic         pkt_rx_ren;

    logic [63:0]  pkt_tx_data;
    logic         pkt_tx_val;
    logic         pkt_tx_sop;
    logic         pkt_tx_eop;
    logic  [2:0]  pkt_tx_mod;

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    logic                    pkt_rx_avail;           // From dut of xge_mac.v
    logic [63:0]             pkt_rx_data;            // From dut of xge_mac.v
    logic                    pkt_rx_eop;             // From dut of xge_mac.v
    logic                    pkt_rx_err;             // From dut of xge_mac.v
    logic [2:0]              pkt_rx_mod;             // From dut of xge_mac.v
    logic                    pkt_rx_sop;             // From dut of xge_mac.v
    logic                    pkt_rx_val;             // From dut of xge_mac.v
    logic                    pkt_tx_full;            // From dut of xge_mac.v
    logic                    wb_ack_o;               // From dut of xge_mac.v
    logic [31:0]             wb_dat_o;               // From dut of xge_mac.v
    logic                    wb_int_o;               // From dut of xge_mac.v
    logic [7:0]              xgmii_txc;              // From dut of xge_mac.v
    logic [63:0]             xgmii_txd;              // From dut of xge_mac.v
    // End of automatics

    logic  [7:0]   wb_adr_i;
    logic          wb_clk_i;
    logic          wb_cyc_i;
    logic  [31:0]  wb_dat_i;
    logic          wb_rst_i;
    logic          wb_stb_i;
    logic          wb_we_i;

    logic [7:0]              xgmii_rxc;
    logic [63:0]             xgmii_rxd;

    logic [3:0]              tx_dataout;
   
    default clocking cb @(posedge clk_156m25);
    endclocking
endinterface
