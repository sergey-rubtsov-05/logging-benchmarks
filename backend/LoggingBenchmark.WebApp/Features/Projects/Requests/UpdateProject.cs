using LoggingBenchmark.WebApp.Database;
using LoggingBenchmark.WebApp.Features.Projects.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;

namespace LoggingBenchmark.WebApp.Features.Projects.Requests;

public class UpdateProject
{
    public class Endpoint
    {
        public void MapEndpoint(IEndpointRouteBuilder builder)
        {
            builder.MapPatch("/projects/{projectId:long}", async Task<Results<Ok<ProjectModel>, NotFound>> (
                long projectId,
                UpdateProjectRequest request,
                ILogger<CreateProject> logger,
                WebAppDbContext dbContext,
                CancellationToken cancellationToken) =>
            {
                int updatedNumber = await dbContext.Projects
                    .Where(o => o.Id == projectId)
                    .ExecuteUpdateAsync(calls => calls.SetProperty(o => o.Name, request.Name), cancellationToken);

                switch (updatedNumber)
                {
                    case 0:
                        return TypedResults.NotFound();
                    case 1:
                        break;
                    default:
                        throw new InvalidOperationException(
                            $"Unexpected number of updates for project with id: {projectId}. Actual number: {updatedNumber}");
                }

                var updatedProject = await dbContext.Projects
                    .SingleOrDefaultAsync(o => o.Id == projectId, cancellationToken);

                if (updatedProject is null)
                    return TypedResults.NotFound();

                var projectModel = new ProjectModel(updatedProject.Id, updatedProject.Name);

                logger.LogInformation("Project updated with id: {projectId}", projectModel.Id);

                return TypedResults.Ok(projectModel);
            });
        }
    }

    private record UpdateProjectRequest(string Name);
}
