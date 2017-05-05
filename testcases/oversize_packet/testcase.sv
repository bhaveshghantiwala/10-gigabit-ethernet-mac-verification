`define TRANSMIT 1'b0
`define RECEIVE  1'b1
`include "packet.sv"
`include "driver.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "scoreboard.sv"
`include "environment.sv"

program testcase(interface tci);

    environment env;

    initial begin
   
        env = new(tci);
        
        env.drv.constraint_mode(0);
        env.drv.packet_length_over.constraint_mode(1);

        env.randomize();
        env.run();
    
    end
   
endprogram
