# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    vim \
    ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /ansible-setup

# Copy local files to the container
COPY ./ .

# Expose SSH port
EXPOSE 22

# Entrypoint
CMD ["bash", "-c", "./scripts/ansible-setup.sh && while true; do sleep 1; done"]