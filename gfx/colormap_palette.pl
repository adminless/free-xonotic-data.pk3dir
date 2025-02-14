use strict;
use warnings;

# Colors:
#   red
#   ORANGE1
#   ORANGE2
#   yellow
#   yellowgreen
#   green
#   cyangreen
#   cyan
#   CYANBLUE1
#   CYANBLUE2
#   blue
#   bluemagenta
#   magenta
#   redmagenta

my @colors = (
	'ffffff', # white
	'ff5500', # orange1
	'00ff80', # cyangreen
	'00ff00', # green
	'ff0000', # red
	'00aaff', # cyanblue1
	'00ffff', # cyan
	'80ff00', # yellowgreen
	'8000ff', # bluemagenta
	'ff00ff', # magenta
	'ff0080', # redmagenta
	'0000ff', # blue
	'ffff00', # yellow
	'0055ff', # cyanblue2
	'ffaa00', # orange2
	'000000' # unused
);

my $value_min = 0x0F;
my $value_max = 0xFF;

my $i = 0;
my $pal_colormap = "";
my $pal_scoreboard = "";
for(@colors)
{
	/^(..)(..)(..)$/ or die "invalid color spec: $_";
	my $r = hex $1;
	my $g = hex $2;
	my $b = hex $3;
	$pal_colormap .= sprintf "%c%c%c", map { int(0.5 + $value_min + ($_ * 1.0 / 0xFF) * ($value_max - $value_min)) } $r, $g, $b;
	printf STDERR "\t\tcase %2d: return '%f %f %f';\n", $i, $r / 0xFF, $g / 0xFF, $b / 0xFF;
	++$i;
}

print "$pal_colormap$pal_colormap$pal_colormap$pal_colormap";
