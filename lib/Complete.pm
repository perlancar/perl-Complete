package Complete;

use 5.010001;

# DATE
# VERSION

1;
#ABSTRACT: Completion modules family

=head1 DESCRIPTION

The namespace C<Complete::> is used for the family of modules that deal with
completion (including, but not limited to, shell tab completion, tab completion
feature in other CLI-based application, web autocomplete, etc).

C<Complete::Bash::*> modules are specific to bash shell. See L<Complete::Bash>
on how to do bash tab completion with Perl.

C<Complete::Zsh::*> modules are specific to zsh shell. See L<Complete::Zsh> on
how to do zsh tab completion with Perl.

C<Complete::Fish::*> modules are specific to fish shell. See L<Complete::Fish>
on how to do fish tab completion with Perl.

Compared to other modules, this (family of) module(s) tries to have a clear
separation between general completion routine and shell-/environment specific
ones, for more reusability.

=head2 C<complete_*()> functions

The main functions that do the actual completion are the C<complete_*()>
functions. These functions are generic completion routines: they accept the word
to be completed, zero or more other arguments, and mostly return an arrayref
containing possible completion from a specific source. They are not tied to any
environment (shell, or web). They can even be used for general purposes outside
the context of completion. Examples are C<complete_file()> (complete from list
of files in a specific directory), C<complete_env()> (complete from list of
environment variables), and so on. An example:

 use Complete::Util qw(complete_array_elem);
 my $ary = complete_array_elem(array=>[qw/apple apricot banana/], word=>'ap');
 # -> ['apple', 'apricot']

More complex C<complete_*()> functions might return a I<hashref> instead of
arrayref: it contains the completion reply (in the C<completion> keys) as well
as other metadata like hints so the formatting function can properly display
this to shell/etc. Example:

 {completion=>[qw/$HOME $ENV/], type=>'env'}

Given this data, C<Complete::Bash::format_completion()> will produce this:

 $HOME
 $ENV

However, given one of these:

 [qw/$HOME $ENV/]
 {completion=>[qw/$HOME $ENV/], type=>'filename'}

then C<format_completion()> will produce:

 \$HOME
 \$ENV

the difference is the escaping backslash for the C<$> character. There are other
hints available.


=head1 DEVELOPER'S NOTES

B<Metadata>. C<complete_*()> currently returns array of string. In some
environment like fish shell this does not provide enough metadata. In fish,
aside from string, each completion alternative has some extra metadata. For
example, when completing filenames, fish might show each possible completion
filename with type (file/directory) and file size at the right of each file
name. When completing options, it can also display a summary text for each
option. So instead of an array of strings, in the future C<complete_*()> can
also return an array of hashrefs:

 ["word1", "word2", "word3"]

versus:

 [ {word=>"word1", ...},
   {word=>"word2", ...},
   {word=>"word3", ...}, ]

B<Matching method>. Currently most C<complete_*()> routines match word using
simple string prefix matching. fish also supports matching not by prefix only,
but using wildcard. For example, if word if C<b??t> then C<bait> can be
suggested as a possible completion. fish also supports fuzzy matching (e.g.
C<house> can bring up C<horse> or C<hose>). There is also
spelling-/auto-correction feature in some shells. This mode of matching can be
added later in the various C<complete_*()> routines, turned on via a flag
argument. Or there could be helper routines for this. In general this won't pose
a problem to the API.

B<Autosuggest>. fish supports autosuggestion (autocomplete). When user types,
without she pressing Tab, the shell will suggest completion (not only for a
single token, but possibly for the entire command). If the user wants to accept
the suggestion, she can press the Right arrow key. This can be supported later
by a function in L<Complete::Fish> e.g. C<shell_complete()> which accepts the
command line string.


=head1 SEE ALSO

L<Bash::Completion>, L<Getopt::Complete>, L<Term::Completion>

L<Perinci::Sub::Complete> and C<Perinci::Sub::Complete::*> modules deal with
providing completion capability for functions that have L<Rinci> metadata.


=cut
