use v6;
use Test;

use Geo::Ellipsoid;
use Geo::Ellipsoid::Utils;

#plan 2;

# Test pseudo "private" methods

# tests against original NOAA/NGS code test results

my ($faz, $baz, $dist);
my ($FAZ, $BAZ, $DIST);

#=====================================
# GRS80 / WGS84 (NAD83) (default)
# station Jones
my $lat_11 = lat-hms2deg('n34  0 12.12345');
my $lon_11 = lon-hms2deg('w111 0 12.12345');
# station Smith
my $lat_12 = lat-hms2deg('n33  22 11.54321');
my $lon_12 = lon-hms2deg('w112 55 44.33333');

#=====================================
# Clark 1866 (NAD27)
# station Charlie
my $lat_21 = lat-hms2deg('n45 0 12.00000');
my $lon_21 = lon-hms2deg('w68 0  0.00000');
# station Sam
my $lat_22 = lat-hms2deg('n33 22 11.54321');
my $lon_22 = lon-hms2deg('w70 12 34.78900');


# FROM: station Bill
my $lat_31 = lat-hms2deg('+34 0 0.0');
my $lon_31 = lon-hms2deg('+68 0 0.0');
my $EHT_3 = 76.0;
my $DH_3  = -22.0;
my $FAZ_3 = hms2deg(+245, 0, 34.7);
my $S_3 = 123456.7891;
# TO: station George
# results
my $lat_32 = lat-hms2deg(' n33 31 25.93490');
my $lon_32 = lon-hms2deg('w112 12 16.40986');

#say "DEBUG: \$lat_11 = $lat_11"; die "DEBUG exit";


=begin pod

=head1 Original Test Data

Following are the nearly verbatim contents from the readme.doc included with the
original fortran source code from NOAA/NGS (some spelling errors were corrected 
and some formatting was tidied).  The test data contained below
are used to verify the Perl 6 versions of the _forward and _inverse functions
in module Geo::Ellipsoid.

=head2 readme.doc

                   USER DOCUMENTATION  -  Version 2.0

Programs :  INVERSE, FORWARD, INVERS3D, FORWRD3D


Introduction :

The geodetic inverse, program INVERSE, is the tool for computing
the geodetic azimuth and distance between two points, given their
latitudes and longitudes.

The geodetic forward, program FORWARD, is the tool for computing
the latitude and longitude of a point, given the latitude and
longitude of a starting point and the geodetic azimuth and geodetic
distance between the points.

The three-dimensional versions of the geodetic inverse and
geodetic forward, programs INVERS3D and FORWRD3D, include the
ellipsoid height component.  Also included in the 3D programs are:

1) Conversions between geodetic positions (latitude, longitude,
and ellipsoid height) and rectangular coordinates (X,Y,Z in the
Conventional Terrestrial Reference System).

2) Conversions between the following four observation sets:
   a) DN,DE,DU (differential N, E, U using the FROM station
      as the origin of the NEU-coordinate system.)
   b) DX,DY,DZ (differential X, Y, Z used to express GPS vectors)
   c) delta height, forward azimuth, ellipsoidal distance
   d) delta height, forward azimuth, mark-to-mark distance

Hardware Requirements :

Programs INVERSE, FORWARD, INVERS3D, and FORWRD3D are all written
in Fortran77 and complied on an IBM-PC or compatible.

       - A math-coprocessor is required,
       - 256 kb of RAM, and
       - DOS version 2.1 or greater.

User Instructions :

All four programs run interactively; prompts are given for input,
and the output is directed to the screen.  Simply type the name
of the desired program, then answer the prompts as they appear.
Once all the prompts have been answered, the output will appear
on the screen.  A prompt is given for saving the output into a
file, if desired.

Programs INVERSE and FORWARD allow the user to select from the
following list of reference ellipsoids for the computations:

     Clarke 1866    (NAD27)
     GRS80 / WGS84  (NAD83)
     Airy 1858
     Airy Modified
     Australian National
     Bessel 1841
     Clarke 1880
     Everest 1830
     Everest Modified
     Fisher 1960
     Fisher 1968
     Hough 1956
     International (Hayford)
     Krassovsky 1938
     NWL-9D (WGS 66)
     South American 1969
     Soviet Geod. System 1985
     WGS 72
     User defined.

Please note that the GRS80 and WGS84 are considered to be the
same.  Actually, there is a very small difference in the
flattening which results in the semi-minor axis, b, being
different by 0.0001 meters.  There is no known application for
which this difference is significant.

The user is given the option of defining their own reference
ellipsoid in whatever units they prefer.  (If, for example, the
user wishes to define the semi-major and semi-minor axes in
miles, they may do so.  The units for the geodetic distance would
then be given in miles also.)  The units for all the listed
reference ellipsoid are given in meters, and therefore the
distances are also in meters.

