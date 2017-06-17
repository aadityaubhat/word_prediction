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

    //val conf = new SparkConf().setAppName("wordCount")
    //val sc = new SparkContext(conf)

    val conf = new SparkConf().setMaster("local[*]").setAppName("Simple Application")
    val sc = new SparkContext(conf)


    val input = sc.textFile(inputFile)
    val words = input.flatMap(_.split(" "))
    val counts = words.map(word => (word, 1)).reduceByKey(_+_)

    counts.saveAsTextFile(outputLocation + "/counts")



    input.map{

      substrings => substrings.split(' ').sliding(2).toArray.map{_.mkString(" ")}.groupBy{identity}.mapValues{_.size}}.

//
//      // Split each line into substrings by periods
//      _.split('.').map{ substrings => substrings.split(' ').sliding(2)
//
//      }.
//
//        // Flatten, and map the bigrams to concatenated strings
//        flatMap{identity}.map{_.mkString(" ")}.
//
//        // Group the bigrams and count their frequency
//        groupBy{identity}.mapValues{_.size}
//
//    }.

      // Reduce to get a global count, then collect
      flatMap{identity}.reduceByKey(_+_).saveAsTextFile(outputLocation + "/bigrams")
  }
}
