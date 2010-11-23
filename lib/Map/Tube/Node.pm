package Map::Tube::Node;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Map::Tube::Node - Defines the node for Map::Tube

=head1 VERSION

Version 2.04

=head1 AWARD

Map::Tube has been granted the "Famous Software Award" by Download.FamousWhy.com on Tue 09 Nov 2010.

http://download.famouswhy.com/map_tube/

=cut

our $VERSION = '2.04';

Readonly my $BAKERLOO => {
    'Kilburn Park'        => 'B11',
    'Maida Vale'          => 'B12',
    'Warwick Avenue'      => 'B13',
    'Marleybone'          => 'B16',
    q{Regent's Park}      => 'B18',
    'Lambeth North'       => 'B24',
};

Readonly my $CENTRAL => {
    'West Ruislip'     => 'C01',
    'Ruislip Gardens'  => 'C02',
    'South Ruislip'    => 'C03',
    'Northolt'         => 'C04',
    'Greenford'        => 'C05',
    'Perivale'         => 'C06',
    'Hanger Lane'      => 'C07',
    'West Acton'       => 'C10',
    'East Acton'       => 'C11',
    'Holland Park'     => 'C14',
    'Queensway'        => 'C16',
    'Lancaster Gate'   => 'C17',
    'Marble Arch'      => 'C18',
    'Chancery Lane'    => 'C23',
    q{St. Paul's}      => 'C24',
    'Bethnal Green'    => 'C27',
    'Leyton'           => 'C30',
    'Wanstead'         => 'C32',
    'Redbridge'        => 'C33',
    'Gants Hill'       => 'C34',
    'Newbury Park'     => 'C35',
    'Barkingside'      => 'C36',
    'Fairlop'          => 'C37',
    'Hainault'         => 'C38',
    'Grange Hill'      => 'C39',
    'Chigwell'         => 'C40',
    'Roding Valley'    => 'C41',
    'Snaresbrook'      => 'C42',
    'South Woodford'   => 'C43',
    'Woodford'         => 'C44',
    'Loughton'         => 'C46',
    'Debden'           => 'C47',
    'Theydon Bois'     => 'C48',
    'Epping'           => 'C49'
};

Readonly my $DISTRICT => {
    'Chiswick Park'     => 'D04',
    'Stamford Brook'    => 'D06',
    'Ravenscourt Park'  => 'D07',
    'West Kensington'   => 'D10',
    'Fulham Broadway'   => 'D14',
    'Parsons Green'     => 'D15',
    'Putney Bridge'     => 'D16',
    'East Putney'       => 'D17',
    'Southfields'       => 'D18',
    'Wimbledon Park'    => 'D19',
    'Wimbledon'         => 'D20',
    'Upney'             => 'D48',
    'Becontree'         => 'D49',
    'Dagenham Heathway' => 'D50',
    'Dagenham East'     => 'D51',
    'Elm Park'          => 'D52',
    'Hornchurch'        => 'D53',
    'Upminster Bridge'  => 'D54',
    'Upminster'         => 'D55',
};

Readonly my $DLR => {
    'Woolwich Arsenal'       => 'L01',
    'King George V'          => 'L02',
    'London City Airport'    => 'L03',
    'Pontoon Dock'           => 'L04',
    'West Silvertown'        => 'L05',
    'Royal Victoria'         => 'L07',
    'Custom House for ExCeL' => 'L08',
    'Prince Regent'          => 'L09',
    'Royal Albert'           => 'L10',
    'Beckton Park'           => 'L11',
    'Cyprus'                 => 'L12',
    'Gallons Reach'          => 'L13',
    'Beckton'                => 'L14',
    'East India'             => 'L15',
    'Blackwall'              => 'L16',
    'All Saints'             => 'L18',
    'Langdon Park'           => 'L19',
    'Devons Road'            => 'L20',
    'Bow Church'             => 'L21',
    'Pudding Mill Lane'      => 'L22',
    'West India Quay'        => 'L24',
    'Heron Quays'            => 'L26',
    'South Quay'             => 'L27',
    'Crossharbour'           => 'L28',
    'Mudchute'               => 'L29',
    'Island Gardens'         => 'L30',
    'Cutty Sark for Maritime Greenwich' => 'L31',
    'Greenwich'              => 'L32',
    'Deptford Bridge'        => 'L33',
    'Elverson Road'          => 'L34',
    'Lewisham'               => 'L35',
    'Westferry'              => 'L36',
    'Limehouse'              => 'L37',
    'Tower Gateway'          => 'L39',
};

Readonly my $JUBILEE => {
    'Stanmore'         => 'J01',
    'Canons Park'      => 'J02',
    'Queensbury'       => 'J03',
    'Kingsbury'        => 'J04',
    'Neasden'          => 'J06',
    'Dollis Hill'      => 'J07',
    'Willesden Green'  => 'J08',
    'Kilburn'          => 'J09',
    'West Hampstead'   => 'J10',
    'Swiss Cottage'    => 'J12',
    q{St. John's Wood} => 'J13',
    'Southwark'        => 'J19',
    'Bermondsey'       => 'J21',
    'North Greenwich'  => 'J24',
};

Readonly my $METROPOLITAN => {
    'West Harrow'     => 'M07',
    'North Harrow'    => 'M09',
    'Pinner'          => 'M10',
    'Northwood Hills' => 'M11',
    'Northwood'       => 'M12',
    'Croxley'         => 'M14',
    'Watford'         => 'M15',
    'Rickmansworth'   => 'M16',
    'Chorleywood'     => 'M17',
    'Chesham'         => 'M19',
    'Amersham'        => 'M20',
    'Norhtwick Park'  => 'M21',
    'Preston Road'    => 'M22',
};

Readonly my $NORTHERN => {
    'Edgware'                => 'N01',
    'Burnt Oak'              => 'N02',
    'Collindale'             => 'N03',
    'Hendon Central'         => 'N04',
    'Brent Cross'            => 'N05',
    'Hampstead'              => 'N06',
    'Belsize Park'           => 'N07',
    'Chalk Farm'             => 'N08',
    'Kentish Town'           => 'N10',
    'Tufnell Park'           => 'N11',
    'Archway'                => 'N12',
    'Highgate'               => 'N13',
    'East Finchley'          => 'N14',
    'Mill Hill East'         => 'N16',
    'West Finchley'          => 'N17',
    'Woodside Park'          => 'N18',
    'Totteridge & Whetstone' => 'N19',
    'High Barnet'            => 'N20',
    'Momington Crescent'     => 'N21',
    'Goodge Street'          => 'N24',
    'Oval'                   => 'N31',
    'Clapham North'          => 'N33',
    'Clapham Common'         => 'N34',
    'Clapham South'          => 'N35',
    'Balham'                 => 'N36',
    'Tooting Bec'            => 'N37',
    'Tooting Broadway'       => 'N38',
    'Collers Wood'           => 'N39',
    'South Wimbledon'        => 'N40',
    'Morden'                 => 'N41',
    'Borough'                => 'N42',
    'Old Street'             => 'N46',
    'Angel'                  => 'N47',
};

Readonly my $OVERGROUND => {
    'West Croydon'                => 'O01',
    'Norwood Junction'            => 'O02',
    'Anerly'                      => 'O03',
    'Crystal Palace'              => 'O05',
    'Forest Hill'                 => 'O07',
    'Honor Oak Park'              => 'O08',
    'Brockley'                    => 'O09',
    'New Cross Gate'              => 'O10',
    'New Cross'                   => 'O12',
    'Rotherhithe'                 => 'O14',
    'Wapping'                     => 'O15',
    'Shoreditch High Steet'       => 'O18',
    'Hoxton'                      => 'O19',
    'Haggerston'                  => 'O20',
    'Dalston Junction'            => 'O21',
    'Hackney Central'             => 'O23',
    'Homerton'                    => 'O24',
    'Hackney Wick'                => 'O25',
    'Canonbury'                   => 'O27',
    'Caledonian Road & Barnsbury' => 'O29',
    'Camden Road'                 => 'O30',
    'Kentish Town West'           => 'O31',
    'Upper Holloway'              => 'O33',
    'Crouch Hill'                 => 'O34',
    'Haringay Green Lanes'        => 'O35',
    'South Tottenham'             => 'O36',
    q{Walthamstow Queen's Road}   => 'O38',
    'Leyton Midland Road'         => 'O39',
    'Wanstead Park'               => 'O40',
    'Woodgrange Park'             => 'O41',
    'Hamstead Heath'              => 'O43',
    'Finchley Road & Frognal'     => 'O44',
    'Brondesbury'                 => 'O45',
    'Kensal Rise'                 => 'O46',
    'Kilburn High Road'           => 'O50',
    'South Hamstead'              => 'O51',
    'Headstone Lane'              => 'O60',
    'Hatch End'                   => 'O61',
    'Carpenders Park'             => 'O62',
    'Bushey'                      => 'O63',
    'Watford High Street'         => 'O64',
    'Watford Junction'            => 'O65',
    'Acton Central'               => 'O66',
    'South Acton'                 => 'O67',
    'Imperial Wharf'              => 'O74',
    'Clapham Junction'            => 'O75',
};

Readonly my $PICCADILLY => {
    'South Harrow'            => 'P08',
    'Sudbury Hill'            => 'P09',
    'Sudbury Town'            => 'P10',
    'Alperton'                => 'P11',
    'Park Royal'              => 'P12',
    'North Ealing'            => 'P13',
    'Knightsbridge'           => 'P19',
    'Hyde Park Corner'        => 'P20',
    'Covent Garden'           => 'P24',
    'Russel Square'           => 'P26',
    'Caledonian Road'         => 'P29',
    'Holloway Road'           => 'P30',
    'Arsenal'                 => 'P31',
    'Manor House'             => 'P33',
    'Turnpike Lane'           => 'P34',
    'Wood Green'              => 'P35',
    'Bounds Green'            => 'P36',
    'Arnos Grove'             => 'P37',
    'Southgate'               => 'P38',
    'Oakwood'                 => 'P39',
    'Cockfosters'             => 'P40',
    'South Ealing'            => 'P41',
    'Northfields'             => 'P42',
    'Boston Manor'            => 'P43',
    'Osterley'                => 'P44',
    'Hounslow East'           => 'P45',
    'Hounslow Central'        => 'P46',
    'Hounslow West'           => 'P47',
    'Hatton Cross'            => 'P48',
    'Heathrow Terminal 4'     => 'P49',
    'Heathrow Terminal 1,2,3' => 'P50',
    'Heathrow Terminal 5'     => 'P51'
};

Readonly my $VICTORIA => {
    'Brixton'              => 'V01',
    'Vauxhall'             => 'V03',
    'Pimlico'              => 'V04',
    'Seven Sisters'        => 'V13',
    'Tottenham Hale'       => 'V14',
    'Walthamstow Central'  => 'V16'
};

Readonly my $COMMON => {
    'Acton Town'                => 'ACT',
    'Aldgate'                   => 'AGT',
    'Aldgate East'              => 'AGE',
    'Alperton'                  => 'P11',
    'Baker Street'              => 'BST',
    'Bank'                      => 'BNK',
    'Barbican'                  => 'BBC',
    'Barking'                   => 'BKG',
    'Barons Court'              => 'BCT',
    'Bayswater'                 => 'BYW',
    'Blackfriars'               => 'BLF',
    'Blackhose Road'            => 'BHR',
    'Bond Street'               => 'BOS',
    'Bow Road'                  => 'BRD',
    'Bromley-by-Bow'            => 'BBB',
    'Buckhurst Hill'            => 'BHH',
    'Canada Water'              => 'CWT',
    'Cannon Street'             => 'CNS',
    'Canary Wharf'              => 'CWF',
    'Canning Town'              => 'CTN',
    'Chalfont & Latimer'        => 'CAL',
    'Camden Town'               => 'CAT',
    'Charing Cross'             => 'CRS',
    'Dalston Kingsland'         => 'DKL',
    'Ealing Broadway'           => 'EBW',
    'Ealing Common'             => 'ECM',
    q{Earl's Court}             => 'ECT',
    'East Ham'                  => 'EHM',
    'Eastcote'                  => 'ETC',
    'Edgware Road'              => 'EDG',
    'Elephant & Castle'         => 'EAC',
    'Embankment'                => 'EBK',
    'Euston'                    => 'EUS',
    'Euston Square'             => 'ESQ',
    'Farringdon'                => 'FRG',
    'Finchley Road'             => 'FNR',
    'Finchley Central'          => 'FCC',
    'Finsbury Park'             => 'FBP',
    'Gloucester Road'           => 'GLS',
    'Goldhawk Road'             => 'GHR',
    'Gospel Oak'                => 'GOK',
    'Great Portland Street'     => 'GPS',
    'Green Park'                => 'GPK',
    'Gunnersbury'               => 'GBY',
    'Hammersmith'               => 'HSM',
    'Harlesden'                 => 'HDN',
    'Harrow-on-the-Hill'        => 'HOH',
    'Harrow & Wealdstone'       => 'HAW',
    'Highbury & Islington'      => 'HAI',
    'High Street Kensington'    => 'HSK',
    'Hillingdon'                => 'HGD',
    'Holborn'                   => 'HBN',
    'Ickenham'                  => 'IKH',
    'Kennington'                => 'KNG',
    'Kensal Green'              => 'KEN',
    'Kensington (Olympia)'      => 'KSG',
    'Kenton'                    => 'KTN',
    'Kew Gardens'               => 'KGN',
    q{King's Cross St. Pancras} => 'KCS',
    'Ladbroke Grove'            => 'LBG',
    'Latimer Road'              => 'LTR',
    'Leicester Square'          => 'LSQ',
    'Leytonstone'               => 'LES',
    'Liverpool Street'          => 'LST',
    'London Bridge'             => 'LON',
    'Mansion House'             => 'MSH',
    'Mile End'                  => 'MEN',
    'Monument'                  => 'MMT',
    'Moor Park'                 => 'MPK',
    'Moorgate'                  => 'MGT',
    'North Acton'               => 'NAC',
    'North Wembley'             => 'NWB',
    'Notting Hill Gate'         => 'NHG',
    'Oxford Circus'             => 'OXC',
    'Paddington'                => 'PDG',
    'Penge West'                => 'PWT',
    'Piccadilly Circus'         => 'PCS',
    'Plaistow'                  => 'PST',
    'Poplar'                    => 'PLR',
    q{Queen's Park}             => 'QPK',
    'Rayners Lane'              => 'RAL',
    'Richmond'                  => 'RCH',
    'Royal Oak'                 => 'RYL',
    'Ruislip'                   => 'RSP',
    'Ruislip Manor'             => 'RSM',
    'Shadwell'                  => 'SWL',
    q{Shepherd's Bush}          => 'SBH',
    q{Shepherd's Bush Market}   => 'SBM',
    'Sloane Square'             => 'SLQ',
    'South Kensington'          => 'SKN',
    'South Kenton'              => 'STK',
    q{St. James's Park}         => 'SJP',
    'Stepney Green'             => 'SGN',
    'Stockwell'                 => 'STW',
    'Stonebridge Park'          => 'SPK',
    'Stratford'                 => 'STF',
    'Surrey Quays'              => 'SQY',
    'Syndenham'                 => 'SDH',
    'Temple'                    => 'TMP',
    'Tottenham Court Road'      => 'TCR',
    'Tower Hill'                => 'THL',
    'Turnham Green'             => 'TGN',
    'Upton Park'                => 'UPK',
    'Uxbridge'                  => 'UXB',
    'Victoria'                  => 'VCT',
    'Warren Street'             => 'WST',
    'Waterloo'                  => 'WLO',
    'Wembley Central'           => 'WCL',
    'Wembley Park'              => 'WMB',
    'West Brompton'             => 'WBM',
    'West Ham'                  => 'WHM',
    'Westbourne Park'           => 'WBP',
    'Westminster'               => 'WMN',
    'Willesdon Junction'        => 'WJN',
    'White City'                => 'WTC',
    'Whitechapel'               => 'WCH',
    'Wood Lane'                 => 'WDL',
};

Readonly my $LINE => {
    'Bakerloo'           => ['HAW','KTN','STK','NWB','WCL','SPK','HDN','WJN','KEN','QPK',
                             'B11','B12','B13','PDG','EDG','B16','BST','B18','OXC','PCS',
                             'CRS','EBK','WLO','B24','EAC'],
    'Central'            => ['C01','C02','C03','C04','C05','C06','C07','NAC','EBW','C10',
                             'C11','WTC','SBH','C14','NHG','C16','C17','C18','BOS','OXC',
                             'TCR','HBN','C23','C24','BNK','LST','C27','MEN','STF','C30',
                             'LES','C32','C33','C34','C35','C36','C37','C38','C39','C40',
                             'C41','C42','C43','C44','BHH','C46','C47','C48','C49'],
    'Circle'             => ['HSM','GHR','SBM','WDL','LTR','LBG','WBP','RYL','PDG','EDG',
                             'BST','GPS','ESQ','KCS','FRG','BBC','MGT','LST','AGT','THL',
                             'MMT','CNS','MSH','BLF','TMP','EBK','WMN','SJP','VCT','SLQ',
                             'SKN','GLS','HSK','NHG','BYW'],
    'District'           => ['EBW','ECM','ACT','D04','TGN','D06','D07','HSM','BCT','D10',
                             'ECT','KSG','WBM','D14','D15','D16','D17','D18','D19','D20',
                             'HSK','NHG','BYW','EDG','GLS','SKN','SLQ','VCT','SJP','WMN',
                             'EBK','TMP','BLF','MSH','CNS','MMT','THL','AGE','WCH','SGN',
                             'MEN','BRD','BBB','WHM','PST','EHM','BKG','D48','D49','D50',
                             'D51','D52','D53','D54','D55','GBY','KGN','RCH'],
    'DLR'                => ['L01','L02','L03','L04','L05','CTN','L07','L08','L09','L10',
                             'L11','L12','L13','L14','L15','L16','PLR','L18','L19','L20',
                             'L21','L22','STF','L24','CWF','L26','L27','L28','L29','L30',
                             'L31','L32','L33','L34','L35','L36','L37','SWL','L39','MMT'],
    'Hammersmith & City' => ['HSM','GHR','SBM','WDL','LTR','LBG','WBP','RYL','PDG','EDG',
                             'BST','GPS','ESQ','KCS','FRG','BBC','MGT','LST','AGE','WCH',
                             'SGN','MEN','BRD','BBB','WHM','PST','UPK','EHM','BKG'],
    'Jubilee'            => ['J01','J02','J03','J04','WMB','J06','J07','J08','J09','J10',
                             'FNR','J12','J13','BST','BOS','GPK','WMN','WLO','J19','LON',
                             'J21','CWT','CWF','J24','CTN','STF'],
    'Metropolitan'       => ['UXB','HGD','IKH','RSP','RSM','ETC','M07','HOH','M09','M10',
                             'M11','M12','MPK','M14','M15','M16','M17','CAL','M19','M20',
                             'M21','M22','WMB','FNR','BST','GPS','ESQ','KCS','FRG','BBC',
                             'MGT','LST','AGT'],
    'Northern'           => ['N01','N02','N03','N04','N05','N06','N07','N08','CAT','N10',
                             'N11','N12','N13','N14','FCC','N16','N17','N18','N19','N20',
                             'N21','EUS','WST','N24','TCR','LSQ','CRS','EBK','WLO','KNG',
                             'N31','STW','N33','N34','N35','N36','N37','N38','N39','N40',
                             'N41','N42','LON','BNK','MGT','N46','N47'],
    'Overground'         => ['O01','O02','O03','PWT','O05','SDH','O07','O08','O09','O10',
                             'SQY','O12','CWT','O14','O15','SWL','WCH','O18','O19','O20',
                             'O21','DKL','O23','O24','O25','STF','O27','HAI','O29','O30',
                             'O31','GOK','O33','O34','O35','O36','BHR','O38','O39','O40',
                             'O41','BKG','O43','O44','O45','O46','WJN','KEN','QPK','O50',
                             'O51','EUS','HDN','SPK','WCL','NWB','STK','KTN','HAW','O60',
                             'O61','O62','O63','O64','O65','O66','O67','GBY','KGN','RCH',
                             'SBH','KSG','WBM','O74','O75'],
    'Piccadilly'         => ['UXB','HGD','IKH','RSP','RSM','ETC','RAL','P08','P09','P10',
                             'P11','P12','P13','ECM','ACT','TGN','HSM','BCT','P19','P20',
                             'GPK','PCS','LSQ','P24','HBN','P26','KCS','P29','P30',
                             'P31','FBP','P33','P34','P35','P36','P37','P38','P39','P40',
                             'P41','P42','P43','P44','P45','P46','P47','P48','P49','P50',
                             'P51'],
    'Victoria'           => ['V01','STW','V03','V04','VCT','GPK','OXC','WST','EUS','KCS',
                             'HAI','FBP','V13','V14','BHR','V16'],
    'Waterloo & City'    => ['BNK','WLO'],
};

=head1 SYNOPSIS

      B --------  C
     /  \       /  \
    /    \     /    \
   /      \   /      \
  A ------  G ------- D
   \      /   \      /
    \    /     \    /
     \  /       \  /
      F -------- E
     /
    /
   /
  H
   \
    \
     \
      I

  which can be defined as below:

  { 'A' => ['B','F','G'],
    'B' => ['A','C','G'],
    'C' => ['B','D','G'],
    'D' => ['C','E','G'],
    'E' => ['D','F','G'],
    'F' => ['A','E','G','H'],
    'G' => ['A','B','C','D','E','F'],
    'H' => ['F','I'],
    'I' => ['H']
  }

=head1 METHODS

=head2 init()

This is the core method of the module, where we actually define the relationship
among the diffrerent nodes. I have taken extra care to depict the relationship.
However I would be more than happy to receieve any suggestion to improve the logic.
Please note "Transport for London" is the owner of the data used here.

  use strict; use warnings;
  use Map::Tube::Node;

  use strict; use warnings;
  # Loads up the default node mapping definitions.
  my $node = Map::Tube::Node::init();

=cut

sub init {
    my $node = {
        ## BAKERLOO
        'B11' => ['QPK','B12'],
        'B12' => ['B11','B13'],
        'B13' => ['B12','PDG'],
        'B16' => ['BST','EDG'],
        'B18' => ['BST','OXC'],
        'B24' => ['WLO','EAC'],

        ## CENTRAL
        'C01' => ['C02'],
        'C02' => ['C01','C03'],
        'C03' => ['C02','C04'],
        'C04' => ['C03','C05'],
        'C05' => ['C04','C06'],
        'C06' => ['C05','C07'],
        'C07' => ['C06','NAC'],
        'C10' => ['EBW','C11'],
        'C11' => ['C10','WTC'],
        'C14' => ['SBH','NHG'],
        'C16' => ['NHG','C17'],
        'C17' => ['C16','C18'],
        'C18' => ['C17','BOS'],
        'C23' => ['HBN','C24'],
        'C24' => ['C23','BNK'],
        'C27' => ['LST','MEN'],
        'C30' => ['STF','LES'],
        'C32' => ['LES','C33'],
        'C33' => ['C32','C34'],
        'C34' => ['C33','C35'],
        'C35' => ['C34','C36'],
        'C36' => ['C35','C37'],
        'C37' => ['C36','C38'],
        'C38' => ['C37','C39'],
        'C39' => ['C38','C40'],
        'C40' => ['C39','C41'],
        'C41' => ['C40','BHH'],
        'C42' => ['LES','C43'],
        'C43' => ['C42','C44'],
        'C44' => ['BHH','C43'],
        'C46' => ['BHH','C47'],
        'C47' => ['C46','C48'],
        'C48' => ['C47','C49'],
        'C49' => ['C48'],

        ## DISTRICT / HAMMERSMITHANDCITY / CIRCLE
        'D04' => ['TGN','ACT'],
        'D06' => ['TGN','D07'],
        'D07' => ['HSM','D06'],
        'D10' => ['ECT','BCT'],
        'D14' => ['WBM','D15'],
        'D15' => ['D14','D16'],
        'D16' => ['D15','D17'],
        'D17' => ['D16','D18'],
        'D18' => ['D17','D19'],
        'D19' => ['D18','D20'],
        'D20' => ['D19'],
        'D48' => ['BKG','D49'],
        'D49' => ['D48','D50'],
        'D50' => ['D49','D51'],
        'D51' => ['D50','D52'],
        'D52' => ['D51','D53'],
        'D53' => ['D52','D54'],
        'D54' => ['D53','D55'],
        'D55' => ['D54'],

        ## DLR
        'L01' => ['L02'],
        'L02' => ['L03','L01'],
        'L03' => ['L04','L02'],
        'L04' => ['L05','L03'],
        'L05' => ['CTN','L04'],
        'L07' => ['CTN','L08'],
        'L08' => ['L07','L09'],
        'L09' => ['L08','L10'],
        'L10' => ['L09','L11'],
        'L11' => ['L10','L12'],
        'L12' => ['L11','L13'],
        'L13' => ['L12','L14'],
        'L14' => ['L13'],
        'L15' => ['CTN','L16'],
        'L16' => ['PLR','L15'],
        'L18' => ['PLR','L19'],
        'L19' => ['L18','L20'],
        'L20' => ['L19','L21'],
        'L21' => ['L20','L22'],
        'L22' => ['L21','STF'],
        'L24' => ['PLR','CWF','L36'],
        'L26' => ['CWF','L27'],
        'L27' => ['L26','L28'],
        'L28' => ['L27','L29'],
        'L29' => ['L28','L30'],
        'L30' => ['L29','L31'],
        'L31' => ['L30','L32'],
        'L32' => ['L31','L33'],
        'L33' => ['L32','L34'],
        'L34' => ['L33','L35'],
        'L35' => ['L34'],
        'L36' => ['PLR','L37'],
        'L37' => ['L36','SWL'],
        'L39' => ['SWL'],

        ## JUBILEE
        'J01' => ['J02'],
        'J02' => ['J01','J03'],
        'J03' => ['J02','J04'],
        'J04' => ['J03','WMB'],
        'J06' => ['WMB','J07'],
        'J07' => ['J06','J08'],
        'J08' => ['J07','J09'],
        'J09' => ['J08','J10'],
        'J10' => ['J09','FNR'],
        'J12' => ['FNR','J13'],
        'J13' => ['J12','BST'],
        'J19' => ['WLO','LON'],
        'J21' => ['LON','CWT'],
        'J24' => ['CWF','CTN'],

        ## METROPOLITAN
        'M07' => ['HOH','RAL'],
        'M09' => ['HOH','M10'],
        'M10' => ['M09','M11'],
        'M11' => ['M10','M12'],
        'M12' => ['M11','MPK'],
        'M14' => ['MPK','M15'],
        'M15' => ['M14'],
        'M16' => ['MPK','M17'],
        'M17' => ['M16','CAL'],
        'M19' => ['CAL'],
        'M20' => ['CAL'],
        'M21' => ['M22','HOH'],
        'M22' => ['WMB','M21'],

        ## NORTHERN
        'N01' => ['N02'],
        'N02' => ['N03','N01'],
        'N03' => ['N04','N02'],
        'N04' => ['N05','N03'],
        'N05' => ['N06','N04'],
        'N06' => ['N07','N05'],
        'N07' => ['N08','N06'],
        'N08' => ['CAT','N07'],
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

        ## OVERGROUND
        'O01' => ['O02'],
        'O02' => ['O03','O01'],
        'O03' => ['PWT','O02'],
        'O05' => ['SDH'],
        'O07' => ['SDH','O08'],
        'O08' => ['O07','O09'],
        'O09' => ['O08','O10'],
        'O10' => ['O09','SQY'],
        'O12' => ['SQY'],
        'O14' => ['CWT','O15'],
        'O15' => ['O14','SWL'],
        'O18' => ['WCH','O19'],
        'O19' => ['O18','O20'],
        'O20' => ['O19','O21'],
        'O21' => ['O20','DKL'],
        'O23' => ['DKL','O24'],
        'O24' => ['O23','O25'],
        'O25' => ['O24','STF'],
        'O27' => ['DKL','HAI'],
        'O29' => ['HAI','O30'],
        'O30' => ['O29','O31'],
        'O31' => ['O30','GOK'],
        'O33' => ['GOK','O34'],
        'O34' => ['O33','O35'],
        'O35' => ['O34','O36'],
        'O36' => ['O35','BHR'],
        'O38' => ['BHR','O39'],
        'O39' => ['O38','O40'],
        'O40' => ['O39','O41'],
        'O41' => ['O40','BKG'],
        'O43' => ['GOK','O44'],
        'O44' => ['O43','O45'],
        'O45' => ['O44','O46'],
        'O46' => ['WJN','O45'],
        'O50' => ['QPK','O51'],
        'O51' => ['O50','EUS'],
        'O60' => ['HAW','O61'],
        'O61' => ['O60','O62'],
        'O62' => ['O61','O63'],
        'O63' => ['O62','O64'],
        'O64' => ['O63','O65'],
        'O65' => ['O64'],
        'O66' => ['WJN','O67'],
        'O67' => ['O66','GBY'],
        'O74' => ['WBM','O75'],
        'O75' => ['O74'],

        ## PICCADILLY
        'P08' => ['RAL','P09'],
        'P09' => ['P10','P08'],
        'P10' => ['P11','P09'],
        'P11' => ['P12','P10'],
        'P12' => ['P13','P11'],
        'P13' => ['ECM','P12'],
        'P19' => ['P20','SKN'],
        'P20' => ['GPK','P19'],
        'P24' => ['HBN','LSQ'],
        'P26' => ['KCS','HBN'],
        'P29' => ['P30','KCS'],
        'P30' => ['P31','P29'],
        'P31' => ['FBP','P30'],
        'P33' => ['FBP','P34'],
        'P34' => ['P33','P35'],
        'P35' => ['P34','P36'],
        'P36' => ['P35','P37'],
        'P37' => ['P36','P38'],
        'P38' => ['P37','P39'],
        'P39' => ['P38','P40'],
        'P40' => ['P39'],
        'P41' => ['ACT','P42'],
        'P42' => ['P41','P43'],
        'P43' => ['P42','P44'],
        'P44' => ['P45','P41'],
        'P45' => ['P46','P44'],
        'P46' => ['P47','P45'],
        'P47' => ['P48','P46'],
        'P48' => ['P49'],
        'P49' => ['P50'],
        'P50' => ['P51','P48'],
        'P51' => ['P50'],

        ## VICTORIA
        'V01' => ['STW'],
        'V03' => ['STW','V04'],
        'V04' => ['V03','VCT'],
        'V13' => ['FBP','V14'],
        'V14' => ['V13','BHR'],
        'V16' => ['BHR'],

        ## Special case
        'UXB' => ['HGD'],
        'RCH' => ['KGN'],
        'HAW' => ['KTN'],
        'KTN' => ['HAW','STK'],
        'STK' => ['KTN','NWB'],
        'NWB' => ['STK','WCL'],
        'WCL' => ['NWB','SPK'],
        'SPK' => ['WCL','HDN'],
        'HDN' => ['SPK','WJN'],
        'ESQ' => ['GPS','KCS'],
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
        'CNS' => ['MMT','MSH'],
        'MSH' => ['CNS','BLF'],
        'BLF' => ['TMP','MSH'],
        'TMP' => ['BLF','EBK'],
        'EBK' => ['WMN','TMP'],
        'SJP' => ['WMN','VCT'],
        'SLQ' => ['VCT','SKN'],
        'HSK' => ['GLS','NHG'],
        'BYW' => ['NHG','EDG'],
        'BCT' => ['HSM','D10'],
        'KGN' => ['GBY','RCH'],
        'EHM' => ['UPK','BKG'],
        'UPK' => ['PST','EHM'],
        'PST' => ['WHM','UPK'],
        'BBB' => ['WHM','BRD'],
        'BRD' => ['MEN','BBB'],
        'SGN' => ['WCH','MEN'],
        'ETC' => ['RAL','RSM'],
        'RSM' => ['ETC','RSP'],
        'RSP' => ['RSM','IKH'],
        'IKH' => ['RSP','HGD'],
        'HGD' => ['IKH','UXB'],
        'BHH' => ['C41','C44'],
        'EBW' => ['ECM','C10'],
        'AGE' => ['LST','THL'],
        'KEN' => ['WJN','QPK'],
        'PWT' => ['SDH','O03'],
        'SDH' => ['PWT','O05'],
        'SQY' => ['O10','O12'],
        'DKL' => ['O21','O23','O27'],
        'GOK' => ['O31','O33','O43'],
        'KSG' => ['ECT','SBH','WBM'],
        'WBM' => ['ECT','D14','KSG'],
        'GBY' => ['TGN','KGN','O67'],
        'QPK' => ['KEN','B11','O50'],
        'BKG' => ['EHM','D48','O41'],
        'SWL' => ['L39','MMT','WCH'],
        'MMT' => ['THL','CNS','SWL'],
        'STW' => ['V01','V03','N31'],
        'NAC' => ['C07','C10','C11'],
        'RAL' => ['M07','ETC','P08'],
        'THL' => ['AGT','AGE','MMT'],
        'GLS' => ['SKN','HSK','ECT'],
        'CAL' => ['M17','M19','M20'],
        'CRS' => ['PCS','EBK','LSQ'],
        'EAC' => ['B24','KNG','N42'],
        'FCC' => ['N14','N16','N17'],
        'LSQ' => ['TCR','CRS','PCS'],
        'KNG' => ['WLO','EAC','N31'],
        'SKN' => ['SLQ','GLS','P19'],
        'ECM' => ['ACT','P13','EBW'],
        'PDG' => ['B13','EDG','RYL'],
        'EDG' => ['PDG','B16','BST'],
        'LES' => ['C30','C32','C42'],
        'WST' => ['OXC','EUS','N24'],
        'MPK' => ['M12','M14','M16','HOH'],
        'SBH' => ['WTC','C14','WJN','KSG'],
        'EUS' => ['WST','N21','KCS','O51'],
        'BHR' => ['V14','V16','O36','O38'],
        'HAI' => ['KCS','FBP','O27','O29'],
        'WCH' => ['AGE','SGN','SWL','O18'],
        'CWT' => ['J21','CWF','SQY','O14'],
        'PLR' => ['L16','L24','L36','L18'],
        'CWF' => ['CWT','J24','L24','L26'],
        'NHG' => ['C14','C16','BYW','HSK'],
        'VCT' => ['V04','GPK','SLQ','SJP'],
        'CAT' => ['N08','N10','N21','EUS'],
        'BOS' => ['GPK','BST','OXC','C18'],
        'MEN' => ['C27','STF','SGN','BRD'],
        'WHM' => ['CTN','STF','BBB','PST'],
        'HSM' => ['GHR','BCT','D07','TGN'],
        'ACT' => ['D04','ECM','P41','TGN'],
        'ECT' => ['KSG','HSK','WBM','GLS'],
        'EBK' => ['CRS','WLO','TMP','WMN'],
        'TCR' => ['OXC','HBN','N24','LSQ'],
        'LON' => ['J19','J21','N42','BNK'],
        'MGT' => ['LST','BBC','BNK','N46'],
        'HBN' => ['TCR','C23','P24','P26'],
        'FBP' => ['HAI','V13','P31','P33'],
        'PCS' => ['OXC','CRS','LSQ','GPK'],
        'FNR' => ['J10','J12','BST','WMB','HOH'],
        'WJN' => ['HDN','KEN','O46','O66','SBH'],
        'STF' => ['MEN','C30','WHM','L22','O25'],
        'CTN' => ['J24','WHM','L05','L07','L15'],
        'BNK' => ['C24','LON','MGT','LST','WLO'],
        'WLO' => ['EBK','B24','WMN','J19','BNK'],
        'WMB' => ['J04','J06','FNR','M22','HOH'],
        'GPK' => ['VCT','OXC','BOS','WMN','LSQ'],
        'WMN' => ['SJP','GPK','WLO','EBK','WLO'],
        'WTC' => ['C11','SBH','LTR','WDL','SBH'],
        'LST' => ['MGT','AGT','AGE','BNK','C27'],
        'TGN' => ['D06','D04','GBY','HSM','ACT'],
        'OXC' => ['GPK','WST','BOS','B18','PCS','TCR'],
        'HOH' => ['M21','WMB','M07','M09','UXB','MPK','FNR'],
        'KCS' => ['HAI','EUS','ESQ','FRG','N47','P26','P29'],
        'BST' => ['BOS','B18','B16','GPS','J13','EDG','FNR'],
    };
    return $node;
}

=head2 load_element()

This loads all the nodes defined. It covers Bakerloo, Central, Circle, District,
DLR, Hammersmith & City, Jubilee, Metropolitan, Northern, Overground, Piccadilly,
Victoria and Waterloo & City. Please note this is still very experimental in nature.

  use strict; use warnings;
  use Map::Tube::Node;

  # Loads all the node definitions.
  my $element = Map::Tube::Node::load_element();

=cut

sub load_element
{
    return {%{$COMMON},
            %{$BAKERLOO},
            %{$CENTRAL},
            %{$DISTRICT},
            %{$DLR},
            %{$JUBILEE},
            %{$METROPOLITAN},
            %{$NORTHERN},
            %{$OVERGROUND},
            %{$PICCADILLY},
            %{$VICTORIA}};
}

=head2 load_line()

This loads all the tube lines with their node code.

  use strict; use warnings;
  use Map::Tube::Node;

  # Loads all the node codes with the default tube lines information.
  my $line = Map::Tube::Node::load_line();

=cut

sub load_line
{
    my $info = shift;
    $info = $LINE unless defined $info;

    my $line = {};
    foreach (keys %{$info})
    {
        foreach my $code (@{$info->{$_}})
        {
            $line->{$code}->{$_} = 1;
        }
    }

    return $line;
}

=head2 upcase_element_name

This loads all the nodes with name in uppercase. This is to allow case-insensitive
name lookup. User can also provide the node list otherwise it will pick the
default list.

  use strict; use warnings;
  use Map::Tube::Node;

  # Returns a new list of element with names in upper case.
  my $upcase = Map::Tube::Node::upcase_element_name();

=cut

sub upcase_element_name
{
    my $element = shift;
    $element = load_element()
        unless defined $element;

    my $upcase = undef;
    foreach (keys %{$element})
    {
        $upcase->{uc($_)} = $element->{$_};
    }
    return $upcase;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar@yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube@rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Map-Tube>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

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