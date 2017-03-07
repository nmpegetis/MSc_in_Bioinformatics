#!/bin/perl -w

use warnings;
use strict;

use LWP::Simple;

my $counter = 1;
my $Group;
my @Folders;
my %PDBs;
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
      push(@Folders,$Folder); # Edw 8a periexontai ola ta group
      $Folder .= $counter;
      $counter++;
      @{$PDBs{$Folder}} = @PDBs; 
    }

}
close File;

my @sum_PDBs;
foreach my $key (keys %PDBs){
   print "$key\n";
   my $sum_Group_PDBs = 0;
   my $sum_Group_triangles = 0;
   my $sum_Group_tetraedra = 0;
   my $sum_atoms_A = 0;
   my $sum_atoms_B = 0;
   my $sum_atoms_Wb = 0;
   my $sum_atoms_Wi = 0;
   my $sum_atoms_X = 0;
   my $sum_interface_atoms_A = 0;
   my $sum_interface_atoms_B = 0;
   my $sum_interface_atoms_Wb = 0;
   my $sum_interface_atoms_Wi = 0;
   my $sum_interface_atoms_X = 0;
   my ($sum_interface_atoms_Cali,$sum_interface_atoms_Caro,$sum_interface_atoms_Cpep,$sum_interface_atoms_Nhbd,$sum_interface_atoms_Naro,$sum_interface_atoms_NchP,$sum_interface_atoms_Ohbd,$sum_interface_atoms_Opep,$sum_interface_atoms_OchM,$sum_interface_atoms_Owat,$sum_interface_atoms_Sh,$sum_interface_atoms_Pdna,$sum_interface_atoms_Opd,$sum_interface_atoms_Orib,$sum_interface_atoms_Unk) = 0;
   my $sum_interface_MI_AB_ccs = 0;
   my $sum_interface_MI_AWi_BWi_ccs = 0;
   my $sum_interface_MI_AB_areas = 0;
   my $sum_interface_MI_AWi_areas = 0;
   my $sum_interface_MI_BWi_areas = 0;
   my ($ali,$aro,$hdb,$hbw,$hbdp,$elu,$elf,$hbwp,$ssb,$unk) = 0;
   my $sum_ccs_fromTo = 0;
   my $sumPDBs = 0;
   my $PDBS_with_water = 0;
   for (my $i=0;$i<scalar(@{$PDBs{$key}});$i++){
      #print ${$PDBs{$key}}[$i],"\n";
      $sumPDBs++;
      my $water = 0;
      my $interface;
      my $PDB = ${$PDBs{$key}}[$i];
      my $LogFile = "$PDB"."_log-IV.txt";
      print "$key/$PDB/$LogFile\n";
      open (File,"<","$key/$PDB/$LogFile") or die "$!\n";
      while (my $line = <File>){
	  chomp $line;
	  
	  if ($line =~ m/simplices.+?\d+?.+?\d+?.+?(\d+?).+?(\d+?)/){print"Found 1\n";$sum_Group_triangles += $1; $sum_Group_tetraedra += $2;}
	  if ($line =~ m/:#atoms.+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?)/)  {print"Found 2\n";$sum_atoms_A += $1; $sum_atoms_B += $2; $sum_atoms_Wb += $3; $sum_atoms_Wi += $4; $sum_atoms_X += $5; }
	  if ($line =~ m/iatoms.+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?)/) {print"Found 3\n";$sum_interface_atoms_A += $1; $sum_interface_atoms_B += $2; $sum_interface_atoms_Wb += $3; $sum_interface_atoms_Wi += $4; $sum_interface_atoms_X += $5; }
	  if ($line =~ m/interf.atoms.annotated.+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?).+?(\d+?)/){print"Found 4\n";$sum_interface_atoms_Cali += $1;$sum_interface_atoms_Caro += $2;$sum_interface_atoms_Cpep += $3;$sum_interface_atoms_Nhbd += $4;$sum_interface_atoms_Naro += $5;$sum_interface_atoms_NchP += $6;$sum_interface_atoms_Ohbd += $7;$sum_interface_atoms_Opep += $8;$sum_interface_atoms_OchM += $9;$sum_interface_atoms_Owat += $10;$sum_interface_atoms_Sh += $11;$sum_interface_atoms_Pdna += $12;$sum_interface_atoms_Opd += $13;$sum_interface_atoms_Orib += $14;$sum_interface_atoms_Unk += $15;}
	  if ($line =~ m/Exploring.interface.MI_AB/){print"Found 5\n";$interface = "MI_AB";}
	  if ($line =~ m/Exploring.interface.MI_AWi_BWi/){print"Found 6\n";$water = 1;$PDBS_with_water++;$interface = "MI_AWi_BWi";}
	  if ($line =~ m/dump_interf_stats.+?(\d+?).+?\d+?.+?\d+?.+?\d+?/ && $interface eq "MI_AB"){print"Found 7\n";$sum_interface_MI_AB_ccs += $1 ;}
	  if ($line =~ m/dump_interf_stats.+?(\d+?).+?\d+?.+?\d+?.+?\d+?/ && $interface eq "MI_AWi_BWi"){print"Found 8\n";$sum_interface_MI_AWi_BWi_ccs += $1 ;}
	  if ($line =~ m/:Interface.areas<Areas.+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?)/){print"Found 9\n";$sum_interface_MI_AB_areas += $1; $sum_interface_MI_AWi_areas += $2; $sum_interface_MI_BWi_areas += $3; }
	  if ($line =~ m/:Chem.Interface.areas<Areas.+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?).+?(\d+?.\d+?)/){print"Found 10\n"; $ali += $1; $aro += $2; $hbd += $3; $hbw += $4; $hbdp += $5; $elu += $6; $elf += $7; $hbwp +=$8; $ssb += $9; $unk += $10;  }
	  if ($water == 0){if ($line =~ m/:Interface.areas<Areas.+?(\d+?.\d+?)/){print"Found 9\n";$sum_interface_MI_AB_areas += $1;}}
      }
   }
   push(@sum_PDBs,$sumPDBs);
}