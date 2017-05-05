class environment;
   
    virtual xge_mac_interface ei;
   
    mailbox drv2sb;
    mailbox mon2sb;

    driver drv;
    monitor mon;
    scoreboard sb;

    rand int number_of_packets;
    rand int wait_time;

    constraint num_of_pkts {
        number_of_packets inside { [30:50] };
    }

    constraint wt {
        wait_time inside { [1:5] };
    }

    function new(input virtual xge_mac_interface ei);
        this.ei = ei;

        drv2sb = new();
        mon2sb = new();

        drv = new(ei, drv2sb);
        mon = new(ei, mon2sb);

        sb = new(drv2sb, mon2sb);
    endfunction
    
    task run();
        int i; 

        fork
            begin
                drv.init();
                $display("\nSending %0d packets...", this.number_of_packets);
                for (i = 0; i < this.number_of_packets; i++) begin
                    drv.randomize();
                    drv.send_packet();
                end
            end
            begin
                mon.check_for_rx_packet(number_of_packets);
            end
        join

        for (i = 0; i < this.number_of_packets; i++) begin
            sb.compare();   
        end

        sb.print();
  
        @(posedge ei.clk_156m25);
        $finish;
    
    endtask

endclass
