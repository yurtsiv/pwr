exp=20
problem=2

dir=results/experiment$exp/problem$problem

for I in {0..9}
do
  mkdir -p $dir/ga
  mkdir -p $dir/random

  cargo run test_problems/zad$problem.txt $dir/ga/results$I.svg | tee $dir/ga/log$I.txt
  # cargo run test_problems/zad$problem.txt $dir/random/results$I.svg random | tee $dir/random/log$I.txt
done

echo ""
echo "Analysing results"
python3 analysis/main.py $dir/ga
# python3 analysis/main.py $dir/random
echo "Finished"