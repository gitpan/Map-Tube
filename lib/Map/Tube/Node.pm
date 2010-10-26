package Map::Tube::Node;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Map::Tube::Node - Defines the node for Map::Tube!

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

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
						   'Paddington'          => 'PDG', # Special case
						   'Edgware Road'        => 'EDG',
						   'Marleybone'          => 'B16',
						   'Baker Street'        => 'BST', # Special case
						   q{Regent's Park}      => 'B18',
						   'Oxford Circus'       => 'OXC', # Special case
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
						  'North Acton'            => 'NAC', # Special case
						  'Ealing Broadway'        => 'C9',
						  'West Acton'             => 'C10',
						  'East Acton'             => 'C11',
						  'White City'             => 'WTC',
						  q{Shepherd's Bush}       => 'C13',
						  'Holland Park'           => 'C14',
						  'Notting Hill Gate'      => 'NHG', # Special case
						  'Queensway'              => 'C16',
						  'Lancaster Gate'         => 'C17',
						  'Marble Arch'            => 'C18',
						  'Bond Street'            => 'BOS', # Special case
						  'Oxfod Circus'           => 'OXC', # Special case
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
						  'Leytonstone'            => 'LES', # Special case
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
						  'Buckhurst Hill'         => 'BHH', # Special case
						  'Loughton'               => 'C46',
						  'Debden'                 => 'C47',
						  'Theydon Bois'           => 'C48',
						  'Epping'                 => 'C49' };
						   
Readonly my $CIRCLE => { 'Edgware Road'              => 'EDG', # Special case
						 'Bayswater'                 => 'BYW', # Special case
						 'Notting Hill Gate'         => 'NHG', # Special case
						 'High Street Kensington'    => 'HSK', # Special case
						 'Gloucester Road',          => 'GLS', # Special case
						 'South Kensington'          => 'SKN', # Special case
						 'Sloane Square'             => 'SLQ', # Special case
						 'Victoria'                  => 'VCT', # Special case
						 q{St. James's Park}         => 'SJP', # Special case
						 'Westminster'               => 'WMN', # Special case
						 'Embankment'                => 'EBK', # Special case
						 'Temple'                    => 'TMP', # Special case
						 'Blackfriars'               => 'BLF', # Special case
						 'Mansion House'             => 'MSH', # Special case
						 'Cannon Street'             => 'CNS', # Special case
						 'Monument'                  => 'MMT', # Special case
						 'Tower Hill'                => 'THL', # Special case
						 'Aldgate'                   => 'AGT', # Special case
						 'Liverpool Street'          => 'LST', # Speical case
						 'Moorgate'                  => 'MGT', # Special case
						 'Barbican'                  => 'BBC', # Special case
						 'Farringdon'                => 'FRG', # Special case
						 q{King's cross St. Pancras} => 'KCS', # Special case
						 'Euston Square'             => 'ESQ', # Special case
						 'Great Portland Street'     => 'GPS', # Special case
						 'Baker Street'              => 'BST', # Special case
						 'Edgware Road'              => 'EDG', # Special case
						 'Paddington'                => 'PDG', # Special case
						 'Royal Oak'                 => 'RYL', # Special case
						 'Westbourne Park'           => 'WBP', # Special case
						 'Ladbroke Grove'            => 'LBG', # Special case
						 'Latimer Road'              => 'LTR', # Special case
						 'White City'                => 'WTC', # Special case
						 'Wood Lane'                 => 'WDL', # Special case
						 q{Shepherd's Bush Market}   => 'SBM', # Special case
						 'Goldhawk Road'             => 'GHR', # Special case
						 'Hammersmith'               => 'HSM'  # Special case 
						};
						   
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
						  'Baker Street'     => 'BST', # Special case
						  'Bond Street'      => 'BOS', # Special case
						  'Green Park'       => 'GPK',
						  'Westminster'      => 'WMN',
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
						   'Victoria'                  => 'VCT',
						   'Green Park'                => 'GPK', # Special case
						   'Oxford Circus'             => 'OXC', # Special case
						   'Warren Street'             => 'V8',
						   'Euston'                    => 'V9',
						   q{King's Cross St. Pancras} => 'KCS',
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
		'B13' => ['B12','PDG'],
		'B16' => ['BST','EDG'],
		'B18' => ['BST','OXC'],
		'B20' => ['OXC','B21'],
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
		'C7'  => ['C6','NAC'],
		'C9'  => ['NAC','C10'],
		'C10' => ['C9','C11'],
		'C11' => ['C10','WTC'],
		'C13' => ['WTC','C14'],
		'C14' => ['C13','NHG'],
		'C16' => ['NHG','C17'],
		'C17' => ['C16','C18'],
		'C18' => ['C17','BOS'],
		'C21' => ['OXC','C22'],
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
		'C32' => ['C31','LES'],
		'C34' => ['LES','C35'],
		'C35' => ['C34','C36'],
		'C36' => ['C35','C37'],
		'C37' => ['C36','C38'],
		'C38' => ['C37','C39'],
		'C39' => ['C38','C40'],
		'C40' => ['C39','C41'],
		'C41' => ['C40','BHH'],
		'C42' => ['LES','C43'],
		'C43' => ['C43','C44'],
		'C44' => ['BHH','C43'],
		'C46' => ['BHH','C47'],
		'C47' => ['C46','C48'],
		'C48' => ['C47','C49'],
		'C49' => ['C48'],
		
		## CIRCLE
		'HSM' => ['GHR'],
		'GHR' => ['HSM','SBM'],
		'SBM' => ['GHR','WDL'],
		'WDL' => ['WTC','SBM'],
		'LTR' => ['WTC','LBG'],
		'LBG' => ['LTR','WBP'],
		'WBP' => ['LBG','RYL'],
		'RYL' => ['WBP','PDG'],
		'GPS' => ['BST','ESQ'],
		'FRG' => ['KCS','BBC'],
		'BBC' => ['FRG','MGT'],
		'MGT' => ['LST','BBC'],
		'LST' => ['MGT','AGT'],
		'AGT' => ['LST','THL'],
		'THL' => ['AGT','MMT'],
		'MMT' => ['THL','CNS'],
		'CNS' => ['MMT','MSH'],
		'MSH' => ['CNS','BLF'],
		'BLF' => ['TMP','MSH'],
		'TMP' => ['BLF','EBK'],
		'SJP' => ['WMN','EBK'],
		'SLQ' => ['VCT','SKN'],
		'SKN' => ['SLQ','GLS'],
		'GLS' => ['SKN','HSK'],
		'HSK' => ['GLS','NHG'],
		'BYW' => ['NHG','EDG'],
		
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
		'J14' => ['J13','BOS'],
		'J18' => ['WMN','J19'],
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
		'V4'  => ['V3','VCT'],
		'V8'  => ['OXC','V9'],
		'V9'  => ['V8','KCS'],
		'V11' => ['KCS','V12'],
		'V12' => ['V11','V13'],
		'V13' => ['V12','V14'],
		'V14' => ['V13','V15'],
		'V15' => ['V14','V16'],
		'V16' => ['V15','V17'],
		'V17' => ['V16'],
		
		## Special case
		'BST' => ['BOS','B18','B16','GPS'],		
		'GPK' => ['VCT','OXC','BOS1','WMN'],		
		'BOS' => ['GPK','BST','OXC','C18'],
		'OXC' => ['V6','V8','BOS','B18','B20','C21'],
		'NAC' => ['C7','C10','C11'],
		'LES' => ['C32','C34','C42'],
		'BHH' => ['C41','C44'],
		'NHG' => ['C14','C16','R2','R4'],
		'VCT' => ['V4','GPK','R7','SJP'],
		'WMN' => ['SJP','GPK','J18','EBK'],
		'PDG' => ['B13','EDG','RYL'],
		'WTC' => ['C11','C13','LTR','WDL','C13'],
		'EDG' => ['PDG','B16'],
		'KCS' => ['V9','V11','EUS','FRG'],		
	};
	return $node;
}

=head2 _load_element()

=cut

sub load_element
{
	return {%{$BAKERLOO}, %{$CENTRAL}, %{$CIRCLE}, %{$VICTORIA}, %{$JUBILEE}};
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
