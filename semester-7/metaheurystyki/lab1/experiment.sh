exp=1

for alogrithm in "greedy" "random" "genetic"
do
  for problem in "A-n32-k5" "A-n37-k6" "A-n39-k5" "A-n45-k6" "A-n48-k7" "A-n54-k7" "A-n60-k9"
  do
    dir=results/experiment$exp/$problem

    for I in {0..9}
    do
      mkdir -p $dir/genetic
      mkdir -p $dir/random
      mkdir -p $dir/greedy

      cargo run test_problems/$problem.txt $alogrithm | tee $dir/$alogrithm/log$I.txt
    done

    echo ""
    echo "Analysing results"
    python3 analysis/main.py $dir/$alogrithm
    echo "Finished"
  done
done