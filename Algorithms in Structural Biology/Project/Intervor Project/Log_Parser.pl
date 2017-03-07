#!/bin/perl -w

use warnings;
use strict;

use LWP::Simple;

my $counter = 1;
my $Group;
my @Folders;
my %PDBs;
my %OriginalGroup; # Antistoixia twn Group1, Group2 etc me ta Group names opws parousiazontai sto Input

my %Group_features;

my $GroupedPdbs = shift;
open (File,"<",$GroupedPdbs) or die "$!\n";
while (my $line = <File>){
    chomp $line;
    my $Folder = "Group";
    my @PDBs; 
    my $write = 0;
    if($line =~ /^Group/m){
      $Group = $line;  # Group anathesis
    }
    if($line =~ /^{/m)
    {
      @PDBs = split(/,\s/,$');  # Fetch PDBs included in the Group
      $PDBs[(scalar(@PDBs)-1)]  = substr($PDBs[(scalar(@PDBs)-1)],0,4);
      push(@Folders,$Folder); # Edw 8a periexontai ola ta group, den xrhsimopoieitai
      $Folder .= $counter;
      $counter++;
      @{$PDBs{$Folder}} = @PDBs; 
      $OriginalGroup{$Folder} = $Group; # H antisoixia
    }

}
close File;

open (OUT,">","Statistics.txt") or die "$!\n";
my @sum_PDBs;
foreach my $key (keys %PDBs){
   print OUT "$key\n\n";
   # Ta diafora a8roismata gia ton upologismo twn statistics
   my $sum_Group_PDBs = 0;
   my $sum_Group_triangles = 0;
   my @Group_triangles;
   my $sum_Group_tetraedra = 0;
   my @Group_tetraedra;
   my $sum_atoms_A = 0;
   my @atoms_A;
   my $sum_atoms_B = 0;
   my @atoms_B;
   my $sum_atoms_Wb = 0;
   my $sum_atoms_Wi = 0;
   my $sum_atoms_X = 0;
   my (@atoms_Wb,@atoms_Wi,@atoms_X,@interface_atoms_A,@interface_atoms_B,@interface_atoms_Wb,@interface_atoms_Wi,@interface_atoms_X);
   my $sum_interface_atoms_A = 0;
   my $sum_interface_atoms_B = 0;
   my $sum_interface_atoms_Wb = 0;
   my $sum_interface_atoms_Wi = 0;
   my $sum_interface_atoms_X = 0;
   my ($sum_interface_atoms_Cali,$sum_interface_atoms_Caro,$sum_interface_atoms_Cpep,$sum_interface_atoms_Nhbd,$sum_interface_atoms_Naro,$sum_interface_atoms_NchP,$sum_interface_atoms_Ohbd,$sum_interface_atoms_Opep,$sum_interface_atoms_OchM,$sum_interface_atoms_Owat,$sum_interface_atoms_Sh,$sum_interface_atoms_Pdna,$sum_interface_atoms_Opd,$sum_interface_atoms_Orib,$sum_interface_atoms_Unk) = 0;
   my (@interface_atoms_Cali,@interface_atoms_Caro,@interface_atoms_Cpep,@interface_atoms_Nhbd,@interface_atoms_Naro,@interface_atoms_NchP,@interface_atoms_Ohbd,@interface_atoms_Opep,@interface_atoms_OchM,@nterface_atoms_Owat,@interface_atoms_Sh,@interface_atoms_Pdna,@interface_atoms_Opd,@interface_atoms_Orib,@interface_atoms_Unk) ;
   my $sum_interface_MI_AB_ccs = 0;
   my $sum_interface_MI_AWi_BWi_ccs = 0;
   my $sum_interface_MI_AB_areas = 0;
   my $sum_interface_MI_AWi_areas = 0;
   my $sum_interface_MI_BWi_areas = 0;
   my (@interface_MI_AB_ccs,@interface_MI_AWi_BWi_ccs,@interface_MI_AB_areas,@interface_MI_AWi_areas,@interface_MI_BWi_areas);
   my ($ali,$aro,$hdb,$hbw,$hbdp,$elu,$elf,$hbwp,$ssb,$unk) = 0;
   my (@ali,@aro,@hdb,@hbw,@hbdp,@elu,@elf,@hbwp,@ssb,@unk) ;
   my $sum_ccs_fromTo = 0;
   my $sumPDBs = 0;
   my $PDBS_with_water = 0;
   my $PDB_found = 0;
   for (my $i=0;$i<scalar(@{$PDBs{$key}});$i++){
      #print ${$PDBs{$key}}[$i],"\n";
      my $water = 0;
      my $interface;
      my $PDB = ${$PDBs{$key}}[$i];
      my $LogFile = "$PDB"."_log-IV.txt";
      print "Results/$key/$PDB/$LogFile\n";
      open (File,"<","Results/$key/$LogFile") or die "$!\n";
#       open (File,"<","Results/$key/$PDB/$LogFile") or die "$!\n";  # Afto to prosarmozw, analoga me to pou vrhskontai ta apotelesmata
      while (my $line = <File>){
	  chomp $line;
	  $PDB_found = 0;
	  if ($line =~ m/simplices.+?\d+.+?\d+.+?(\d+).+?(\d+)/){print "Found 1\n";$PDB_found = 1;$sum_Group_triangles += $1; $sum_Group_tetraedra += $2;}
	  if ($line =~ m/:#atoms.+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+)/)  {print "Found 2\n";$sum_atoms_A += $1; $sum_atoms_B += $2; $sum_atoms_Wb += $3; $sum_atoms_Wi += $4; $sum_atoms_X += $5; }
	  if ($line =~ m/iatoms.+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+)/) {print "Found 3\n";$sum_interface_atoms_A += $1; $sum_interface_atoms_B += $2; $sum_interface_atoms_Wb += $3; $sum_interface_atoms_Wi += $4; $sum_interface_atoms_X += $5; }
	  if ($line =~ m/interf.atoms.annotated.+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+).+?(\d+)/){print "Found 4\n";$sum_interface_atoms_Cali += $1;$sum_interface_atoms_Caro += $2;$sum_interface_atoms_Cpep += $3;$sum_interface_atoms_Nhbd += $4;$sum_interface_atoms_Naro += $5;$sum_interface_atoms_NchP += $6;$sum_interface_atoms_Ohbd += $7;$sum_interface_atoms_Opep += $8;$sum_interface_atoms_OchM += $9;$sum_interface_atoms_Owat += $10;$sum_interface_atoms_Sh += $11;$sum_interface_atoms_Pdna += $12;$sum_interface_atoms_Opd += $13;$sum_interface_atoms_Orib += $14;$sum_interface_atoms_Unk += $15;}
	  if ($line =~ m/Exploring.interface.MI_AB/){print"Found 5\n";$interface = "MI_AB";}
	  if ($line =~ m/Exploring.interface.MI_AWi_BWi/){print"Found 6\n";$water = 1;$interface = "MI_AWi_BWi";}
	  if ($line =~ m/dump_interf_stats.+?(\d+).+?\d+.+?\d+.+?\d+/ && $interface eq "MI_AB"){print "Found 7\n";$sum_interface_MI_AB_ccs += $1 ;}
	  if ($line =~ m/dump_interf_stats.+?(\d+).+?\d+.+?\d+.+?\d+/ && $interface eq "MI_AWi_BWi"){print "Found 8\n";$sum_interface_MI_AWi_BWi_ccs += $1 ;}
	  if ($line =~ m/:Interface.areas<Areas.+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+)/){print "Found 9\n";$sum_interface_MI_AB_areas += $1; $sum_interface_MI_AWi_areas += $2; $sum_interface_MI_BWi_areas += $3; }
	  if ($line =~ m/:Chem.Interface.areas<Areas.+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+).+?(\d+.\d+)/){print "Found 10\n"; $ali += $1; $aro += $2; $hdb += $3; $hbw += $4; $hbdp += $5; $elu += $6; $elf += $7; $hbwp +=$8; $ssb += $9; $unk += $10;  }
	  if ($water == 0){if ($line =~ m/:Interface.areas<Areas.+?(\d+.\d+)/){print "Found 9\n";$sum_interface_MI_AB_areas += $1;}}
      }
      #if ($PDB_found == 1){$sumPDBs++;} Prepei na doulepsei etsi k na prosexw k me ta nera ti paizei
      $sumPDBs++;
      if ($water == 1 && $PDB_found == 1){$PDBS_with_water++;}
      }
   print OUT "\nSum PDBs: $sumPDBs\n";   
