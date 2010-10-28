package Map::Tube::Node;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Map::Tube::Node - Defines the node for Map::Tube

=head1 VERSION

Version 0.06

=cut

our $VERSION = '0.06';

Readonly my $BAKERLOO => { 
	'Harrow & Wealdstone' => 'B1',
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
	'Elephant & Castle'   => 'B25' 
};
						   
Readonly my $CENTRAL => { 
	'West Ruislip'           => 'C1',
	'Ruislip Gardens'        => 'C2',
	'South Ruislip'          => 'C3',
	'Northolt'               => 'C4',
	'Greenford'              => 'C5',
	'Perivale'               => 'C6',
	'Hanger Lane'            => 'C7',
	'North Acton'            => 'NAC', # Special case
	'Ealing Broadway'        => 'EBW', # Special case
	'West Acton'             => 'C10',
	'East Acton'             => 'C11',
	'White City'             => 'WTC', # Special case
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
	'Bethnal Green'          => 'C29',
	'Mile End'               => 'MEN', # Special case
	'Stratford'              => 'C31',
	'Leyton'                 => 'C32',
	'Leytonstone'            => 'LES', # Special case
	'Wanstead'               => 'C34',
	'Redbridge'              => 'C35',
	'Gants Hill'             => 'C36',
	'Newbury Park'           => 'C37',
	'Barkingside'            => 'C38',
	'Fairlop'                => 'C39',
	'Hainault'               => 'C40',
	'Grange Hill'            => 'C41',
	'Chigwell'               => 'C42',
	'Roding Valley'          => 'C43',
	'Snaresbrook'            => 'C44',
	'South Woodford'         => 'C45',
	'Woodford'               => 'C46',
	'Buckhurst Hill'         => 'BHH', # Special case
	'Loughton'               => 'C48',
	'Debden'                 => 'C49',
	'Theydon Bois'           => 'C50',
	'Epping'                 => 'C51' 
};
				  			  
