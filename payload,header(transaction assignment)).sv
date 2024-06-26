virtual class transaction;
  
  rand bit [7:0] header;
  rand bit [15:0] payload;
  bit parity;
  
  pure virtual function void print_packets();
  pure virtual function void display_parity();
  pure virtual function void display_payload();
    
    constraint data_payload {
      
      payload < 1500;
      
    }
    
endclass
    
class large_packet extends transaction;
  
  function void print_packets();
    
    $display("Large packet : Header = %0d, Payload = %0d, parity = %b", header, payload, parity);
    
  endfunction
  
  function void display_parity();
    
    $display("Large Packet Parity = %b", parity);
    
  endfunction
  
  
  function void display_payload();
  	
    $display("Large Packet Payload = %0d", payload);
    
  endfunction;
  
  
endclass
    
class small_packet extends transaction;

  function void print_packets();
    
    $display("Small Packet : header = %0d, Payload = %0d, parity = %b", this.header, this.payload, this.parity);
    
  endfunction
  
  function void display_parity();
    
    $display("Small Packet Parity = %b", this.parity);
    
  endfunction
  
  function void display_payload();
    
    $display("Small Packet Payload = %0d", this.payload);
    
  endfunction
 
  
endclass
    
class corrupted_packet extends transaction;
    
  
  function void print_packets();
    
    $display("Corrupted Packet : Header = %0d, Payload = %0d, Parity = %b", this.header, this.payload, this.parity);
    
  endfunction
  
  function void display_payload();
    
    $display("Corrupted Packet Payload = %0d ", this.payload);
    
  endfunction
  
  function void display_parity();
    
    $display("Corrupted Packet Parity = %b",this.parity);
    
  endfunction
  
endclass
    
    
module tb();
  
  function void send_packet(transaction t);
    
    t.print_packets();
    t.display_payload();
    t.display_parity();
    
  endfunction
  
  large_packet l1;
  small_packet s1;
  corrupted_packet c1;
  
  initial begin
    
    l1 = new();
    s1 = new();
    c1 = new();
    
    $display("#############################");
    for( int i = 0 ; i<3 ; i++) begin
      
      l1.randomize();
      send_packet(l1);
	      
    end
    
    $display("##################################");
    
    for( int i = 0 ; i<3 ; i++) begin
      
      s1.randomize(); 
      send_packet(s1);
	      
    end    
    
    $display("################################");
    
    for( int i = 0 ; i<3 ; i++) begin
      
      c1.randomize();
      send_packet(c1);
	      
    end 
    
    $display("###############################");
    
    $finish;

  end
  
  
endmodule
    
    
  
