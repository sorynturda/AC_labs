#!/bin/bash -f
xv_path="/opt/xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim tb_numarator_behav -key {Behavioral:sim_1:Functional:tb_numarator} -tclbatch tb_numarator.tcl -log simulate.log