Programs INVERS3D and FORWRD3D work exclusively on the GRS80
ellipsoid and the units are meters.

Note 1 :

Program FORWRD3D will do a conversion from mark-to-mark distance
to ellipsoidal distance, if a mark-to-mark distance is given as
input.  The first approximation is computed using formulas given
in the NOAA Technical Memorandum NOS NGS-10, Use of Calibration
Baselines, pages 26-27.  These formulas are generally good for
distances less than 100 kilometers.  The program will then do a
forward computation using the computed ellipsoidal distance.  The
mark-to-mark distance is then recomputed from the resulting
DX,DY,DZ.  If the difference between the computed mark-to-mark
distance and the original mark-to-mark distance is greater than
one millimeter, then the difference is applied to the ellipsoidal
distance and another forward computation is performed.  The
program will continue iterating in this fashion until convergence.

Note 2 :

All four program read the input geodetic positions as real
numbers (latitudes are positive North, and longitudes are
positive East), then convert them to radians for internal
computations.  The conversion is done as follows:

radians = ( pi / 180 )* (degrees + minutes/60 + seconds/3600)

The programs return the input values after :
     1. Converting them into degrees, minutes, and seconds and
     2. Checking d,m,s for the correct within range.

Some example latitude inputs are :

     Hemisphere h = (blank,N,n,+   or  S,s,-)
     Commas or blanks may be used between the D,M,S entries.

     Keyed Input :                              Converted latitude :

     Nominal : degrees, minutes & seconds ( hDD MM SS.sssss )
     =========
     hDD MM SS.sssss                            Latitude :
     <cr>                   ( h default = N )     0  0  0.00000 North
     0                             "                     "
     0 0 0                         "                     "
     0,0,0.0                       "                     "
     0d 0m 0s                      "                     "
     00d 00m 00.000s               "                     "
     10 0 1.00001                  "             10  0  1.00001 North
     10d 0m 1.00001s               "             10  0  1.00001 North
     +0                                           0  0  0.00000 North
     +0 0 0.0                                     0  0  0.00000 North
     +0,0,0.1                                     0  0  0.10000 North
     N0                                           0  0  0.00000 North
     N20                                         20  0  0.00000 North
     n20d20m22s                                  20 20 22.00000 North
     n020d  20m 0022s                            20 20 22.00000 North
     n10 0 10.00001                              10  0 10.00001 North
     -0 0 1.00001                                 0  0  1.00001 South
     -10 0 10.00001                              10  0 10.00001 South
     S26 37 48.26371                             26 37 48.26371 South

     Packed : degrees-minutes-seconds ( hDDMMSS.sssss )
     ========
     hDDMMSS.sssss                              Latitude :
     N000000.000                                  0  0  0.00000 North
     N100010.00001                               10  0 10.00001 North
     S263748.26371                               26 37 48.26371 South

     Decimal : degrees ( hDD.dddddddd )
     =========
     hDD.dddddddd                               Latitude :
     20.0                   ( h default = N )    20  0  0.00000 North
     10.002777781                  "             10  0 10.00001 North
     s26.630073253                               26 37 48.26371 South

=======================================================================

Some example longitude inputs are :

     Hemisphere h = (E,e,+   or  blank,W,w,-)
     Commas or blanks may be used between the D,M,S entries.

     Keyed Input :                              Converted longitude :

     Nominal : degrees, minutes & seconds ( hDDD MM SS.sssss )
     =========
     hDDD MM SS.sssss                           Longitude :
     <cr>                   ( h default = W )     0  0  0.00000 West
     0                             "                     "
     0 0 0                         "                     "
     0,0,0.0                       "                     "
     0d 0m 0s                      "                     "
     00d 00m 00.000s               "                     "
     10 0 1.00001                  "             10  0  1.00001 West
     10d 0m 1.00001s               "             10  0  1.00001 West
     -1                                           1  0  0.00000 West
     -0 0 1.00001                                 0  0  1.00001 West
     -10 0 10.00001                              10  0 10.00001 West
     W0                                           0  0  0.00000 West
     W20                                         20  0  0.00000 West
     w20d20m22s                                  20 20 22.00000 West
     w020d  20m 0022s                            20 20 22.00000 West
     w10 0 10.00001                              10  0 10.00001 West
     +0                                           0  0  0.00000 East
     +0 0 0.0                                     0  0  0.00000 East
     +0,0,0.1                                     0  0  0.10000 East
     E26 37 48.26371                             26 37 48.26371 East

     Packed : degrees-minutes-seconds ( hDDDMMSS.sssss )
     ========
     hDDDMMSS.sssss                             Longitude :
     W0000000.000                                 0  0  0.00000 West
     W0100010.00001                              10  0 10.00001 West
     E0263748.26371                              26 37 48.26371 East

     Decimal : degrees ( hDDD.dddddddd )
     =========
     hDDD.dddddddd                              Longitude :
     20.0                   ( h default = W )    20  0  0.00000 West
     10.002777781                  "             10  0 10.00001 West
     -10.002777781                               10  0 10.00001 West
     +10.002777781                               10  0 10.00001 East
     e26.630073253                               26 37 48.26371 East

