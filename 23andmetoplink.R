#Set working directory
setwd("/path/")
# Load necessary library
library(data.table)
library(tidyr)

# Set file paths
input_file <- "/path/file"  # Your 23andMe file path
output_prefix <- "2aMoutput"  # Replace with desired output prefix

# Create directories if they don't exist
output_dir <- dirname(output_prefix)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Read 23andMe data
data <- fread(input_file, header = TRUE, sep = "\t")
colnames(data)[which(names(data) == "# rsid")] <- "rsid"

# Format data for PLINK PED file
ped <- data.table(
  FID = FID1,
  IID = IID1,
  PID = 0,
  MID = 0,
  Sex = 2,
  Phenotype = -9
)

# Extract genotype information and format for MAP+ PED
genotypes <- data[, .(Genotype = paste(substr(genotype, 1, 1), substr(genotype, 2, 2), sep = ""))]
geno<- as.data.frame(rbind(data$genotype))
colnames(geno)<-data$rsid

# Spread the data table from long to wide format
ped <- cbind(ped, geno)

# Save PED file
write.table(ped, paste0(output_prefix, ".ped"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

# Create MAP file
map <- data[, .(Chromosome = chromosome, SNP = rsid, GeneticDistance = 0, BasePairPosition = position)]
write.table(map, paste0(output_prefix, ".map"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

# Use PLINK to convert PED/MAP to BED/BIM/FAM
# You need to have PLINK installed and in your system PATH for this to work
## Set path for PLINK
plink   <- "/path/plink"
system(paste0(plink," --file ",output_prefix," --make-bed --out ", output_prefix))
