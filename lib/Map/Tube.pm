package Map::Tube;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;
use Map::Tube::Node;
use Time::HiRes qw(time);

=head1 NAME

Map::Tube - Interface to the London Tube Map.

=head1 VERSION

Version 2.19

=head1 AWARD

Map::Tube has been granted the "Famous Software Award" by Download.FamousWhy.com on Tue 09 Nov 2010.

http://download.famouswhy.com/map_tube/

=cut

our $VERSION = '2.19';


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

=head1 DESCRIPTION

The module intends to provide you as much information as possible from London Tube Map
through perl interface. The very first thing anyone would like to know from any map is
to find the shortest route between two point. This is exactly what I am trying to solve
at the moment. However I would be adding more interesting information very soon. This
module covers some of the underground lines managed by Travel for London. It is far from
complete and bound to have missing links and incorrect mapping. Please feel free to shout
back to me, if you find any error/issue. While trying to find the shortest route, it
takes into account the number of stops one has to go through to reach the destination. I
do agree, at times, you wouldn't mind going through few extra stops, to avoid changing
lines. I might add this behaviour in future. Please note Map::Tube doesn't try to
explain Dijkstra's algorithm but to provide a perl interface to the London Tube Map.
It covers Bakerloo, Central, Circle, District, DLR, Hammersmith & City, Jubilee, Metropolitan,
Northern, Overground, Piccadilly, Victoria and Waterloo & City. Here is the link to the
official London Tube Map:
http://www.tfl.gov.uk/assets/downloads/standard-tube-map.pdf

=cut

=head1 CONSTRUCTOR

The constructor expects no parameters. This setup the default node definitions. By
default the DEBUG is turned off.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

=cut

sub new
{
    my $class = shift;

    my $self = {};
    bless $self, $class;
    $self->_init();
    $self->{_debug}     = 0;
    $self->{_follow_me} = 0;

    return $self;
}

=head1 METHODS

=head2 get_shortest_route()

This method  accepts  FROM and TO node name. It is case insensitive. It returns back 
the node sequence from FROM to TO. It ignores multiple spaces in between node's name.
It trims any space at the start and at the end of the node's name.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Find the shortest route from 'Bond Street' to 'Euston'.
  my @route = $map->get_shortest_route('Bond Street', 'Euston');

=cut

sub get_shortest_route
{
    my $self = shift;
    my $from = shift;
    my $to   = shift;
    croak("ERROR: Either FROM/TO node is undefined.\n")
        unless (defined($from) && defined($to));
   
    # Ignore if there are more than one space between the node's name.
    # e.g. "Bakers     Street" would be treated as "Bakers Street".
    $from =~ s/\s+/ /g;
    $to   =~ s/\s+/ /g;

    # Trim any space from the beginning and the end of the node's name.
    $from =~ s/^\s+//g;
    $to   =~ s/^\s+//g;
    $from =~ s/\s+$//g;
    $to   =~ s/\s+$//g;

    croak("ERROR: Received invalid FROM node $from.\n")
        unless exists $self->{_upcase}->{uc($from)};
    croak("ERROR: Received invalid TO node $to.\n")
        unless exists $self->{_upcase}->{uc($to)};

    my ($table, @routes, $start, $end);
    $start = Time::HiRes::time;
    unless ($self->{_user})
    {
        $from = $self->{_upcase}->{uc($from)};
        $to   = $self->{_nodes}->{$to};
    }

    $self->_process_node($from);
    $table = $self->{_table};
    while(defined($from) && defined($to) && !(_is_same($from, $to)))
    {
        push @routes, $self->get_node_name($to);
        $to = $table->{$to}->{path};
    }
    push @routes, $self->get_node_name($from);
    $end = Time::HiRes::time;
    print {*STDOUT} sprintf("Time taken %02f second(s).\n", ($end-$start));

    return reverse(@routes);
}

#NOTE: Not fully functional yet, hence not documenting it now.
#=head2 follow_me()
#
#This method forces the search to follow the line, where possible.
#
#=cut

sub follow_me
{
    my $self = shift;
    $self->{_follow_me} = 1;
}

=head2 get_tube_lines()

This method accept node code and returns the line names of the given node code. This
applies mainly to the default node definitions. For user defined node mappings it would
return the node code itself.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get tube lines for the node 'Wembley Park'.
  my @lines = $map->get_tube_lines('Wembley Park');

=cut

