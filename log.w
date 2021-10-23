
\date{2021 April 5}

Added a {\tt -zero} option to {\tt build\_watch\_list} to include
zero-balance accounts in the watch list.  By default, they are
excluded.

Added a {\tt -wallet} option in @<AW@> which scans the wallet for
``{\tt listunspent}'' and adds the addresses with an unspent balance to
the watch list.  This is re-fetched on each periodic scan of new blocks
so that the address list is always current whenever we look at new
blocks.

Due to Perl syntactic Hell when attempting to mix explicit arrays and
references to arrays, @<AW@> was only reporting the first hit on a
watched address in a block.  I rewrote the whole mess to use only
references, added all the requisite arrows and explicit dereferences
and now it appears to work OK.

Fixed some messiness with {\tt -verbose} handling in @<AW@>.  It makes
more sense now and the output is easier to
read.

Added the ability in @<CW@> to specify the RPC password from the
keyboard with no echo or piped from standard input. This is handled by
a new function, {\tt getPassword(}{\em prompt}{\tt )}, which we can
use in other cases where passwords are required.

If no {\tt -wfile} was specified to @<AW@> but explicit addresses were
specified with {\tt -watch}, an error would be reported. Fixed so
there's an error only if no addresses are specified by either
mechanism.

\date{2021 April 6}

