# Bidding-Arbitrator
Design of bidding arbitrator that can arbitrate 4 masters to handle 4 slaves with proper interface.
Completely programmable and faster arbitration due to bidding system. Bid is made depending upon maximum account balance of master. At each time bid is made, account balance keeps decreasing. 
Bidding arbitrator arbitrates masters to handle slave devices based on urgency and priority of device. 

This goal accomplishes by doing this project. 
Here it consists verious systemverilog files/modules. 

Top module/testbench : top.sv
ajajajaja
Bus Master interface : bmif.sv

Slave interface : svif.sv

Bus Master design module : bmx.sv

Slave design module : slvx.sv

Arbitrator design module : arb.sv

script to run this project : sv_vcs

command to run : ./sv_vcs top.sv

Result file : result_arb.txt

All done with a smile :) :)
