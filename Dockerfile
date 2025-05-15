# Stage 1: Base image with common dependencies
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04 as base

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    python3.10 \
    python3-pip \
    git \
    wget \
    libgl1 \
    && ln -sf /usr/bin/python3.10 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install runpod
RUN pip install runpod requests

# Go back to the root
WORKDIR /

# Add scripts
ADD start.sh rp_handler.py workflow.json ./
RUN chmod +x /start.sh

# Start handler
CMD ["/start.sh"]