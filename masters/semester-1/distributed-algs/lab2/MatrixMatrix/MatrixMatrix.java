import java.io.IOException;
import java.util.StringTokenizer;
import java.util.HashMap;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;

public class MatrixMatrix {

  public static class Map
       extends Mapper<Object, Text, Text, Text>{

    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      Configuration config = context.getConfiguration();
      int m = Integer.parseInt(config.get("m")); // rows in A
      int p = Integer.parseInt(config.get("p")); // columns in B

      String line = value.toString();
      // [A|B, i, j, (A|B)ij]
      String[] lineChunks = line.split(",");

      Text outputKey = new Text();
      Text outputValue = new Text();

      if (lineChunks[0].equals("A")) {
        for (int k = 0; k < p; k++) {
          outputKey.set(lineChunks[1] + "," + k);
          outputValue.set(lineChunks[0] + "," + lineChunks[2] + "," + lineChunks[3]);
          context.write(outputKey, outputValue);
        }
      } else {
        for (int i = 0; i < m; i++) {
          outputKey.set(i + "," + lineChunks[2]);
          outputValue.set("B," + lineChunks[1] + "," + lineChunks[3]);
          context.write(outputKey, outputValue);
        }
      }
    }
  }

  public static class Reduce
       extends Reducer<Text,Text,Text,Text> {
    private Text result = new Text();

    public void reduce(Text key, Iterable<Text> values,
                       Context context
                       ) throws IOException, InterruptedException {
      String[] value;
      HashMap<Integer, Float> hashA = new HashMap<Integer, Float>();
      HashMap<Integer, Float> hashB = new HashMap<Integer, Float>();
  
      for (Text val : values) {
        value = val.toString().split(",");
        if (value[0].equals("A")) {
          hashA.put(Integer.parseInt(value[1]), Float.parseFloat(value[2]));
        } else {
          hashB.put(Integer.parseInt(value[1]), Float.parseFloat(value[2]));
        }
      }

      int n = Integer.parseInt(context.getConfiguration().get("n"));
      float result = 0.0f;

      for (int j = 0; j < n; j++) {
        float m_ij = hashA.containsKey(j) ? hashA.get(j) : 0.0f;
        float n_jk = hashB.containsKey(j) ? hashB.get(j) : 0.0f;
        result += m_ij * n_jk;
      }

      if (result != 0.0f) {
        context.write(null, new Text(key.toString() + "," + Float.toString(result)));
      }
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration config = new Configuration();
    // A is an m x n matrix; B is an n x p matrix.
    config.set("m", "2");
    config.set("n", "2");
    config.set("p", "2");

    @SuppressWarnings("deprecation")
    Job job = new Job(config, "MatrixMatrix");
    job.setJarByClass(MatrixMatrix.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    job.setMapperClass(Map.class);
    job.setReducerClass(Reduce.class);
    job.setInputFormatClass(TextInputFormat.class);
    job.setOutputFormatClass(TextOutputFormat.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    job.waitForCompletion(true);
  }
}