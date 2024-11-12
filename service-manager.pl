#!/usr/bin/env perl
#
#          _nnnn_
#         dGGGGMMb
#        @p~qp~~qMb
#        M|@||@) M|
#        @,----.JM|
#       JS^\__/  qKL
#      dZP        qKRb
#     dZP          qKKb
#    fZP            SMMb
#    HZM            MMMM
#    FqM            MMMM
#  __| ".        |\dS"qML
#  |    `.       | `' \Zq
# _)      \.___.,|     .'
# \____   )MMMMMP|   .'
#      `-'       `--' 
#
# Debian Service Manager
# By: 16BitMiker (v2024-11-08)
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Pragmas

use strict;
use warnings;
use autodie;

use utf8;
use open qw(:std :utf8);

use Term::ANSIColor qw(:constants);
use feature qw(say state);
use FindBin qw($RealBin);
use Data::Dumper;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Config

# Configure Data::Dumper
$Data::Dumper::Purity   = 1;  # Produce output that's valid as Perl code
$Data::Dumper::Indent   = 1;  # Turn on pretty-printing with a single-space indent
$Data::Dumper::Sortkeys = 1;  # Sort hash keys for consistent output
$Data::Dumper::Terse    = 1;  # Avoid outputting variable names (just the structure)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Vars

$|++;

my $db = {};
my $dt = {

  tw => \&typeWriter,
  zzz => \&sleepyTime,
  line => \&border,
  bye => \&byebye,

};


my $cmds =
[
    { list    => q|sudo systemctl list-unit-files --type=service --all --no-pager| },
    { today   => q|sudo journalctl -u SERVICE --since today --no-pager| },
    { follow  => q|sudo journalctl -u SERVICE -f --no-pager| },
    { all     => q|sudo journalctl -u SERVICE --no-pager| },
    { start   => q|systemctl start SERVICE| },
    { stop    => q|systemctl stop SERVICE| },
    { restart => q|systemctl restart SERVICE| },
    { status  => q|systemctl status SERVICE| },
];

my $choice = undef;
my $my_service = '';

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Init

REGEX:
{
    $$dt{line}();
    say BOLD q|SERVICE: REGEX OR ENTER FOR ALL|, RESET;
    $$dt{line}();
    print q|> 🔍 |;
    $choice = undef;
    chomp( $choice = <STDIN> );
    $$dt{line}();

    $$dt{bye}($choice);

    if ($choice)
    {
        my $regex = qr~$choice~;

        chomp( local @_ = qx|$$cmds[0]{list}| );

        printf qq|%s%s%s%s%s\n|
        , q|UNIT FILE|
        , q| |x36
        , q|STATE|
        , q| |x11
        , q|PRESET|;

        map
        { say if m~$regex~ } @_;
    }
    else
    {
        system $$cmds[0]{list}
    }
}

##############################

CHOOSE_SERVICE:
my $daemon = do
{
    $$dt{line}();
    say BOLD q|CHOOSE SERVICE: B(ye) R(edo)|, RESET;
    $$dt{line}();
    print q|> 👉 |;
    $choice = undef;
    chomp( $choice = <STDIN> );

    $$dt{bye}($choice);
    goto CHOOSE_SERVICE if $choice =~ m~^$~;
    goto REGEX if $choice =~ m~^R(?:edo)?$~i;

    qx|systemctl status ${choice} > /dev/null 2>&1|;

    if ($? != 0)
    {
        goto CHOOSE_SERVICE;
    }

    $choice
};


$my_service = qq|(${daemon})|;

##############################

RUN:
{
    $$dt{line}();
    say BOLD qq|CMD MENU ${my_service}: B(ye) R(edo)|, RESET;
    $$dt{line}();

    for my $key (sort keys @{$cmds})
    {
        next if $key == 0;

        printf qq|%2d - %s\n|
        , $key
        , keys %{$$cmds[$key]}

    };

    $$dt{line}();
    print q|> 🏃 |;
    $choice = undef;
    chomp( $choice = <STDIN> );
    $$dt{line}();

    $$dt{bye}($choice);
    if ( $choice =~ m~^$~ )
    {
        print q|> |, YELLOW BOLD;
        typewriter(q|Need to choose!|);
        say RESET q||;
        goto RUN;
    }
    goto REGEX if $choice =~ m~^R(?:edo)?$~i;

    goto RUN unless $$cmds[$choice];

    my ($run) = values %{$$cmds[$choice]};
    $run =~ s~SERVICE~${daemon}~g;

    # say Dumper $$cmds[$choice];
    print q|> |, GREEN BOLD;
    typewriter( $run );
    say RESET q||;
    system $run;
    goto RUN;
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Subs

sub byebye
{
    my $choice = shift;

    return 0 unless $choice;

    if ($choice =~ m~^Q(?:uit)?$|^E(?:xit)?$|^B(?:ye)?$~i)
    {
        print q|> |;
        print RED BOLD q||;
        typewriter(q|Bye Bye! |);
        print RESET q||;
        say q||;
        exit 0;
    }
}


##############################

sub border
{
    my $num = shift // 42;
    say q|-|x$num;
}

##############################

sub sleepyTime
{
  my $random = shift // 0;
  my $fixed = shift // 0;

  # Early return if both random and fixed times are too small
  return 0 if ( $random <= 2 and $fixed == 0 );

  # Calculate sleep time and display it
  my $sleep = int( rand( $random ) ) + $fixed;
  say qq|> |, q|Sleeping for |, YELLOW UNDERLINE $sleep, RESET q| seconds...|;
  sleep $sleep;
}

##############################

sub typewriter
{
    my $text = shift;
    # Use regex to process each character of the text
    $text =~ s`.`
        select(undef, undef, undef, rand(0.05)); # Small random delay
        print $&; # Print the matched character
    `sger;
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ End

__END__