sub get_tube_lines
{
    my $self = shift;
    my $node = shift;
    return unless defined $node;

    my $lines = $self->get_node_lines();
    my @lines = keys(%{$lines->{$node}});
    croak("ERROR: No lines information found for node $node.\n")
        unless (scalar(@lines));
    return @lines;
}

=head2 set_node_mappings()

This method accept the node defintion from user. It does some basic check i.e. the
node data has to be reference to a HASH and each key has a value which is a reference
to an ARRAY. 

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Define node mappings.
  my $mappings = { 'A' => ['B','F','G'],
                   'B' => ['A','C','G'],
                   'C' => ['B','D','G'],
                   'D' => ['C','E','G'],
                   'E' => ['D','F','G'],
                   'F' => ['A','E','G','H'],
                   'G' => ['A','B','C','D','E','F'],
                   'H' => ['F','I'],
                   'I' => ['H'],};

  # However user can override the node definition.
  $map->set_node_mappings($mappings);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

=cut

sub set_node_mappings
{
    my $self     = shift;
    my $mappings = shift;
    croak("ERROR: Node mapping is undefined.\n")
        unless defined($mappings);
    croak("ERROR: Node has to be a reference to a HASH.\n")
        unless ref($mappings) eq 'HASH';

    foreach (keys %{$mappings})
    {
        croak("ERROR: Member of the node '$_' has to be a reference to an ARRAY.\n")
            unless (ref($mappings->{$_}) eq 'ARRAY');
    }
    $self->{_user}     = 1;
    $self->{_nodes}    = Map::Tube::Node::load_nodes($mappings);    
    $self->{_mappings} = $mappings;
    $self->{_lines}    = Map::Tube::Node::load_node_lines($mappings);
    $self->{_upcase}   = Map::Tube::Node::upcase_node_names($self->{_nodes});
    $self->{_table}    = _init_table($mappings);
    
    # Do the sanity check on all the data.
    $self->_sanity_check();
}

=head2 set_default_node_mappings()

This method set the default node mapping definitions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Define node mappings.
  my $mappings = { 'A' => ['B','F','G'],
                   'B' => ['A','C','G'],
                   'C' => ['B','D','G'],
                   'D' => ['C','E','G'],
                   'E' => ['D','F','G'],
                   'F' => ['A','E','G','H'],
                   'G' => ['A','B','C','D','E','F'],
                   'H' => ['F','I'],
                   'I' => ['H'],};

  # However user can override the node mapping definitions.
  $map->set_node_mappings($mappings);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

  # Revert back to the default node mapping definitions.
  $map->set_default_node_mappings();

  # Find the shortest route from 'Bond Street' to 'Euston'.
  @route = $map->get_shortest_route('Bond Street', 'Euston');

=cut

sub set_default_node_mappings
{
    my $self = shift;
    $self->_init();
}

=head2 get_node_mappings()

Returns all the nodes mapping defintions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get all the nodes mapping definitions.
  my $mappings = $map->get_node_mappings();

=cut

sub get_node_mappings
{
    my $self = shift;
    return $self->{_mappings};
}

=head2 get_node_lines()

Returns all the tube line's defintions. For user defined node, it would return line
definition provided by the user, if any, otherwise UNDEF.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get the node lines definitions.
  my $lines = $map->get_node_lines();

=cut

sub get_node_lines
{
    my $self = shift;
    return $self->{_lines};
}

=head2 set_node_lines()

Set the user defined node lines defintions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Define node mappings.
  my $mappings = { 'A' => ['B'],
                   'B' => ['A','C'],
                   'C' => ['B','D','F'],
                   'D' => ['C','E'],
                   'E' => ['D','F'],
                   'F' => ['C','E'] };

  # Set the user node mapping definitions.
  $map->set_node_mappings($mappings);

  # Define user node lines definitions.
  my $lines = { 'Line1' => ['A','B','C','D','E','F'],
                'Line2' => ['C','F','E'] };

  # Set the user defined node line definitions.
  $map->set_node_lines($lines);

=cut

sub set_node_lines
{
    my $self  = shift;
    my $lines = shift;

    unless (defined($lines))
    {
        print {*STDOUT} "WARNING: Line information is undefined.\n";
        return;
    }

    croak("ERROR: Line information has to be a reference to a HASH.\n")
        unless ref($lines) eq 'HASH';

    foreach (keys %{$lines})
    {
        croak("ERROR: Member of the line '$_' has to be a reference to an ARRAY.\n")
            unless ref($lines->{$_}) eq 'ARRAY';
    }

    $self->{_lines} = Map::Tube::Node::load_node_lines($lines);
}

