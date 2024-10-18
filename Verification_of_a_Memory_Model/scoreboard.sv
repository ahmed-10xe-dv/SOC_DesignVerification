/*
Scoreboard is responsible for receiving the sampled packet from monitor 
    1. If transaction type is read then compares with the local memory data
    2. If transaction type is write then the local memory will be written with the data
*/


class scoreboard;
    
    mailbox mbx_M2Sc;
    int no_transactions;

    //array to use as local memory
     bit [7:0] mem[4];


    function new(mailbox mbx_M2Sc);
        this.mbx_M2Sc = mbx_M2Sc;
        
        foreach(mem[i]) mem[i] = 8'hFF;
    endfunction //new()


    task main();
        forever begin
          Transaction tr;
          tr = new();  
            #50;
            mbx_M2Sc.get(tr);
            if (tr.rd_en) begin
                if (mem[tr.addr] != tr.rdata) 
                    $error("[SCB-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.addr,mem[tr.addr],tr.rdata);
//                 end  
                else 
                    $display("[SCB-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.addr,mem[tr.addr],tr.rdata);
            end
            else if (tr.wr_en) begin
                mem[tr.addr] = tr.wdata;
            end
          no_transactions++;
        end
    endtask
endclass //scoreboard