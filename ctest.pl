#!/usr/bin/env perl

$results = `curl http://jimbarcelona.com/`;
sleep 5;
print $results;
