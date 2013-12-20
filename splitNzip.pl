#!/usr/bin/env perl 
# split.pl
# Luca Cappelletti (2013)
# luca.cappelletti@gmail.com
# WTF License
#
# per windows dovrebbe essere
# C:\Perl\bin\perl.exe -w
# 
use strict;
use warnings;
#use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Archive::Tar;
my @file = glob( "*.txt" ); 

my $buf_size = 20000000;
my $SecondiDelGiorno = 86400;

foreach ( @file ) {

	my $ilFile = $_;
	printf("file: $ilFile\t");

	my $righe_totali = 0;
	open (FILE, $ilFile) or die "Non riesco ad aprire il file: '$ilFile': $!";
	$righe_totali++ while (<FILE>);
	close FILE;

	print "Totale righe: $righe_totali\n";

	my $GiorniPerFile = int($righe_totali / $SecondiDelGiorno);
#	print "In questo file potrebbero esserci memorizzati circa $GiorniPerFile giorni\n";
#	print "mi aspetto quindi di produrre almeno $GiorniPerFile files pieni + 1 o 2 files residui\n";

	my $local_parts = 1;
	my $local_raws = 1;

	unlink glob "$ilFile.*";
	open ( INPUT_FILE, $ilFile) or die "Non riesco ad aprire $ilFile : $!";

	my $FineGiornata = "23.59.59";
	while (<INPUT_FILE>) {
	
	  my ($Riga) = $_;

		open (OUTPUT_FILE, ">> $ilFile.$local_parts");
		print OUTPUT_FILE $Riga;
		if (  index( $Riga, $FineGiornata) != -1 ) {
			close (OUTPUT_FILE);
			print "File numero $local_parts - local_raws: $local_raws\n";
			    
#				my $zip = Archive::Zip->new();
#				my $file_member = $zip->addFile( $ilFile - '.' . $local_parts );
#				$file_member ->desiredCompressionMethod( 6 );
#				$zip->writeToFileNamed( $ilFile . '.' . $local_parts . '.zip' );

			$local_raws = 1;			
			$local_parts++;
			}
	  
	$local_raws++;
	} # END while

close (INPUT_FILE);

} # END foreach

	my @files_to_zip = glob ("*.txt.*");
	foreach ( @files_to_zip ) {
	
		my $fileToZip = $_;
		print "comprimo: " . $fileToZip . "\t";
			my $tar = Archive::Tar->new;
			$tar->add_files( $fileToZip );
			$tar->write($fileToZip . '.tgz', COMPRESS_GZIP);
		print "\tok!\n";

	}

exit;
