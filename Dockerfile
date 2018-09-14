FROM microsoft/dotnet:2.1-sdk-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY nuget.config . 
COPY superzeit/*.csproj ./superzeit/
RUN dotnet restore

# copy everything else and build app
COPY . .
WORKDIR /app/superzeit
RUN dotnet build
 
FROM build AS publish
WORKDIR /app/superzeit
# add IL Linker package (optional, can make things smaller. Can also be here, or in the actual csproj)
RUN dotnet add package ILLink.Tasks -v 0.1.5-preview-1841731 -s https://dotnet.myget.org/F/dotnet-core/api/v3/index.json
# ALPINE SELF CONTAINED
RUN dotnet publish -c Release -o out -r linux-musl-x64 /p:ShowLinkerSizeComparison=true 
# NOT SELF CONTAINED
#RUN dotnet publish -c Release -o out /p:ShowLinkerSizeComparison=true 

# ALPINE SELF CONTAINED 
FROM microsoft/dotnet:2.1-runtime-deps-alpine AS runtime
# NOT SELF CONTAINED
#FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine AS runtime

ENV DOTNET_USE_POLLING_FILE_WATCHER=true
#ENV ASPNETCORE_ENVIRONMENT=Development
WORKDIR /app
COPY --from=publish /app/superzeit/out ./

#expose a port and run it!
EXPOSE 80
ENTRYPOINT ["./superzeit"]
