#!/usr/bin/perl
use lib "lib";
use MyApp::Utils;
use MyApp::TheSchwartz::Worker;

MyApp::TheSchwartz::Worker->new({max_workers => 1})->run;
