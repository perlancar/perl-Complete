package Complete;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $OPT_CI          = ($ENV{COMPLETE_OPT_CI}          // 1) ? 1:0;
our $OPT_MAP_CASE    = ($ENV{COMPLETE_OPT_MAP_CASE}    // 1) ? 1:0;
our $OPT_EXP_IM_PATH = ($ENV{COMPLETE_OPT_EXP_IM_PATH} // 1) ? 1:0;
our $OPT_EXP_IM_PATH_MAX_LEN = ($ENV{COMPLETE_OPT_EXP_IM_PATH_MAX_LEN} // 2)+0;
our $OPT_DIG_LEAF    = ($ENV{COMPLETE_OPT_DIG_LEAF}    // 1) ? 1:0;

1;
#ABSTRACT: Convention for Complete::* modules family and common settings

=head1 DESCRIPTION

The namespace C<Complete::> is used for the family of modules that deal with
completion (including, but not limited to, shell tab completion, tab completion
feature in other CLI-based application, web autocomplete, completion in GUI,
etc). This (family of) modules try to have a clear separation between general
completion routine and shell-/environment specific ones, for more reusability.

This POD page gives an overview of the modules in C<Complete::*> namespace,
establishes convention, and declares common settings.

=head2 Modules

=head3 Generic (non-environment-specific) modules

Modules usually are named after the type of completion answer they provide. For
example: L<Complete::Unix> completes username/group name,
L<Complete::Getopt::Long> completes from L<Getopt::Long> specification,
L<Complete::Module> completes Perl module names, and so on. A current exception
is L<Complete::Util> which contains several routines to complete from
common/generic sources (array, hash, file, environment).

=head3 Environment-specific modules

C<Complete::Bash::*> modules are specific to bash shell. See L<Complete::Bash>
on some of the ways to do bash tab completion with Perl. Other shells are also
supported. For shell-specific information, please refer to L<Complete::Zsh>,
L<Complete::Tcsh>, L<Complete::Fish>, as well as their submodules.

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

Convention for C<complete_*> function:

=over

=item * Accept a hash argument

Example:

 complete_array_elem(%args)

Required arguments: C<word> (the word to be completed). Sometimes, for
lower-level functions, you can accept C<words> and C<cword> instead of C<word>,
For example, in function C<Complete::Getopt::Long::complete_cli_arg>.

Optional common arguments: C<ci> (bool, whether the matching should be
case-insensitive, if unspecified should default to C<$Complete::OPT_CI>).

Other arguments: you can define more arguments as you fit. Often there is at
least one argument to specify or customize the source of completion, for example
for the function C<Complete::Util::complete_array_elem> there is an C<array>
argument to specify the source array.

=item * Return completion answer structure

See L</"Completion answer structure">.

=item * Use defaults from global Complete settings, when applicable

See L<"/SETTINGS">

=back

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

=item * esc_mode => str

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


=head1 SETTINGS

This module also defines some configuration variable. C<Complete::*> modules
should use the default from these settings, to make it convenient for users to
change some behavior globally.

The defaults are optimized for convenience and laziness for user typing and
might change from release to release.

=head2 C<$Complete::OPT_CI> => bool (default: from COMPLETE_OPT_CI or 1)

If set to 1, matching is done case-insensitively. This setting should be
consulted as the default for all C<ci> arguments in the C<complete_*> functions.
But users can override this setting by providing value to C<ci> argument.

In bash/readline, this is akin to setting C<completion-ignore-case>.

=head2 C<$Complete::OPT_MAP_CASE> => bool (default: from COMPLETE_OPT_MAP_CASE or 1)

This is exactly like C<completion-map-case> in readline/bash to treat C<_> and
C<-> as the same when matching.

All L<Complete::Path>-based modules (like L<Complete::Util>'s
C<complete_file()>), L<Complete::Module>, or L<Complete::Riap> respect this
setting.

=head2 C<$Complete::OPT_EXP_IM_PATH> => bool (default: from COMPLETE_OPT_EXP_IM_PATH or 1)

Whether to "expand intermediate paths". What is meant by this is something like
zsh: when you type something like C<cd /h/u/b/myscript> it can be completed to
C<cd /home/ujang/bin/myscript>.

All L<Complete::Path>-based modules (like L<Complete::Util>'s
C<complete_file()>, L<Complete::Module>, or L<Complete::Riap>) respect this
setting.

=head2 C<$Complete::OPT_EXP_IM_PATH_MAX_LEN> => int (default: from COMPLETE_OPT_EXP_IM_PATH_MAX_LEN or 2)

Wehn OPT_EXP_IM_PATH is active, because of the way bash does completion (it cuts
current word to the shortest common denominator of all completion candidates),
in some cases this can be annoying because it prevents completion to be done the
way we want. For example:

 l/D/Zi/Plugi/Author<tab>

if we have:

 lib/Dist/Zilla/Plugin/Author/
 lib/Dist/Zilla/PluginBundle/Author/

the completion candidates are both the above, and bash cuts our word at the
buffer to:

 lib/Dist/Zilla/Plugin

even if we type C</> and then Tab like this:

 lib/Dist/Zilla/Plugin/<tab>

bash will again cuts the buffer to become:

 lib/Dist/Zilla/Plugin

To work around (or compromise around) this, the setting
C<OPT_EXP_IM_PATH_MAX_LEN> is introduced. The default is 2. So if a path element
is over 2 characters long, expand will not be done. This means in this path:

 l/D/Zi/Plugi/Author<tab>

we expand C<l>, C<D>, C<Zi>, but not C<Plugi>. So to get expansion you'll have
to write:

 l/D/Zi/P/Author<tab>
 l/D/Zi/Pl/Author<tab>

which is usually fine.

=head2 C<$Complete::OPT_DIG_LEAF> => bool (default: from COMPLETE_OPT_DIG_LEAF or 1)

(Experimental) When enabled, this option mimics what's seen on GitHub. If a
directory entry only contains a single subentry, it will directly show the
subentry (and subsubentry and so on) to save a number of tab presses.

Suppose you have files like this:

 a
 b/c/d/e
 c

If you complete for C<b> you will directly get C<b/c/d/e> (the leaf).

This is currently experimental because if you want to complete only directories,
you won't get b or b/c or b/c/d. Need to think how to solve this.


=head1 ENVIRONMENT

=head2 COMPLETE_OPT_CI => bool

Set default for C<$Complete::OPT_CI>.

=head2 COMPLETE_OPT_MAP_CASE => bool

Set default for C<$Complete::OPT_MAP_CASE>.

=head2 COMPLETE_OPT_EXP_IM_PATH => bool

Set default for C<$Complete::OPT_EXP_IM_PATH>.

=head2 COMPLETE_OPT_EXP_IM_PATH_MAX_LEN => int

Set default for C<$Complete::OPT_EXP_IM_PATH_MAX_LEN>.

=head2 COMPLETE_OPT_DIG_LEAF => bool

Set default for C<$Complete::OPT_DIG_LEAF>.


=head1 SEE ALSO

=cut
