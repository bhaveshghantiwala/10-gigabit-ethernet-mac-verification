class monitor;
    
    virtual xge_mac_interface mi;

    mailbox mon2sb;

    packet pkt;

    int pkt_length;

    function new(input virtual xge_mac_interface mi, input mailbox mon2sb);
        this.mi = mi;
        this.mon2sb = mon2sb;
    endfunction

    task check_for_rx_packet(input int num_pkt_sent);
        forever begin
            
            @(posedge mi.clk_156m25);
            
            if (mi.pkt_rx_avail) begin
                pkt = new();
                this.receive_packet();
                if (num_pkt_sent == pkt.rx_pkt_count()) begin
                    break;
               end

            end

        end
        
 
    endtask

    local task receive_packet();
        logic [63:0] queue_pkt_data[$];
        logic queue_pkt_val[$];
        logic queue_pkt_sop[$];
        logic queue_pkt_eop[$];
        logic [2:0] queue_pkt_mod[$];

        
        bit done;
        bit sop_check;
        bit [2:0] rx_mod;
        int i;

        done = 0;
        sop_check = 0;

        mi.pkt_rx_ren <= 1'b1;
        
        while (!done) begin
            
            if(mi.pkt_rx_sop)
                sop_check = 1'b1;

            if(sop_check == 1'b1) begin 
                if (mi.pkt_rx_val) begin
                    
                    if (mi.pkt_rx_eop) begin
                        
                        mi.pkt_rx_ren <= 1'b0;
                        rx_mod = mi.pkt_rx_mod;
                        done = 1;
                    end
                end
                queue_pkt_data.push_back(mi.pkt_rx_data);
                queue_pkt_val.push_back(mi.pkt_rx_val);
                queue_pkt_sop.push_back(mi.pkt_rx_sop);
                queue_pkt_eop.push_back(mi.pkt_rx_eop);
                queue_pkt_mod.push_back(mi.pkt_rx_mod);
            end        
            
            @(posedge mi.clk_156m25);
        end
        
        if (rx_mod)
            this.pkt_length = queue_pkt_mod.size()*8 - 8 + rx_mod;
        else
            this.pkt_length = queue_pkt_mod.size()*8;

        pkt.setup_packet(this.pkt_length, `RECEIVE);

        for(i = 0; i < pkt.pkt_size; i++) begin
            pkt.pkt_data[i] = queue_pkt_data.pop_front();
            pkt.pkt_val[i]  = queue_pkt_val.pop_front();
            pkt.pkt_sop[i]  = queue_pkt_sop.pop_front();
            pkt.pkt_eop[i]  = queue_pkt_eop.pop_front();
            pkt.pkt_mod[i]  = queue_pkt_mod.pop_front();
        end
        
        mon2sb.put(pkt);
        pkt.increment_rx_pkt_count();
 
    endtask

endclass
