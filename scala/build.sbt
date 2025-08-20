name := "scala-benchmark"
version := "1.0"
scalaVersion := "2.13.12"

libraryDependencies ++= Seq(
  "org.json4s" %% "json4s-native" % "4.0.6"
)

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-Xlint",
  "-opt:l:inline",
  "-opt-inline-from:**"
)

assembly / assemblyJarName := "benchmark.jar"
assembly / mainClass := Some("com.benchmark.Benchmark")