# ---- Stage 1: Build ----
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build 
WORKDIR /src

# Copy only the project file and restore dependencies first
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the source code and build
COPY . .
RUN dotnet publish -c Release -o /app/publish

# ---- Stage 2: Runtime ----
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app

# Copy build output from previous stage
COPY --from=build /app/publish .

# Set the entrypoint
ENTRYPOINT [ "dotnet", "EnvApp.dll" ]