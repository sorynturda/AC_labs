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
ExecStep $xv_path/bin/xelab -wto 39905329fbe043d4a14a505567f30606 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_numarator_behav xil_defaultlib.tb_numarator -log elaborate.log
