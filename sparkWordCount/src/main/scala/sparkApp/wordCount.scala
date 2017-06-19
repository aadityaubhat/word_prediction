package sparkApp

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext


/**
  * Created by aadityabhat on 6/17/17.
  */
object wordCount {
  def main(args: Array[String]): Unit = {
    val inputFile = args(0)
    val outputLocation = args(1)

    // Setting up Spark Cluster
    val conf = new SparkConf().setMaster("local[*]").setAppName("Simple Application").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Reading input
    val input = sc.textFile(inputFile)

    // Counting Frequency Count
    // Splitting input on space, to separate words
    input.flatMap(_.split(" "))

      // Converting words to tuple of word and 1
      .map(word => (word, 1))

      // Reducing the list by keys, adding up the counters
      .reduceByKey(_+_)

      // Converting a tuple into a comma separated string
      .map(x => x._1 + "," + x._2)

      // Saving the output as a text file
      .saveAsTextFile(outputLocation + "/counts")


    // Computing Bigrams
    input.map{
      substrings => substrings.split(' ').sliding(2).toArray.map{_.mkString(" ")}.groupBy{identity}.mapValues{_.size}
    }.

      // Reduce to get a global count, then collect
      flatMap{identity}.reduceByKey(_+_).map(x => x._1 + "," + x._2).saveAsTextFile(outputLocation + "/bigrams")

    // Computing Trigrams
    input.map{
      substrings => substrings.split(' ').sliding(3).toArray.map{_.mkString(" ")}.groupBy{identity}.mapValues{_.size}
    }.

      // Reduce to get a global count, then collect
      flatMap{identity}.reduceByKey(_+_).map(x => x._1 + "," + x._2).saveAsTextFile(outputLocation + "/trigrams")
  }
}
