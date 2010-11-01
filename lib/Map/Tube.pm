package Map::Tube;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

use Map::Tube::Node;

=head1 NAME

Map::Tube - A very simple perl interface to the London Tube Map.

=head1 VERSION

Version 1.2

=cut

our $VERSION = '1.2';


=head1 SYNOPSIS

Here is sample map

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

=head1 Description

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
  
=head1 Example

  use Map::Tube;
  my $map = Map::Tube->new();
  my @route = $map->get_shortest_route('Bond Street', 'Euston');
  print "Shortest route from 'Bond Street' to 'Euston': " . join(" => ",@route) . "\n";  

  Output:
  Shortest route from Bond Street to Euston: Bond Street => Oxford Circus => Warren Street => Euston

=cut
  
=head1 CONSTRUCTOR

The constructor expects an optional debug flag which is 0(false) by default.

=cut

sub new
{
    my $class = shift;
    my $debug = shift;

    my $self = {};
    $self->{_node}    = Map::Tube::Node::init();
    $self->{_element} = Map::Tube::Node::load_element();
    $self->{_upcase}  = Map::Tube::Node::upcase_element_name();
    $self->{_table}   = _initialize_table($self->{_node});
    $self->{_debug}   = $debug || 0;
    $self->{_user}    = 0;
    bless $self, $class;
    return $self;
}
    
=head1 METHODS

=head2 get_shortest_route()

This method accepts FROM and TO node name. It is case insensitive. It returns back 
the node sequence from FROM to TO.

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
        
    my ($table, @routes);
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
    return reverse(@routes);
}

=head2 set_node()

This method accept the node defintion from user. It does some basic check i.e. the 
node data has to be reference to a HASH and each key has a value which is a reference 
to an ARRAY. It doesn't, however, checks the mapping currently. Beware if you have any
error in mapping, you might get an awkard response. Please note key of each node
has to be a string. For example refer to unit test case [test-case-14.t].

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
}

=head2 set_default_node()

This method set the default node definition.

=cut

sub set_default_node
{
    my $self = shift;
    $self->{_node}    = Map::Tube::Node::init();
    $self->{_element} = Map::Tube::Node::load_element();
    $self->{_upcase}  = Map::Tube::Node::upcase_element_name();
    $self->{_table}   = _initialize_table($self->{_node});
    $self->{_user}    = 0;
}

=head2 get_node()

Returns all the node's map defintions.

=cut

sub get_node
{
    my $self = shift;
    return $self->{_node};
}

=head2 get_element()

Returns all the elements i.e. node defintions.

=cut

sub get_element
{
    my $self = shift;
    return $self->{_element};
}

=head2 show_map_chart()

This method takes no parameter. It prints map chart to STDOUT generated while 
looking for shortest route. It has three columns by the title "N" - Node Code, 
"P" - Path to here and "L" - Length to reach "N" from "P". At the moment it 
dumps node code used internally, however, I would change that to dump real 
node name instead soon.

=cut

=head2 get_name()

This method takes a node code and returns its name. If the node belongs to user
defined mapping then it simply returns the node code itself.

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

sub show_map_chart
{
    my $self  = shift;
    my $table = $self->{_table};
    print " N  -  P  -  L\n----------------\n";
    foreach (sort keys %{$table})
    {
        my $path   = (defined($table->{$_}->{path}))?($table->{$_}->{path}):('');
        my $length = (defined($table->{$_}->{length}))?($table->{$_}->{length}):('');
        print {*STDOUT} sprintf("%3s - %3s - %3s\n",$_,$path,$length);
    }
    print "-----------------\n\n";
}
    
=head2 _process_node

This is an internal method of the module, which takes FROM node code only. This 
assumes all the node definitions are defined and map chart has been initialized.

=cut

sub _process_node
{
    my $self  = shift;
    my $from  = shift;
    my $node  = $self->{_node};
    my $table = $self->{_table};

    my (@queue, $index, $continue);
    $index = 0;
    $table->{$from}->{path}   = $from;
    $table->{$from}->{length} = $index;
    while(1)
    {
        $continue = 0;
        foreach (@{$node->{$from}})
        {
            if (!defined($table->{$_}->{length}) || ($table->{$from}->{length} > ($index+1)))
            {
                $table->{$_}->{length} = $table->{$from}->{length}+1;
                $table->{$_}->{path}   = $from;
                push @queue, $_;
                print "Pushing to queue [$_]\n" if $self->{_debug};
                sleep 1 if $self->{_debug};
                $continue = 1;
            }
        }
        last unless ($continue || scalar(@queue));
        $index = $table->{$from}->{length}+1;
        $from  = shift(@queue);
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