=======================================================================

=======================================================================
Sample Outputs From Programs INVERSE and FORWARD
=======================================================================

  Ellipsoid : GRS80 / WGS84  (NAD83)
  Equatorial radius,  a   =    6378137.0000
  Polar radius,       b   =    6356752.3141
  Inverse flattening, 1/f =  298.25722210088

  First  Station : Jones
  ----------------
    LAT =  34  0 12.12345 North
    LON = 111  0 12.12345 West

  Second Station : Smith
  ----------------
    LAT =  33 22 11.54321 North
    LON = 112 55 44.33333 West

  Forward azimuth        FAZ = 249  3 16.4237 From North
  Back azimuth           BAZ =  67 59 11.1619 From North
  Ellipsoidal distance     S =    191872.1190 m

=end pod
# tests:
=begin pod

=================================================

  Ellipsoid : Clarke 1866    (NAD27)
  Equatorial radius,  a   =    6378206.4000
  Polar radius,       b   =    6356583.8000
  Inverse flattening, 1/f =  294.97869821380

  First  Station : charlie
  ----------------
    LAT =  45  0 12.00000 North
    LON =  68  0  0.00000 West

  Second Station : sam
  ----------------
    LAT =  44 33  0.00000 North
    LON =  70 12 34.78900 West

  Forward azimuth        FAZ = 254 42 44.6439 From North
  Back azimuth           BAZ =  73  9 21.3315 From North
  Ellipsoidal distance     S =    182009.1679 m

=end pod
# tests:
=begin pod

=================================================

Sample Inputs

FROM : bill
 LAT : 34,00,00.0
 LON : 111 00 00.0
 EHT : 76.0
  dh : -22.0
 FAZ : 245,00,34.7
   S : 123456.7891
  TO : george

Sample Outputs From Program FORWRD3D

  First  Station : bill
  ----------------
  X =   -1896956.7156 m  LAT =  34  0  0.00000 North
  Y =   -4941741.1960 m  LON = 111  0  0.00000 West
  Z =    3546489.0623 m  EHT =        76.0000  Meters

  Second Station : george
  ----------------
  X =   -2011507.3910 m  LAT =  33 31 25.93490 North
  Y =   -4927927.6718 m  LON = 112 12 16.40986 West
  Z =    3502571.6004 m  EHT =        54.0000  Meters

  Forward azimuth        FAZ = 245  0 34.7000 From North
  Back azimuth           BAZ =  64 20 24.6862 From North
  Ellipsoidal distance     S =    123456.7891 m
  Delta height            dh =       -22.0000 m
  Mark-to-mark distance    D =    123456.1224 m

  DX =   -114550.6754 m   DN =    -52153.4448 m
  DY =     13813.5242 m   DE =   -111892.5928 m
  DZ =    -43917.4619 m   DU =     -1216.5690 m

=end pod
# tests:
=begin pod

=================================================

Sample Inputs

FROM : MOUNT WHITNEY, CA
 LAT : 36,34,42.89133
 LON : 118 17 31.18182
 EHT : 4395.832
  TO : BAD WATER (DEATH VALLEY), CA
 LAT : 36 1 37
 LON : 116,49,32
 EHT : -101.868

Sample Output From Programs INVERS3D

  First  Station : MOUNT WHITNEY, CA
  ----------------
  X =   -2432166.7206 m  LAT =  36 34 42.89133 North
  Y =   -4518536.0565 m  LON = 118 17 31.18182 West
  Z =    3782560.2447 m  EHT =      4395.8320  Meters

  Second Station : BAD WATER (DEATH VALLEY), CA
  ----------------
  X =   -2330458.8019 m  LAT =  36  1 37.00000 North
  Y =   -4608415.6501 m  LON = 116 49 32.00000 West
  Z =    3730550.0939 m  EHT =      -101.8680  Meters

  Forward azimuth        FAZ = 114 29 26.9586 From North
  Back azimuth           BAZ = 295 21 32.6566 From North
  Ellipsoidal distance     S =    145239.0603 m
  Delta height            dh =     -4497.7000 m
  Mark-to-mark distance    D =    145354.3872 m

  DX =    101707.9187 m   DN =    -60202.3026 m
  DY =    -89879.5936 m   DE =    132158.0537 m
  DZ =    -52010.1508 m   DU =     -6150.5675 m

  Zenith (mk-to-mk)       ZD =  92 25 30.56
  Apparent zenith distance   =  92 19 55.21

=end pod
# tests:
=begin pod

=================================================

=end pod