#    print OUT "Triangles Sum: $sum_Group_triangles\n";
   print OUT "Triangles Group avg: ",($sum_Group_triangles/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_Group_triangles/$sumPDBs));
   print OUT "Tetrahedra Group avg: ",($sum_Group_tetraedra/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_Group_tetraedra/$sumPDBs));
   print OUT "Partner A Group avg: ",($sum_atoms_A/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_atoms_A/$sumPDBs));
   print OUT "Partner B Group avg: ",($sum_atoms_B/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_atoms_B/$sumPDBs));
   print OUT "Partner Wb Group avg: ",($sum_atoms_Wb/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_atoms_Wb/$sumPDBs));
   print OUT "Partner Wi Group avg: ",($sum_atoms_Wi/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_atoms_Wi/$sumPDBs));
   print OUT "Partner X Group avg: ",($sum_atoms_X/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_atoms_X/$sumPDBs));
   print OUT "Interface Atom  Group avg (A B Wb Wi X)s:\n\n ",($sum_interface_atoms_A/$sumPDBs),"\n",($sum_interface_atoms_B/$sumPDBs),"\n",($sum_interface_atoms_Wb/$sumPDBs),"\n",($sum_interface_atoms_Wi/$sumPDBs),"\n",($sum_interface_atoms_X/$sumPDBs),"\n"; 
   push(@{$Group_features{$key}},($sum_interface_atoms_A/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_B/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Wb/$sumPDBs);push(@{$Group_features{$key}},($sum_interface_atoms_Wi/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_X/$sumPDBs));
   print OUT "Interface Atoms Annotation  Group avg (Cali - Caro - Cpep - Nhbd - Naro - NchP - Ohbd - Opep - OchM - Owat - Sh - Pdna - Opd - Orib - Unk):\n\n ",($sum_interface_atoms_Cali/$sumPDBs),"\n",($sum_interface_atoms_Caro/$sumPDBs),"\n",($sum_interface_atoms_Cpep/$sumPDBs),"\n",($sum_interface_atoms_Nhbd/$sumPDBs),"\n",($sum_interface_atoms_Naro/$sumPDBs),"\n",($sum_interface_atoms_NchP/$sumPDBs),"\n",($sum_interface_atoms_Ohbd/$sumPDBs),"\n",($sum_interface_atoms_Opep/$sumPDBs),"\n",($sum_interface_atoms_OchM/$sumPDBs),"\n",($sum_interface_atoms_Owat/$sumPDBs),"\n",($sum_interface_atoms_Sh/$sumPDBs),"\n",($sum_interface_atoms_Pdna/$sumPDBs),"\n",($sum_interface_atoms_Opd/$sumPDBs),"\n",($sum_interface_atoms_Orib/$sumPDBs),"\n",($sum_interface_atoms_Unk/$sumPDBs),"\n"; 
   push(@{$Group_features{$key}},($sum_interface_atoms_Cali/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Caro/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Cpep/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Nhbd/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Naro/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_NchP/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Ohbd/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Opep/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_OchM/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Owat/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Sh/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Pdna/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Opd/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Orib/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_atoms_Unk/$sumPDBs));
   print OUT "\nConnected Components  Group avg (AB merged) ",($sum_interface_MI_AB_ccs/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_interface_MI_AB_ccs/$sumPDBs));
   print OUT "Connected Components  Group avg (AB - AW - BW merged) ",($sum_interface_MI_AWi_BWi_ccs/$sumPDBs),"\n"; push(@{$Group_features{$key}},($sum_interface_MI_AWi_BWi_ccs/$sumPDBs));
   print OUT "Interface Areas  Group avg (AB - AW - BW merged): \n\n",($sum_interface_MI_AB_areas/$sumPDBs),"\n",($sum_interface_MI_AWi_areas/$sumPDBs),"\n",($sum_interface_MI_AB_areas/$sumPDBs),"\n"; 
   push(@{$Group_features{$key}},($sum_interface_MI_AB_areas/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_MI_AWi_areas/$sumPDBs));push(@{$Group_features{$key}},($sum_interface_MI_AB_areas/$sumPDBs));
   print OUT "\nChemical Interface Areas  Group avg (ali - aro - hbd - hbw - hbdp - elu - elf - hbwp - ssb - unk):\n\n ",($ali/$sumPDBs),"\n",($aro/$sumPDBs),"\n",($hdb/$sumPDBs),"\n",($hbw/$sumPDBs),"\n",($hbdp/$sumPDBs),"\n",($elu/$sumPDBs),"\n",($elf/$sumPDBs),"\n",($hbwp/$sumPDBs),"\n",($ssb/$sumPDBs),"\n",($unk/$sumPDBs),"\n";
   push(@{$Group_features{$key}},($ali/$sumPDBs));push(@{$Group_features{$key}},($aro/$sumPDBs));push(@{$Group_features{$key}},($hdb/$sumPDBs));push(@{$Group_features{$key}},($hbw/$sumPDBs));push(@{$Group_features{$key}},($hbdp/$sumPDBs));push(@{$Group_features{$key}},($elu/$sumPDBs));push(@{$Group_features{$key}},($elf/$sumPDBs));push(@{$Group_features{$key}},($hbwp/$sumPDBs));push(@{$Group_features{$key}},($ssb/$sumPDBs));push(@{$Group_features{$key}},($unk/$sumPDBs));
 
      
   }
  
#    push(@sum_PDBs,$sumPDBs);


