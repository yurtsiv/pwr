alg="tabu"
for exp in "2.1" "2.2" "2.3" "2.4"
do
  for problem in "A-n32-k5" "A-n39-k5" "A-n45-k6" "A-n48-k7" "A-n54-k7" "A-n60-k9"
  do
    results_dir=results/experiment$exp/$problem

    echo ""
    echo "Analysing results"
    python3 analysis/$alg/main.py $results_dir/$alg
    echo "Finished"
  done

  python3 analysis/combine_results.py results/experiment$exp $alg
done