alg="sa"
for exp in "3.7"
do
  for problem in "A-n39-k5"
  do
    results_dir=results/experiment$exp/$problem

    echo ""
    echo "Analysing results"
    python3 analysis/$alg/main.py $results_dir/$alg
    echo "Finished"
  done

  # python3 analysis/combine_results.py results/experiment$exp $alg
done