Added support for unlocking and locking wallets in {\tt
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
all settings, into a separate {\tt configuration.w} Nuweb file.  These
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
index from transaction index to the block that contains the
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
transaction IDs.

Looking up each input transaction, then, we examine the item in its
``{\tt vout}'' array specified as the source, and can finally extract
the address(es) and value associated with it.  (I don't know what it
means for more than one address to be present in the
``{\tt addresses}'' field of a ``{\tt vout}''.)

With this analysis in place, I added analysis of inbound transactions
to @<AW@>.  For the cold storage monitoring application,
this is arguably the most important, since if somebody has obtained
the private key of a cold storage vault address, the first indication
will be a transfer to another address with the cold storage as the
inbound funds of the thief's transaction.  The real world blockchain
has a large number of references to the same transactions as inputs
within the block, so I implemented a cache mechanism to that we'll only
ever look up a transaction once per scan of a block.

\date{2021 April 17}

Added ``logic'' to @<CW@> which allows, when specifying a single
argument, it to be either a label looked up in the @<AW@> {\tt -lfile}
log or a transaction ID, which may be specified without the block hash
in which it resides if Bitcoin Core has been built with {\tt
txindex=1}.  This is done with a hideous kludge which considers
anything of 48 or fewer characters or which contains a character that
is not a hexadecimal digit to be a label.  If two arguments are
specified, they continue to be interpreted as a transaction index and
block hash.

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
funds can't possibly have come from a watched address).

\date{2021 April 19}

Added a {\tt -help} option to all of the programs.  Those which share
the common RPC options use a common definition of the options imported
into the help text they print.

Added analysis of reward fees paid to miners to @<AW@>.
For each block, the value items in the ``{\tt vout}'' section of the
first transaction (which is always the ``coinbase'' reward to the
miner who published the block) are summed, giving the total reward.
The portion of that which is the current standard reward for a new
block, computed by the new common utility function {\tt blockReward()},
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
generic configuration file which specifies options that only some
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
as many sequences of 32 bytes as exist in the file and pushes them, as
hexadecimal seed values, onto the stack.  In the process, I found and
fixed a bug in {\tt bytesToHex()} that caused it to be sensitive to end
of line characters in the byte stream and updated the {\tt -random} and
{\tt -urandom} commands to use that function rather than their own
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
loading seeds with {\tt -seed} or {\tt -hexfile} in @<BA@>.

Our strategy in @<AW@> of purging addresses from the wallet containing
unspent funds and retrieving a new list before each scan of a block had
the consequence of failing to see the transaction which spent the funds
in a wallet address.  This happens because when using funds from a
wallet address, its balance is zeroed out and replaced with a new
address containing the change (if any).  These changes happen in the
wallet when the transaction is broadcast to the mempool, but don't
appear on the blockchain until the first confirmation for the
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

\date{2021 April 28}

Added code which causes specifying the null string as an RPC password
to prompt the user to enter the password from the console.  Changed the
option to specify the RPC password to {\tt -rpcpass}.

\date{2021 May 1}

Updated the code in @<CW@> which looks up wallet labels and addresses
in the @<AW@> log file to parse the new CSV format of that file.
Changed the logic to search the log file for all references to the
specified address and use the transaction ID and block hash of the most
recently added transaction involving that address, not the oldest.
Completed major sections of the User Guide for @<AW@> and @<CW@>.

\date{2021 May 2}

Removed the median transaction fee from the type 2 block fee statistics
output and logged by @<FW@>.  This is not the median fee rate, as I
misunderstood it to be, but the median {\em fee} for transactions in
the block, which is useless for our statistical analysis purposes.

Added User Guide section for @<FW@>, including documenting its log file
format.

\date{2021 May 3}

Moved all of the Perl files generated from the web to a new {\tt perl}
subdirectory and adjusted output file commands and the {\tt Makefile}
accordingly.

Created a new {\tt run} subdirectory, which will not be included in the
distribution, containing symbolic links to the programs in the {\tt
perl} directory and all of the configuration, log, and status files
needed to run them locally.  This will make it convenient to test and
run in production locally without contaminating the development and
distribution files with any local configuration information.  The {\tt
run} directory is excluded from the Git repository.

Renamed the project and all derivative files {\tt blockchain\_tools}.
This required a little wizardry in the intermediate steps to get the
{\tt Makefile} to build the right thing, but once changed all is well.

Renaming the Perl destination directory broke the code which checks for
and loads a program-specific configuration file.  Fixed to ignore a
directory prefix before the program name.

\date{2021 August 14}

Added an {\tt -outfile} command to @<BA@> to redirect the output of
key generation commands to the specified file.

\date{2021 August 15}

Added the ability to extract the User Guide from the integrated
document for the program.  This is controlled by declarations within
the \LaTeX\ code in the web file.  Code which should not be included
in the User Guide is bracketed by statements:

\begin{quotation}
\noindent
\verb+\expunge{begin}{userguide}+\\
\verb+\expunge{end}{userguide}+
\end{quotation}

and code which is to be included only in the User Guide is declared
with:

\begin{quotation}
\noindent
\verb+\impunge{userguide}{+{\em \TeX\ code}\verb+}+
\end{quotation}

A new {\tt guide} target in the {\tt Makefile} generates the complete
User Guide document, then runs {\tt sed} filters over it to remove
everything marked to be expunged and expand the material which appears
only in the User Guide, compiles the document, and displays the
resulting PDF\@@.  The {\tt geek} target just views this PDF.

These targets are intended for the development cycle.  For release,
a general target to build distribution files will be added and used.

\date{2021 August 16}

Renamed the paper wallet generation program @<PW@> and the cold storage
wallet validator to @<VW@> to be consistent with the other programs in
the package.

Added the ability to specify the font family, size, and weight to be
used to display addresses and keys in @<PW@>.

Added a {\tt -separator} option to @<PW@> to insert user-defined
separators between groups of four characters in paper wallet addresses
and keys.  The @<VW@> program now ignores separators in addresses
it validates.

\date{2021 August 23}

Added {\tt *.py} files to the list of those not included in the
repository via {\tt .gitignore}.

Integrated the @<CC@> program into the main web.

Updated the ``{\tt make stats}'' target to count lines of Python
programs as well as Perl.

\date{2021 August 31}

The {\tt -wfile} parser in @<AW@> was befuddled by blank lines and
comments which we permit in other programs.  I added code to ignore
them and also to ignore any Ethereum addresses which might be present
in a composite cold storage listing.  In addition, I corrected the
parser to take the balance from the fourth field, after the blank
private key field we added for compatibililty with other programs.

\date{2021 September 1}

In @<CC@>, the expression ``{\tt -SATOSHI}'', where ``{\tt SATOSHI}''
is a Perl {\tt use constant} declaration, caused a warning on Juno,
which has an older version of Perl (5.16 as opposed to 5.30 on Hayek
and Ragnar).  I rewrote the expression as ``{\tt -(SATOSHI)}'' and
the warning went away.

\date{2021 September 2}

In @<CC@>, changed the handling of API failures so that the
message appears in the warning/error field of the report instead
of the current balance.  This triggers display of the address item
when {\tt -verbose} is not set.

\date{2021 September 3}

In @<BA@>, added an option to the {\tt -format} command, ``{\tt k}'',
which causes the {\tt -btc} and {\tt -eth} commands to preserve the
keys on the stack from which they generate addresses.  This allows
generating key/address pairs multiple times in various formats using
the same source keys.  This can be cancelled by entering a new
{\tt -format} without the option.

Added a ``{\tt b}'' (Bowdlerise) option to the {\tt -format} command
in @<BA@> which causes the private key to be excluded from {\tt CSV}
format output, allowing it to be used with utilities such as @<CC@>
and @<AW@> without compromising security.

\date{2021 September 4}

Replaced our own function to shuffle the order of items in an array
with the {\tt List::Util shuffle()} function in @<CC@> and @<MK@>.  The
shuffling of bytes on the stack performed by the @<BA@>'s {\tt
-shuffle} command continues to be done by a custom function which uses
the higher-quality Mersenne Twister pseudorandom generator in the
interest of security.

