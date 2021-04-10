
\date{2021 April 5}

Added a {\tt -zero} option to {\tt build\_watch\_list} to include 
zero-balance accounts in the watch list.  By default, they are 
excluded.

Added a {\tt -wallet} option in bitwatch which scans the wallet for 
``{\tt listunspent}'' and adds the addresses with an unspent balance to 
the watch list.  This is re-fetched on each periodic scan of new blocks 
so that the address list is always current whenever we look at new 
blocks.

Due to Perl syntactical Hell when attempting to mix explicit arrays and
references to arrays, bitwatch was only reporting the first hit on a
watched address in a block.  I rewrote the whole mess to use only
references, added all the requisite arrows and explicit dereferences
and now it appears to work OK.

Fixed some messiness with {\tt -verbose} handling in {\tt 
address\_watch}.  It makes more sense now and the output is easier to 
read.

Added the ability in {\tt confirmation\_watch} to specify the RPC 
password from the keyboard with no echo or piped from standard input.  
This is handled by a new function, {\tt getPassword(<prompt>)}, which 
we can use in other cases where passwords are required.

If no {\tt -wfile} was specified to {\tt address\_watch} but explicit 
addresses were specified with -watch, an error would be reported.  
Fixed so there's an error only if no addresses specified by either 
mechanism.

\date{2021 April 6}

Added support for unlocking and unlocking wallets in {\tt 
address\_watch} when the user has locked the wallet and {\tt -wallet} 
is specified.  The password for the wallet is read from standard input 
with echo disabled or may be specified with a command line option which 
is, of course, in a multi-user environment, hideously insecure.

Rewrote {\tt sendRPCcommand()} to accept its arguments as a reference 
to a list instead of a string it parses.  The original scheme didn't 
play nice with quoted arguments which contain spaces, as happens when 
specifying pass phrases for the RPC API and wallets.  Other than 
passing a list instead of a string, nothing has changed.

\date{2021 April 7}

Updated {\tt confirmation\_watch} to use the new list argument {\tt 
sendRPCcommand()} function.  There is just one call on this function in 
the entire program.

Integrated all of the programs into a Nuweb Literate Programming
web named {\tt bitcoin\_tools.w}.  This allows eliminating duplication
across the various programs and easier maintenance, as well as much
improved documentation.

Split the global configuration parameters, which set the default for
all settings into a separate {\tt configuration.w} Nuweb file.  These
are the settings used when their corresponding command-line option is
not specified.

\date{2021 April 8}

Completed the transition to Nuweb, breaking up over-long sequences
of code and adding documentation where appropriate.

\date{2021 April 9}

Brought the project under Git configuration control.  The
{\tt .gitignore} file excludes everything generated from the {\tt .w}
files by Nuweb, including itself.

Added statistics collection and output to {\tt address\_watch}.  The
{\tt -stats} option collects statistics on each block examined and
reports the block number, date and time, number of transactions,
total transaction size, and for both the transaction size and value
of transactions, the minimum, maximum, mean, standard deviation,
and total.  The {\tt -sfile} option collects the same information
and writes it as a record to the file specified.  In the statistics
file, the date and time is written as a Unix {\tt time()} value.

Re-enabled inclusion of the build number, date, and time in generated
files.  Since these files are excluded from the Git repository by
{\tt .gitignore}, they will not cause unnecessary update transactions.

Began implementation of the stack-oriented version of {\tt 
bitcoin\_address}.  This will increase the flexibility of generation of 
addresses by this program.  Commands allow fetching seeds from the 
command line, HotBits, {\tt /dev/random}, or {\tt /dev/urandom}.


