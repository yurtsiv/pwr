exp=2.5
algorithm="tabu"

if [ -d results/experiment$exp ]
then
  echo "Results exist"
  exit 1;
fi

params_str=$(cat src/$algorithm/params.txt)

for problem in "A-n32-k5" "A-n39-k5" "A-n45-k6" "A-n48-k7" "A-n54-k7" "A-n60-k9"
do
  results_dir=results/experiment$exp/$problem

  for I in {0..9}
  do
    mkdir -p $results_dir/$algorithm

    echo $params_str
    cargo run --release test_problems/$problem.txt $algorithm "$params_str" | tee $results_dir/$algorithm/log$I.txt
  done

  echo ""
  echo "Analysing results"
  python3 analysis/$algorithm/main.py $results_dir/$algorithm
  echo "Finished"
done

python3 analysis/combine_results.py results/experiment$exp $algorithm