Integrated @<MK@> into the main web.

\date{2021 September 5}

Replaced hard-coded in-line accesses to {\tt /dev/random} and
{\tt /dev/urandom} with calls to the Perl module
{\tt Crypt::Random::Seed}, which provides access to these facilities
on systems that support them and alternatives on others which do not.
If no strong generator is available, the {\tt -random} command in
@<BA@> will report an error and do nothing.

Added {\tt -help} option support to @<MK@> and @<PW@>.

\date{2021 September 6}

Made the {\tt -dump} command in @<BA@> write its output to a file if
{\tt -outfile} has diverted it from the console.  The output is
written in such a format and order that {\tt -hexfile} will
reload it onto the stack.

Modified the {\tt -help} command in @<BA@> so it doesn't exit
if invoked in interactive ({\tt -inter}) mode.

Added a {\tt -bindump} command to @<BA@> which writes the entire
contents of the stack in binary to a specified file.  Such files can
be loaded back onto the stack with the {\tt -binfile} command.

Replaced all \verb+\ref{LBL}+ references with \verb+\hyperref[LBL]{}+
wrapped around the referenced text.

\date{2021 September 7}

Fixed page numbering in the PDF, where the last two pages of the
table of contents had Arabic rather than Roman numbers.

Modified handling of {\tt -inter} mode in @<BA@> so a blank line does
not terminate interactive mode, but is simply ignored.

Added a ``Project Version'' declaration in the Introduction and used
it as the version number in the document and distribution archive.

Began the process of building distributions for release in the {\tt
Makefile}.  Added a {\tt dist} target which copies the generated Perl
and Python files to a {\tt bin} directory, where there are pre-created
symbolic links to invoke the programs without the file type extension,
and to copy the PDF documentation to a {\tt doc} directory.  A new {\tt
release} target builds a gzipped tar archive containing the web files,
the {\tt Makefile}, and the {\tt bin}, {\tt doc}, {\tt figures}, and
{\tt tools} directories.  I have yet to see if this is sufficient to
rebuild everything from bare metal.

\date{2021 September 8}

Added {\tt README.md}, {\tt LICENSE.md}, and {\tt CONTRIBUTING.md} to
the main archive in preparation for publication on GitHub.

\date{2021 September 9}

Renamed the @<BA@> command {\tt -sha256} to {\tt -sha2} to make room
for support of SHA3.

Modified the {\tt -sha2} command in @<BA@> to respond to the
{\tt -repeat} setting.  It now computes the 256 bit digest of the
concatenation of the specified number of items, top to bottom being
concatenated left to right, and replaces them with the digest.

Added a {\tt -sha3} command which computes SHA-3 digests in the
same manner as {\tt -sha2}.