Readonly my $CIRCLE => { 
	'Edgware Road'              => 'EDG', # Special case
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

Readonly my $DISTRICT => {
	'Edgware Road'              => 'EDG', # Special case
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
	'Aldgate East'              => 'AGE', # Special case
	'Whitechapel'               => 'WCH', # Special case
	'Stepney Green'             => 'SGN', # Special case
	'Mile End'                  => 'MEN', # Special case
	'Bow Road'                  => 'BRD', # Special case
	'Bromley-by-Bow'            => 'BBB', # Special case
	'West Ham'                  => 'WHM', # Special case
	'Plaistow'                  => 'PST', # Special case
	'Upton Park'                => 'UPK', # Special case
	'East Ham'                  => 'EHM', # Special case
	'Barking'                   => 'BKG', # Special case
    'Upney'                     => 'D29',
    'Becontree'                 => 'D30',
    'Dagenham Heathway'         => 'D31',
	'Dagenham East'             => 'D32',
	'Elm Park'                  => 'D33',
	'Hornchurch'                => 'D34',
	'Upminster Bridge'          => 'D35',
	'Upminster'                 => 'D36',
	q{Earl's Court}             => 'ECT', # Special case
	'West Kensington'           => 'D38',
	'Barons Court'              => 'BCT', # Special case
	'Hammersmith'               => 'HSM', # Special case
	'Ravenscourt Park'          => 'D41',
	'Stamford Brook'            => 'D42',
    'Turnham Green'             => 'TGN', # Special case
	'Chiswick Park'             => 'D44',
	'Acton Town'                => 'ACT', # Special case
	'Ealing Common'             => 'ECM', # Special case
	'Ealing Broadway'           => 'EBW', # Special case
	'Gunnersbury'               => 'GBY', # Special case
	'Kew Gardens'               => 'KGN', # Special case
	'Richmond'                  => 'RCH', # Special case
	'West Brompton'             => 'WBM', # Special case
	'Fulham Broadway'           => 'D52',
	'Parsons Green'             => 'D53',
	'Putney Bridge'             => 'D54',
	'East Putney'               => 'D55',
	'Southfields'               => 'D56',
	'Wimbledon Park'            => 'D57',
	'Wimbledon'                 => 'D58',
	'Kensington (Olympia)'      => 'KSG' # Special case
};
						 
Readonly my $HAMMERSMITHANDCITY => { 
	'Barking'                   => 'BKG', # Special case
	'East Ham'                  => 'EHM', # Special case
	'Plaistow'                  => 'PST', # Special case
	'West Ham'                  => 'WHM', # Special case
	'Bromley-by-Bow'            => 'BBB', # Special case
	'Bow Road'                  => 'BRD', # Special case
	'Mile End'                  => 'MEN', # Special case
	'Stepney Green'             => 'SGN', # Special case
	'Whitechapel'               => 'WCH', # Special case
	'Aldgate East'              => 'AGE', # Special case
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
						   
Readonly my $JUBILEE => { 
	'Stanmore'         => 'J1',
	'Canons Park'      => 'J2',
	'Queensbury'       => 'J3',
	'Kingsbury'        => 'J4',
	'Wembley Park'     => 'WMB',
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
	'West Ham'         => 'WHM', # Special case
	'Stratford'        => 'J27' 
};

Readonly my $VICTORIA => { 
	'Brixton'                   => 'V1',
	'Stockwell'                 => 'V2',
	'Vauxhall'                  => 'V3',
	'Pimlico'                   => 'V4',
	'Victoria'                  => 'VCT',
	'Green Park'                => 'GPK', # Special case
	'Oxford Circus'             => 'OXC', # Special case
	'Warren Street'             => 'V8',
	'Euston'                    => 'V9',
	q{King's Cross St. Pancras} => 'KCS', # Special case
	'Highbury & Islington'      => 'V11',
	'Finsbury Park'             => 'V12',
	'Seven Sisters'             => 'V13',
	'Tottenham Hale'            => 'V14',
	'Blackhose Road'            => 'V15',
	'Walthamstow Central'       => 'V16' 
};

=head1 SYNOPSIS

Here is sample map

    1 --------  2 
   /  \       /  \
  /    \     /    \
 /      \   /      \
0 ------  6 ------- 3
 \      /   \      /
  \    /     \    /
   \  /       \  / 
    5 -------- 4 
   /
  /
 /  
7
 \
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

=head1 METHODS

=head2 init()

This is the core method of the module, where we actually define the relationship among the diffrerent nodes. I have taken extra care to depict the relationship. 
However I would be more than happy to receieve any suggestion to improve the logic.
Please note "Transport for London" is the owner of the data used here. 

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
		'C10' => ['EBW','C11'],
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
		'C27' => ['C26','C29'],
		'C29' => ['C27','MEN'],
		'C31' => ['MEN','C32'],
		'C32' => ['C31','LES'],
		'C34' => ['LES','C35'],
		'C35' => ['C34','C36'],
		'C36' => ['C35','C37'],
		'C37' => ['C36','C38'],
		'C38' => ['C37','C39'],
		'C39' => ['C38','C40'],
		'C40' => ['C39','C41'],
		'C41' => ['C40','C42'],
		'C42' => ['C41','C43'],
		'C43' => ['C42','BHH'],
		'C44' => ['LES','C45'],
		'C45' => ['C44','C46'],
		'C46' => ['BHH','C45'],
		'C48' => ['BHH','C49'],
		'C49' => ['C48','C50'],
		'C50' => ['C49','C51'],
		'C51' => ['C50'],
		
		## CIRCLE / HAMMERSMITHANDCITY
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
		'AGT' => ['LST','THL'],
		'MMT' => ['THL','CNS'],
		'CNS' => ['MMT','MSH'],
		'MSH' => ['CNS','BLF'],
		'BLF' => ['TMP','MSH'],
		'TMP' => ['BLF','EBK'],
		'EBK' => ['WMN','TMP'],
		'SJP' => ['WMN','VCT'],
		'SLQ' => ['VCT','SKN'],
		'SKN' => ['SLQ','GLS'],
		'HSK' => ['GLS','NHG'],
		'BYW' => ['NHG','EDG'],
		
		## DISTRICT / HAMMERSMITHANDCITY
        'D36' => ['D35'],
		'D35' => ['D34','D36'],
        'D34' => ['D33','D35'],
        'D33' => ['D32','D34'],
        'D32' => ['D31','D33'],
        'D31' => ['D30','D32'],
        'D30' => ['D29','D31'],
        'D29' => ['BKG','D30'],
		'BKG' => ['EHM','D29'],
		'EHM' => ['UPK','BKG'],
		'UPK' => ['PST','EHM'],
		'PST' => ['WHM','UPK'],
		'BBB' => ['WHM','BRD'],
		'BRD' => ['MEN','BBB'],
		'SGN' => ['WCH','MEN'],
		'WCH' => ['AGE','SGN'],
  		'D38' => ['ECT','BCT'],
		'BCT' => ['HSM','D38'],
		'D41' => ['HSM','D42'],
		'D42' => ['TGN','D41'],
		'D44' => ['TGN','ACT'],
		'ECM' => ['EBW','ACT'],
		'GBY' => ['TGN','KGN'],
		'KGN' => ['GBY','RCH'],
		'RCH' => ['KGN'],
		
		## JUBILEE
		'J1'  => ['J2'],
		'J2'  => ['J1','J3'],
		'J3'  => ['J2','J4'],
		'J4'  => ['J3','WMB'],
		'J6'  => ['WMB','J7'],
		'J7'  => ['J6','J8'],
		'J8'  => ['J7','J9'],
		'J9'  => ['J8','J10'],
		'J10' => ['J9','J11'],
		'J11' => ['J10','J12'],
		'J12' => ['J11','J13'],
		'J13' => ['J12','BST'],
		'J18' => ['WMN','J19'],
		'J19' => ['J18','J20'],
		'J20' => ['J19','J21'],
		'J21' => ['J20','J22'],
		'J22' => ['J21','J23'],
		'J23' => ['J22','J24'],
		'J24' => ['J23','J25'],
		'J25' => ['J24','WHM'],
		'J27' => ['WHM'],
		
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
		'BST' => ['BOS','B18','B16','GPS','J13','EDG'],		
		'GPK' => ['VCT','OXC','BOS','WMN'],		
		'BOS' => ['GPK','BST','OXC','C18'],
		'OXC' => ['V6','V8','BOS','B18','B20','C21'],
		'NAC' => ['C7','C10','C11'],
		'LES' => ['C32','C34','C44'],						  
		'BHH' => ['C43','C46'],				
		'NHG' => ['C14','C16','R2','R4'],
		'VCT' => ['V4','GPK','R7','SJP'],
		'WMN' => ['SJP','GPK','J18','EBK'],
		'PDG' => ['B13','EDG','RYL'],
		'WTC' => ['C11','C13','LTR','WDL','C13'],
		'EDG' => ['PDG','B16','BST'],
		'KCS' => ['V9','V11','EUS','FRG'],		
		'MEN' => ['C29','C31','SGN','BRD'],		
		'WHM' => ['J25','J27','BBB','PST'],		
		'HSM' => ['GHR','BCT','D41'],
		'EBW' => ['ECM','C10'],		
		'AGE' => ['LST','THL'],
		'LST' => ['MGT','AGT','AGE'],
		'THL' => ['AGT','AGE','MMT'],
		'GLS' => ['SKN','HSK','ECT'],
		'ECT' => ['KSG','HSK','SKN','WBM'],
		'TGN' => ['D42','D44','GBY'],
		'ACT' => ['D44','ECM'],
		'WMB' => ['J4','J6'],	
	};
	return $node;
}

=head2 load_element()

This loads all the nodes defined. Currently covers only Bakerloo, Central, Circle, District, Hammersmith & City, Jubilee and Victoria. 
I have been working hard to cover all the remaining (Metropolitan, Northern, Picadilly and Waterloo & City). 
Please note this is still a very experimental in nature.

=cut

sub load_element
{
	return {%{$BAKERLOO}, %{$CENTRAL}, %{$CIRCLE}, %{$DISTRICT}, %{$HAMMERSMITHANDCITY}, %{$VICTORIA}, %{$JUBILEE}};
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar@yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube@rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Map-Tube>. 
I will be notified, and then you'll automatically be notified of progress on your 
bug as I make changes.

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
