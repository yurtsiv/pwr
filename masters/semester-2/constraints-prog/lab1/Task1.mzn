% Lab 1 Task 1
int: max_w = 40;
var 1..max_w: w1;
var 1..max_w: w2;
var 1..max_w: w3;
var 1..max_w: w4;

constraint w1 + w2 + w3 + w4 = max_w;
constraint w1 >= w2;
constraint w2 >= w3;
constraint w3 >= w4;

constraint forall(i in 1..(max_w - 1)) (
  exists(s1 in -1..1, s2 in -1..1, s3 in -1..1, s4 in -1..1) (
    w1 * s1 + w2 * s2 + w3 * s3 + w4 * s4 = i
  )
);

solve satisfy;