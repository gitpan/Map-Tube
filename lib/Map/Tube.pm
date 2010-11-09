package Map::Tube;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;
use Map::Tube::Node;
use Time::HiRes qw(time);

=head1 NAME

Map::Tube - A very simple perl interface to the London Tube Map.

=head1 VERSION

Version 1.7

=head1 AWARD

Map::Tube has been granted the "Famous Software Award" by Download.FamousWhy.com on Tue 09 Nov 2010.

http://download.famouswhy.com/map_tube/

=cut

our $VERSION = '1.7';


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
As of today, it covers Bakerloo, Central, Circle, District, Hammersmith & City, Jubilee, 
Metropolitan, Northern, Piccadilly and Victoria. I shall be finishing the last remaining 
Waterloo & City line very soon. Here is the link to the official London Tube Map:
http://www.tfl.gov.uk/assets/downloads/standard-tube-map.pdf

=cut

=head1 CONSTRUCTOR

The constructor expects an optional debug flag which is 0(false) by default. This setup the default
node definitions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node with DEBUG turned OFF.
  my $map = Map::Tube->new();

  or 

  # Setup the default node with DEBUG turned ON.
  my $map = Map::Tube->new(1);

=cut

sub new
{
    my $class = shift;
    my $debug = shift;

    croak("ERROR: Only valid argument to the constructor is 1 or 0.\n")
        if (defined($debug) && ($debug !~ /[1|0]/));
    my $self = {};
    bless $self, $class;
    $self->_initialize();    
    $self->{_debug}  = $debug || 0;
    $self->{_follow} = 0;

    return $self;
}

=head1 METHODS

=head2 get_shortest_route()

This method accepts FROM and TO node name. It is case insensitive. It returns back 
the node sequence from FROM to TO.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
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
    croak("ERROR: Received invalid FROM node $from.\n")
        unless exists $self->{_upcase}->{uc($from)};
    croak("ERROR: Received invalid TO node $to.\n")
        unless exists $self->{_upcase}->{uc($to)};

    my ($table, @routes, $start, $end);
    $start = Time::HiRes::time;
    unless ($self->{_user})
    {
        $from = $self->{_upcase}->{uc($from)};
        $to   = $self->{_element}->{$to};
    }

    $self->_process_node($from);
    $table = $self->{_table};
    while(defined($from) && defined($to) && (uc($from) ne uc($to)))
    {
        push @routes, $self->get_name($to);
        $to = $table->{$to}->{path};
    }
    push @routes, $self->get_name($from);
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
    $self->{_follow} = 1;
}

=head2 get_next_node()

This method accept the current node and list of remaining untouched nodes. It then
returns the next node, if possible stay on the same line as the current node's line.

  use strict; use warnings;
  use Map::Tube;

  # This setup the default node ready to be use.
  my $map = Map::Tube->new();

  #  A --- B --- C --- D
  #         \         /
  #          \       /
  #           \     / 
  #            \   /
  #              E
  #  
  # Suppose the start node is 'A' and the end node is 'D'. Based on the above map
  # There are two possible routes either A - B - C - D or A - B - E - D. 
  # Now lets assume A - B - C - D belongs to Line1 and A - B - E - D belongs to Line2.
  # 
  # Lets assume we have 'C','E' as untouched nodes. and current node is 'B'.
  # 
  # So from node 'B', we could either move to 'B' or 'E', since 'C' belongs to 
  # Line1 and the parent node of current node is 'A' belongs to Line1, we would 
  # rather prefer choosing 'C' first as it is on the same Line1.
  #
  # Therefore, the get_next_node() should return us 'C' from the list ('C','E').

  my $node = { 'A' => ['B'],
               'B' => ['A','C','E'],
               'C' => ['B','D'],
               'D' => ['C','E'],
               'E' => ['B','D']};
  
  my $line = { 'Line1' => ['A','B','C','D'],
               'Line2' => ['B','E','D'] };
    
  # Define user node.
  $map->set_node($node);
  
  # Define line.
  $map->set_line($line);
  
  # Find the next node from 'B'.
  my $next = $map->get_next_node('B', ['C','E']);
  
=cut

