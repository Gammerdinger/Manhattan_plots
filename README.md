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

* First, you may try to make a graph for each chromosome/scaffold/linkage group. This is what I did at first, but you realize that since each chromosome/scaffold/linkage group is a different size, that you'd need to scale each chromosome/scaffold/linkage group to be proportional to fairly portray the genome. For example, if we allocate 2 inches for each chromosome, then a 5 megabase chromosome will occupy the same amount of space as a 35 megabase chromosome. The result from this will be that the 35 megabase chromsome will appear to have a denser clustering of SNPs. The solution as I said above would be to make plots sized proportionally to the size of the chromosome, so that a plot with 5 megabase chromosome takes up a seventh the space that a 35 megabase chromosome. I suspect that a solution to this criticism exists, but I am unaware of it. 

  Furthermore, many genome assemblies, particularly for non-model organsims, are thousands of scaffolds. Perhaps this scaling approach could be accomplished manually for a limited number of chromosomes, but it isn't feasible for assemblies that are more fragmented and contain many scaffolds.

* Second, you may try to put all of the information in one plot. You'll use the start position as the x-axis and the Fst value as the y-axis. This is basically where we are going, but remember you have information about the genome position in column 1 and column 2. The problem is that it makes no distinction between position 1 on chromsome 1 and position 1 on chromosome 2. The result of this is shown in the file Overlap_O_niloticus_WG.png.
 
![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/Overlap_O_niloticus_WG.png)

### Making your first plots, actually

In order to accomplish this you will need to get a few files downloaded and created. First, let's get the reference genome we are working with using this command:

```
curl -O -L http://chambo.umd.edu/download/20120125_MapAssembly.anchored.assembly.fasta.underscores .
```

Next, you'll want to make a file containing the sizes of each chromosome. In order to do this, we need to use a useful program called Samtools. First we need to download and install it on your computer. You'll want to use these commands:

```
curl -O -L http://sourceforge.net/projects/samtools/files/samtools/1.2/samtools-1.2.tar.bz2
tar xvfj samtools-1.2.tar.bz2
make
sudo make install
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

Next, you need to run this perl script with will convert the position column into a "running position" column using this command-line:

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

Now we are ready to make our Manhattan plots in R. First, we need to open R and set our working directory.

```
setwd(/Where/ever/your/folder/you/are/using/as/a/working/directory)
```

Next, you need to read in your files using these commands

```
WG_Fst.dat<-read.table("/Path/to/O_niloticus_males_vs_females.downsampled.fst.R_ready", header=F)
WG_Fet.dat<-read.table("/Path/to/O_niloticus_males_vs_females.downsampled.fet.R_ready", header=F)
```

Lastly, we get to make the png containing two plots using this command:

```

png("O_niloticus_WG.png",width=13,height=7.5,units="in",res=300)

par(mfrow=c(2,1), oma=c(0.25,0.25,3,0.25), mar=c(5,4,1.5,1))

plot(WG_Fst.dat$V2/1000000,WG_Fst.dat$V3, col=WG_Fst.dat$V1, xlab=NA, ylab=NA, pch=20, cex=0.01, ylim=c(0,1), axes=F) 
box()
axis(2, cex=0.85, las=2)
mtext(side=1, "                                                1        2      3      4         5           6            7          8_24    9   10     11        12       13       14       15    16_21     17      18     19      20      22     23                                                                                                                                          ", cex=0.75, las=0, line=0.2)
mtext(side=1, "                                                                                                                                                                                                                                                                             _______________________________________________________", cex=0.65, las=0, line=-0.5)
mtext(side=1, "                                                                                                                                                                                                                               UNK1-UNK5655", cex=0.75, las=0, line=0.45)
mtext(side=1, "Linkage Group", line=2, cex=0.9)
mtext(side=2, expression("F"[ST]), line=2.5, cex=0.9)
mtext(side=3, expression("Popoolation2's F"[ST]), line=0.2)

plot(WG_Fet.dat$V2/1000000,WG_Fet.dat$V3, col=WG_Fet.dat$V1, xlab=NA, ylab=NA, pch=20, cex=0.01, ylim=c(0,20), axes=F) 
box()
axis(2, cex=0.85, las=2)
mtext(side=1, "                                                1        2      3      4         5           6            7          8_24    9   10     11        12       13       14       15    16_21     17      18     19      20     22      23                                                                                                                                          ", cex=0.75, las=0, line=0.2)
mtext(side=1, "                                                                                                                                                                                                                                                                             _______________________________________________________", cex=0.65, las=0, line=-0.5)
mtext(side=1, "                                                                                                                                                                                                                               UNK1-UNK5655", cex=0.75, las=0, line=0.45)
mtext(side=1, "Linkage Group", line=2, cex=0.9)
mtext(side=2, "-log(p)", line=2.5, cex=0.9)
mtext(side=3, expression("Popoolation2's Fisher's Exact Test"), line=0.2)
abline(h=1.301, lwd=2, col="chartreuse", lty=2)
abline(h=3, lwd=2, col="red", lty=2)

dev.off()
```

The final product should look like:
![alt tag](https://github.com/Gammerdinger/Manhattan_plots/blob/master/O_niloticus_WG.png)
