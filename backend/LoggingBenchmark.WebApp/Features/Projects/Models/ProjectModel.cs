namespace LoggingBenchmark.WebApp.Features.Projects.Models;

public record ProjectModel
{
    public long Id { get; init; }
    public required string Name { get; init; }
}
