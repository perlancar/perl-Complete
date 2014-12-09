package Complete;

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

C<complete_*()> functions return completion answer structure. Completion answer
contains the completion entries as well as extra metadata to give hints to
formatters/tools. It is a hashref which can contain the following keys:

=over

=item * words => array

This key is required. Its value is an array of completion entries. A completion
entry can be a string or a hashref. Example:

 ['apple', 'apricot'] # array of strings

 [{word=>'apple', summary=>'A delicious fruit with thousands of varieties'},
  {word=>'apricot', summary=>'Another delicious fruit'},] # array of hashes

As you can see from the above, each entry can contain description (can be
displayed in shells that support them, like fish and zsh).

=item * type => str

See L<Complete::Bash>.

=item * path_sep => str

See L<Complete::Bash>.

=item * escmode => str

See L<Complete::Bash>.

=item * static => bool

Specify that completion is "static", meaning that it does not depend on external
state (like filesystem) or a custom code which can return different answer
everytime completion is requested.

This can be useful for code that wants to generate completion code, like bash
completion or fish completion. Knowing that completion for an option value is
static means that completion for that option can be answered from an array
instead of having to call code/program (faster).

=back

As a shortcut, completion answer can also be an arrayref (just the C<words>)
without any metadata.

Examples:

 # hash form
 {words=>[qw/apple apricot/]}

 # another hash form. type=env instructs formatter not to escape '$'
 {words=>[qw/$HOME $ENV/], type=>'env'}

 # array form
 ['apple', 'apricot']

 # another array form, each entry is a hashref to include description
 [{word=>'apple', summary=>'A delicious fruit with thousands of varieties'},
  {word=>'apricot', summary=>'Another delicious fruit'},] # array of hashes


=head1 SEE ALSO

=cut
