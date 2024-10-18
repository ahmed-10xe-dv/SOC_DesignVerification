/* Interface is responsible for 
    1. Grouping Signals
    2. Defining Modports
    3. Clocking Block 

*/

interface mem_intf(input logic clk, reset);           // Why we using the reset and clk as an input to the intf as argument?
  //declaring the signals
 logic [1:0] addr;
 logic wr_en;
 logic rd_en;
 logic [7:0] wdata;
 logic [7:0] rdata;

 //Driver Clocking Block 
 clocking driver_cb @(posedge clk);              // Clocking block to synchrionize the DRIVER 
     default input #1 output #1;                 // Default input and output skew of 1 time unit
     output addr;
     output wr_en;
     output rd_en;
     output wdata;
     input rdata;                                    //Since a driver gives the values to the DUT this is why all the input ports of 
                                                     //the DUT are actually outputs of the   driver and vice versa
 endclocking
    
 
 //Monitor Clocking Block
 clocking monitor_cb @(posedge clk);              // Clocking block to synchrionize the Monitor 
     default input #1 output #1;                 // Default input and output skew of 1 time unit
     input addr;
     input wr_en;
     input rd_en;
     input wdata;
     input rdata;                                    //Since we are only getting the response from the DUT to monitor through interface, that's why all signals 
                                                     // Are declared inputs
 endclocking



 //Modports
 modport DRIVER (
 clocking driver_cb,                     //Declaring here that all the I/O defined in driver_cb are I/O here in this modport and addtional clk and reset input
 input clk, reset
 );


 modport MONITOR (
     clocking monitor_cb,
     input clk, reset
 );

endinterface //mem_intf