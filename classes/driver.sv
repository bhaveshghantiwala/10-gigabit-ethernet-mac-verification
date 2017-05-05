class driver;
    
    virtual xge_mac_interface di;

    mailbox drv2sb;

    packet pkt;
    
    rand int pkt_length;

    constraint packet_length_reg {
        pkt_length inside { [64:1518] };
    }
    constraint packet_length_under {
        pkt_length inside { [8:63] };
    }
    constraint packet_length_over {
        pkt_length inside { [1518:2048] };
    }
    
    function new(input virtual xge_mac_interface di, input mailbox drv2sb);
        this.di = di;
        this.drv2sb = drv2sb;
    endfunction

    task send_packet();
 
        pkt = new();
        pkt.setup_packet(pkt_length, `TRANSMIT);
        assert(pkt.randomize());
        this.send();
    endtask
    
    local task send();
        int i;
        for (i = 0; i < pkt.pkt_size; i++) begin
            
            @(posedge di.clk_156m25);
            
            di.pkt_tx_data <= pkt.pkt_data[i];
            di.pkt_tx_val  <= pkt.pkt_val[i];
            di.pkt_tx_sop  <= pkt.pkt_sop[i];
            di.pkt_tx_eop  <= pkt.pkt_eop[i];
            di.pkt_tx_mod  <= pkt.pkt_mod[i];
        end

        drv2sb.put(pkt);
        pkt.increment_tx_pkt_count();
    endtask

    task init();
        di.wb_adr_i <= 8'b0;
        di.wb_clk_i <= 1'b0;
        di.wb_cyc_i <= 1'b0;
        di.wb_dat_i <= 32'b0;
        di.wb_rst_i <= 1'b1;
        di.wb_stb_i <= 1'b0;
        di.wb_we_i  <= 1'b0;
                    
        //init signals
        di.pkt_rx_ren <= 1'b0;
        di.pkt_tx_data <= 64'b0;
        di.pkt_tx_val <= 1'b0;
        di.pkt_tx_sop <= 1'b0;
        di.pkt_tx_eop <= 1'b0;
        di.pkt_tx_mod <= 3'b0;

        //reset signals
        di.reset_156m25_n <= 1'b0;
        di.reset_xgmii_rx_n <= 1'b0;
        di.reset_xgmii_tx_n <= 1'b0;

        @(posedge di.clk_156m25);
        di.reset_156m25_n <= 1'b1;
        di.reset_xgmii_rx_n <= 1'b1;
        di.reset_xgmii_tx_n <= 1'b1;

        @(posedge di.clk_156m25);
    endtask
 

endclass
