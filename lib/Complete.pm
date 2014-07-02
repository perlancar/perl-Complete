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

Many of the C<Complete::*> modules (like, e.g. L<Complete::Perl>,
L<Complete::Module>, L<Complete::Unix>, L<Complete::Util>) contains
C<complete_*()> functions. These functions are generic, "low-level" completion
routines: they accept the word to be completed, zero or more other arguments,
and return an arrayref containing possible completion from a specific source.
They are not tied to any environment (shell, or web). They can even be used for
general purposes outside the context of completion. Examples are:
C<complete_file()> (complete from list of files in a specific directory),
C<complete_env()> (complete from list of environment variables), and so on.

C<Complete::Bash::*> modules are specific to bash shell. See L<Complete::Bash>
on how to do bash tab completion with Perl.

C<Complete::Zsh::*> modules are specific to zsh shell. See L<Complete::Zsh> on
how to do zsh tab completion with Perl.

C<Complete::Fish::*> modules are specific to fish shell. See L<Complete::Fish>
on how to do fish tab completion with Perl.

Compared to other modules, this (family of) module(s) tries to have a clear
separation between general completion routine and shell-/environment specific
ones, for more reusability.


=head1 SEE ALSO

L<Bash::Completion>

L<Getopt::Complete>

L<Perinci::Sub::Complete> and C<Perinci::Sub::Complete::*> modules deal with
providing completion capability for functions that have L<Rinci> metadata.


=cut
