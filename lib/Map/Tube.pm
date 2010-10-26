package Map::Tube;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

use Map::Tube::Node;

=head1 NAME

Map::Tube - A very simple perl interface to the London Tube Map.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';


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


    use Map::Tube;

    my $map   = Map::Tube->new({from => 'Vauxhall', to => 'Euston'});
	my @route = $map->get_shortest_route();
	
    ...
	...

=head1 CONSTRUCTOR

=cut

sub new
{
	my $class = shift;
	my $param = shift;

	my $self = {};
	$self->{_node}    = Map::Tube::Node::init();
	$self->{_element} = Map::Tube::Node::load_element();
	$self->{_table}   = _initialize_table($self->{_node});
	# TODO: Validate FROM and TO name.
	$self->{_from} = $self->{_element}->{$param->{from}};
	$self->{_to}   = $self->{_element}->{$param->{to}};
	$self->{debug} = $param->{debug} || 0;
	bless $self, $class;
	return $self;
}
	
=head1 SUBROUTINES/METHODS

=head2 _process_node

=cut

sub _process_node
{
	my $self  = shift;
	my $node  = $self->{_node};
	my $from  = $self->{_from};
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
				print "Pushing to queue [$_]\n" if $self->{debug};
				sleep 1 if $self->{debug};
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

=head2 show_map_chart()

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
		print sprintf("%3s - %3s - %3s\n",$_,$path,$length);
	}
	print "-----------------\n\n";
}

=head2 get_shortest_route()

=cut

sub get_shortest_route
{
	my $self  = shift;
	
	$self->_process_node();
	my $table = $self->{_table};
	my $from  = $self->{_from};
	my $to    = $self->{_to};

	my @routes;
	while($from ne $to)
	{
		push @routes, $self->_get_name($to);
		$to = $table->{$to}->{path};
		sleep 1 if $self->{debug};
	}
	push @routes, $self->_get_name($from);
	return reverse(@routes);
}

=head2 _get_name()

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

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-map-tube at rt.cpan.org>, or through
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
