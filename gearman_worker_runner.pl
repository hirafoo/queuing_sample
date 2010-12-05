#!/usr/bin/perl
use lib "lib";
use MyApp::Utils;
use MyApp::Gearman::Worker;

MyApp::Gearman::Worker->new->run;
