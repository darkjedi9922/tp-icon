temps=`sensors -u | grep 'temp1_input:' | sort | awk '{print $2}'`;
echo $temps | awk '{print $1}';