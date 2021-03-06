#!/usr/bin/perl -W
use strict;
use warnings;
use JSON::XS;
use Data::Dumper;
use AI::MicroStructure;
use AI::MicroStructure::util;
use Storable::CouchDB;
my @ARGVX = ();

my $state = AI::MicroStructure::util::load_config(); my @CWD=$state->{cwd}; my $config=$state->{cfg};

our $json_main =  {lang=>"C",category=>"no",name=>"santex",size=>1,children=>[]};

@ARGVX=("user",
      "pass",
      "localhost",
      "nav") unless($#ARGVX>2);



my $x = AI::MicroStructure->new;

sub getAll {
  my $key =shift;

  require LWP::UserAgent;
  my $ua = LWP::UserAgent->new;
  my ($server,$db) = ($config->{couchdb},"table");
  my $res = $ua->get(sprintf('%s/%s/_design/base/_view/instances?reduce=false&start_key=["%s"]&end_key=["%sZZZ"]',
                              $server,
                              $db,
                              $key,
                              $key));


my $content = decode_json($res->content);
my @all;
my @book;

foreach(@{$content->{rows}}){

  if(@{$_->{key}}){
    push @all,grep{!/\W/}@{$_->{key}};
  }
}


return @all;


}




$ARGV[0] = "" unless($ARGV[0]);
my $key = sprintf("%s_%s",join("",@ARGVX),$ARGV[0]);
my @datax = getAll($ARGV[0]);

if($#datax){


foreach my $i(0..$#datax) {

  printf("%s\n","".$datax[$i]) unless(!$datax[$i]);

}
}

1;
__DATA__


