setwd("~/Downloads/Manhattan_plots-master/")

WG_Fst.dat<-read.table("~/Downloads/Manhattan_plots-master/O_niloticus_males_vs_females.downsampled.fst.R_ready", header=F)

WG_Fet.dat<-read.table("~/Downloads/Manhattan_plots-master/O_niloticus_males_vs_females.downsampled.fet.R_ready", header=F)


##############################################################
######                  Whole Genome                     #####
##############################################################

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

# Adds lime green dotted line at 1.301 (p=0.05) to the bottom panel

abline(h=1.301, lwd=2, col="chartreuse", lty=2)

# Adds red dotted line at 3 (p=0.001) to the bottom panel

abline(h=3, lwd=2, col="red", lty=2)

# Closes the png

dev.off()

##############################################################
######                      LG1                         ######
##############################################################

# Makes a new data table using a subset of the old data table for Fst

LG1_Fst.dat<-subset(WG_Fst.dat, V2 < 31194787,select = c(V1:V3))

# Makes a new data table using a subset of the old data table for Fisher's Exact Test

LG1_Fet.dat<-subset(WG_Fet.dat, V2 < 31194787,select = c(V1:V3))

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
