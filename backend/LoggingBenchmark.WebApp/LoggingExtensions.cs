using Elastic.Extensions.Logging;
using OpenTelemetry;

namespace LoggingBenchmark.WebApp;

public static class LoggingExtensions
{
    public static void AddLogging(this WebApplicationBuilder builder)
    {
        builder.Logging.ClearProviders();

        var benchmarkType = builder.Configuration.GetValue<BenchmarkType>("BenchmarkType");

        switch (benchmarkType)
        {
            case BenchmarkType.JsonConsole:
                builder.AddJsonConsoleLogging();
                break;
            case BenchmarkType.ElasticsearchHttpClient:
                builder.AddElasticsearchHttpClientLogging();
                break;
            case BenchmarkType.NoLogging:
                break;
        }

        builder.UseOtlpExporterIfAspire();
    }

    private static ILoggingBuilder AddJsonConsoleLogging(this WebApplicationBuilder builder)
    {
        return builder.Logging
            .AddJsonConsole(options =>
            {
                options.IncludeScopes = true;
                options.UseUtcTimestamp = true;
            });
    }

    private static ILoggingBuilder AddElasticsearchHttpClientLogging(this WebApplicationBuilder builder)
    {
        return builder.Logging.AddElasticsearch();
    }

    private static void UseOtlpExporterIfAspire(this WebApplicationBuilder builder)
    {
        bool useAspire = builder.Configuration.GetValue<bool>("AspireRuntime");
        if (useAspire)
        {
            builder.Services.AddOpenTelemetry().UseOtlpExporter();
        }
    }
}

public enum BenchmarkType
{
    JsonConsole = 1,
    ElasticsearchHttpClient = 2,
    NoLogging = 3
}
