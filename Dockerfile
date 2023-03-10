FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
RUN ln -s /lib/x86_64-linux-gnu/libdl-2.24.so /lib/x86_64-linux-gnu/libdl.so

# install System.Drawing native dependencies
RUN apt-get update && apt-get install -y --allow-unauthenticated libgdiplus libc6-dev libx11-dev
RUN ln -s libgdiplus.so gdiplus.dll
WORKDIR /app
EXPOSE 80
ENV SYNCFUSION_LICENSE_KEY=""
ENV SPELLCHECK_DICTIONARY_PATH=""
ENV SPELLCHECK_JSON_FILENAME=""
ENV SPELLCHECK_CACHE_COUNT=""

ENV DOCUMENT_SLIDING_EXPIRATION_TIME="10"
ENV REDIS_CACHE_CONNECTION_STRING=""
ENV DOCUMENT_PATH=""
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /source
COPY ["src/ej2-webservice/ej2-webservice.csproj", "./ej2-webservice/ej2-webservice.csproj"]
COPY ["src/ej2-webservice/NuGet.Config", "./ej2-webservice/"]
RUN dotnet restore "./ej2-webservice/ej2-webservice.csproj"
COPY . .
WORKDIR "/source/src"
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ej2-webservice.dll"]