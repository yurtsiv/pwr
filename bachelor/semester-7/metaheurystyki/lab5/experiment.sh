exp=1.11
algorithm="ga_sa"
analysis=$algorithm

if [ "$algorithm" = "ga_sa" ] || [ "$algorithm" = "ga_dynamic" ]
then
  analysis="ga"
fi

if [ -d results/experiment$exp ]
then
  echo "Results exist"
  exit 1;
fi

mkdir -p results/experiment$exp

params_str=$(cat src/$algorithm/params.txt)
ga_params_str=$(cat src/ga/params.txt)
sa_params_str=$(cat src/sa/params.txt)

cp src/$algorithm/params.txt results/experiment$exp/params.txt
cp src/ga/params.txt results/experiment$exp/ga_params.txt
cp src/sa/params.txt results/experiment$exp/sa_params.txt

for problem in  "A-n32-k5" "A-n39-k5" "A-n45-k6" "A-n48-k7" "A-n54-k7" "A-n60-k9" "A-n80-k10"
do
  results_dir=results/experiment$exp/$problem

  for I in {0..9}
  do
    mkdir -p $results_dir/$algorithm

    echo $params_str
    cargo run --release test_problems/$problem.txt $algorithm "$params_str" "$ga_params_str" "$sa_params_str" | tee $results_dir/$algorithm/log$I.txt
  done

  echo ""
  echo "Analysing results"
  python3 analysis/$analysis/main.py $results_dir/$algorithm
  echo "Finished"
done

python3 analysis/combine_results.py results/experiment$exp $algorithm