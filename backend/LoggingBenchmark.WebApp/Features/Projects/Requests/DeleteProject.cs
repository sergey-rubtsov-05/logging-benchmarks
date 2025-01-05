using LoggingBenchmark.WebApp.Database;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;

namespace LoggingBenchmark.WebApp.Features.Projects.Requests;

public class DeleteProject
{
    public class Endpoint
    {
        public void MapEndpoint(IEndpointRouteBuilder builder)
        {
            builder.MapDelete("/projects/{projectId:long}", async Task<Results<Ok, NotFound>> (
                long projectId,
                ILogger<DeleteProject> logger,
                WebAppDbContext dbContext,
                CancellationToken cancellationToken) =>
            {
                logger.LogInformation("Delete project {projectId}", projectId);

                int deletedCount = await dbContext.Projects
                    .Where(o => o.Id == projectId)
                    .ExecuteDeleteAsync(cancellationToken);

                return deletedCount switch
                {
                    0 => TypedResults.NotFound(),
                    1 => TypedResults.Ok(),
                    _ => throw new InvalidOperationException(
                        $"Unexpected number of deleted projects for {projectId}. Actual number: {deletedCount}")
                };
            });
        }
    }
}
