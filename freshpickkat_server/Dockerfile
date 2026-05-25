# Build stage
FROM dart:3.8.0 AS build
WORKDIR /app

# Copy dependencies first for better caching
COPY pubspec.* .
RUN dart pub get

# Copy the rest of the code
COPY . .

# Compile the server executable
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM dart:3.8.0
WORKDIR /app

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/
COPY --from=build /app/repair-migration/ repair-migration/

# Ensure protocol.yaml is available for Insights
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command with environment variables
ENTRYPOINT ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role
