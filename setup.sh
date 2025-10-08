#!/bin/bash

# Automated setup script for BDA-Mini-Project
# This script checks prerequisites and sets up the environment

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         BDA Mini Project - Setup Script                       ║"
echo "║         Hadoop Ecosystem with R                               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "ℹ $1"
}

# Check if R is installed
echo "Checking prerequisites..."
echo ""

if command -v R &> /dev/null; then
    R_VERSION=$(R --version | head -n 1)
    print_success "R is installed: $R_VERSION"
else
    print_error "R is not installed"
    echo ""
    print_info "Please install R before continuing:"
    echo "  Ubuntu/Debian: sudo apt install r-base r-base-dev"
    echo "  CentOS/RHEL:   sudo yum install R"
    echo "  macOS:         brew install r"
    echo "  Windows:       Download from https://cran.r-project.org/"
    echo ""
    exit 1
fi

if command -v Rscript &> /dev/null; then
    print_success "Rscript is available"
else
    print_error "Rscript is not available"
    exit 1
fi

echo ""
echo "─────────────────────────────────────────────────────────────────"
echo "Installing R packages..."
echo "─────────────────────────────────────────────────────────────────"
echo ""

if Rscript install_packages.R; then
    print_success "R packages installed successfully"
else
    print_error "Package installation failed"
    print_info "Try installing system dependencies:"
    echo "  Ubuntu/Debian: sudo apt install libcurl4-openssl-dev libssl-dev libxml2-dev"
    echo "  CentOS/RHEL:   sudo yum install libcurl-devel openssl-devel libxml2-devel"
    exit 1
fi

echo ""
echo "─────────────────────────────────────────────────────────────────"
echo "Setting up project directories..."
echo "─────────────────────────────────────────────────────────────────"
echo ""

# Create directories if they don't exist
mkdir -p data
mkdir -p outputs
mkdir -p outputs/plots

print_success "Project directories created"

echo ""
echo "─────────────────────────────────────────────────────────────────"
echo "Running initial data generation..."
echo "─────────────────────────────────────────────────────────────────"
echo ""

if Rscript scripts/generate_data.R; then
    print_success "Sample data generated"
else
    print_warning "Data generation had issues (will be generated during main execution)"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Setup Complete! ✓                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
print_info "To run the project, execute:"
echo "  Rscript main.R"
echo ""
print_info "Or for step-by-step execution, see README.md"
echo ""
