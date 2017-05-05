class packet;

    rand logic [63:0] pkt_data[];
    logic pkt_val[];
    logic pkt_sop[];
    logic pkt_eop[];
    logic [2:0] pkt_mod[];
    int pkt_length;
    int pkt_size;
    static int tx_pkt_cnt;
    static int rx_pkt_cnt;

    function new();
    endfunction
    
    function setup_packet(input int pkt_length = 64, input bit pkt_type);
        int i;
        
        this.pkt_length = pkt_length;
        
        if(this.pkt_length % 8)
            this.pkt_size = this.pkt_length/8 + 1;
        else
            this.pkt_size = this.pkt_length/8;
        
        this.pkt_data = new[this.pkt_size];
        this.pkt_val  = new[this.pkt_size];
        this.pkt_sop  = new[this.pkt_size];
        this.pkt_eop  = new[this.pkt_size];
        this.pkt_mod  = new[this.pkt_size];
        
        if (pkt_type == `TRANSMIT) begin
            for(i = 0; i < this.pkt_size; i++) begin
                
                this.pkt_val[i] = 1'b1;

                if (i == 0)
                    this.pkt_sop[i] = 1'b1;
                else
                    this.pkt_sop[i] = 1'b0;

                if (i == this.pkt_size - 1) begin
                    this.pkt_eop[i] = 1'b1;
                    this.pkt_mod[i] = this.pkt_length % 8;
                end
                else begin
                    this.pkt_eop[i] = 1'b0;
                    this.pkt_mod[i] = 3'b0;
                end

            end
        end
        
    endfunction

    function print_status();
        int i;
        $display("Status:");
        for(i = 0; i < this.pkt_size; i++) begin
            $display("%b%b000%b", 
                this.pkt_sop[i], this.pkt_eop[i], this.pkt_mod[i]);
        end
    endfunction

    function print_data(input bit pkt_type);
        int i;
        $display("---------------------------------------------");
        if (pkt_type == `TRANSMIT) begin
            $display("Transmit packet with length: %0d, Time: %0t", this.pkt_length, $time);
        end
        if (pkt_type == `RECEIVE) begin
            $display("Receive packet with length %0d, Time: %0t", this.pkt_length, $time);
        end
        $display("---------------------------------------------");
        for(i = 0; i < this.pkt_size; i++) begin
            $display("%h", this.pkt_data[i]);
        end
        $display("---------------------------------------------\n");
    endfunction

    function int tx_pkt_count();
        return this.tx_pkt_cnt;
    endfunction

    function int rx_pkt_count();
        return this.rx_pkt_cnt;
    endfunction

    function increment_tx_pkt_count();
        this.tx_pkt_cnt++;
    endfunction

    function increment_rx_pkt_count();
        this.rx_pkt_cnt++;
    endfunction

endclass
