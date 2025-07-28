#!/bin/bash

# Define an array of Go packages to install with specific versions where needed
packages=(
  "google.golang.org/protobuf/cmd/protoc-gen-go@latest"
  "google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"
  "github.com/go-kratos/kratos/cmd/kratos/v2@latest"
  "github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest"
  "github.com/google/gnostic/cmd/protoc-gen-openapi@latest"
  "github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2@latest"
  "github.com/envoyproxy/protoc-gen-validate@latest"
)

echo "Installing Go packages..."

# Loop through each package and install it
for package in "${packages[@]}"; do
  echo "Installing $package..."
  go install "$package"
  if [ $? -eq 0 ]; then
    echo "Successfully installed $package"
  else
    echo "Failed to install $package"
    exit 1
  fi
done

echo "All packages installed successfully!"