=head2 get_nodes()

Returns all the node defintions. For user defined nodes it would returned all 
the node codes.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get all the node definitions.
  my $nodes = $map->get_nodes();

=cut

sub get_nodes
{
    my $self = shift;
    return $self->{_nodes};
}

=head2 get_node_name()

This method takes a node code and returns its name. If the node belongs to user
defined  mapping then it simply returns the node code itself.  It returns undef
if it can't find the code.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintions with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get node name for the given node code.
  my $name = $map->get_node_name('BST');

=cut

sub get_node_name
{
    my $self = shift;
    my $code = shift;
    croak("ERROR: Code is not defined.\n")
        unless defined($code);
    croak("ERROR: Invalid node code '$code'.\n")
        unless exists $self->{_mappings}->{$code};
    return $code if $self->{_user};

    foreach (keys %{$self->{_nodes}})
    {
        return $_ if _is_same($self->{_nodes}->{$_}, $code);
    }
    return;
}

=head2 set_debug()

This method enables to turn the debug on or off.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Debug is turned on.
  $map->set_debug(1);

=cut

sub set_debug
{
    my $self = shift;
    my $flag = shift;

    croak("ERROR: Invalid swith to debug flag [$flag].\n")
        unless (defined($flag) && ($flag =~ /[1|0]/));

    $self->{_debug} = $flag;
}

=head2 show_map_chart()

This method dumps the map chart used internally to find the shortest
route to the STDOUT. This should only be called after get_shortest_route() to
get some reasonable data. The map chart is generated by the internal
method _process_node() which gets called by the method get_shortest_route().
This method takes no parameter. It has three columns by the title "N" - Node Code,
"P" - Path to here and "L" - Length to reach "N" from "P".

  use strict; use warnings;
  use Map::Tube;

  # This setup the default nodes ready to be use.
  my $map = Map::Tube->new();

  # Define node mappings.
  my $mappings = { 'A' => ['B','F','G'],
                   'B' => ['A','C','G'],
                   'C' => ['B','D','G'],
                   'D' => ['C','E','G'],
                   'E' => ['D','F','G'],
                   'F' => ['A','E','G','H'],
                   'G' => ['A','B','C','D','E','F'],
                   'H' => ['F','I'],
                   'I' => ['H'],};

  # However user can override the default node mapping definitions.
  $map->set_node_mappings($mappings);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

  # The map chart will have meaningfull data only after you
  # have called method get_shortest_route().
  $map->show_map_chart();

  # You should expect the following output: 
  #  N  -  P  -  L
  # ---------------
  #  A  -  B  -  2
  #  B  -  C  -  1
  #  C  -  C  -  0
  #  D  -  C  -  1
  #  E  -  D  -  2
  #  F  -  G  -  2
  #  G  -  C  -  1
  #  H  -  F  -  3
  #  I  -  H  -  4
  # ---------------

=cut

sub show_map_chart
{
    my $self  = shift;
    my $table = $self->{_table};

    if (defined($table) && scalar(keys %{$table}))
    {
        print " N  -  P  -  L\n----------------\n";
        foreach (sort keys %{$table})
        {
            my $path   = (defined($table->{$_}->{path}))?($table->{$_}->{path}):('');
            my $length = (defined($table->{$_}->{length}))?($table->{$_}->{length}):('');
            print {*STDOUT} sprintf("%3s - %3s - %3s\n",$_,$path,$length);
        }
        print "-----------------\n\n";
    }
}

sub _init
{
    my $self = shift;

    $self->{_nodes}    = Map::Tube::Node::load_nodes();
    $self->{_mappings} = Map::Tube::Node::load_node_mappings();
    $self->{_lines}    = Map::Tube::Node::load_node_lines();
    $self->{_upcase}   = Map::Tube::Node::upcase_node_names();
    $self->{_table}    = _init_table($self->{_mappings});
    $self->{_user}     = 0;

    # Do the sanity check on all the data.
    $self->_sanity_check();
}

