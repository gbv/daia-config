#!/usr/bin/perl
use v5.12;
use autodie;

my $base = "http://uri.gbv.de/organization/isil/";

opendir(DIR,'sstmap');
while (readdir(DIR)) {
    next unless /^([A-Z]+-[A-Z0-9-]+)\.csv/;
    my $main = $1;
    open FILE, '<', "sstmap/$_";
    foreach (<FILE>) {
        s/"|\s+$//g;
        s/\s+,|,\s+/,/g;
        next if /^sst,department/;
        my ($sst,$dep) = split /,/;
        next if $dep eq '-';
        next if $dep eq '' or $dep eq '@' or $dep eq $main;

        if ($dep !~ /^((ISIL )?([^@, ]+))?(@[^, ]*)?$/) {
            say STDERR "$main.csv: $_ || $dep";
        } else {
            $dep = $3 ? "$3$4" : "$main$4";
            say "<$base$main> <http://www.w3.org/ns/org#hasSite> <$base$dep> .";
        }
    }
    close FILE;
}
