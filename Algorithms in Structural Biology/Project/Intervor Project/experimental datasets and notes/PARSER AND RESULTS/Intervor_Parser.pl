#!/bin/perl

use warnings;
use strict;

use LWP::Simple;

my $counter = 1;
my $Group;
my @Folders;
open (File,"<","data_pdbs_grouped.txt") or die "$!\n";
while (my $line = <File>){
    chomp $line;
    my $Folder = "Group";
    my @PDBs;
    my $write = 0;
    if($line =~ /^Group/m){
      $Group = $line;
    }
    if($line =~ /^{/m)
    {
      @PDBs = split(/,\s/,$');
      $PDBs[(scalar(@PDBs)-1)]  = substr($PDBs[(scalar(@PDBs)-1)],0,4);
      $write = 1;
      $Folder .= $counter;
      push(@Folders,$Folder);
      $counter++;
    }
    if($write == 1){
      system "mkdir $Folder";
      print "$Folder/Pdbs.txt\n";
      open (OUT,">","$Folder/Pdbs.txt") or die "$!\n";
      for (my $i = 0;$i<scalar(@PDBs);$i++){
	print OUT $PDBs[$i],"\n";
	#print $PDBs[$i],"\n";
      }
    }
}
close File;

for (my $i = 0;$i<scalar(@Folders);$i++){
    print "In\n";
    open (File,"<",$Folders[$i]."/Pdbs.txt") or die "$!\n";
    while (my $line = <File>){
      print "In the folder ",$Folders[$i],"\n";
      chomp $line;
      my $Temp = $Folders[$i];
      my $TempFileName = $line.".pdb";
#       my $url = "www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=$line";
#       my $file = $Temp."/".$line.".pdb";
      system "mkdir $Temp/$line";
      my $result=`wget -O $TempFileName "www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=$line"`;
      my $result = `/home/mitsias/Intervor/./intervor-static-32.exe -f /home/mitsias/Intervor/PDB_files/$TempFileName -C A -C B -w 1 -p all -D /home/mitsias/Intervor/PDB_files/$Temp --log`
#       getstore($url, $file);
    }
}

#my $result = `wget -P /home/mitsias/Intervor/PDB_files/Group1 "www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=1a17"`;
# system "mkdir Group1/1azs";
# my $result = `wget -O 1azs.pdb "www.rcsb.org/pdb/download/downloadFile.do?fileFormat=pdb&compression=NO&structureId=1azs"`;
# my $result = `/home/mitsias/Intervor/./intervor-static-32.exe -f /home/mitsias/Intervor/PDB_files/1azs.pdb -C A -C B -w 1 -p all -D /home/mitsias/Intervor/PDB_files/Group1/1azs --log`

#system "perl $bin_folder/create_maf_for_genes_1.3.pl $species $geneSeqFile $maf_database $working_dir >> $log_file";
#system "mv $working_dir/maf_chr*.spliced.txt $working_dir/geneMAF.txt";