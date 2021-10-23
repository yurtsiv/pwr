exp=1
solveType=ForwardChecking
valSelector=Next
# varSelector=MostConstrained

problemSizes=(
  2
  3
  4
  6
  8
  9
  10
  12
  13
)

mkdir experiment_results || true

> $output

# solveTypes=(
#   Backtracking
#   ForwardChecking
#   AC3Dynamic
# )

varSelectors=(
  Next 
  MostConstrained 
)

for varSelector in "${varSelectors[@]}"
do
  output="experiment_results/$exp-$solveType-$valSelector-$varSelector.txt"

  for SIZE in "${problemSizes[@]}"
  do
    echo "Size $SIZE"
    echo "---" >> $output
    echo "SIZE $SIZE" >> $output
    cargo run MapColoring $solveType $SIZE $valSelector $varSelector | grep METRIC >> $output
  done
done

# echo "Analysing"
# python3 analyse.py