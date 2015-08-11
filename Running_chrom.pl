#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;

my ($input_file, $output_file, $empty) = ("empty", "empty");

GetOptions(
"input_file=s"      => \$input_file,
"output_file=s"     => \$output_file,
) or Usage ("Invalid command-line option");

if ($input_file eq "empty" || $output_file eq "empty"){
    die "\nERROR: The format should be perl Running_chrom.pl --input_file=input.fai --output_file=output_chrom_size.txt\n\nThe input file is: $input_file\nThe output_file is: $output_file\n\n"
}

print "\nThe input file is: $input_file\nThe output_file is: $output_file\n\n";

open (INPUT_FILE, "<$input_file");
open (OUTPUT_FILE, ">$output_file");

my $running_position = 0;
my $initial_boolean = 0;

while (my $line = <INPUT_FILE>){
    chomp $line;
    my @array_of_line = split(/\t/, $line);
    if ($initial_boolean == 0){
        print OUTPUT_FILE "$array_of_line[0]\t$running_position\n";
        $initial_boolean = 1;
        $running_position = $running_position + $array_of_line[1];
        next;
    }
    print OUTPUT_FILE "$array_of_line[0]\t$running_position\n";
    $running_position = $running_position + $array_of_line[1];
}

sub Usage
{
    my $command = $0;
    $command =~ s#^[^\s]/##;
    printf STDERR "@_\n" if ( @_ );
    printf STDERR "\nThe format should be perl Running_chrom.pl --input_file=input.fai --output_file=output.txt\n\nThe input file is: $input_file\nThe output_file is: $output_file\n\n";
    exit;
}

close INPUT_FILE;
close OUTPUT_FILE;