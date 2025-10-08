# Quick Start Guide

## For Windows Users

### 1. Install R
1. Download R from: https://cran.r-project.org/bin/windows/base/
2. Run the installer (R-4.x.x-win.exe)
3. Follow installation wizard (use default settings)
4. Check "Add R to PATH" option

### 2. Install RStudio (Optional but Recommended)
1. Download from: https://posit.co/download/rstudio-desktop/
2. Install RStudio-xxx.exe

### 3. Run the Project

**Using Command Prompt or PowerShell:**
```cmd
cd C:\path\to\BDA-Mini-Project
Rscript install_packages.R
Rscript main.R
```

**Using RStudio:**
1. Open RStudio
2. File → Open File → Select `main.R`
3. Click "Source" button or press Ctrl+Shift+S

---

## For macOS Users

### 1. Install R
**Method 1 - Using Homebrew (Recommended):**
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install R
brew install r
```

**Method 2 - Manual Download:**
1. Download from: https://cran.r-project.org/bin/macosx/
2. Install the .pkg file

### 2. Install RStudio (Optional)
Download from: https://posit.co/download/rstudio-desktop/

### 3. Run the Project
```bash
cd /path/to/BDA-Mini-Project
Rscript install_packages.R
Rscript main.R
```

---

## For Linux Users (Ubuntu/Debian)

### 1. Install R
```bash
# Update package list
sudo apt update

# Install R and development tools
sudo apt install -y r-base r-base-dev

# Install system dependencies for R packages
sudo apt install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

# Verify installation
R --version
```

### 2. Install RStudio (Optional)
```bash
# Download and install RStudio
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.12.1-402-amd64.deb
sudo dpkg -i rstudio-2023.12.1-402-amd64.deb
sudo apt-get install -f  # Fix any dependency issues
```

### 3. Run the Project
```bash
cd /home/user/BDA-Mini-Project
Rscript install_packages.R
Rscript main.R
```

---

## For Linux Users (CentOS/RHEL/Fedora)

### 1. Install R
```bash
# Install EPEL repository (CentOS/RHEL)
sudo yum install -y epel-release

# Install R
sudo yum install -y R

# Install development tools
sudo yum groupinstall -y "Development Tools"
sudo yum install -y \
    libcurl-devel \
    openssl-devel \
    libxml2-devel \
    cairo-devel \
    libXt-devel

# Verify installation
R --version
```

### 2. Run the Project
```bash
cd /home/user/BDA-Mini-Project
Rscript install_packages.R
Rscript main.R
```

---

## Common Installation Issues

### Issue: "Rscript not found" after installing R

**Windows Solution:**
1. Add R to PATH manually:
   - Right-click "This PC" → Properties
   - Advanced system settings → Environment Variables
   - Edit PATH variable
   - Add: `C:\Program Files\R\R-4.x.x\bin`

**macOS/Linux Solution:**
```bash
# Find R installation
which R

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="/usr/local/bin:$PATH"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### Issue: Package compilation fails

**Solution (Linux):**
```bash
# Install all development dependencies
sudo apt install -y build-essential gfortran
```

**Solution (macOS):**
```bash
# Install Xcode command line tools
xcode-select --install
```

### Issue: Permission denied errors

**Solution:**
```bash
# Linux/macOS: Fix permissions
chmod -R 755 ~/BDA-Mini-Project
```

---

## Verification Steps

After installation, verify everything works:

```bash
# Check R version
R --version

# Check if Rscript works
Rscript --version

# Test package installation
Rscript -e "library(ggplot2); library(dplyr)"
```

Expected output: No errors

---

## Next Steps

Once R is installed:
1. Navigate to project directory
2. Run `Rscript install_packages.R` (first time only)
3. Run `Rscript main.R` (main execution)
4. Check `outputs/plots/` for visualizations
5. Check `outputs/` for CSV results

---

## Alternative: Using Docker (Advanced)

If you prefer not to install R locally:

```bash
# Create Dockerfile (already provided in project)
docker build -t hadoop-r-project .

# Run project
docker run -v $(pwd)/outputs:/app/outputs hadoop-r-project

# View results
ls outputs/plots/
```

---

## Getting Help

If you encounter issues:

1. Check the main README.md for detailed documentation
2. Verify R installation: `R --version`
3. Check package installation: `Rscript install_packages.R`
4. Review error messages carefully
5. Ensure all system dependencies are installed

---

## Time Estimate

- **R Installation**: 5-10 minutes
- **Package Installation**: 5-15 minutes (depending on internet speed)
- **Project Execution**: 30-60 seconds
- **Total Setup Time**: ~20-30 minutes (first time only)
