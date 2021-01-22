offlineimap -a Personal & pid1=$!
# offlineimap -a Work & pid2=$!

wait $pid1
# wait $pid2
echo "Last execution: $(date)"
