# Verbosegc in Java VM logs

Verbose garbage collection \(verbosegc\) logging is often required when tuning and debugging many issues, and has negligible impact on system performance.

The default HCL Digital Experience (DX) WebEngine installation enables verbosegc logging and configures the following generic Java Virtual Machine (JVM) argument:

`-Xlog:safepoint=info,gc:file=verbosegc.log:time,level,tags:filecount=5,filesize=20M`

The verbosegc log file name is `verbosegc.log`. 

The default HCL Digital Experience installation redirects the verbosegc output to 5 rotating historical log files, each containing 20MB.

For more information about configuring the JVM through Open Liberty see: [Logging and Tracing in Open Liberty](https://openliberty.io/docs/latest/log-trace-configuration.html)


