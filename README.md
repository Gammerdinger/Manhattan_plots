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

### Making your first plots, actually

In order to accomplish this you will need to get a few files downloaded and created. First, let's get the reference genome we are working with using this command:

```
curl -O -L http://chambo.umd.edu/download/20120125_MapAssembly.anchored.assembly.fasta.underscores .
```

Next, you'll want to make a file containing the sizes of each chromosome. You'll want to use this commands:

```
samtools faidx 20120125_MapAssembly.anchored.assembly.fasta.underscores
```

Now, we have a file containing each chromosome and the size of the chromosome like below:

```
LG1	31194787	5	60	61
LG2	25048291	31714711	60	61
LG3	19325363	57180479	60	61
LG4	28679955	76827937	60	61
LG5	37389089	105985897	60	61
LG6	36725243	143998143	60	61
LG7	51042256	181335479	60	61
LG8_24	29447820	233228448	60	61
LG9	20956653	263167070	60	61
LG10	17092887	284473007	60	61
...
```

What we want now is a file that alters these sizes into a "running total" of the genome. This way postion 1 of LG1 is 1, position 1 of LG2 is 31194788, position 1 of LG3 is 56243079 and etc. To accomplish this goal, we will run the script named Running_chrom.pl using this command-line:

```
perl Running_chrom.pl --input_file=20120125_MapAssembly.anchored.assembly.fasta.underscores.fai --output_file=O_niloticus_running_chrom_size.txt
```
 
 Now the output should look like:
 
```
LG1	0
LG2	31194787
LG3	56243078
LG4	75568441
LG5	104248396
LG6	141637485
LG7	178362728
LG8_24	229404984
LG9	258852804
LG10	279809457
...
```