Rationalised the handling of AES encryption and decryption in @<BA@>.
The main problem in providing a useful encryption and decryption
facility is the requirement that all of the objects upon which @<BA@>
operates be 256 bit quantities.  Typical use of AES encryption in,
for example, cipher-block-chaining mode, is not length-preserving:
the encrypted text is longer than the plaintext, with a header
containing the (usually random) initial vector used to encrypt it.
This complete message is required, then, to decrypt the shorter
plaintext.  But since things we might want to encrypt are 256 bits
and we can only pass quantities of that length along our pipelines,
there's a problem.

But consider what this might be used for in our application: almost
always encrypting private keys so that they may be stored separately
from the encryption key in the interest of security.  (Of course, for
most such applications, splitting keys into parts with @<MK@> is a
better solution.)  The main rationale for a random initial vector is to
avoid known plaintext attacks.  But the private keys that people will
be encrypting will be near-maximal entropy random or pseudorandom bit
strings (unless the user is doing something stupid which, of course,
with a toolbox utility like this, they are entitled to do).
Consequently, the additional security provided by a random initial
vector is not as important as for potentially low entropy text.  To
maintain a secure form of encryption and not increase message length,
we synthesise an initial vector from the encryption key, forming its
256 bit SHA2 digest, then use the first 16 bytes of this as the
initial vector.  Used with the cipher feedback mode and no header, the
encrypted data remain 256 bits long.  To decrypt it with the key, we
rebuild the initial vector from the key, then pass it to decryption.

Encryption is now done by an {\tt -aesenc} command with decryption
performed by {\tt -aesdec}, both of which take the encryption key from
the top of the stack and the plaintext or codetext from the second item
and place the result back on the stack.

Building the initial vector from the key may not have the crystalline
purity of a purely random initial vector, but it not only preserves
message length by allowing us to dispense with a header, it also has
the salutary effect of making the codetext produced by encrypting data
with a key deterministic, which allows it to be easily checked in
regression tests.

Modified the {\tt -test} command in @<BA@> to respect the {\tt -repeat}
setting, allowing any number of items to be tested.  The {\tt -testall}
command is thus no longer strictly necessary, but left in as a
convenience so you don't have to fiddle with the repeat setting when
loading keys from a binary or hexadecimal file, for example.

Modified @<BA@>'s {\tt -shuffle} command to respect the {\tt -repeat}
setting instead of blindly shuffling the entire contents of the stack.
This also provides the useful capability to shuffle just the bytes of
the top item on the stack.

Fixed the flaw that caused @<BA@> to blow out to the command line when
something was entered that {\tt processCommand()} could not parse.

Added a {\tt -pseudoseed} command to @<BA@> to facilitate regression
testing.  It seeds the pseudorandom number generator with up 78 seeds
with the number set by {\tt -repeat} (additional values are ignored
and left on the stack), representing the maximum of 624 32-bit state
values used by Mersenne Twister.

\date{2021 September 10}

Added a regression test in a new subdirectory {\tt test/test.sh}.
This tests all of the stand-alone blockchain utilities: @<BA@>,
@<CC@>, @<MK@>, @<PW@>, @<VW@>.  The Bitcoin node monitoring
utilities are not tested, as configuring access to a full Bitcoin
node is more complicated to arrange.  The test may be run from a
new {\tt Makefile} target, ``{\tt regress}''.  When the test is run,
it compares the output to a reference file,
{\tt test/test\_log\_expected.txt}.  If discrepancies are found, the
{\tt diff} is shown and an exit status of 1 is returned, which will
cause {\tt make} to report the failure.  If a change to the test
or the environment in which it runs requires the reference output to
be updated, the make target {\tt regress\_update} will copy the most
recent test run output to the reference master.

Added decoding of Bitcoin mini private keys to @<BA@> with the {\tt
-minikey} command.  Both the standard 30 character format and legacy 22
character form used by Series 1 Casascius physical Bitcoin tokens are
accepted.

Added generation of Bitcoin mini private keys to @<BA@> with the {\tt
-minigen} command.  Due to the screwball way mini keys are ``found'',
this command combines generation of seeds with creation of keys and
does not take seeds off the stack.  Only the current standard 30
character mini keys are produced; the (even more) insecure legacy 22
character format is not supported.

