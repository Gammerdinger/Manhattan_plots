Manhattan plots
==============
Background
--------------

This was designed as a tutorial for Ian Misner's R course in order to demonstrate how to plot whole genome information, such as Fst, Dxy or any other statistic, in R.

The sample files here are downsampled and they are intended for tutorial use only. Additionally, R is extremely powerful and there are many ways to accomplish the same task. I dappled around trying to make Manhattan plots for awhile and this was my solution to it. I suspect there are much better ways to accomplish it, but this is the pipeline I use. 

### Getting started

You may have a BED file, IGV (Integrative Genomics Viewer: https://www.broadinstitute.org/igv/) file or a different type of file. This tutorial is designed to work with IGV files, but it can be modified by tweaking the the provide perl scripts to work on BED files or other files formats. Below is the outline of the pipeline I used to get from raw reads into the IGV file format:

![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/Poopolation_Pipeline.png)

First, download Github file contain all of the files you'll need for this tutorial by click on the "Download ZIP" icon on the right side. Using the terminal window, you'll need to change directories to this folder using this command:

```
cd ~/Downloads/Manhattan_plots-master/
```

Inside you should find the file titled: O_niloticus_males_vs_females.downsampled.fst.igv 

This is a downsampled file of what was used in Gammerdinger et al., 2014.

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
UNK5647	331	332	snp	0.00877602
UNK5647	607	608	snp	0.03875315
UNK5647	773	774	snp	0.02473372
UNK5647	819	820	snp	0.03518803
UNK5647	902	903	snp	0.01615389
UNK5651	779	780	snp	0.02416214
UNK5651	842	843	snp	0.01711530
UNK5655	248	249	snp	0.04347897
UNK5655	431	432	snp	0.02690219
UNK5655	774	775	snp	0.15040816
```

### Making the first plots

Instinctively, you may be tempted to do two things:

* First, you may try to make a graph for each chromosome/scaffold/linkage group. This is what I did at first, but you realize that since each chromosome/scaffold/linkage group is a different size, that you'd need to scale each chromosome/scaffold/linkage group to be proportional to fairly portray the genome. For example, if we allocate 2 inches for each chromosome, then a 5 megabase chromosome will occupy the same amount of space as a 35 megabase chromosome. The result from this will be that the 35 megabase chromsome will artificially appear to have a denser clustering of SNPs. The solution, as I said above, would be to make plots sized proportionally to the size of the chromosome, so that a plot with 5 megabase chromosome takes up a seventh the space of a 35 megabase chromosome. I suspect that a solution to this criticism exists, but I am unaware of it. 

  Furthermore, many genome assemblies, particularly for non-model organsims, are thousands of scaffolds. Perhaps this scaling approach could be accomplished manually for a limited number of chromosomes, but it isn't feasible for assemblies that are more fragmented and contain many scaffolds.

* Second, you may try to put all of the information in one plot. You'll use the start position as the x-axis and the Fst value as the y-axis. This is basically where we are going, but remember you have information about the genome position in column 1 and column 2. The problem is that this idea makes no distinction between position 1 on chromsome 1 and position 1 on chromosome 2. The result of this is shown in the file Overlap_O_niloticus_WG.png. Note the overlapping of the colors, this is the chromsomes laid on top of each other. 
 
![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/Overlap_O_niloticus_WG.png)

### Making your first plots, actually

In order to accomplish this you will need to get a few files downloaded and created. First, let's get the tilapia reference genome, which is the reference genome we are working with, using this command:

```
curl -O -L http://chambo.umd.edu/download/20120125_MapAssembly.anchored.assembly.fasta.underscores
```

Next, you'll want to make a file containing the sizes of each chromosome/scaffold/linkage group. In order to do this, we need to use a useful program called Samtools. First, we need to download and install it on your computer. You'll want to use these commands:

```
curl -O -L http://sourceforge.net/projects/samtools/files/samtools/1.2/samtools-1.2.tar.bz2
tar xvfj samtools-1.2.tar.bz2
cd samtools-1.2/
make
export PATH=$PATH:~/Downloads/Manhattan_plots-master/samtools-1.2
samtools faidx ../20120125_MapAssembly.anchored.assembly.fasta.underscores
cd ..
```

Now, we have a file containing each chromosome/scaffold/linkage group and the size of the chromosome/scaffold/linkage group like below:

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
UNK5646	1002	943183303	60	61
UNK5647	1001	943184331	60	61
UNK5648	1001	943185358	60	61
UNK5649	1001	943186385	60	61
UNK5650	1001	943187412	60	61
UNK5651	1000	943188439	60	61
UNK5652	1000	943189465	60	61
UNK5653	1000	943190491	60	61
UNK5654	1000	943191517	60	61
UNK5655	1000	943192543	60	61
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
UNK5646	927669481
UNK5647	927670483
UNK5648	927671484
UNK5649	927672485
UNK5650	927673486
UNK5651	927674487
UNK5652	927675487
UNK5653	927676487
UNK5654	927677487
UNK5655	927678487
```

Next, you need to run this perl script which will convert the position column into a "running position" column using this command-line:

```
perl Genome_R_script.pl --input_file=O_niloticus_males_vs_females.downsampled.fst.igv --output_file=O_niloticus_males_vs_females.downsampled.fst.R_ready --chrom_size_file=O_niloticus_running_chrom_size.txt
```

The output should look like:

```
LG1	697	0.02473565
LG1	821	0.01328195
LG1	1098	0.02965631
LG1	1432	0.01148924
LG1	3842	0.05440369
LG1	8114	0.05959184
LG1	9326	0.03735688
LG1	11606	0.05065753
LG1	14177	0.02231113
LG1	15117	0.01535743
...
UNK5647	927670814	0.00877602
UNK5647	927671090	0.03875315
UNK5647	927671256	0.02473372
UNK5647	927671302	0.03518803
UNK5647	927671385	0.01615389
UNK5651	927675266	0.02416214
UNK5651	927675329	0.01711530
UNK5655	927678735	0.04347897
UNK5655	927678918	0.02690219
UNK5655	927679261	0.15040816
```

And you'll need to run the previous perl script again for the Fisher's Exact Test file

```
perl Genome_R_script.pl --input_file=O_niloticus_males_vs_females.downsampled.fet.igv --output_file=O_niloticus_males_vs_females.downsampled.fet.R_ready --chrom_size_file=O_niloticus_running_chrom_size.txt
```

Now we are ready to make our Manhattan plots in R. First, we need to open R and set our working directory.

```
setwd(~/Dowloads/Manhattan_plots-master/)
```

Next, you need to read in your files using these commands

```
WG_Fst.dat<-read.table("/Path/to/O_niloticus_males_vs_females.downsampled.fst.R_ready", header=F)
WG_Fet.dat<-read.table("/Path/to/O_niloticus_males_vs_females.downsampled.fet.R_ready", header=F)
```

Lastly, we get to make the png containing two plots using this command:

```
# Makes a png file named O_niloticus_WG.png in my working directory with a size of 13inx7.5in and a resolution of 300dpi

png("O_niloticus_WG.png",width=13,height=7.5,units="in",res=300)

# Makes two panels stack on top of each other and defines the borders and margins

par(mfrow=c(2,1), oma=c(0.25,0.25,3,0.25), mar=c(5,4,1.5,1))

# Makes the Fst plot without axes in the top panel. This is super bare bones. We want to customize it all ourselves.

plot(WG_Fst.dat$V2,WG_Fst.dat$V3, col=WG_Fst.dat$V1, xlab=NA, ylab=NA, pch=20, cex=0.01, ylim=c(0,1), axes=F) 

# Adds a box around the plot in the top panel

box()

# Adds y-axis values to the top panel

axis(2, cex=0.85, las=2)

# Adds the Linkage Group numbers to the x-axis in the top panel

mtext(side=1, "                                                1        2      3      4         5           6            7          8_24    9   10     11        12       13       14       15    16_21     17      18     19      20      22     23                                                                                                                                          ", cex=0.75, las=0, line=0.2)

# Adds the line to emcompass the UNK scaffolds for the top panel

mtext(side=1, "                                                                                                                                                                                                                                                                             _______________________________________________________", cex=0.65, las=0, line=-0.5)

# Adds the text beneath the UNK Scaffolds line to the top panel

mtext(side=1, "                                                                                                                                                                                                                               UNK1-UNK5655", cex=0.75, las=0, line=0.45)

# Adds an x-axis label to the top panel

mtext(side=1, "Linkage Group", line=2, cex=0.9)

# Adds a y-axis label to the top panel. The square brackets around ST makes subscript.

mtext(side=2, expression("F"[ST]), line=2.5, cex=0.9)

# Adds a title to the top panel

mtext(side=3, expression("Popoolation2's F"[ST]), line=0.2)

# Makes the Fisher's Exact Test plot without axes in the bottom panel.

plot(WG_Fet.dat$V2,WG_Fet.dat$V3, col=WG_Fet.dat$V1, xlab=NA, ylab=NA, pch=20, cex=0.01, ylim=c(0,20), axes=F) 

# Adds a box around the plot for the bottom panel

box()

# Adds y-axis values for the bottom panel

axis(2, cex=0.85, las=2)

# Adds the Linkage Group numbers to the x-axis for the bottom panel

mtext(side=1, "                                                1        2      3      4         5           6            7          8_24    9   10     11        12       13       14       15    16_21     17      18     19      20     22      23                                                                                                                                          ", cex=0.75, las=0, line=0.2)

# Adds the line to emcompass the UNK scaffolds for the bottom panel

mtext(side=1, "                                                                                                                                                                                                                                                                             _______________________________________________________", cex=0.65, las=0, line=-0.5)

# Adds the text beneath the UNK Scaffolds line to the bottom panel

mtext(side=1, "                                                                                                                                                                                                                               UNK1-UNK5655", cex=0.75, las=0, line=0.45)

# Adds an x-axis label to the bottom panel

mtext(side=1, "Linkage Group", line=2, cex=0.9)

# Adds a y-axis label to the bottom panel

mtext(side=2, "-log(p)", line=2.5, cex=0.9)

# Adds a title to the bottom panel

mtext(side=3, expression("Popoolation2's Fisher's Exact Test"), line=0.2)

# Adds lime green dotted line at 1.301 to the bottom panel

abline(h=1.301, lwd=2, col="chartreuse", lty=2)

# Adds red dotted line at 3 to the bottom panel

abline(h=3, lwd=2, col="red", lty=2)

# Closes the png

dev.off()

```

The final product should look like:
![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/O_niloticus_WG.png)

One trick I do here (And I am not entirely sure why it works, because stumbled across it) is I assign the color of each plot ("col" option) to be equal to the chromosome/linkage group/scaffold. Each time a new chromosome/linkage group/scaffold arises in the plot making process it changes the color. 

### Making individual chromosome/linkage group/scaffold plots

We can now see that LG1 is interesting to us, so we might want to make a plot of just linkage group 1. This is really easily accomplished and just requires us to modify a few things. First, we will need to make a LG1 subset data table out of our whole genome data table using the the following commands for Fst and Fisher's Exact Test:

```
LG1_Fst.dat<-subset(WG_Fst.dat, V2 < 31194787,select = c(V1:V3))
LG1_Fet.dat<-subset(WG_Fet.dat, V2 < 31194787,select = c(V1:V3))
```

Then we just need to plot them. For the most part the code is similar. There are a few tweaks though. Now we don't worry about making a bunch of text on the bottom of each plot for the linkage groups. Instead, we just have to turn the x-axis on. Another tweak is now I have divide the x-axis by 1,000,000 in order to have the graph scale by megabase. It gives a much cleaner overall look and it is much easier to interpret. The code for the individal chromosome/linkage group/scaffold is below:

```
# Makes a png file named O_niloticus_LG1.png in my working directory with a size of 13inx7.5in and a resolution of 300dpi

png("O_niloticus_LG1.png",width=13,height=7.5,units="in",res=300)

# Makes two panels stack on top of each other and defines the borders and margins

par(mfrow=c(2,1), oma=c(0.25,0.25,3,0.25), mar=c(5,4,1.5,1))

# Makes the Fst plot without axes in the top panel. Once again, this is super bare bones. We want to customize it all ourselves.

plot(LG1_Fst.dat$V2/1000000,LG1_Fst.dat$V3, col="blue", xlab=NA, ylab=NA, pch=20, cex=0.05, ylim=c(0,1), axes=F) 

# Adds a box around the plot in the top panel

box()

# Adds x-axis values for the top panel

axis(1, cex=0.85, las=0)

# Adds y-axis values for the top panel

axis(2, cex=0.85, las=2)

# Adds an x-axis label to the top panel

mtext(side=1, "Position (Mb)", line=2.5, cex=0.9)

# Adds an y-axis label to the top panel

mtext(side=2, expression("F"[ST]), line=2.5, cex=0.9)

# Adds a title to the top panel

mtext(side=3, expression("Popoolation2's F"[ST]), line=0.2)

# Makes the Fisher's Exact Test plot without axes in the bottom panel.

plot(LG1_Fet.dat$V2/1000000,LG1_Fet.dat$V3, col="blue", xlab=NA, ylab=NA, pch=20, cex=0.05, axes=F) 

# Adds a box around the plot in the bottom panel

box()

# Adds x-axis values for the bottom panel

axis(1, cex=0.85, las=0)

# Adds y-axis values for the bottom panel

axis(2, cex=0.85, las=2)

# Adds an x-axis label to the bottom panel

mtext(side=1, "Position (Mb)", line=2.5, cex=0.9)

# Adds an y-axis label to the bottom panel

mtext(side=2, "-log(p)", line=2.5, cex=0.9)

# Adds a title to the bottom panel

mtext(side=3, expression("Popoolation2's Fisher's Exact Test"), line=0.2)

# Adds lime green dotted line at 1.301 (p=0.05) to the bottom panel

abline(h=1.301, lwd=2, col="chartreuse", lty=2)

# Adds red dotted line at 3 (p=0.001) to the bottom panel

abline(h=3, lwd=2, col="red", lty=2)

# Closes the png

dev.off()
```

The final product should appear to look like this:

![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/O_niloticus_LG1.png)

Congratulations!!! You have now created publication quality plots in R using a next-generation sequencing data set!!!
