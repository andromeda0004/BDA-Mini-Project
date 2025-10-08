# Instructions for Running on Other Machines

This document provides step-by-step instructions for running this project on different machines.

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] A computer with Windows, macOS, or Linux
- [ ] Internet connection for downloading R and packages
- [ ] At least 4GB RAM
- [ ] 500MB free disk space
- [ ] Administrator/sudo privileges (for installation)

## 🚀 Quick Start (3 Steps)

### Step 1: Install R
Choose your operating system and follow the instructions:

**Windows**: Download and install from https://cran.r-project.org/bin/windows/base/

**macOS**: Run `brew install r` or download from https://cran.r-project.org/bin/macosx/

**Linux (Ubuntu/Debian)**:
```bash
sudo apt update
sudo apt install -y r-base r-base-dev
```

**Linux (CentOS/RHEL)**:
```bash
sudo yum install -y epel-release
sudo yum install -y R
```

### Step 2: Download and Extract Project
- Download the project ZIP file or clone the repository
- Extract to a folder (e.g., `C:\BDA-Mini-Project` or `~/BDA-Mini-Project`)

### Step 3: Run Setup and Execute

**On Windows**:
```cmd
cd C:\path\to\BDA-Mini-Project
setup.bat
```

**On macOS/Linux**:
```bash
cd /path/to/BDA-Mini-Project
chmod +x setup.sh
./setup.sh
```

That's it! The project will:
1. Install required R packages
2. Generate sample data
3. Process with Hive and HBase
4. Create visualizations

## 📁 What You'll Get

After execution, you'll find:

```
BDA-Mini-Project/
├── outputs/
│   ├── plots/               # 9 visualization PNG files
│   │   ├── 0_dashboard.png  # Combined dashboard
│   │   ├── 1_category_sales.png
│   │   ├── 2_region_sales.png
│   │   ├── 3_monthly_trend.png
│   │   ├── 4_payment_methods.png
│   │   ├── 5_satisfaction.png
│   │   ├── 6_customer_segments.png
│   │   ├── 7_top_products.png
│   │   └── 8_customer_behavior.png
│   │
│   └── *.csv                # 10 CSV result files
```

## 🎯 Alternative Methods

### Method 1: Manual Step-by-Step

```bash
# 1. Install packages
Rscript install_packages.R

# 2. Run main script
Rscript main.R
```

### Method 2: Using RStudio (Recommended for Beginners)

1. Install RStudio from https://posit.co/download/rstudio-desktop/
2. Open RStudio
3. File → Open Project → Navigate to `BDA-Mini-Project`
4. Open `main.R`
5. Click "Source" button at the top

### Method 3: Using Docker (No R Installation Needed)

```bash
# Build image
docker build -t hadoop-r .

# Run project
docker run -v $(pwd)/outputs:/app/outputs hadoop-r

# View results
ls outputs/plots/
```

See `DOCKER.md` for detailed Docker instructions.

## 🔍 Verifying Installation

After installation, verify R is working:

```bash
# Check R version
R --version

# Test Rscript
Rscript --version

# Test package loading
Rscript -e "library(ggplot2); library(dplyr); cat('Packages OK\n')"
```

Expected output: No errors, "Packages OK" message

## 🐛 Troubleshooting

### Problem: "Rscript not found"

**Solution**: R is not in PATH. 

**Windows**:
1. Right-click "This PC" → Properties
2. Advanced system settings → Environment Variables
3. Edit PATH, add: `C:\Program Files\R\R-4.x.x\bin`

**macOS/Linux**:
```bash
# Find R location
which R

# Add to ~/.bashrc or ~/.zshrc
export PATH="/usr/local/bin:$PATH"
source ~/.bashrc
```

### Problem: Package installation fails

**Solution**: Install system dependencies.

**Ubuntu/Debian**:
```bash
sudo apt install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev
```

**macOS**:
```bash
xcode-select --install
```

### Problem: Permission denied

**Solution**:
```bash
# Linux/macOS
chmod -R 755 ~/BDA-Mini-Project

# Windows
# Run Command Prompt as Administrator
```

### Problem: Plots not generated

**Solution**: Check if output directory exists and has write permissions:
```bash
mkdir -p outputs/plots
chmod 755 outputs/plots  # Linux/macOS
```

### Problem: Memory errors

**Solution**: Use smaller dataset or increase R memory:
```r
# Edit main.R, add at top:
memory.limit(size = 8000)  # Windows only
```

## 📧 Getting Help

If you encounter issues:

1. Check the error message carefully
2. Review `README.md` for detailed documentation
3. Check `QUICKSTART.md` for platform-specific instructions
4. Verify all prerequisites are installed
5. Try running `setup.sh` or `setup.bat` again

## ⏱️ Time Estimates

- **First-time Setup**: 20-30 minutes
  - R installation: 5-10 minutes
  - Package installation: 10-15 minutes
  - First run: 1 minute

- **Subsequent Runs**: 30-60 seconds
  - No installation needed
  - Just run: `Rscript main.R`

## 📊 Expected Results

After successful execution:

1. **Console Output**: Step-by-step progress with statistics
2. **Data File**: `data/sales_data.csv` (1000 records)
3. **Hive Results**: 5 CSV files with aggregations
4. **HBase Results**: 5 CSV files with profiles
5. **Visualizations**: 9 PNG files (300 DPI, publication quality)

## 🎓 Learning Objectives

By running this project, you'll learn:

✅ How to set up R environment  
✅ How Hive processes data (SQL-like operations)  
✅ How HBase stores data (NoSQL structure)  
✅ How to create visualizations with ggplot2  
✅ Big Data analytics workflow  

## 📚 Additional Resources

- **Full Documentation**: See `README.md`
- **Quick Start Guide**: See `QUICKSTART.md`
- **Docker Instructions**: See `DOCKER.md`
- **Architecture Details**: See `ARCHITECTURE.md`

## ✅ Success Checklist

After running, verify:
- [ ] No error messages in console
- [ ] `data/sales_data.csv` exists (should be ~200 KB)
- [ ] `outputs/` folder has 10 CSV files
- [ ] `outputs/plots/` folder has 9 PNG files
- [ ] Dashboard image `0_dashboard.png` can be opened
- [ ] Individual plots show meaningful data

## 🎉 Next Steps

After successful execution:

1. **View Results**: Open `outputs/plots/0_dashboard.png`
2. **Explore Data**: Check CSV files in `outputs/`
3. **Customize**: Modify parameters in scripts
4. **Learn More**: Read `ARCHITECTURE.md` for technical details
5. **Share**: Send project folder to others to run

## 💡 Tips for Demonstration

When presenting this project:

1. Show the main dashboard first: `0_dashboard.png`
2. Explain Hive aggregations with `hive_*.csv` files
3. Demonstrate HBase structure with `hbase_customer_table_raw.csv`
4. Walk through individual visualizations
5. Show the code structure and modularity

---

**Important Note**: This project simulates Hive and HBase operations. For production use with actual Hadoop clusters, additional configuration and JDBC/API connections would be needed. See comments in the code for real connection examples.
