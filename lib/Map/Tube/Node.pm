package Map::Tube::Node;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Map::Tube::Node - Defines the node for Map::Tube!

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

Readonly my $BAKERLOO => { 'Harrow & Wealdstone' => 'B1',
                           'Kenton'              => 'B2',
						   'South Kenton'        => 'B3',
						   'North Wembley'       => 'B4',
						   'Wembley Central'     => 'B5',
						   'Stonebridge Park'    => 'B6',
						   'Harlesden'           => 'B7',
						   'Willesdon Junction'  => 'B8',
						   'Kensal Green'        => 'B9',
						   q{Queen's Park}       => 'B10',
						   'Kilburn Park'        => 'B11',
						   'Maida Vale'          => 'B12',
						   'Warwick Avenue'      => 'B13',
						   'Paddington'          => 'B14',
						   'Edgware Road'        => 'B15',
						   'Marleybone'          => 'B16',
						   'Baker Street'        => 'BS1',  # Special case
						   q{Regent's Park}      => 'B18',
						   'Oxford Circus'       => 'OX1',
						   'Piccadilly Circus'   => 'B20',
						   'Charing Cross'       => 'B21',
						   'Embankment'          => 'B22',
						   'Waterloo'            => 'B23',
						   'Lambeth North'       => 'B24',
						   'Elephant & Castle'   => 'B25' };
						   
Readonly my $CENTRAL => { 'West Ruislip'           => 'C1',
						  'Ruislip Gardens'        => 'C2',
						  'South Ruislip'          => 'C3',
						  'Northolt'               => 'C4',
						  'Greenford'              => 'C5',
						  'Perivale'               => 'C6',
						  'Hanger Lane'            => 'C7',
						  'North Acton'            => 'NA1', # Special case
						  'Ealing Broadway'        => 'C9',
						  'West Acton'             => 'C10',
						  'East Acton'             => 'C11',
						  'White City'             => 'C12',
						  q{Shepherd's Bush}       => 'C13',
						  'Holland Park'           => 'C14',
						  'Notting Hill Gate'      => 'C15',
						  'Queensway'              => 'C16',
						  'Lancaster Gate'         => 'C17',
						  'Marble Arch'            => 'C18',
						  'Bond Street'            => 'BO1', # Special case
						  'Oxfod Circus'           => 'OX1', # Special case
						  'Tottenham Court Road'   => 'C21',
						  'Holborn'                => 'C22',
						  'Chancery Lane'          => 'C23',
						  q{St. Paul's}            => 'C24',
						  'Bank'                   => 'C25',
						  'Moorgate'               => 'C26',
						  'Liverpool Street'       => 'C27',
						  'Shoreditch High Street' => 'C28',
						  'Bethnal Green'          => 'C29',
						  'Mile End'               => 'C30',
						  'Stratford'              => 'C31',
						  'Leyton'                 => 'C32',
						  'Leytonstone'            => 'LE1', # Special case
						  'Wanstead'               => 'C34',
						  'Redbridge'              => 'C35',
						  'Gants Hill'             => 'C36',
						  'Newbury Park'           => 'C37',
						  'Barkingside'            => 'C38',
						  'Fairlop'                => 'C39',
						  'Hainault'               => 'C39',
						  'Grange Hill'            => 'C40',
						  'Roding Valley'          => 'C41',
						  'Snaresbrook'            => 'C42',
						  'South Woodford'         => 'C43',
						  'Woodford'               => 'C44',
						  'Buckhurst Hill'         => 'BH1', # Special case
						  'Loughton'               => 'C46',
						  'Debden'                 => 'C47',
						  'Theydon Bois'           => 'C48',
						  'Epping'                 => 'C49' };
						   
Readonly my $JUBILEE => { 'Stanmore'         => 'J1',
					      'Canons Park'      => 'J2',
						  'Queensbury'       => 'J3',
						  'Kingsbury'        => 'J4',
						  'Wembley Park'     => 'J5',
						  'Neasden'          => 'J6',
						  'Dollis Hill'      => 'J7',
						  'Willesden Green'  => 'J8',
						  'Kilburn'          => 'J9',
						  'West Hampstead'   => 'J10',
						  'Finchley Road'    => 'J11',
						  'Swiss Cottage'    => 'J12',
						  q{St. John's Wood} => 'J13',
						  'Baker Street'     => 'BS1',
						  'Bond Street'      => 'BO1',
						  'Green Park'       => 'GP1',
						  'Westminster'      => 'J17',
						  'Waterloo'         => 'J18',
						  'Southwark'        => 'J19',
						  'London Bridge'    => 'J20',
						  'Bermondsey'       => 'J21',
						  'Canada Water'     => 'J22',
						  'Canary Wharf'     => 'J23',
						  'North Greenwich'  => 'J24',
						  'Canning Town'     => 'J25',
						  'West Ham'         => 'J26',
						  'Stratford'        => 'J27' };

Readonly my $VICTORIA => { 'Brixton'                   => 'V1',
						   'Stockwell'                 => 'V2',
						   'Vauxhall'                  => 'V3',
						   'Pimlico'                   => 'V4',
						   'Victoria'                  => 'V5',
						   'Green Park'                => 'GP1',  # Special case
						   'Oxford Circus'             => 'OX1',  # Special case
						   'Warren Street'             => 'V8',
						   'Euston'                    => 'V9',
						   q{King's Cross St. Pancras} => 'V10',
						   'Highbury & Islington'      => 'V11',
						   'Finsbury Park'             => 'V12',
						   'Seven Sisters'             => 'V13',
						   'Tottenham Hale'            => 'V14',
						   'Blackhose Road'            => 'V15',
						   'Walthamstow Central'       => 'V16' };

=head1 SYNOPSIS

Here is sample map

    1 ----- 2 
  /  \    /   \
 /    \  /     \
0 ----  6 ----- 3
\     /   \    /
 \   /     \  /
   5  ---- 4 /
  /
 /
7
 \
  \
   8 
   
which can be defined as below:

{ 0 => [1,5,6],
  1 => [0,2,6],
  2 => [1,3,6],
  3 => [2,4,6],
  4 => [3,5,6],
  5 => [0,4,6,7],
  6 => [0,1,2,3,4,5],
  7 => [5,8],
  8 => [7],};

=cut

=head1 SUBROUTINES/METHODS

=head2 init()

=cut

sub init {
	my $node = {
		## BAKERLOO
		'B1'  => ['B2'],
		'B2'  => ['B1','B3'],
		'B3'  => ['B2','B4'],
		'B4'  => ['B3','B5'],
		'B5'  => ['B4','B6'],
		'B6'  => ['B5','B7'],
		'B7'  => ['B6','B8'],
		'B8'  => ['B7','B9'],
		'B9'  => ['B8','B10'],
		'B10' => ['B9','B11'],
		'B11' => ['B10','B12'],
		'B12' => ['B11','B13'],
		'B13' => ['B12','B14'],
		'B14' => ['B13','B15'],
		'B15' => ['B14','B16'],
		'B16' => ['BS1','B15'],
		'B18' => ['BS1','OX1'],
		'B20' => ['OX1','B21'],
		'B21' => ['B20','B22'],
		'B22' => ['B21','B23'],		
		'B23' => ['B22','B24'],
		'B24' => ['B23','B25'],		
		'B25' => ['B24'],		
	
		## CENTRAL
		'C1'  => ['C2'],
		'C2'  => ['C1','C3'],
		'C3'  => ['C2','C4'],
		'C4'  => ['C3','C5'],
		'C5'  => ['C4','C6'],
		'C6'  => ['C5','C7'],
		'C7'  => ['C6','NA1'],
		'C9'  => ['NA1','C10'],
		'C10' => ['C9','C11'],
		'C11' => ['C10','C12'],
		'C12' => ['C11','C13'],
		'C13' => ['C12','C14'],
		'C14' => ['C13','C15'],
		'C15' => ['C14','C16'],
		'C16' => ['C15','C17'],
		'C17' => ['C16','C18'],
		'C18' => ['C17','BO1'],
		'C21' => ['OX1','C22'],
		'C22' => ['C21','C23'],
		'C23' => ['C22','C24'],
		'C24' => ['C23','C25'],
		'C25' => ['C24','C26'],
		'C26' => ['C25','C27'],
		'C27' => ['C26','C28'],
		'C28' => ['C27','C29'],
		'C29' => ['C28','C30'],
		'C30' => ['C29','C31'],
		'C31' => ['C30','C32'],
		'C32' => ['C31','LE1'],
		'C34' => ['LE1','C35'],
		'C35' => ['C34','C36'],
		'C36' => ['C35','C37'],
		'C37' => ['C36','C38'],
		'C38' => ['C37','C39'],
		'C39' => ['C38','C40'],
		'C40' => ['C39','C41'],
		'C41' => ['C40','BH1'],
		'C42' => ['LE1','C43'],
		'C43' => ['C43','C44'],
		'C44' => ['BH1','C43'],
		'C46' => ['BH1','C47'],
		'C47' => ['C46','C48'],
		'C48' => ['C47','C49'],
		'C49' => ['C48'],
		
		## JUBILEE
		'J1'  => ['J2'],
		'J2'  => ['J1','J3'],
		'J3'  => ['J2','J4'],
		'J4'  => ['J3','J5'],
		'J5'  => ['J4','J6'],
		'J6'  => ['J5','J7'],
		'J7'  => ['J6','J8'],
		'J8'  => ['J7','J9'],
		'J9'  => ['J8','J10'],
		'J10' => ['J9','J11'],
		'J11' => ['J10','J12'],
		'J12' => ['J11','J13'],
		'J13' => ['J12','J14'],
		'J14' => ['J13','BO1'],
		'J17' => ['GP1','J18'],
		'J18' => ['J17','J19'],
		'J19' => ['J18','J20'],
		'J20' => ['J19','J21'],
		'J21' => ['J20','J22'],
		'J22' => ['J21','J23'],
		'J23' => ['J22','J24'],
		'J24' => ['J23','J25'],
		'J25' => ['J24','J26'],
		'J26' => ['J25','J27'],
		'J27' => ['J26'],
		
		# VICTORIA
		'V1'  => ['V2'],
		'V2'  => ['V1','V3'],
		'V3'  => ['V2','V4'],
		'V4'  => ['V3','V5'],
		'V5'  => ['V4','GP1'],
		'V8'  => ['OX1','V9'],
		'V9'  => ['V8','V10'],
		'V10' => ['V9','V11'],
		'V11' => ['V10','V12'],
		'V12' => ['V11','V13'],
		'V13' => ['V12','V14'],
		'V14' => ['V13','V15'],
		'V15' => ['V14','V16'],
		'V16' => ['V15','V17'],
		'V17' => ['V16'],
		
		## Special case
		'BS1' => ['BO1','B18','B16'],		
		'GP1' => ['V5','OX1','BO1','J17'],		
		'BO1' => ['GP1','BS1','OX1','C18'],
		'OX1' => ['V6','V8','BO1','B18','B20','C21'],
		'NA1' => ['C7','C10','C11'],
		'LE1' => ['C32','C34','C42'],
		'BH1' => ['C41','C44'],
	};
	return $node;
}

=head2 _load_element()

=cut

sub load_element
{
	return {%{$BAKERLOO}, %{$CENTRAL}, %{$VICTORIA}, %{$JUBILEE}};
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Map-Tube>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Map::Tube::Node

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Map-Tube>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Map-Tube>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Map-Tube>

=item * Search CPAN

L<http://search.cpan.org/dist/Map-Tube/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Mohammad S Anwar.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Map::Tube::Node
