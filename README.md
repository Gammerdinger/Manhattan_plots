Manhattan_plots
==============
Background
--------------

This was designed as a tutorial for Ian Misner's R course in order to demonstrate how to plot whole genome information, such as Fst, Dxy or any other statistic, in R.

The sample files here are downsampled and they are intended for tutorial use only. Additionally, R is extremely powerful and there are many ways to accomplish the same task. I dappled around trying to make Manhattan plots for awhile and this was my solution to it. I suspect there are much better ways to accomplish it, but this is the pipeline I use.

### Getting started

You will may have a BED file, IGV (Integrative Genomics Viewer: https://www.broadinstitute.org/igv/) file or a different type of file. This tutorial is designed to work with IGV files, but it can be modified by tweaking the code to work on BED files or other files formats.

First, download the file titled: O_niloticus_males_vs_females.downsampled.fst.igv

This is a downsampled file that was used in Gammerdinger et al., 2014.

* The file should have 5 columns and the first line is the header for the file:
  - Column 1 is the chromosome/scaffold/linkage group
  - Column 2 is the start position of the feature
  - Column 3 is the end position of the feature
  - Column 4 is the feature, in this case it is a Single Nucleotide Polymorphism ("snp")
  - Column 5 is the score of the feature, in this case it is Fst



```
Chromosome	Start	End	Feature	1:2
LG1	697	698	snp	0.02473565
LG1	821	822	snp	0.01328195
LG1	1098	1099	snp	0.02965631
LG1	1432	1433	snp	0.01148924
LG1	3842	3843	snp	0.05440369
LG1	8114	8115	snp	0.05959184
LG1	9326	9327	snp	0.03735688
LG1	11606	11607	snp	0.05065753
LG1	14177	14178	snp	0.02231113
...
```

### Making the first plots

Instinctively, you may be tempted to do two things:

* First, you may try to make a graph for each chromosome/scaffold/linkage group. This is what I did at first, but you realize that since each chromosome/scaffold/linkage group is a different size, that you'd need to scale each chromosome/scaffold/linkage group to be proportional to fairly portray the genome. For example, if we allocate 2 inches for each chromosome, then a 5 megabase chromosome will occupy the same amount of space as a 35 megabase chromosome. The result from this will be that the 35 megabase chromsome will appear to have a denser clustering of SNPs. The solution as I said above would be to make plots sized proportionally to the size of the chromosome, so that a plot with 5 megabase chromosome takes up a seventh the space that a 35 megabase chromosome. I suspect that a solution to this criticism exists, but I am unaware of it. 

  Furthermore, many genome assemblies, particularly for non-model organsims, are thousands of scaffolds. Perhaps this scaling approach could be accomplished manually for a limited number of chromosomes, but it isn't feasible for assemblies that are more fragmented and contain many scaffolds.

* Second, you may try to put all of the information in one plot. You'll use the start position as the x-axis and the Fst value as the y-axis. This is basically where we are going, but remember you have information about the genome position in column 1 and column 2. The problem is that it makes no distinction between position 1 on chromsome 1 and position 1 on chromosome 2. The result of this is shown in the file Second_mistake.png.

### Making your first plots actually



 

