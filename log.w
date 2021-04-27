
\date{2021 April 5}

Added a {\tt -zero} option to {\tt build\_watch\_list} to include
zero-balance accounts in the watch list.  By default, they are
excluded.

Added a {\tt -wallet} option in @<AW@> which scans the wallet for
``{\tt listunspent}'' and adds the addresses with an unspent balance to
the watch list.  This is re-fetched on each periodic scan of new blocks
so that the address list is always current whenever we look at new
blocks.

Due to Perl syntactical Hell when attempting to mix explicit arrays and
references to arrays, @<AW@> was only reporting the first hit on a
watched address in a block.  I rewrote the whole mess to use only
references, added all the requisite arrows and explicit dereferences
and now it appears to work OK.

Fixed some messiness with {\tt -verbose} handling in @<AW@>.  It makes
more sense now and the output is easier to
read.

Added the ability in @<CW@> to specify the RPC
password from the keyboard with no echo or piped from standard input.
This is handled by a new function, {\tt getPassword(<prompt>)}, which
we can use in other cases where passwords are required.

If no {\tt -wfile} was specified to @<AW@> but explicit
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

Updated @<CW@> to use the new list argument {\tt
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

Added statistics collection and output to @<AW@>.  The
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

Began implementation of the stack-oriented version of
@<BA@>.  This will increase the flexibility of generation of
addresses by this program.  Commands allow fetching seeds from the
command line, HotBits, {\tt /dev/random}, or {\tt /dev/urandom}.

\date{2021 April 10}

Implemented BIP39 encoding and decoding in @<BA@>.
The BIP39-encoded phrase is output along with other formats by the
{\tt -key} command, and a seed specified by a BIP39 phrase supplied
as a string argument may be pushed onto the stack with the {\tt -phrase}
command.

Added stack underflow checking to all commands that require arguments
from the stack. The {\tt stackCheck(}$n${\tt )} function checks
if $n$ or more arguments are on the stack and errors if fewer are
present.

Implemented a proper {\tt hexToBytes()} function to convert one of our
strings of hexadecimal digits into a string of bytes composed of
pairs of digits.  Naturally, there's a {\tt bytesToHex()} to go the
other way.

Implemented an {\tt -xor} command to exclusive-or the two top items
on the stack and replace them with the result.

Added a full suite of FORTH-like stack commands: {\tt -drop},
{\tt -dup}, {\tt -over}, {\tt -pick} $n$, {\tt -roll} $n$, {\tt -rot},
and {\tt -rrot}.

Added a {\tt -type} {\em message} command to output to standard output.

\date{2021 April 11}

Added code to @<CW@> to dump the transaction if
the {\tt -verbose} level is two or above.

If a previous generation of the PDF document failed due to a syntax
error in a title appearing in the table of contents, it could torpedo a
subsequent run due to the error having been transcribed to the {\tt
.toc} document.  I added a command to the {\tt view} target in the {\tt
Makefile} to delete all of the intermediate files from the last run to
avoid this happening.

\date{2021 April 12}

Added a {\tt -wif} option to @<BA@> to extract the seed
from a private key in Wallet Import Format (WIF) and push it on the
stack.  The key may be in either compressed or uncompressed format.

\date{2021 April 16}

Now, it's back to @<AW@> to implement watching of
inputs to transactions which come from addresses we're watching.
For the application of monitoring cold storage against unauthorised
accesses, this is a critical functionality.  Doing this requires
being able to look up transactions by their transaction ID, and
to do this on a Bitcoin Core node means enabling the
{\tt txindex=1} mode on the server, which causes it to build an
index from transaction index to the block which contains the
transaction and, in turn, enable the {\tt getrawtransaction}
API call to return a transaction purely from its ID, without needing
to know in which block it appears.

Enabling this requires a complete re-scan of the archived blocks
back to the Genesis block.  At the time I did this yesterday, the
complete blockchain was 360 Gb, and performing a complete re-scan
and re-index, which you do by starting Bitcoin with:

\begin{verbatim}
    bitcoin-qt -rescan -reindex
\end{verbatim}

This starts a process which ran for around ten and a half hours, using
around two CPU cores for the first nine hours, then seven cores for the
last hour.  When it was done, the transaction index, {\tt
indexes/txindex} was 31 Gb and we were able to retrieve transactions by
ID.

Now let's start digging into the inputs side of a transaction.  Using
JSON dumps from a test transaction, we see a ``{\tt vin}'' section
which contains an array of inputs to the transaction.  Each of these
contains a ``{\tt txid}'' field with the transaction which last
modified the input and a ``{\tt vout}'' field which identifies which of
the output addresses in that transaction is being spent as an input to
this one.  To learn more about the inputs, we must look up their
transactions IDs.

Looking up each input transaction, then, we examine the item in its
``{\tt vout}'' array specified as the source, and can finally extract
the address(es) and value associated with it.  (I don't know what it
means for more than one address to be present in the
``{\tt addresses}'' field of a ``{\tt vout}''.)

With this analysis in place, I added analysis of inbound transactions
to @<AW@>.  For the cold storage monitoring application,
this is arguably the most important, since is somebody has obtained
the private key of a cold storage vault address, the first indication
will be a transfer to another address with the cold storage as the
inbound funds of the thief's transaction.  The real world blockchain
has a large number of references to the same transactions as inputs
within the block, so I implemented a cache mechanism to that we'll only
ever look up a transaction once per scan of a block.

\date{2021 April 17}

Added ``logic'' to @<CW@> which allows, when
specifying a single argument, it to be either a label looked up in the
@<AW@> {\tt -lfile} log or a transaction ID, which may be
specified without the block hash in which it resides if Bitcoin Core
has been built with {\tt txindex=1}.  This is done with a hideous
kludge which considers anything of 48 or fewer characters of which
contains a character which is not a hexadecimal digit.  If two
arguments are specified, they continue to be interpreted as a
transaction index and block hash.

Added a command to the {\tt build} target of the {\tt Makefile} to
mark all the Perl programs executable when they are re-generated.

\date{2021 April 18}

If a source of funds in a transaction was a ``coinbase'' transaction:
newly-created Bitcoin paid to miners in compensation for publishing
a block, that transaction contains no addresses in its ``{\tt vout}''
section, which caused {\tt scanBlock()} in @<AW@> to
fail with a reference an undefined variable.  I added code to detect
absence of an {\tt address} in source transactions and skip scanning
them for matches to one of our watched addresses (since newly-created
funds can't possibly come from a watched address).

\date{2021 April 19}

Added {\tt -help} option to all of the programs.  Those which share the
common RPC options use a common definition of the options imported
into the help text they print.

Added analysis of reward fees paid to miners in @<AW@>.
For each block, the value items in the ``{\tt vout}'' section of the
first transaction (which is always the ``coinbase'' reward to the
miner who published the block) are summed, giving the total reward.
The portion of that which is the current standard reward for a new
bloc, computed by the new common utility function {\tt blockReward()},
is output and subtracted to yield the portion of the reward due to
transaction fees.  This information is included in the status shown
on standard ouput by the {\tt -stats} option and in the file written
by the {\tt -sfile} option.

Converted the output of the {\tt -sfile} command to proper CSV which
may be imported directly into a spreadsheet or database.

\date{2021 April 20}

Implemented a configuration file and optional interactive command
facility.  This is driven from the same option array we use
to process command line options.  The configuration facility is
included in each program and uses its {\tt \%option} declaration
as a hidden parameter.  The function {\tt processCommand()}
parses and executes a command defined in the {\tt \%options}
hash, ignoring blank lines and ``{\tt \#}'' comments.  If an
undefined command is submitted, a warning is given if running in
interactive mode, but ignored otherwise.  This allows using a
generic configuration file which specifies options which only some
of the programs implement.

A ready-to-use {\tt arg\_inter()} argument processor is provided,
which can be invoked by a command line option (usually {\tt -inter})
to interact with the user.  Commands and arguments are read and
processed until interactive mode is exited with any of ``@{end@}'',
``@{exit@}'', ``@{quit@}'', or end of file.

The {\tt processConfiguration()} function provides configuration
file support.  Called before the program processes its command line
options, it looks for {\tt .conf} configuration files named for
the project and the specific program and, if present, processes
them in order.  Program configuration, if present, overrides that
for the overall project, and both may be overridden by command line
options.

Added a {\tt -swap} command to @<BA@>, which I had
somehow overlooked on the last pass.

Added a {\tt -binfile} command to @<BA@>, which reads
as any sequences of 32 bytes as exist in the file and pushes them, as
hexadecimal seed values, onto the stack.  In the process, I found and
fixed a bug in {\tt bytesToHex()} that caused it to be sensitive to end
of line characters in the byte stream and updated the {\tt -random} and
{\tt -urandom} commands to use the function rather than their own
built-in code.

Made the {\tt -type} command universal in all programs.  This allows
it to be used in configuration files for all programs.

Added a {\tt -test} command to @<BA@> to run a
bit-level randomness analysis of the seed on the top of the stack.
The top of the stack is unchanged.  Removed the built-in randomess
test from the {\tt key} command.

\date{2021 April 21}

Implemented a {\tt -pseudo} command in @<BA@> which
places one or more (it respects {\tt repeat}) pseudorandom seeds
generated by a Mersenne Twister generator itself seeded from
{\tt /dev/urandom} on the stack.

Added {\tt -zero} and {\tt -not} commands for stack manipulation.

Added a {\tt -shuffle} command, which shuffles all of the bytes
on the stack.  All stack items are concatenated together, shuffled
as a single byte stream, then divided back into 32 byte seeds and
pushed back onto the stack.

\date{2021 April 23}

Added a {\tt -testall} command to @<BA@> which tests
the entire contents of the stack for randomness with {\tt ent}.

\date{2021 April 24}

Tested @<AW@> with an encrypted wallet.  It turns out
that you only need to unlock the wallet with its encryption key for
functions which require private keys, such as sending funds or
(duh!) retrieving private keys.  Consequently, since the only query we
make of the wallet is {\tt listunspent}, which does not return
private keys, there is no need to worry about unlocking and re-locking
the wallet for our requests.  I commented out the unlock/lock code,
keeping it around just in case it should come in handy for some
further project which requires unlocked access to the wallet.

\date{2021 April 25}

Added a {\tt -clear} command to @<BA@> to clear the
stack.  Added a {\tt -p} command to print the top of the stack, or
report ``Stack empty.''

Added a ``{\tt bl}'' target to the {\tt Makefile} to do a {\tt build}
and then {\tt lint}, aborting the make if an error occurs in the build.

Added code to force hexadecimal letter digits to upper case when
loading seeds with {\tt -seed} or {\tt hexfile} in @<BA@>.

Our strategy in @<AW@> of purging addresses from the wallet containing
unspent funds and retrieving a new list before each scan of a block had
the consequence of failing to see the transaction which spent the funds
in a wallet address.  This happens because when using funds from a
wallet address, its balance is zeroed out and replaced with a new
address containing the change (if any).  These changes happen in the
wallet when the transaction is broadcast to the mempool, but don't
appear in the blockchain until the first confirmation for the
transaction arrives.  When that happens, however, the sending address
will no longer appear in the list returned by {\tt listunspent} since
it has been zeroed out when the transaction was broadcast.

To avoid this happening and, more critically, keep a watch for rogue
``looting transactions'' where a private key has been compromised and a
miscreant enters a transaction to transfer the entire balance of a
wallet address to a third party, every time we scan wallet addresses we
now save the time of the scan and continue to watch a wallet address
after its balance goes to zero for an interval specified by
configuration parameter ``{\tt AW wallet purge interval}'' which is set
by default to 3600 seconds (one hour).  As long as transactions do not
sit in the mempool longer than this before being confirmed, we'll not
miss the spend transaction when it arrives on the blockchain.

Added code to the {\tt -seed} command in @<BA@> to allow an optional
``{\tt 0x}'' hexadecimal specifier before the seed.

Added initial support for generation of Ethereum addresses, including
the whacky upper and lower case hexadecimal letter checksums used
by these addresses.  This appears to be working correctly, but is
pretty rough in user interface.  I'll clean this up once I've done
some more functionality testing.

\date{2021 April 26}

Added CSV output support for Ethereum address generation, including
options to use non-checksummed public addresses and include the
complete public key in the CSV file.  Fixed some CSV generation bugs
common to BTC and ETH.

Improved recovery from errors in @<BA@> interactive mode.  Stack
underflow no longer bounces you out to the command line.

Added statistics for time since last block, including an exponentially
smoothed moving average of time between recent blocks.

\subsection{Abbreviations used in this document}

@d AW @{{\tt address\_watch}@}
@d BA @{{\tt blockchain\_address}@}
@d CW @{{\tt confirmation\_watch}@}

\section{To do}

Add ability to write the stack to a file in either hex or binary form.

Accumulate value in to address as well as value out in address\_watch
and report in statistics.

Options which request passwords prompt the user interactively if given
a blank argument.


