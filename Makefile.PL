use 5.006;
use strict;
use warnings;
use Config;
use ExtUtils::MakeMaker;

# have_inc() EV's Makefile.PL by Marc Lehmann <schmorp@schmorp.de>
sub have_inc($) {
    scalar grep -r "$_/$_[0]", $Config{usrinc}, split / /, $Config{incpth};
}

my @LIBS = ( '-lgetdns' );
my @DEFINES;
my %DL_FUNCS = (
    'Net__GetDNS__XS'          => ['boot_Net__XS__GetDNS'],
    'Net__GetDNS__XS__Context' => ['boot_Net__GetDNS__XS__Context'],
    'Net__GetDNS__XS__Dict'    => ['boot_Net__GetDNS__XS__Dict'],
    'Net__GetDNS__XS__List'    => ['boot_Net__GetDNS__XS__List'],
    'Net__GetDNS__XS__Bindata' => ['boot_Net__GetDNS__XS__Bindata'],
);

WriteMakefile(
    NAME         => 'Net::GetDNS',
    DISTNAME     => 'p5-Net-GetDNS',
    AUTHOR       => q{Jerry Lundström <lundstrom.jerry@gmail.com>},
    VERSION_FROM => 'lib/Net/GetDNS.pm',
    ABSTRACT     => 'Perl bindings for getdns, a modern asynchronous DNS API',
    (
        !eval { ExtUtils::MakeMaker->VERSION( 6.3002 ) }
        ? ()
        : ( LICENSE => 'perl' )
    ),
    (
        eval { ExtUtils::MakeMaker->VERSION( 6.5503 ) }
        ? (
            BUILD_REQUIRES => {
                'Test::More'          => 0,
                'Test::CheckManifest' => 0.9,
                'common::sense'       => 3,
            },
            PREREQ_PM => {
                'common::sense' => 3,
            }
          )
        : (
            PREREQ_PM => {
                'Test::More'    => 0,
                'common::sense' => 3,
            }
        )
    ),
    (
        !eval { ExtUtils::MakeMaker->VERSION( 6.46 ) }
        ? ()
        : (
            META_ADD => {
                resources => {
                    homepage   => 'https://github.com/DNS-OARC/p5-Net-GetDNS',
                    repository => 'https://github.com/DNS-OARC/p5-Net-GetDNS',
                    bugtracker => 'https://github.com/DNS-OARC/p5-Net-GetDNS/issues',
                },
            }
        )
    ),
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'p5-Net-GetDNS-*' },
    LIBS     => \@LIBS,                   # e.g., '-lm'
    DEFINE   => join( ' ', @DEFINES ),    # e.g., '-DHAVE_SOMETHING'
    INC      => '-I.',                    # e.g., '-I. -I/usr/include/other'
    OBJECT   => '$(O_FILES)',             # link all the C files too
    TYPEMAPS => ['typemap'],
    DL_FUNCS => \%DL_FUNCS,
);
