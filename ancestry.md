---
title: "Ancestry"
author: "Deepika Dokuru"
output:
  pdf_document: default
  html_document: default
---






1. Examine the dataset:
  * How many samples are present? 
  

```
## [1] 489
```

  * How many SNPs?
  

```
## [1] 141123
```

  * What is the number of samples in each population?
  
![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

2. Get the first 10 principal components (PCs) in PLINK using all SNPs. The basic command would look like


  * Make a scatterplot of the first two PCs with each point colored by population membership. 
  
![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

  * Project new individuals onto PCs
  
![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)
