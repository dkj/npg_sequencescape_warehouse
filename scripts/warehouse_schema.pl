#!/usr/bin/env perl

#########
# Author:        Marina Gourtovaia
# Maintainer:    $Author: mg8 $
# Last Modified: $Date: 2010-04-19 10:34:31 +0100 (Mon, 19 Apr 2010) $
# Id:            $Id: loader.pm 9066 2010-04-19 09:34:31Z mg8 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/data_handling/branches/prerelease-21.0/lib/npg_warehouse/loader.pm $

use strict;
use warnings;
use Carp;
use Config::Auto;
use DBIx::Class::Schema::Loader qw(make_schema_at);

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 8733 $ =~ /(\d+)/mxs; $r; };

Readonly::Scalar our $NPG_CONF_DIR   => q[.npg];
Readonly::Scalar our $CONF_FILE_NAME => q[npg_warehouse-Schema];

my $domain = $ENV{dev}||q[live];
my $schema_class_name = q[npg_warehouse::Schema];

carp qq[SCHEMA CLASS NAME $schema_class_name, DOMAIN $domain];

my $path = join q[/], $ENV{'HOME'}, $NPG_CONF_DIR, $CONF_FILE_NAME;
my $config = Config::Auto::parse($path);
if (defined $config->{$domain}) {
  $config = $config->{$domain};
}

make_schema_at(
          $schema_class_name, 
          { 
            debug           => 0, 
            dump_directory  => q[lib], 
            naming          => q[current],
            components      => [qw(InflateColumn::DateTime)],
            skip_load_external => 1,
            use_moose       => 1,
          }, 
          [ $config->{'dsn'}, $config->{'dbuser'}, $config->{'dbpass'}]
              );

1;
