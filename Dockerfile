# Specify the base image as Golang with the Buster version of Debian Linux
FROM golang:buster AS terraform

# Install necessary dependencies for Terraform and other packages
RUN apt-get update && apt-get install -y gnupg software-properties-common musl-dev gcc python3-pip jq

# Import HashiCorp's GPG key
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Verify the fingerprint of the imported key
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

# Add HashiCorp's APT repository to the list of available sources
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform from HashiCorp's APT repository
RUN apt-get update && apt-get install -y terraform


# Build a separate image for the Terraformer utility
FROM golang:alpine AS builder

# Install necessary dependencies for Terraformer and other packages
RUN apk --update --no-cache add bash musl-dev gcc py3-pip jq git

# Install the AWS CLI using pip
RUN pip3 install --upgrade pip && pip3 install awscli

# Clone the Terraformer repository from GitHub
RUN git clone https://github.com/GoogleCloudPlatform/terraformer.git 

# Set the working directory to the Terraformer directory
WORKDIR ./terraformer

# Download Go modules
RUN go mod download

# Build the Terraformer binary
RUN go build -v


# Create a final image for running Terraformer
FROM golang:alpine AS runner

# Copy the Terraform binary from the first image
COPY --from=terraform /usr/bin/terraform /usr/bin/terraform

# Copy the Terraformer binary from the second image
COPY --from=builder /go/terraformer/terraformer /usr/bin/terraformer

# Set the entrypoint command to run the "tail -f /dev/null" command
ENTRYPOINT ["tail", "-f", "/dev/null"]
