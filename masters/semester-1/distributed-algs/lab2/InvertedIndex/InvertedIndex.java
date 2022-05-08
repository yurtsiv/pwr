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
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class InvertedIndex {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, Text>{

    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      Path filePath = ((FileSplit)context.getInputSplit()).getPath();
      String fileName = filePath.getName();

      Text file = new Text(fileName);

      String line = value.toString().replaceAll("[^a-zA-Z]", " ").toLowerCase();
      StringTokenizer itr = new StringTokenizer(line);
      while (itr.hasMoreTokens()) {
        String word = itr.nextToken().trim();

        if (word != "" && !word.isEmpty()) {
          context.write(new Text(word), file);
        }
      }
    }
  }

  public static class AppendReducer
       extends Reducer<Text,Text,Text,Text> {
    private Text result = new Text();

    public void reduce(Text word, Iterable<Text> files,
                       Context context
                       ) throws IOException, InterruptedException {
       HashMap<String,Integer> occurances = new HashMap<String,Integer>();

      for (Text file : files) {
        occurances.put(
          file.toString(),
          occurances.containsKey(file.toString()) ? occurances.get(file.toString()) + 1 : 1
        );
      }

      StringBuilder res = new StringBuilder();
      for (String file : occurances.keySet()) {
        res.append(file + ":" + occurances.get(file) + " ");
      }

      context.write(word, new Text(res.toString()));
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "word count");
    job.setJarByClass(InvertedIndex.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setReducerClass(AppendReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}