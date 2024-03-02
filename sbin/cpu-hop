for var in `seq 0 15`
do
    let mask=10**$var
    # echo "var: $var"
    # echo "mas: $mask"
    hex_mask=`printf '%x\n' "$((2#$mask))"`
    echo "Hopping to CPU $var"
    taskset -p $hex_mask $1
    sleep 8
done
