##Set working directory and load in the data file

# Get working directory; 
getwd()	
#You can set a different working directory here if you want
setwd("/path/to/23andme")	
options(timeout=600)
options(max.print=1e4)

#Load data
mygenome <- read.table("mygenome.txt",header=FALSE,col.names=c("rsid","chrom","bp37","genotype"))
colnames(mygenome)<-c("SNP","CHR","BP","GENOTYPE")

#Load necessary libraries
require(data.table)

#Load in 1000G reference file
ref <- fread('/path/to/reference.1000G.maf.0.005.txt', header = T)
ref$CHR <- as.numeric(ref$CHR)
ref$BP <- as.numeric(ref$BP)

#Merge
mygenome_wrefalt <- merge(mygenome, ref, by.x = c('CHR', 'BP','SNP'), by.y = c('CHR', 'BP','SNP'), all = F)

# Create start and end positions
# For SNPs and insertions, the end position is the same as the start position
# For deletions, the end position is the start position - 1
mygenome_wrefalt$start <- mygenome_wrefalt$BP
mygenome_wrefalt$end <- ifelse(nchar(mygenome_wrefalt$A1) == 1 & nchar(mygenome_wrefalt$A2) == 1, 
                               mygenome_wrefalt$BP, 
                         ifelse(nchar(mygenome_wrefalt$A1) > nchar(mygenome_wrefalt$A2), 
                                mygenome_wrefalt$BP + nchar(mygenome_wrefalt$A1) - 1, 
                                mygenome_wrefalt$BP - 1))


# Rename columns to match avinput format
avinput_data <- data.frame(
  chr = mygenome_wrefalt$CHR,
  start = mygenome_wrefalt$start,
  end = mygenome_wrefalt$end,
  ref = mygenome_wrefalt$A1,
  alt = mygenome_wrefalt$A2,
  stringsAsFactors = FALSE
)


# Write the avinput data to a file
annovar_input_file <- "annovar_input_file.avinput"
write.table(avinput_data, annovar_input_file, sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

# Define the path to ANNOVAR and input files
annovar_path <- "/path/to/annovar/"
input_file <- "/path/to/annovar_input_file.avinput"
output_prefix <- "/path/to/output_file"
humandb_path <- "/path/to/annovar/humandb/"

# Prepare the command to run ANNOVAR
command <- paste(
  "perl", paste0(annovar_path, "table_annovar.pl"),
  input_file,
  humandb_path,
  "-buildver hg19",
  "-out", output_prefix,
  "-remove",
  "-protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_eas,1000g2015aug_eur,snp138,ljb26_all,exac03,clinvar_20150330,gnomad211_exome",
  "-operation g,r,r,f,f,f,f,f,f,f,f,f,f",
  "-nastring .",
  "-csvout",
  "-polish"
)
# Print the command (for debugging)
cat("Running command:\n", command, "\n")

# Run the command
system(command)

# Read the output file
output_file <- paste0(output_prefix, ".hg19_multianno.csv")
annotated_variants <- fread(output_file)

# View the first few lines of the annotated variants
head(annotated_variants)