Added tests of {\tt -minikey} to the regression test.

To aid in regression testing where we want to test things which are
usually non-deterministic, I added a {\tt -testmode} command to @<BA@>.
This sets a bit-coded value, initially zero, to select test modes. The
only bit currently used is 1, which causes {\tt -minigen} to not mix
input from the local fast entropy source into the key, and thus behave
deterministically and repeatably.

Added some ``big hack attack'' code to the Makefile {\tt regress}
target to check for the all-too-frequent omission of running ``{\tt
make dist}'' before running the regression test, and thus using an
older version of the code.  We just check one of the Perl programs,
counting on the discrepancy in build number being the same in all
generated code.

\date{2021 September 11}

Added a {\tt -testmode 4} bit to print all of the modules loaded
by @<BA@> by the time it finally exits.

Added support for multi-part keys in @<PW@>.  If the key file has an
initial record with the special label ``{\tt -1}'', the multi-part
parameters are parsed and used to label the printed pages for that
part with a heading of ``Part $i$ of $n$ ($k$ needed)''.

Added tests for creation of paper wallets from multi-part keys to the
regression test.

\date{2021 September 12}

Extended the {\tt sendRPCcommand()} function used by all the utilities
that interact with a Bitcoin node to accept RPC arguments which are
JSON lists.  These are tricky and messy to handle, as each of our
access methods: {\tt local}, {\tt rpc}, and {\tt ssh} require different
quoting of the argument to make it through correctly to the JSON
request received by the API.

Fixed @<CW@> so that when it displays the time a confirmation was
received, it shows the time of the most recent block at the time the
confirmation arrived.  Previously, it always showed the time of the
block containing the transaction when it first appeared on the
blockchain.

Logged on to github.com.

Created a new {\tt blockchain\_tools} repository with access URLs:
\begin{description}
\dense
\item[HTTPS]{\tt https://github.com/Fourmilab/blockchain\_tools.git}
\item[SSH]{\tt git@@github.com:Fourmilab/blockchain\_tools.git}
\end{description}

Linked the local repository to the GitHub archive:\\
    {\tt git remote add origin git@@github.com:Fourmilab/blockchain\_tools.git}

Confirmed that my local ``{\tt git sync}'' command works with the
remote repository.

The documents in the repository root now work properly.

\date{2021 September 13}

Implemented the {\tt -testmode} option in @<CW@> to allow easy testing
without the need to submit a transaction or find one in a recent block.
When set, @<CW@> scans the most recent block (and more, if necessary)
to find a transaction with a single confirmation and uses its
transaction ID and block hash instead of requiring they be specified
from the command line or the @<AW@> log file.  This is useless for
normal user cases, but it makes testing much simpler.

\date{2021 September 17}

Added Ethereum and Bitcoin logos to title page of PDF documents.

\date{2021 September 19}

Added a {\tt -sort} option to @<CC@> which accumulates all of the
output records from a pass of queries of the watched addresses
and sorts them back into the order the addresses were specified in
the files named on the command line.  This makes the output easier to
interpret but defers output until all addresses have been
queried.

\date{2021 October 15}

Added the {\tt test} subdirectory to the distribution archive so that
the regression test may be run after building from it.

Added instructions for rebuilding from the distribution archive to
the ``Installation'' section of the documents.

Updated {\tt test/watch\_addrs.csv} to replace some volatile Ethereum
addresses with ones I hope will be more stable.

\date{2021 October 17}

Integrated the regression test into the main web.  The
{\tt watch\_addrs.csv} file it uses to test @<CC@> is also defined in
the web.

Replaced watched addresses for the regression test with well-known
dormant Bitcoin addresses and likely typographic error Ethereum
addresses.

\date{2021 October 19}

Removed the build number and date from {\tt test/test.sh} and
{\tt test/watch\_addrs.csv} to avoid proliferating changes to the
Git archive for changes only to build ID.

\date{2021 October 20}

Release 1.0, Build 806.

\date{2021 October 23}

Removed the {\tt Makefile} from {\tt .gitignore} so it is included
in the Git repository.  It is needed to bootstrap the build process.

Release 1.0.1, Build 808.
