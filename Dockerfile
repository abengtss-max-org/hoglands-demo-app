# =============================================================================
# Intentionally Vulnerable Dockerfile — for Defender for DevOps Demo
# =============================================================================
# This Dockerfile contains multiple security issues that Microsoft Security
# DevOps and Trivy will detect during pipeline scanning.
# =============================================================================

# ISSUE 1: Using an old base image with known CVEs
FROM node:16-alpine

# ISSUE 2: Running as root (no USER directive until too late)
# ISSUE 3: Installing unnecessary packages
RUN apk add --no-cache \
    curl \
    wget \
    nmap \
    netcat-openbsd \
    bash

# ISSUE 4: Setting sensitive environment variables in the image
ENV DB_PASSWORD=SuperSecretPassword123!
ENV API_KEY=sk-demo-12345-insecure-key
ENV JWT_SECRET=my-jwt-secret-do-not-share

# ISSUE 5: Copying all files including potentially sensitive ones
WORKDIR /app
COPY . .

# ISSUE 6: Installing dependencies as root
RUN npm install --production 2>/dev/null || true

# ISSUE 7: Exposing unnecessary ports
EXPOSE 80
EXPOSE 8080
EXPOSE 3000
EXPOSE 22

# ISSUE 8: Using CMD with shell form (PID 1 issues)
CMD npm start || tail -f /dev/null
