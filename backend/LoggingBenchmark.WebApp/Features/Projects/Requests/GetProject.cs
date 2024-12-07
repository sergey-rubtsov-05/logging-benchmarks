using IdGen;
using LoggingBenchmark.WebApp.Domain;
using LoggingBenchmark.WebApp.Features.Projects.Models;
using Microsoft.AspNetCore.Http.HttpResults;

namespace LoggingBenchmark.WebApp.Features.Projects.Requests;

public class GetProject
{
    public class Endpoint
    {
        public void MapEndpoint(IEndpointRouteBuilder builder)
        {
            builder.MapGet("/project/{projectId}",
                Task<Ok<ProjectModel>> (ulong projectId, ILoggerFactory loggerFactory, IdGenerator idGenerator,
                    CancellationToken cancellationToken) =>
                {
                    var logger = loggerFactory.CreateLogger<GetProject>();

                    logger.LogInformation("Request project {projectId}", projectId);

                    var project = new Project { Id = idGenerator.CreateId(), Name = "Sample Project" };

                    var projectModel = new ProjectModel { Id = project.Id, Name = project.Name };

                    return Task.FromResult(TypedResults.Ok(projectModel));
                });
        }
    }
}