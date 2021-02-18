FROM sanchorubyroid/house:latest

# Copy project
COPY . .

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
