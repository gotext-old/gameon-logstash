# Game On Logstash

This is a simple logstash container that opens a secure Lumberjack endpoint for
our containers to send their logs to (using Logstash Forwarder for now) and, after
it groks them based on source, it sends them on to Bluemix's Logmet.
