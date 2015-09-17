package Complete::Setting;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $OPT_CI          = ($ENV{COMPLETE_OPT_CI}          // 1) ? 1:0;
our $OPT_FUZZY       = ($ENV{COMPLETE_OPT_FUZZY}       // 1)+0;
our $OPT_MAP_CASE    = ($ENV{COMPLETE_OPT_MAP_CASE}    // 1) ? 1:0;
our $OPT_EXP_IM_PATH = ($ENV{COMPLETE_OPT_EXP_IM_PATH} // 1) ? 1:0;
our $OPT_DIG_LEAF    = ($ENV{COMPLETE_OPT_DIG_LEAF}    // 1) ? 1:0;

1;
#ABSTRACT: Common settings for completion routines

=head1 DESCRIPTION

This module defines some configuration variables. C<Complete::*> modules should
use the default from these settings, to make it convenient for users to change
some behaviors globally.

The defaults are optimized for convenience and laziness for user typing and
might change from release to release.

=head2 C<$Complete::Setting::OPT_CI> => bool (default: from COMPLETE_OPT_CI or 1)

If set to 1, matching is done case-insensitively. This setting should be
consulted as the default for all C<ci> argument in the C<complete_*> functions.
But users can override this setting by providing value to C<ci> argument.

In bash/readline, this is akin to setting C<completion-ignore-case>.

=head2 C<$Complete::Setting::OPT_FUZZY> => int (default: from COMPLETE_OPT_FUZZY or 1)

Enable fuzzy matching. The greater the number, the greater the tolerance. To
disable fuzzy matching, set to 0. This setting should be consulted for every
C<fuzzy> argument in the C<complete_*> functions. But users can override this
setting by providing value to C<fuzzy> argumnt.

=head2 C<$Complete::Setting::OPT_MAP_CASE> => bool (default: from COMPLETE_OPT_MAP_CASE or 1)

This is exactly like C<completion-map-case> in readline/bash to treat C<_> and
C<-> as the same when matching.

All L<Complete::Path>-based modules (like L<Complete::File>,
L<Complete::Module>, or L<Complete::Riap>) respect this setting.

=head2 C<$Complete::Setting::OPT_EXP_IM_PATH> => bool (default: from COMPLETE_OPT_EXP_IM_PATH or 1)

Whether to "expand intermediate paths". What is meant by this is something like
zsh: when you type something like C<cd /h/u/b/myscript> it can be completed to
C<cd /home/ujang/bin/myscript>.

All L<Complete::Path>-based modules (like L<Complete::File>,
L<Complete::Module>, or L<Complete::Riap>) respect this setting.

=head2 C<$Complete::Setting::OPT_DIG_LEAF> => bool (default: from COMPLETE_OPT_DIG_LEAF or 1)

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

Set default for C<$Complete::Setting::OPT_CI>.

=head2 COMPLETE_OPT_FUZZY => int

Set default for C<$Complete::Setting::OPT_FUZZY>.

=head2 COMPLETE_OPT_MAP_CASE => bool

Set default for C<$Complete::Setting::OPT_MAP_CASE>.

=head2 COMPLETE_OPT_EXP_IM_PATH => bool

Set default for C<$Complete::Setting::OPT_EXP_IM_PATH>.

=head2 COMPLETE_OPT_DIG_LEAF => bool

Set default for C<$Complete::Setting::OPT_DIG_LEAF>.


=head1 SEE ALSO

L<Complete>

=cut
