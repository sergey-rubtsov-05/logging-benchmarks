using OpenTelemetry.Metrics;

namespace LoggingBenchmark.WebApp;

public static class MetricsExtensions
{
    public static WebApplicationBuilder AddMetrics(this WebApplicationBuilder builder)
    {
        builder.Services.AddOpenTelemetry()
            .WithMetrics(metrics =>
            {
                metrics
                    .AddAspNetCoreInstrumentation()
                    .AddHttpClientInstrumentation()
                    .AddRuntimeInstrumentation()
                    .AddPrometheusExporter();
            });

        return builder;
    }
}