sub get_next_node
{
    my $self   = shift;
    my $from   = shift;
    my $list   = shift;
    return unless (defined($list) && scalar(@{$list}));

    return shift(@{$list})
        unless ($self->{_follow} && defined($self->{_line}));
        
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

=head2 get_tube_lines()

This method accept node code and returns the line name of the given node code. This
applies mainly to the default node definitions. However if user has provided line
information then it will use them.

  use strict; use warnings;
  use Map::Tube;

  # This setup the default node ready to be use.
  my $map = Map::Tube->new();

  # Get tube lines for the node 'Wembley Park'.
  my @lines = $map->get_tube_lines('Wembley Park');
  
=cut

sub get_tube_lines
{
    my $self = shift;
    my $node = shift;
    return unless defined $node;

    my $line  = $self->get_line();
    my @lines = keys(%{$line->{$node}});
    croak("ERROR: No line information found for node $node.\n")
        unless (scalar(@lines));
    return @lines;
}

=head2 set_node()

This method accept the node defintion from user. It does some basic check i.e. the 
node data has to be reference to a HASH and each key has a value which is a reference 
to an ARRAY. It doesn't, however, checks the mapping currently. Beware if you have any
error in mapping, you might see garbage out. Please note key of each node has to 
be a string.

  use strict; use warnings;
  use Map::Tube;

  # This setup the default node ready to be use.
  my $map = Map::Tube->new();

  # Define node
  my $node = { 'A' => ['B','F','G'],
               'B' => ['A','C','G'],
               'C' => ['B','D','G'],
               'D' => ['C','E','G'],
               'E' => ['D','F','G'],
               'F' => ['A','E','G','H'],
               'G' => ['A','B','C','D','E','F'],
               'H' => ['F','I'],
               'I' => ['H'],};

  # However user can override the node definition.
  $map->set_node($node);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

=cut

sub set_node
{
    my $self = shift;
    my $node = shift;
    croak("ERROR: Node is not defined.\n")
        unless defined($node);
    croak("ERROR: Node has to be a reference to a HASH.\n")
        unless ref($node) eq 'HASH';

    my $element = {};    
    foreach (keys %{$node})
    {
        my $member = $node->{$_};
        croak("ERROR: Member of the node '$_' has to be a reference to an ARRAY.\n")
            unless ref($member) eq 'ARRAY';
        $element->{$_} = 1;
    }
    $self->{_user}    = 1;
    $self->{_node}    = $node;
    $self->{_table}   = _initialize_table($node);
    $self->{_element} = $element;
    $self->{_upcase}  = Map::Tube::Node::upcase_element_name($element);
    $self->{_line}    = undef;
    
    # Do the sanity check on all the data.
    $self->sanity_check();
}

=head2 set_default_node()

This method set the default node definition.

  use strict; use warnings;
  use Map::Tube;

  # This setup the default node ready to be use.
  my $map = Map::Tube->new();

  # Define node
  my $node = { 'A' => ['B','F','G'],
               'B' => ['A','C','G'],
               'C' => ['B','D','G'],
               'D' => ['C','E','G'],
               'E' => ['D','F','G'],
               'F' => ['A','E','G','H'],
               'G' => ['A','B','C','D','E','F'],
               'H' => ['F','I'],
               'I' => ['H'],};

  # However user can override the node definition.
  $map->set_node($node);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

  # Revert back to the default node definition.
  $map->set_default_node();

  # Find the shortest route from 'Bond Street' to 'Euston'.
  @route = $map->get_shortest_route('Bond Street', 'Euston');

=cut

sub set_default_node
{
    my $self = shift;
    $self->_initialize();
}

=head2 get_node()

Returns all the node's map defintions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get the node's map definition.
  my $node = $map->get_node();

=cut

sub get_node
{
    my $self = shift;
    return $self->{_node};
}

=head2 get_line()

Returns all the tube line's defintions. For user defined node, it would return line
definition provided by the user, if any, otherwise UNDEF.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get the tube line's definition.
  my $line = $map->get_line();

=cut

sub get_line
{
    my $self = shift;
    return $self->{_line};
}

=head2 set_line()

Set the user defined line defintions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map  = Map::Tube->new();

  my $node = { 'A' => ['B'],
               'B' => ['A','C'],
               'C' => ['B','D','F'],
               'D' => ['C','E'],
               'E' => ['D','F'],
               'F' => ['C','E'] };

  # Set the user node.
  $map->set_node($node);

  # Define line.
  my $line = { 'Line1' => ['A','B','C','D','E','F'],
               'Line2' => ['C','F','E'] };

  # Set the user defined line definitions.
  $map->set_line($line);

=cut

sub set_line
{
    my $self = shift;
    my $line = shift;

    unless (defined($line))
    {
        print {*STDOUT} "WARNING: Line information is undefined.\n";
        return;
    }

    croak("ERROR: Line information has to be a reference to a HASH.\n")
        unless ref($line) eq 'HASH';
        
    foreach (keys %{$line})
    {
        croak("ERROR: Member of the line '$_' has to be a reference to an ARRAY.\n")
            unless ref($line->{$_}) eq 'ARRAY';
    }

    $self->{_line} = Map::Tube::Node::load_line($line);
}

=head2 get_element()

Returns all the elements i.e. node defintions.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get all the elements i.e. node definition.
  my $element = $map->get_element();

=cut

sub get_element
{
    my $self = shift;
    return $self->{_element};
}

=head2 get_name()

This method takes a node code and returns its name. If the node belongs to user
defined mapping then it simply returns the node code itself.

  use strict; use warnings;
  use Map::Tube;

  # Setup the default node defintion with DEBUG turned OFF.
  my $map = Map::Tube->new();

  # Get node name for the given node code.
  my $name = $map->get_name('BST');

=cut

sub get_name
{
    my $self = shift;
    my $code = shift;
    croak("ERROR: Code is not defined.\n")
        unless defined($code);
    croak("ERROR: Invalid node code '$code'.\n")
        unless exists $self->{_node}->{$code};
    return $code if $self->{_user};

    foreach (keys %{$self->{_element}})
    {
        return $_ if ($self->{_element}->{$_} eq $code);
    }
    return;
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

  # This setup the default node ready to be use.
  my $map = Map::Tube->new();

  # Define node
  my $node = { 'A' => ['B','F','G'],
               'B' => ['A','C','G'],
               'C' => ['B','D','G'],
               'D' => ['C','E','G'],
               'E' => ['D','F','G'],
               'F' => ['A','E','G','H'],
               'G' => ['A','B','C','D','E','F'],
               'H' => ['F','I'],
               'I' => ['H'],};

  # However user can override the node definition.
  $map->set_node($node);

  # Find the shortest route from 'C' to 'H'
  my @route = $map->get_shortest_route('C', 'H');

  # The map chart will have meaningfull data only after you
  # have called method get_shortest_route().
  $map->show_map_chart();

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

=head2 sanity_check()

This method is used for sanity checking of all the data involved in the module.
It croaks with appropriate error message if any vital information is missing.

=cut

sub sanity_check
{
    my $self = shift;

    my ($element, $node, $line, $missing);
    my ($element_count, $node_count, $line_count);    
    
    # Get all the node defintions.
    $element = $self->get_element();
    
    # Get all the node map definitions.
    $node    = $self->get_node();
    
    # Get all the node line definitions.
    $line    = $self->get_line();
    
    croak("ERROR: Missing node definitions.\n")
        unless defined($element);
    croak("ERROR: Missing node map definitions.\n")
        unless defined($node);
        
    $element_count = scalar(keys(%{$element}));
    $node_count    = scalar(keys(%{$node}));
    
    if ($node_count < $element_count)
    {
        $missing = undef;
        foreach (keys(%{$element}))
        {
            $missing .= ":" . $element->{$_}
                unless (exists($node->{$element->{$_}}));
        }
        $missing =~ s/^\://;
        croak("ERROR: Missing map definitions for [$missing].\n");
    }    
    
    if ($node_count > $element_count)
    {
        $missing = undef;
        foreach (keys(%{$node}))
        {
            $missing .= ":" . $node->{$_}
                unless (exists($element->{$node->{$_}}));
        }
        $missing =~ s/^\://;
        croak("ERROR: Found map definitions for invalid node(s) [$missing].\n");
    }    
        
    if ($self->{_follow})
    {
        croak("ERROR: Missing node line definitions.\n")
            unless defined($line);
            
        $line_count = scalar(keys(%{$line}));

        if ($line_count < $node_count)
        {
            $missing = undef;
            foreach (keys(%{$node}))
            {
                $missing .= ":" . $_
                    unless (exists($line->{$_}));
            }
            $missing =~ s/^\:// if defined($missing);
            croak("ERROR: Missing line definitions for [$missing].\n");
        }    
        
        if ($line_count > $node_count)
        {
            $missing = undef;
            foreach (keys(%{$line}))
            {
                $missing .= ":" . $_
                    unless (exists($node->{$_}));
            }
            $missing =~ s/^\:// if defined($missing);
            croak("ERROR: Found line definitions for invalid node(s) [$missing].\n");
        }    
    }    
}

=head2 _initialize()

This is an internal method of the module, which sets the default node definition,
mapping and line information. This gets called by the method set_default_node()
and the constructor new().

=cut

sub _initialize
{
    my $self = shift;

    $self->{_node}    = Map::Tube::Node::init();
    $self->{_line}    = Map::Tube::Node::load_line();
    $self->{_element} = Map::Tube::Node::load_element();
    $self->{_upcase}  = Map::Tube::Node::upcase_element_name();
    $self->{_table}   = _initialize_table($self->{_node});
    $self->{_user}    = 0;
    
    # Do the sanity check on all the data.
    $self->sanity_check();
}

=head2 _process_node()

This is an internal method of the module, which takes FROM node code only. This 
assumes all the node definitions are defined and map chart has been initialized.

=cut

sub _process_node
{
    my $self  = shift;
    my $from  = shift;
    my $node  = $self->{_node};
    my $table = $self->{_table};

    my (@queue, $index);
    $index = 0;
    $table->{$from}->{path}   = $from;
    $table->{$from}->{length} = $index;

    while (defined($from))
    {
        foreach (@{$node->{$from}})
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
        $from   = $self->get_next_node($from, \@queue);
        @queue  = grep(!/$from/, @queue);
    }

    $self->{_table} = $table;
}

=head2 _initialize_table()

This is an internal method and it simply initialize the map chart. It takes nodes 
definition as reference to a hash and return the table, which is also reference 
to a hash.

=cut

sub _initialize_table
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

Copyright 2010 Mohammad S Anwar.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Map::Tube