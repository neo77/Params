#!/usr/bin/perl
#*
#* Name: Params::Dry::Types
#* Info: Types definitions module
#* Author: Pawel Guspiel (neo77) <neo@cpan.org>
#*
#* This module keeps validation functions. You can of course add your modules which inherites from this and will add additional checks
#* Build in types for Params::Dry
#*
package Params::Dry::Types;
{
    use strict;
    use warnings;

# --- version ---
    our $VERSION = 1.09;

#=------------------------------------------------------------------------ { use, constants }

    use Scalar::Util 'blessed';

    use constant PASS => 1;    # pass test
    use constant FAIL => 0;    # test fail

#=------------------------------------------------------------------------ { export }

    use Exporter;              # to export _ rq and opt
    our @ISA = qw(Exporter);

    our @EXPORT_OK = qw(PASS FAIL);

    our %EXPORT_TAGS = ( const => [qw(PASS FAIL)], );

#=------------------------------------------------------------------------ { module public functions }

    #=---------
    #  String
    #=---------
    #* string type check (parameter sets max length)
    #* RETURN: PASS if test pass otherwise FAIL
    sub String {
        ref( $_[0] ) and return FAIL;
        $_[1] and length $_[0] > $_[1] and return FAIL;
        PASS;
    } #+ end of: sub String

    #=------
    #  Int
    #=------
    #* int type check Int[3] - no more than 999
    #* RETURN: PASS if test pass otherwise FAIL
    sub Int {
        ( ref( $_[0] ) or $_[0] !~ /^[+\-]?(\d+)$/ ) and return FAIL;
        $_[1] and $1 and length $1 > $_[1] and return FAIL;
        PASS;
    } #+ end of: sub Int

    #=--------
    #  Float
    #=--------
    #* float type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Float {
        ( ref( $_[0] ) or $_[0] !~ /^[+\-]?(\d+(?:\.\d+)?)$/ ) and return FAIL;
        $_[1] and $1 and length $1 > $_[1] and return FAIL;
        PASS;
    } #+ end of: sub Float

    #=-------
    #  Bool
    #=-------
    #* Bool type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Bool {
        return PASS if !ref( $_[0] ) and ( "$_[0]" eq '0' or "$_[0]" eq 1 );
        FAIL;
    } #+ end of: sub Bool

    #=---------
    #  Object
    #=---------
    #* Object type check, Object - just object, or Object(APos::core) check if is APos::core type
    #* RETURN: PASS if test pass otherwise FAIL
    sub Object {
        my $class = blessed( $_[0] );
        return FAIL if !$class;                         # not an object
        return FAIL if $_[1] and ( $_[1] ne $class );
        PASS;
    } #+ end of: sub Object

    #=------
    #  Ref
    #=------
    #* ref type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Ref {
        my $ref = ref( $_[0] ) or return FAIL;

        return FAIL if $_[1] and $ref ne $_[1];
        PASS;
    } #+ end of: sub Ref

    #=---------
    #  Scalar
    #=---------
    #* scalar type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Scalar {
        Ref( $_[0], 'SCALAR' );
    } #+ end of: sub Scalar

    #=--------
    #  Array
    #=--------
    #* array type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Array {
        Ref( $_[0], 'ARRAY' );
    } #+ end of: sub Array

    #=-------
    #  Hash
    #=-------
    #* array type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Hash {
        Ref( $_[0], 'HASH' );
    } #+ end of: sub Hash

    #=-------
    #  Code
    #=-------
    #* array type check
    #* RETURN: PASS if test pass otherwise FAIL
    sub Code {
        Ref( $_[0], 'CODE' );
    } #+ end of: sub Code

};
0115 && 0x4d;

#+ End of Params::Dry::Types
__END__
=head1 NAME

Params::Dry::Types - Build-in types for Params::Dry - Simple Global Params Management System which helps you to keep always DRY rule

=head1 VERSION

version 1.09

=head1 EXPORT

=over 4

=item * B<:const> imports PASS and FAIL constants

=back

=head1 BUILD IN TYPES

=over 4

=item * B<String> - can be used with parameters (like: String[20]) which mean max 20 chars string

=item * B<Int> - can be used with parameters (like: Int[3]) which mean max 3 chars int not counting signs

=item * B<Float> - number with decimal part

=item * B<Bool> - boolean value (can be 0 or 1)

=item * B<Object> - check if is an object. Optional parameter extend check of exact object checking ex. Object[DBI::db]

=item * B<Ref> - any reference, Optional parameter defines type of the reference

=item * B<Scalar> - short cut of Ref[Scalar]

=item * B<Array> - short cut of Ref[Array]

=item * B<Hash> - short cut of Ref[Hash]

=item * B<Code> - short cut of Ref[Code]

=back

=head1 EXTENDING INTERNAL TYPES

You can always write your module to check parameters. Please use always subnamespace of Params::Dry::Types

You will to your check function C<param value> and list of the type parameters

Example.

    package Params::Dry::Types::Super;

    use Params::Dry::Types qw(:const);

    sub String {
        Params::Dry::Types::String(@_) and $_[0] =~ /Super/ and return PASS;
        return FAIL;
    }

    ...

    package main;

    sub test {
        my $self = __@_;

        my $p_super_name = rq 'super_name', 'Super::String'; # that's all folks!

        ...
    }


=head1 AUTHOR

Pawel Guspiel (neo77), C<< <neo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-params at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Params-Dry>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Params::Dry::Types
    perldoc Params::Dry


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Params-Dry>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Params-Dry>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Params-Dry>

=item * Search CPAN

L<http://search.cpan.org/dist/Params-Dry/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Pawel Guspiel (neo77).

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


