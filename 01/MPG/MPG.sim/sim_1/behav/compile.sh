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
echo "xvhdl -m64 --relax -prj tb_numarator_vhdl.prj"
ExecStep $xv_path/bin/xvhdl -m64 --relax -prj tb_numarator_vhdl.prj 2>&1 | tee -a compile.log
