#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die "Usage: $0 <markdown_file>\n";

open my $fh, '<', $file or die "Cannot open file '$file': $!\n";

my $line1 = <$fh>;
my $line2 = <$fh>;
close $fh;

unless ( defined $line1 ) {
    print "(blank)";
    exit;
}

chomp($line1);
chomp($line2) if defined $line2;

$line1 =~ s/^#+\s*//;

my $title;
if ( $line1 =~ / - / ) {
    $title = $line1;
}
elsif ( defined $line2 && $line2 ne "" ) {
    $title = "$line1 - $line2";
}
else {
    $title = $line1;
}

my $site_title = "かれは開発室 - Kareha Hub";

if ($title eq $site_title) {
	print $title;
} else {
	print "$title | $site_title";
}
