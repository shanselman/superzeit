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


# EXPOSE 8080

# RUN apk add --update build-base && \
#   apk add --update go git && \
#   mkdir -p /tmp/gotty && \
#   GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
#   mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
#   apk del go git build-base && \
#   rm -rf /tmp/gotty /var/cache/apk/*

# ENTRYPOINT ["/usr/local/bin/gotty"]
# CMD ["--permit-write","--reconnect","/bin/sh"]

#RUN sysctl -p
ENTRYPOINT ["./superzeit"]
#CMD watch -n 5 lsof | grep inotify & dotnet superzeit.dll
#CMD ["sh", "wwwroot/start.sh"]
#ENTRYPOINT ["dotnet","superzeit.dll"]

#RUN chmod a+x ./superzeit
#USER nobody
#ENTRYPOINT ["./superzeit"]

