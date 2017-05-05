class scoreboard;
    
    mailbox drv2sb;
    mailbox mon2sb;

    packet pkt_from_drv;
    packet pkt_from_mon;

    coverage cov;

    bit error;
    
    static int tot_num_comp;
    static int num_bytes_comp;

    function new(
        input mailbox drv2sb,
        input mailbox mon2sb
        );

        this.drv2sb = drv2sb;
        this.mon2sb = mon2sb;
        
        cov = new();

        error = 1'b0;
    endfunction

    task compare();

        int i;
        int k;
        int last_bytes;

        drv2sb.get(pkt_from_drv);
        mon2sb.get(pkt_from_mon);
        
        tot_num_comp++;
        
        //check pkt size
        if (pkt_from_drv.pkt_length !== pkt_from_mon.pkt_length) begin
            $display("ERROR: Packet length transmitted does not match packet length received.");
            $display("Location of error: packet #%0d", tot_num_comp);
            error = 1'b1;
        end
        
        //check pkt data
        for (i = 0; i < pkt_from_drv.pkt_size; i++) begin
            if ( i == pkt_from_drv.pkt_size - 1 && pkt_from_drv.pkt_mod[i] !== 3'b000) begin
                num_bytes_comp = num_bytes_comp + pkt_from_drv.pkt_mod[i];
                last_bytes = 8 - pkt_from_drv.pkt_mod[i];
                for (k = 8; k > last_bytes; k--) begin
                    if (pkt_from_drv.pkt_data[i][k*8-1 -: 8] !== pkt_from_mon.pkt_data[i][k*8-1 -: 8]) begin 
                        $display("ERROR: Packet data mismatch. Location of error: packet #%0d, 8 byte section #%0d", tot_num_comp, i);
                        error = 1'b1;
                    end
                end
            end
            else begin  
                num_bytes_comp = num_bytes_comp + 8;
                if (pkt_from_drv.pkt_data[i] !== pkt_from_mon.pkt_data[i]) begin
                    $display("ERROR: Packet data mismatch. Location of error: packet #%0d, 8 byte section #%0d", tot_num_comp, i);
                    error = 1'b1;
                end
            end

        end

        cov.collect_coverage(pkt_from_drv);

    endtask

    function print();
        $display("----------------------------------------------");
        $display("Scoreboard Data");
        $display("----------------------------------------------");
        $display("Number of packets transmitted: %0d", pkt_from_drv.tx_pkt_count());
        $display("Number of packets received   : %0d", pkt_from_mon.rx_pkt_count());
        $display("Number of packets checked    : %0d", this.tot_num_comp);
        $display("Number of bytes checked      : %0d", this.num_bytes_comp);
        if (error)
            $display("NOT all packets received successfully.");
        else
            $display("All packets recieved sucessfully.");
        $display("----------------------------------------------\n");
    endfunction

endclass