sub _sanity_check
{
    my $self = shift;

    my ($mappings, $nodes, $lines, $missing);
    my ($mapping_count, $node_count, $line_count);

    # Get all the node defintions.
    $nodes    = $self->get_nodes();

    # Get all the node map definitions.
    $mappings = $self->get_node_mappings();

    # Get all the node line definitions.
    $lines    = $self->get_node_lines();

    croak("ERROR: Missing node definitions.\n")
        unless defined($nodes);
    croak("ERROR: Missing node map definitions.\n")
        unless defined($mappings);
    croak("ERROR: Missing node line definitions.\n")
        unless defined($lines);
        
    $node_count    = scalar(keys(%{$nodes}));
    $mapping_count = scalar(keys(%{$mappings}));
    $line_count    = scalar(keys(%{$lines}));
    
    if ($mapping_count < $node_count)
    {
        $missing = undef;
        foreach (keys(%{$nodes}))
        {
            $missing .= ":" . $nodes->{$_}
                unless (exists($mappings->{$nodes->{$_}}));
        }
        $missing =~ s/^\://;
        croak("ERROR: Missing map definitions for '$missing'.\n");
    }

    if ($mapping_count > $node_count)
    {
        $missing = undef;
        foreach (keys(%{$mappings}))
        {
            $missing .= ":" . $mappings->{$_}
                unless (exists($nodes->{$mappings->{$_}}));
        }
        $missing =~ s/^\://;
        croak("ERROR: Found map definitions for invalid node(s) '$missing'.\n");
    }

    if ($line_count < $mapping_count)
    {
        $missing = undef;
        foreach (keys(%{$mappings}))
        {
            $missing .= ":" . $_
                 unless (exists($lines->{$_}));
        }
        $missing =~ s/^\:// if defined($missing);
        croak("ERROR: Missing line definitions for '$missing'.\n");
    }

    if ($line_count > $mapping_count)
    {
        $missing = undef;
        foreach (keys(%{$lines}))
        {
            $missing .= ":" . $_
                unless (exists($mappings->{$_}));
        }
        $missing =~ s/^\:// if defined($missing);
        croak("ERROR: Found line definitions for invalid node(s) '$missing'.\n");
    }
}

sub _process_node
{
    my $self  = shift;
    my $from  = shift;

    $self->{_table} = _init_table($self->{_mappings});
    my $mappings = $self->{_mappings};
    my $table    = $self->{_table};

    my (@queue, $index);
    $index = 0;
    $table->{$from}->{path}   = $from;
    $table->{$from}->{length} = $index;

    while (defined($from))
    {
        print "[$from] to [".join(":",@{$mappings->{$from}})."]\n"
            if $self->{_debug};
        foreach (@{$mappings->{$from}})
        {
            if (!defined($table->{$_}->{length}) || ($table->{$from}->{length} > ($index+1)))
            {
                $table->{$_}->{length} = $table->{$from}->{length}+1;
                $table->{$_}->{path}   = $from;
                push @queue, $_;
                print "Pushing to queue [$_]\n" if $self->{_debug};
                sleep 1 if $self->{_debug};
            }
        }
        $index  = $table->{$from}->{length}+1;
        $from   = $self->_get_next_node($from, \@queue);
        @queue  = grep(!/$from/, @queue);
    }

    $self->{_table} = $table;
}

sub _get_next_node
{
    my $self   = shift;
    my $from   = shift;
    my $list   = shift;
    return unless (defined($list) && scalar(@{$list}));

    return shift(@{$list})
        unless ($self->{_follow_me} && defined($self->{_lines}));

    my @current_lines = $self->get_tube_lines($from);
    foreach my $line (@current_lines)
    {
        foreach my $code (@{$list})
        {
            my @next_lines = $self->get_tube_lines($code);
            return $code if grep(/$line/,@next_lines);
        }
    }
    return shift(@{$list});
}

sub _init_table
{
    my $node = shift;
    my $table;
    foreach (keys %{$node})
    {
        $table->{$_}->{path}   = undef;
        $table->{$_}->{length} = undef;
    }
    return $table;
}

sub _is_same
{
    my $this = shift;
    my $that = shift;
    return 0 unless (defined($this) && defined($that));

    if (_is_number($this) && _is_number($that))
    {
        return 1 if ($this == $that);
    }
    else
    {
        return 1 if (uc($this) eq uc($that));
    }
    return 0;
}

sub _is_number
{
    my $this = shift;
    return 1 if (defined($this) && ($this =~ /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/));

    return 0;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar@yahoo.com> >>

=head1 ACKNOWLEDGEMENTS

=over 2

=item Peter Makholm (http://search.cpan.org/~pmakholm/) for valuable advice.

=back

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube@rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Map-Tube>.
I will be notified, and then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Map::Tube

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

Copyright 2010-2011 Mohammad S Anwar.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of Map::Tube