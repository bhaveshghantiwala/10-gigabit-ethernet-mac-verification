class coverage;

    packet covpacket;

    covergroup mac_cov with function sample(reg [63:0] pkt_data);
        src_addr: coverpoint pkt_data {
            bins low_addr = {[64'h0000_0000_0000_0000:64'h5555_5555_5555_5555]};
            bins high_addr = {[64'haaaa_aaaa_aaaa_aaaa:64'hffff_ffff_ffff_ffff]};
            bins leftover = default;
        }
    endgroup

    function new();
        mac_cov = new();
    endfunction

    task collect_coverage(input packet pkt_from_drv);
        this.covpacket = pkt_from_drv;
        for(int i = 0; i < covpacket.pkt_size; i++) begin
            mac_cov.sample(covpacket.pkt_data[i]);
        end
    endtask
    
endclass
