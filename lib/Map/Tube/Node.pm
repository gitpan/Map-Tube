package Map::Tube::Node;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Map::Tube::Node - Defines the node for Map::Tube

=head1 VERSION

Version 0.09

=cut

our $VERSION = '0.09';

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
    'Piccadilly Circus'   => 'PCS', # Special case
    'Charing Cross'       => 'CRS', # Special case
    'Embankment'          => 'EBK', # Special case
    'Waterloo'            => 'WLO', # Special case
    'Lambeth North'       => 'B24',
    'Elephant & Castle'   => 'EAC'  # Special case
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
    'Oxford Circus'          => 'OXC', # Special case
    'Tottenham Court Road'   => 'TCR', # Special case
    'Holborn'                => 'HBN',
    'Chancery Lane'          => 'C23',
    q{St. Paul's}            => 'C24',
    'Bank'                   => 'BNK', # Special case
    'Moorgate'               => 'MGT', # Special case
    'Liverpool Street'       => 'LST', # Special case
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
    q{King's Cross St. Pancras} => 'KCS', # Special case
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
    q{King's Cross St. Pancras} => 'KCS', # Special case
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
    'Wembley Park'     => 'WMB', # Special case
    'Neasden'          => 'J6',
    'Dollis Hill'      => 'J7',
    'Willesden Green'  => 'J8',
    'Kilburn'          => 'J9',
    'West Hampstead'   => 'J10',
    'Finchley Road'    => 'FNR', # Special case
    'Swiss Cottage'    => 'J12',
    q{St. John's Wood} => 'J13',
    'Baker Street'     => 'BST', # Special case
    'Bond Street'      => 'BOS', # Special case
    'Green Park'       => 'GPK', # Special case
    'Westminster'      => 'WMN', # Special case
    'Waterloo'         => 'WLO', # Special case
    'Southwark'        => 'J19',
    'London Bridge'    => 'LON', # Special case
    'Bermondsey'       => 'J21',
    'Canada Water'     => 'J22',
    'Canary Wharf'     => 'J23',
    'North Greenwich'  => 'J24',
    'Canning Town'     => 'J25',
    'West Ham'         => 'WHM', # Special case
    'Stratford'        => 'J27'
};

Readonly my $METROPOLITAN => {
    'Aldgate'                   => 'AGT', # Special case
    'Liverpool Street'          => 'LST', # Speical case
    'Moorgate'                  => 'MGT', # Special case
    'Barbican'                  => 'BBC', # Special case
    'Farringdon'                => 'FRG', # Special case
    q{King's Cross St. Pancras} => 'KCS', # Special case
    'Euston Square'             => 'ESQ', # Special case
    'Great Portland Street'     => 'GPS', # Special case
    'Baker Street'              => 'BST', # Special case
    'Finchley Road'             => 'FNR', # Special case
    'Wembley Park'              => 'WMB', # Special case
    'Preston Road'              => 'M12',
    'Norhtwick Park'            => 'M13',
    'Harrow-on-the-Hill'        => 'HOH', # Special case
    'West Harrow'               => 'M15',
    'Rayners Lane'              => 'RAL', # Special case
    'Eastcote'                  => 'ETC',
    'Ruislip Manor'             => 'RSM',
    'Ruislip'                   => 'RSP',
    'Ickenham'                  => 'IKH',
    'Hillingdon'                => 'HGD',
    'Uxbridge'                  => 'UXB',
    'North Harrow'              => 'M23',
    'Pinner'                    => 'M24',
    'Northwood Hills'           => 'M25',
    'Northwood'                 => 'M26',
    'Moor Park'                 => 'MPK', # Special case
    'Croxley'                   => 'M28',
    'Watford'                   => 'M29',
    'Rickmansworth'             => 'M30',
    'Chorleywood'               => 'M31',
    'Chalfont & Latimer'        => 'CAL', # Special case
    'Chesham'                   => 'M33',
    'Amersham'                  => 'M34'
};

Readonly my $NORTHERN => {
    'Edgware'                => 'N1',
    'Burnt Oak'              => 'N2',
    'Collindale'             => 'N3',
    'Hendon Central'         => 'N4',
    'Brent Cross'            => 'N5',
    'Hampstead'              => 'N6',
    'Belsize Park'           => 'N7',
    'Chalk Farm'             => 'N8',
    'Camden Town'            => 'CAT',
    'Kentish Town'           => 'N10',
    'Tufnell Park'           => 'N11',
    'Archway'                => 'N12',
    'Highgate'               => 'N13',
    'East Finchley'          => 'N14',
    'Finchley Central'       => 'FCC',
    'Mill Hill East'         => 'N16',
    'West Finchley'          => 'N17',
    'Woodside Park'          => 'N18',
    'Totteridge & Whetstone' => 'N19',
    'High Barnet'            => 'N20',
    'Momington Crescent'     => 'N21',
    'Euston'                 => 'EUS',
    'Warren Street'          => 'WST',
    'Goodge Street'          => 'N24',
    'Tottenham Court Road'   => 'TCR',
    'Leicester Square'       => 'LSQ',
    'Charing Cross'          => 'CRS',
    'Embankment'             => 'EBK',
    'Waterloo'               => 'WLO',
    'Kennington'             => 'KNG',
    'Oval'                   => 'N31',
    'Stockwell'              => 'STW',
    'Clapham North'          => 'N33',
    'Clapham Common'         => 'N34',
    'Clapham South'          => 'N35',
    'Balham'                 => 'N36',
    'Tooting Bec'            => 'N37',
    'Tooting Broadway'       => 'N38',
    'Collers Wood'           => 'N39',
    'South Wimbledon'        => 'N40',
    'Morden'                 => 'N41',
    'Elephant & Castle'      => 'EAC',
    'Borough'                => 'N42',
    'London Bridge'          => 'LON',
    'Bank'                   => 'BNK',
    'Moorgate'               => 'MGT',
    'Old Street'             => 'N46',
    'Angel'                  => 'N47',
    q{King's Cross St. Pancras} => 'KCS'
};

Readonly my $PICCADILLY => {
    'Uxbridge'                  => 'UXB', # Special case
    'Hillingdon'                => 'HGD', # Special case
    'Ruislip Manor'             => 'RSM', # Special case
    'Ickenham'                  => 'IKH', # Special case
    'Ruislip'                   => 'RSP', # Special case
    'Eastcote'                  => 'ETC', # Special case
    'Rayners Lane'              => 'RAL', # Special case
	'South Harrow'              => 'P8',
	'Sudbury Hill'              => 'P9',
	'Sudbury Town'              => 'P10',
	'Alperton'                  => 'P11',
	'Park Royal'                => 'P12',
	'North Ealing'              => 'P13',
    'Ealing Common'             => 'ECM', # Special case
    'Acton Town'                => 'ACT', # Special case
    'Turnham Green'             => 'TGN', # Special case
    'Hammersmith'               => 'HSM', # Special case
    'Barons Court'              => 'BCT', # Special case
    q{Earl's Court}             => 'ECT', # Special case
    'Gloucester Road',          => 'GLS', # Special case
    'South Kensington'          => 'SKN', # Special case
	'Knightsbridge'             => 'P22',
	'Hyde Park Corner'          => 'P23',
	'Green Park'                => 'GPK', # Special case
	'Piccadilly Circus'         => 'PCS', # Special case
	'Leicester Square'          => 'LSQ',
	'Covent Garden'             => 'P27',
	'Holborn'                   => 'HBN',
	'Russel Square'             => 'P29',
	q{King's Cross St. Pancras} => 'KCS', # Special case
	'Caledonian Road'           => 'P31',
	'Holloway Road'             => 'P32',
	'Arsenal'                   => 'P33',
	'Finsbury Park'             => 'FBP',
	'Manor House'               => 'P35',
	'Turnpike Lane'             => 'P36',
	'Wood Green'                => 'P37',
	'Bounds Green'              => 'P38',
	'Arnos Grove'               => 'P39',
	'Southgate'                 => 'P40',
	'Oakwood'                   => 'P41',
	'Cockfosters'               => 'P42',
	'South Ealing'              => 'P43',
    'Northfields'               => 'P44',
	'Boston Manor'              => 'P45',
	'Osterley'                  => 'P46',
	'Hounslow East'             => 'P47',
	'Hounslow Central'          => 'P48',
	'Hounslow West'             => 'P49',
	'Hatton Cross'              => 'P50',
	'Heathrow Terminal 4'       => 'P51',
	'Heathrow Terminal 1,2,3'   => 'P52',
	'Heathrow Terminal 5'       => 'P53'
};

Readonly my $VICTORIA => {
    'Brixton'                   => 'V1',
    'Stockwell'                 => 'STW',
    'Vauxhall'                  => 'V3',
    'Pimlico'                   => 'V4',
    'Victoria'                  => 'VCT', # Special case
    'Green Park'                => 'GPK', # Special case
    'Oxford Circus'             => 'OXC', # Special case
    'Warren Street'             => 'WST', # Special case
    'Euston'                    => 'V9',
    q{King's Cross St. Pancras} => 'KCS', # Special case
    'Highbury & Islington'      => 'V11',
    'Finsbury Park'             => 'FBP',
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
        'B24' => ['WLO','EAC'],

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
        'C23' => ['HBN','C24'],
        'C24' => ['C23','BNK'],
        'C29' => ['LST','MEN'],
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
        'AGT' => ['LST','THL'],
        'MMT' => ['THL','CNS'],
        'CNS' => ['MMT','MSH'],
        'MSH' => ['CNS','BLF'],
        'BLF' => ['TMP','MSH'],
        'TMP' => ['BLF','EBK'],
        'EBK' => ['WMN','TMP'],
        'SJP' => ['WMN','VCT'],
        'SLQ' => ['VCT','SKN'],
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
        'J10' => ['J9','FNR'],
        'J12' => ['FNR','J13'],
        'J13' => ['J12','BST'],
        'J19' => ['WLO','LON'],
        'J21' => ['LON','J22'],
        'J22' => ['J21','J23'],
        'J23' => ['J22','J24'],
        'J24' => ['J23','J25'],
        'J25' => ['J24','WHM'],
        'J27' => ['WHM'],

        ## METROPOLITAN
        'M12' => ['FNR','M13'],
        'M15' => ['HOH','RAL'],
        'ETC' => ['RAL','RSM'],
        'RSM' => ['ETC','RSP'],
        'RSP' => ['RSM','IKH'],
        'IKH' => ['RSP','HGD'],
        'HGD' => ['IKH','UXB'],
        'UXB' => ['HGD'],
        'M23' => ['HOH','M24'],
        'M24' => ['M23','M25'],
        'M25' => ['M24','M26'],
        'M26' => ['M25','MPK'],
        'M28' => ['MPK','M29'],
        'M29' => ['M28'],
        'M30' => ['MPK','M31'],
        'M31' => ['M30','CAL'],
        'M33' => ['CAL'],
        'M34' => ['CAL'],

        ## NORTHERN
        'N1'  => ['N2'],
        'N2'  => ['N3','N1'],
        'N3'  => ['N4','N2'],
        'N4'  => ['N5','N3'],
        'N5'  => ['N6','N4'],
        'N6'  => ['N7','N5'],
        'N7'  => ['N8','N6'],
        'N8'  => ['CAT','N7'],
        'N10' => ['CAT','N11'],
        'N11' => ['N10','N12'],
        'N12' => ['N11','N13'],
        'N13' => ['N12','N14'],
        'N14' => ['N13','FCC'],
        'N16' => ['FCC'],
        'N17' => ['FCC','N18'],
        'N18' => ['N17','N19'],
        'N19' => ['N18','N20'],
        'N20' => ['N19'],
        'N21' => ['CAT','EUS'],
        'N24' => ['WST','TCR'],
        'N31' => ['STW','KNG'],
        'N33' => ['STW','N34'],
        'N34' => ['N33','N35'],
        'N35' => ['N34','N36'],
        'N36' => ['N35','N37'],
        'N37' => ['N36','N38'],
        'N38' => ['N37','N39'],
        'N39' => ['N38','N40'],
        'N40' => ['N39','N41'],
        'N41' => ['N40'],
        'N42' => ['EAC','LON'],
        'N46' => ['MGT','N47'],
        'N47' => ['N46','KCS'],

        ## PICCADILLY
	    'P53' => ['P52'],
	    'P52' => ['P53','P50'],
	    'P51' => ['P52'],
	    'P50' => ['P51'],
	    'P49' => ['P50','P48'],
	    'P48' => ['P49','P47'],
	    'P47' => ['P48','P46'],
	    'P46' => ['P47','P45'],
	    'P45' => ['P46','P44'],
	    'P44' => ['P45','P43'],
	    'P43' => ['ACT','P44'],
	    'P42' => ['P41'],
	    'P41' => ['P40','P42'],
	    'P40' => ['P39','P41'],
	    'P39' => ['P38','P40'],
	    'P38' => ['P37','P39'],
	    'P37' => ['P36','P38'],
	    'P36' => ['P35','P37'],
	    'P35' => ['FBP','P36'],
	    'P33' => ['FBP','P32'],
	    'P32' => ['P33','P31'],
	    'P31' => ['P32','KCS'],
	    'P29' => ['KCS','HBN'],
	    'P27' => ['HBN','LSQ'],
	    'P23' => ['GPK','P22'],
	    'P22' => ['P23','SKN'],
		'P13' => ['ECM','P12'],
	    'P12' => ['P13','P11'],
	    'P11' => ['P12','P10'],
	    'P10' => ['P11','P9'],
	    'P9'  => ['P10','P8'],
	    'P8'  => ['RAL','P9'],
 		
        ## VICTORIA
        'V1'  => ['STW'],
        'V3'  => ['STW','V4'],
        'V4'  => ['V3','VCT'],
        'V9'  => ['WST','KCS'],
        'V11' => ['KCS','FBP'],
        'V13' => ['FBP','V14'],
        'V14' => ['V13','V15'],
        'V15' => ['V14','V16'],
        'V16' => ['V15','V17'],
        'V17' => ['V16'],

        ## Special case
        'BST' => ['BOS','B18','B16','GPS','J13','EDG','FNR'],
        'GPK' => ['VCT','OXC','BOS','WMN','LSQ'],
        'BOS' => ['GPK','BST','OXC','C18'],
        'OXC' => ['V6','WST','BOS','B18','PCS','TCR'],
        'NAC' => ['C7','C10','C11'],
        'LES' => ['C32','C34','C44'],
        'BHH' => ['C43','C46'],
        'NHG' => ['C14','C16','R2','R4'],
        'VCT' => ['V4','GPK','R7','SJP'],
        'WMN' => ['SJP','GPK','WLO','EBK','WLO'],
        'PDG' => ['B13','EDG','RYL'],
        'WTC' => ['C11','C13','LTR','WDL','C13'],
        'EDG' => ['PDG','B16','BST'],
        'KCS' => ['V9','V11','EUS','FRG','N47','P29','P31'],
        'MEN' => ['C29','C31','SGN','BRD'],
        'WHM' => ['J25','J27','BBB','PST'],
        'HSM' => ['GHR','BCT','D41','TGN'],
        'EBW' => ['ECM','C10'],
        'AGE' => ['LST','THL'],
        'LST' => ['MGT','AGT','AGE','BNK','C29'],
        'THL' => ['AGT','AGE','MMT'],
        'GLS' => ['SKN','HSK','ECT'],
        'ECT' => ['KSG','HSK','WBM','GLS'],
        'TGN' => ['D42','D44','GBY','HSM','ACT'],
        'ACT' => ['D44','ECM','P43','TGN'],
        'WMB' => ['J4','J6','FNR','M12','HOH'],
        'FNR' => ['J10','J12','BST','WMB'],
        'HOH' => ['M13','WMB','M15','UXB'],
        'RAL' => ['M15','ETC','P8'],
        'MPK' => ['M26','M28','M30'],
        'CAL' => ['M31','M33','M34'],
        'CRS' => ['PCS','EBK','LSQ'],
        'EBK' => ['CRS','WLO','TMP','WMN'],
        'WLO' => ['EBK','B24','WMN','J19'],
        'TCR' => ['OXC','HBN','N24','LSQ'],
        'EAC' => ['B24','KNG','N42'],
        'STW' => ['V1','V3','N31'],
        'LON' => ['J19','J21','N42','BNK'],
        'BNK' => ['C24','LON','MGT','LST'],
        'MGT' => ['LST','BBC','BNK','N46'],
        'CAT' => ['N8','N10','N21','EUS'],
        'FCC' => ['N14','N16','N17'],
        'EUS' => ['WST','N21','KCS'],
        'WST' => ['OXC','V9','EUS','N24'],
        'LSQ' => ['TCR','CRS','PCS'],
        'KNG' => ['WLO','EAC','N31'],
		'HBN' => ['TCR','C23','P27','P29'],
		'FBP' => ['V11','V13','P33','P35'],
		'PCS' => ['OXC','CRS','LSQ','GPK'],
		'SKN' => ['SLQ','GLS','P22'],
		'ECM' => ['ACT','P13','EBW'],
    };
    return $node;
}

=head2 load_element()

This loads all the nodes defined. Currently covers Bakerloo, Central, Circle,
District, Hammersmith & City, Jubilee, Metropolitan, Northern, Piccadilly and Victoria. 
I shall be finishing the last remaining Waterloo & City line very soon. Please note this 
is still a very experimental in nature.

=cut

sub load_element
{
    return {%{$BAKERLOO},
            %{$CENTRAL},
            %{$CIRCLE},
            %{$DISTRICT},
            %{$HAMMERSMITHANDCITY},
            %{$JUBILEE},
            %{$METROPOLITAN},
            %{$NORTHERN},
			%{$PICCADILLY},
            %{$VICTORIA}};
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
