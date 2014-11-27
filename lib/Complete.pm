package Complete;

use 5.010001;

# DATE
# VERSION

1;
#ABSTRACT: Completion modules family

=head1 DESCRIPTION

The namespace C<Complete::> is used for the family of modules that deal with
completion (including, but not limited to, shell tab completion, tab completion
feature in other CLI-based application, web autocomplete, completion in GUI,
etc). Compared to other modules, this (family of) module(s) tries to have a
clear separation between general completion routine and shell-/environment
specific ones, for more reusability.

This POD page gives an overview of the modules in C<Complete::*> namespace.

=head2 Modules

C<Complete::Bash::*> modules are specific to bash shell. See L<Complete::Bash>
on some of the ways to do bash tab completion with Perl. Other shells are also
supported. For shell-specific information, please refer to C<Complete::Zsh>,
C<Complete::Tcsh>, C<Complete::Fish>.

Other modules usually are named after the type of completion answer they
provide. For example: L<Complete::Unix> completes username/group name,
L<Complete::Util> completes from several generic sources: C<complete_array_elem>
completes from an array, C<complete_env> from a list of environment variables,
C<complete_file> from files/directories on the filesystem.

C<Complete::*> modules for non-shell environment (like browser or GUI) have not
been developed. Please check again from time to time in the future.

=head2 C<complete_*()> functions

The main functions that do the actual completion are the C<complete_*()>
functions. These functions are generic completion routines: they accept the word
to be completed, zero or more other arguments, and return a completion answer
structure (see L</"Completion answer structure">).

 use Complete::Util qw(complete_array_elem);
 my $ary = complete_array_elem(array=>[qw/apple apricot banana/], word=>'ap');
 # -> ['apple', 'apricot']

=head2 Completion answer structure

C<complete_*()> functions can return an arrayref or hashref. An example of the
arrayref form:

 ['apple', 'apricot']

That is, the completion answer is simply an array of words. However, each
element can also be a hashref to give metadata to each entry, for example:

 [{word=>'apple', summary=>'A delicious fruit with thousands of varieties'},
  {word=>'apricot', summary=>'Another delicious fruit'},]

The C<summary> can be used, e.g. by the fish shell which displays a description
beside each completion. Or by other environments as they see fit. Other metadata
can also be added to each entry's hashref.

The second form of completion answer structure is hashref. It must contain the
main key C<words> which is the same structure as the arrayref above. Aside from
C<words>, the hashref can contain extra metadata which can give hints to the
formatter on how to better format/display the answer: C<type>, C<path_sep>,
C<escmode> etc (see L<Complete::Bash> for example on what hints it understands).

 {words=>[qw/apple apricot/]}
 {words=>[qw/$HOME $ENV/], type=>'env'}

In the second example, C<Complete::Bash::format_completion()> can be instructed
to produce the final result like this:

 $HOME
 $ENV

However, given one of these:

 [qw/$HOME $ENV/]
 {words=>[qw/$HOME $ENV/], type=>'filename'}

then C<format_completion()> will produce:

 \$HOME
 \$ENV

the difference is the escaping backslash for the C<$> character.


=head1 SEE ALSO

=cut
