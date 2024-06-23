//Write the SystemVerilog code for the following items. Create a class Exercise1 containing two random variables, 8-bit data and 4-bit address . Create a constraint block that keeps address to 3 or 4. 
In an initial block, construct an Exercise1 object and randomize it. Check the status from randomization.////////////////

class Exercise;
  rand bit [7:0] data;
  rand bit [3:0] address;
  constraint adress_constraint{
  address inside {3,4};
  }
endclass

module tb;
initial begin
  Exercise ex1 = new();
  if(ex1.randomize()) begin
    $display("randomize successful: data = %0d and adress = %0d", ex1.data, ex1.address);
  end
end
endmodule

######################################################################################################

/////////////////////////////Modify the solution for Exercise 1 to create a new class Exercise2 so that:
data is always equal to 5
The probability of address==0 is 10%
The probability of address being between [1:14] is 80%
The probability of address==15 is 10%
/////////////////////////////////////////////////



class Exercise;
  rand bit [7:0] data;
  rand bit [3:0] address;
  constraint adress_constraint{
  address = 5;
  }
  
  address before data;
  if address == 0;
  address dist (0:= 10);
  else if
   address == 15
    address dist (15:=10);
  else
     address dist {[1:14] := 80};
endclass

######################################################################################################








































######################################################################################################

///////////////////////////////////////////////////////////////////////////////////////////A constraint that limits read transaction addresses to the range 0 to 7, inclusive.
Write behavioral code to turn off the above constraint. Construct and randomize a MemTrans object with an in-line constraint that limits read transaction addresses to the range 0 to 8, inclusive. Test that the in-line constraint is working.
/////////////////////////////////////
class MemTrans;
  rand bit [2:0] address;
  constraint read_address_range {
    address inside {[0:7]};
  }
endclass

module testbench;
  initial begin
    MemTrans mem = new();
    if (mem.randomize()) begin
      $display("Randomization successful: address = %0d", mem.address);
    end else begin
      $display("Randomization failed");
    end

    // In-line constraint
    if (mem.randomize() with {address inside {[0:8]};}) begin
      $display("In-line constraint successful: address = %0d", mem.address);
    end else begin
      $display("In-line constraint failed");
    end
  end
endmodule


#########################################################################################################3
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Create a class for a graphics image that is 10x10 pixels. The value for each pixel can be randomized to black or white. Randomly generate an image that is, on average, 20% white. 
  Print the image and report the number of pixels of each type.///////////////////////////////////////

  
class GraphicsImage;
  rand bit [99:0] pixels; // 10x10 pixels

  constraint pixel_distribution {
    pixels.dist {0 := 80, 1 := 20};
  }
endclass

module testbench;
  initial begin
    GraphicsImage img = new();
    if (img.randomize()) begin
      int white_count = 0;
      for (int i = 0; i < 100; i++) begin
        if (img.pixels[i]) white_count++;
      end
      $display("Generated image: %0d white pixels, %0d black pixels", white_count, 100 - white_count);
    end else begin
      $display("Randomization failed");
    end
  end
endmodule
######################################################################################################









######################################################################################################
/////////////////////////////////////////////////////////////////////////////////////////
Create a class, StimData, containing an array of integer samples. Randomize the size and contents of the array, constraining the size to be between 1 and 1000. Test the constraint by generating 20 transactions and reporting the size.
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class StimData;
  rand int unsigned samples[];
  constraint size_constraint {
    samples.size inside {[1:1000]};
  }
endclass

module testbench;
  initial begin
    StimData data = new();
    for (int i = 0; i < 20; i++) begin
      if (data.randomize()) begin
        $display("Transaction %0d: size = %0d", i, data.samples.size());
      end else begin
        $display("Randomization failed for transaction %0d", i);
      end
    end
  end
endmodule

######################################################################################################


  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  Expand the Transaction class below so back-to-back transactions of the same type do not have the same address.
    Test the constraint by generating 20 transactions.//////////////////////////////////////
    class Transaction;
  rand bit [7:0] data;
  rand bit [3:0] address;
  rand bit type;

  static bit previous_type;
  static bit [3:0] previous_address;

  constraint unique_address {
 
    if (type == previous_type) {
      address != previous_address;
    }
  }

  function void post_randomize();
    previous_type = type;
    previous_address = address;
  endfunction
endclass

module testbench;
  initial begin
    Transaction tx = new();
    for (int i = 0; i < 20; i++) begin
      if (tx.randomize()) begin
        $display("Transaction %0d: type = %0d, address = %0d", i, tx.type, tx.address);
      end else begin
        $display("Randomization failed %0d", i);
      end
    end
  end
endmodule
