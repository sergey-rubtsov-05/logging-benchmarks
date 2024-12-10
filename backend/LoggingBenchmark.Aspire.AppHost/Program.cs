using Projects;

var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<LoggingBenchmark_WebApp>("web-app");

builder.Build().Run();
