#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my ($input_file, $output_file, $chrom_size_file, $help) = ("empty", "empty", "empty");

GetOptions(
"input_file=s"                    => \$input_file,
"output_file=s"                   => \$output_file,
"chrom_size_file=s"               => \$chrom_size_file
) or Usage ( "Invalid command-line option" );

if ($input_file eq "empty" || $output_file eq "empty" || $chrom_size_file eq "empty"){
    die "\nERROR: The format should be perl Genome_R_script.pl --input_file=input.igv --output_file=output.R.ready --chrom_size_file=chrom_size_file.txt\n\nThe input file is: $input_file\nThe output file is: $output_file\nThe chromosome size file is: $chrom_size_file\n\n"
}

open (INPUT, "<$input_file");
open (INPUT_CHROM_SIZES, "<$chrom_size_file");
open (OUTPUT, ">$output_file");

my %Running_position;

while (my $line = <INPUT_CHROM_SIZES>){
    if ($line =~ m/Chromosome/){
        next;
    }
    my @array_of_line = split(/\t/, $line);
    $Running_position{$array_of_line[0]} = $array_of_line[1];
}

while (my $line = <INPUT>){
    if ($line =~ m/Chromosome/){
        next;
    }
    my @array_of_line = split(/\t/, $line);
    my $x_axis_position = $array_of_line[1] + $Running_position{$array_of_line[0]};
    print OUTPUT "$array_of_line[0]\t$x_axis_position\t$array_of_line[4]";
}



close INPUT;
close INPUT_CHROM_SIZES;
close OUTPUT;

sub Usage
{
    my $command = $0;
    $command =~ s#^[^\s]/##;
    printf STDERR "@_\n" if ( @_ );
    printf STDERR "\nThe format should be perl Genome_R_script.pl --input_file=input.igv --output_file=output.R.ready --chrom_size_file=chrom_size_file.txt\n\nThe input file is: $input_file\nThe output file is: $output_file\nThe chromosome size file is: $chrom_size_file\n\n";
    exit;
}