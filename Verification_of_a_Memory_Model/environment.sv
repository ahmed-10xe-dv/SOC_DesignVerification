/*
Environment is a container class that contains
    1. Mailbox
    2. Gnerator
    3. Driver
    
    
*/
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
    //Classes Instances
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;


    mailbox mbx_G2D;           //Mailbox handle
    mailbox mbx_M2Sc;
    event completion;          
    virtual mem_intf vif;



    function new(virtual mem_intf vif);
        this.vif = vif;
        mbx_G2D = new();
        mbx_M2Sc = new();


        gen = new(mbx_G2D, completion);
        drv = new(mbx_G2D, vif);
        mon = new(vif, mbx_M2Sc);
        scb = new(mbx_M2Sc);
    endfunction //new()


    task pre_test();
        drv.reset();
    endtask //pre_test

    task test();
        fork
            gen.main();
            drv.main();
            mon.main();
            scb.main();

        join_any
    endtask

    task post_test();
        wait(gen.completion.triggered);
        wait(gen.repeat_count == drv.no_transactions);
        wait(gen.repeat_count == scb.no_transactions);
    endtask



    task run();
        pre_test();
        test();
        post_test();
        $finish;
    endtask

endclass //environment