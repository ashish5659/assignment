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
