package Map::Tube;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

use Map::Tube::Node;

=head1 NAME

Map::Tube - A very simple perl interface to the London Tube Map.

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';


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
  
=head1 Example

  use Map::Tube;
  my $map = Map::Tube->new();
  my @route = $map->get_shortest_route('Bond Street', 'Euston');
  print "Shortest route from 'Bond Street' to 'Euston': " . join(" => ",@route) . "\n";  
  my $map   = Map::Tube->new({from => 5, to => 2});
  my @route = $map->get_shortest_route();

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
	$self->{_table}   = _initialize_table($self->{_node});
	$self->{_debug}   = $debug || 0;
	bless $self, $class;
	return $self;
}
	
=head1 METHODS

=head2 get_shortest_route()

This method accepts FROM and TO node name. It is case sensitive at the moment. However I would make it case-insensitive very soon.
It returns back the node sequence from FROM to TO.

=cut

sub get_shortest_route
{
	my $self = shift;
	my $from = shift;
	my $to   = shift;
	croak("ERROR: Either FROM/TO node is undefined.\n") 
		unless (defined($from) && defined($to));
	croak("ERROR: Received invalid FROM node $from.\n")
		unless exists $self->{_element}->{$from};
	croak("ERROR: Received invalid TO node $to.\n")
		unless exists $self->{_element}->{$to};
		
	my ($table, @routes);
	$from = $self->{_element}->{$from};
	$to   = $self->{_element}->{$to};
	
	$self->_process_node($from);
	$table = $self->{_table};
	while(defined($from) && defined($to) && ($from ne $to))
	{
		push @routes, $self->_get_name($to);
		$to = $table->{$to}->{path};
		sleep 1 if $self->{_debug};
	}
	push @routes, $self->_get_name($from);
	return reverse(@routes);
}


=head2 show_map_chart()

This method takes no parameter. It prints map chart to STDOUT generated while looking for shortest route. It has three columns by 
the title "N" - Node Code, "P" - Path to here and "L" - Length to reach "N" from "P". At the moment it dumps node code used internally,
however, I would change that to dump real node name instead soon.

=cut

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

=head2 get_nodes()

Returns all the node's map defintions.

=cut

sub get_node
{
	my $self = shift;
	return $self->{_node};
}

=head2 get_elements()

Returns all the elements i.e. node defintions.

=cut

sub get_element
{
	my $self = shift;
	return $self->{_element};
}
	
=head2 _process_node

This is an internal method of the module, which takes FROM node code only. This assumes all the node definitions are defined and
map chart has been initialized.

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

This is an internal method and it simply initialize the map chart. It takes nodes definition as reference to a hash and return 
the table, which is also reference to a hash.

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

=head2 _get_name()

This is an internal method and not exposed to the outside world. It takes node code and gives us full name of the node.
It is only called from the method get_shortest_route().

=cut

sub _get_name
{
	my $self = shift;
	my $code = shift;
	
	foreach (keys %{$self->{_element}})
	{
		return $_ if ($self->{_element}->{$_} eq $code);
	}
	return;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar@yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube@rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Map-Tube>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

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
