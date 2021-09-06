\documentclass{report}

%    ****** TURN OFF HARDWARE TABS BEFORE EDITING THIS DOCUMENT ******
%
%   Should you ignore this admonition, tabs in the program code will
%   not be respected in the LaTeX-generated program document.
%   If that should occur, simply pass this file through
%   expand to replace the tabs with sequences of spaces.

%   This document MUST be edited with a utility that understands
%   and displays Unicode characters in the UTF-8 encoding.

%   This program is written using the Nuweb Literate Programming
%   tool:
%
%           http://sourceforge.net/projects/nuweb/
%
%   For information about Literate Programming, please visit the
%   site:   http://www.literateprogramming.com/

\setlength{\oddsidemargin}{0cm}
\setlength{\evensidemargin}{0cm}
\setlength{\topmargin}{0cm}
\addtolength{\topmargin}{-\headheight}
\addtolength{\topmargin}{-\headsep}
\setlength{\textheight}{22.5cm}
\setlength{\textwidth}{16.5cm}
\setlength{\marginparwidth}{1.25cm}
\setcounter{tocdepth}{6}
\setcounter{secnumdepth}{6}
\newcommand{\dense}{\setlength{\itemsep}{-1ex}}
\newcommand{\expunge}[2]{}
\newcommand{\impunge}[2]{}

\let\cleardoublepage\clearpage

%   Space between paragraphs, don't indent
\usepackage[parfill]{parskip}

%   Keep section numbers from colliding with title in TOC
\usepackage{tocloft}
\cftsetindents{subsection}{4em}{4em}
\cftsetindents{subsubsection}{6em}{5em}

%   Enable PDF output and hyperlinks within PDF files
\usepackage[unicode=true,pdftitle={Fourmilab Blockchain Tools},pdfauthor={John Walker},colorlinks=true,linkcolor=blue,urlcolor=blue]{hyperref}

%   Enable inclusion of graphics files
\usepackage{graphicx}

%   Enable proper support for appendices
\usepackage[toc,titletoc,title]{appendix}

%   Support text wrapping around figures
\usepackage{wrapfig}

%   Add additional math notation, including \floor and \ceil
\usepackage{mathtools}

\expunge{begin}{userguide}
\title{\bf Fourmilab Blockchain Tools}
\expunge{end}{userguide}
\impunge{userguide}{\title{\bf Fourmilab Blockchain Tools\\ User Guide}}

\author{
    by \href{http://www.fourmilab.ch/}{John Walker}
}
\date{
    Version 1.0 \\
    September 2021 \\
    \vspace{12ex}
    \includegraphics[width=3cm]{figures/fourlogo_640.png} \\
    \vspace{\fill}
    {\small
    Build @<Build number@> --- @<Build date and time@> UTC
    }
}

\begin{document}

\pagenumbering{roman}
\maketitle
\tableofcontents
\pagenumbering{arabic}

\expunge{begin}{userguide}
\chapter{Introduction}

This collection of programs and utilities provides a set of tools for
advanced users, explorers, and researchers of the Bitcoin and Ethereum
blockchains. Some of the tools are self-contained, while others require
access to a system (either local or remote) which runs a ``full node''
using the \href{https://bitcoin.org/en/bitcoin-core/}{Bitcoin Core}
software and maintains a complete copy of the up-to-date Bitcoin
blockchain.  In order to use the \hyperref[UG:AW]{Address Watcher}, the
node must maintain a transaction index, which is enabled by setting
``{\tt txindex=1}'' in its {\tt bitcoin.conf} file.

Some utilities (for example, the Bitcoin and Ethereum address generator
and paper wallet tools) do not require access to a Bitcoin node and
others may be able to be used on nodes which have ``pruned'' the
blockchain to include only more recent blocks.

@d Project Title @{Blockchain Tools@}
@d Project File Name @{blockchain_tools@}

%   The following allows disabling the build number and date and
%   time inclusion in programs during periods of active development.
%   The build number continues to be incremented as a record, but
%   we embed zero values here to avoid having files which are not
%   otherwise changed be updated by Nuweb.  Such unnecessary updates
%   would generate a large number of meaningless Git transactions which
%   would only confuse the record of genuine changes to the code.
%
%   When it's time to go into production, re-enable the include of
%   build.w to restore the build number configuration control
%   facility.
%
@i build.w
%d Build number @{0@}
%d Build date and time @{1900-01-01 00:00@}

\section{Configuration}

Include the configuration from {\tt configuration.w}.

@i configuration.w

\section{Host System Properties}

These path names to the Perl and Python interpreters are embedded in
programs in the respective languages so they may be invoked directly
from the command line.  If these are incorrect, you can still run
the programs by explicitly calling the correct interpreter.  Due to
incompatibilities, many systems have both Python versions 2 and 3
installed.  If this is the case, be sure you specify the path to
Python version 3 or greater below.

@d Perl directory @{/usr/bin/perl@}
@d Python directory @{/usr/bin/python3@}
\expunge{end}{userguide}

\chapter{User Guide}

\section{Overview}

Fourmilab Blockchain Tools provide a variety of utilities for users,
experimenters, and researchers working with blockchain-based
cryptocurrencies such as Bitcoin and Ethereum.  These are divided
into two main categories.

\subsection{Bitcoin and Ethereum Address Tools}

These programs assist in generating, analysing, archiving,
protecting, and monitoring addresses on the Bitcoin and
Ethereum blockchains.  They do not require you run a local
node or maintain a copy of the blockchain, and all
security-related functions may be performed on an ``air-gapped''
machine with no connection to the Internet or any other computer.

\begin{itemize}
    \item \hyperref[UG:BAG]{Blockchain Address Generator} creates
        address and private key pairs for both the Bitcoin
        and Ethereum blockchains, supporting a variety of
        random generators, address types, and output formats.

    \item \hyperref[UG:MKM]{Multiple Key Manager} allows you to
        split the secret keys associated with addresses into
        $n$ multiple parts, from which any $k\leq n$ can be used
        to reconstruct the original key, allowing a variety of
        secure custodial strategies.

    \item \hyperref[UG:PWU]{Paper Wallet Utilities} includes a
        \hyperref[UG:PWg]{Paper Wallet Generator} which transforms
        a list of addresses and private keys generated by the
        Blockchain Address Generator or parts of keys produced by
        the Multiple Key Manager into a HTML file which may be
        printed for off-line ``cold storage'', and a
        \hyperref[UG:PWv]{Cold Storage Wallet Validator} that
        provides independent verification of the correctness of
        off-line copies of addresses and keys.

    \item \hyperref[UG:CSM]{Cold Storage Monitor} connects to free
        blockchain query services to allow periodic monitoring of
        a list of cold storage addresses to detect unauthorised
        transactions which may indicate they have been compromised.
\end{itemize}

\subsection{Bitcoin Blockchain Analysis Tools}

This collection of tools allows various kinds of monitoring and
analysis of the Bitcoin blockchain.  They do not support Ethereum.
These programs are intended for advanced, technically-oriented users
who run their own full Bitcoin Core node on a local computer.  Note
that anybody can run a Bitcoin node as long as they have a computer
with the modest CPU and memory capacity required, plus the very large
(and inexorably growing) file storage capacity to archive the entire
Bitcoin blockchain. You can run a Bitcoin node without being a
``miner'', nor need you expose your computer to external accesses from
other nodes unless you so wish.

These tools are all read-only monitoring and analysis utilities.
They do not generate transactions of any kind, nor do they require
unlocked access to the node owner's wallet.

\begin{itemize}
    \item \hyperref[UG:AW]{Address Watch} monitors the
        Bitcoin blockchain and reports any transactions which
        reference addresses on a ``watch list'', either deposits to
        the address or spending of funds from it.  The program
        may also be used to watch activity on the blockchain,
        reporting statistics on blocks as they are mined and
        published.

    \item \hyperref[UG:CW]{Confirmation Watch} examines blocks
        as they are mined and reports confirmations for a transaction
        as they arrive.

    \item \hyperref[UG:TFW]{Transaction Fee Watch} analyses the
        transaction fees paid to include transactions in blocks
        and the reward to miners and produces real-time statistics
        and log files which may be used to analyse transaction fees
        over time.
\end{itemize}

\section{Blockchain Address Generator}
\label{UG:BAG}

The Blockchain Address Generator, with program name @<BA@>, is a
stand-alone tool for generating addresses and private keys for
both the Bitcoin and Ethereum blockchains.  This program does not
require access to a Bitcoin node and may be run on an ``air gapped''
machine without access to the Internet.  This permits generating
keys and addresses for offline cold storage of funds (for example,
in paper wallets kept in secure locations) without the risk of
having private keys compromised by spyware installed on the
generating machine.

The Address Generator may be run from the command line (including
being launched by another program) or interactively, where the user
enters commands from the keyboard.  The commands used in both modes
of operation are identical.

\subsection{Architecture}

The address generator is not a single-purpose utility, but rather more
of a toolkit which can be used in a variety of ways to meet your
requirements.  The program is implemented as a ``stack machine'',
somewhat like the FORTH or PostScript languages.  Its stack stores
``seeds'', which are 256-bit integers represented as 64 hexadecimal
digits, ``{\tt 0}'' to ``{\tt F}'' (when specifying seeds in
hexadecimal, upper or lower case letters may be used interchangeably).
Specifications on the command line are not options in the usual sense,
but rather commands that perform operations on the stack.  When in
interactive mode, the same commands may be entered from the keyboard,
without the leading ``{\tt -}'', and perform identically.

Here are some sample commands which illustrate operations you can
perform.

\begin{description}
    \item[{\tt @<BA@> -urandom -btc}]~\\
        Obtain a seed from the system's fast (non-blocking) entropy
        source and generate a Bitcoin key/address pair from it,
        printing the results on the console.

    \item[{\tt @<BA@> -repeat 10 -pseudo -format CSV -eth}]~\\
        Generate 10 seeds using the program's built-in Mersenne Twister
        pseudorandom generator (seeded with entropy from the system's
        fast entropy source), then create Ethereum key/address pairs
        for each and write as a Comma-Separated Value (CSV) file
        intended, for example, as offline ``paper wallet'' cold
        storage.

    \item[{\tt @<BA@> -repeat 16 -hotbits -hbapik MyApiKey -shuffle
                      -xor -test -repeat 1 -btc}]~\\
        Request 16 seeds from Fourmilab's
        \href{https://www.fourmilab.ch/hotbits/}{HotBits} radioactive
        random number generator (requires Internet connection), shuffle
        the bytes among the 16 seeds, exclusive-or the two top seeds
        together, perform a randomness test on the result using
        Fourmilab's
        \href{https://www.fourmilab.ch/random/}{random sequence tester},
        then use the seed to generate a Bitcoin key/address
        pair.
\end{description}

\subsection{Commands}

\begin{description}
    \item[{\tt -aes}] ~\\
        Encrypt the second item on the stack with the
        \href{https://en.wikipedia.org/wiki/Advanced_Encryption_Standard}{Advanced
        Encryption Standard}, 256 bit key size version, with the key on
        the top of the stack.  The stack data are encrypted in two 128
        bit AES blocks in cipher-block chaining mode and the encrypted
        result is placed on the top of the stack.

    \item[{\tt -bindump} {\em filename}] ~\\
        Write the entire stack in binary to the named {\tt filename}.
        A dump to file may be reloaded onto the stack with the {\tt
        -binfile} command.

    \item[{\tt -binfile} {\em filename}] ~\\
        Read successive 64 byte blocks from the binary file {\em
        filename} and place them on the stack, pushing down the stack
        with each block.

    \item[{\tt -btc}] ~\\
        Use the seed on the top of the stack, which is removed after
        the command completes, to generate a Bitcoin private key and
        public address, which are displayed on the console in all of
        the various formats available.  If the {\tt -format} command has
        been to select CSV output, CSV records are generated using
        the specified format options.  If a {\tt -repeat} value has
        been set, that number of stack items will be used to generate
        multiple key/address pairs.

    \item[{\tt -clear}] ~\\
        Remove all items from the stack.

    \item[{\tt -drop}] ~\\
        Remove the top item from the stack.

    \item[{\tt -dump}] ~\\
        Dump the entire stack in hexadecimal to the console or to a
        file if {\tt -outfile} has been set.  A dump to file may be
        reloaded onto the stack with the {\tt -hexfile} command.

    \item[{\tt -dup}] ~\\
        Duplicate the top item on the stack and push on the stack.

    \item[{\tt -eth}] ~\\
        Generate an Ethereum private key and public address from the
        seed at the top of the stack, which is removed.  The key and
        address are displayed on the console in human-readable form. If
        the {\tt -format} command has been to select CSV output, CSV
        records are generated using the specified format options.  If a
        {\tt -repeat} value has been set, that number of stack items
        will be used to generate multiple key/address pairs.

    \item[{\tt -format} {\em fmt}] ~\\
        Set the format to be used for key/address pairs generated by
        the {\tt -btc} and {\tt -eth} commands.  If the first three
        letters of {\em fmt} are ``{\tt CSV}'' (case-sensitive), a
        Comma-Separated Value file is generated.  Letters following
        ``{\tt CSV}'' select options, which vary depending upon the
        type of address being generated.  For Bitcoin addresses, the
        following options are available.
        \begin{quote}
        \begin{description}
        \dense
            \item[{\tt q}]  Use uncompressed private key
            \item[{\tt u}]  Use uncompressed public address
            \item[{\tt l}]  Legacy (``{\tt 1}'') public address
            \item[{\tt c}]  Compatible (``{\tt 3}'') public address
            \item[{\tt s}]  Segwit ``{\tt bc1}'' public address
        \end{description}
        \end{quote}
        For Ethereum addresses, options are:
        \begin{quote}
        \begin{description}
        \dense
            \item[{\tt n}]  No checksum on public address
            \item[{\tt p}]  Include full public key
        \end{description}
        \end{quote}
        For either kind of address, the letter ``{\tt k}'' indicates
        that a subsequent key generation command will not remove
        the keys it processes from the stack.  This permits generating
        the same keys in different formats.  The letter ``{\tt b}''
        on either address type causes the private key to be omitted
        from CSV format output, replaced by a null string.  This allows
        generation of address lists containing only public addresses
        that may be used with utilities such as @<CC@> and @<AW@>
        without risking compromise of the private keys.


    \item[{\tt -hbapik} {\em APIkey}] ~\\
        When requesting true random data from Fourmilab's HotBits
        radioactive random number generator, use the
        \href{https://www.fourmilab.ch/hotbits/apikey.html}{\em APIkey}
        to permit access to the generator.  If you don't have an API
        key (they are free), you may request pseudorandom data based
        upon a radioactively-generated seed by specifying an API key
        of ``{\tt Pseudorandom}''.

    \item[{\tt -help}] ~\\
         Print a summary of these commands.

    \item[{\tt -hexfile} {\em filename}] ~\\
         Load one or more seeds from the named {\em filename}, which
         contains data in hexadecimal format.  White space in the file
         (including line breaks) is ignored, and each successive
         sequence of 64 hexadecimal digits is pushed onto the stack as
         a 256 bit seed.  The {\tt -hexfile} command can load keys
         dumped to a file with the {\tt -outfile} and {\tt -dump}
         commands back onto the stack.

    \item[{\tt -hotbits}] ~\\
        Retrieve one or more 256 bit seeds from Fourmilab's HotBits
        radioactive random number generator, using the API key specified
        by the {\tt -hbapik} command.  If the {\tt -repeat} command has
        specified multiple keys, that number of keys will be retrieved
        from HotBits and pushed on the stack.

    \item[{\tt -inter}] ~\\
        Enter interactive mode.  The user is prompted for commands,
        which are entered exactly as on the command line, except without
        the leading hyphen on the command name.  To exit interactive
        mode and return to processing commands from the command line,
        enter ``{\tt end}'', ``{\tt exit}'', ``{\tt quit}'', or the
        end of file character.

    \item[{\tt -mnemonic}] ~\\
        Generate a
        \href{https://en.bitcoin.it/wiki/BIP_0039}{Bitcoin Improvement
        Proposal 39} (BIP39) mnemonic phrase from the seed on the top
        of the stack.  The seed remains on the stack.

    \item[{\tt -not}] ~\\
        Invert the bits of the seed on the top of the stack.

    \item[{\tt -outfile} {\em filename}] ~\\
        Output from subsequent {\tt -btc}, {\tt -eth}, and {\tt dump}
        commands will be written to {\em filename} instead of standard
        output.  Specifying a {\em filename} of ``{\tt -}'' restores
        output to standard output.  Each key generation command
        overwrites any previous output in {\em filename}; it is not
        concatenated.  Note that a file written by {\tt -dump}
        may be loaded back on the stack with the {\tt -hexfile}
        command.

    \item[{\tt -over}] ~\\
        Duplicate the second item on the stack and push it on the top
        of the stack.

    \item[{\tt -p}] ~\\
        Print the top item on the stack on the console.

    \item[{\tt -phrase} {\em words\ldots}] ~\\
        Push a key defined by a
        \href{https://en.bitcoin.it/wiki/BIP_0039}{Bitcoin Improvement
        Proposal 39} (BIP39) mnemonic phrase on the stack.  On the
        command line, the phrase should be enclosed in quotes.

    \item[{\tt -pseudo}] ~\\
        Push one or more seeds generated by the internal Mersenne
        Twister pseudorandom generator onto the stack.  If the
        {\tt -repeat} command has been set to greater than one, that
        number of seeds will be generated and pushed.  The pseudorandom
        generator is itself seeded by entropy supplied by the system's
        fast entropy source ({\tt /dev/urandom} on most Unix-like
        systems).

    \item[{\tt -random}] ~\\
        Push one or more seeds read from the system's strong
        entropy source ({\tt /dev/random} on most Unix-like
        systems) onto the stack.  If the {\tt -repeat} command
        has been set to greater than one, that number of seeds will be
        generated and pushed.  Reading data from a strong source
        faster than the system can collect hardware entropy may result
        in delays: the program will wait as long as necessary to obtain
        the requested number of bytes.

    \item[{\tt -repeat} {\em n}] ~\\
        Commands which generate and consume seeds will create and use
        $n$ seeds instead of the default of 1.  To restore the default,
        specify {\tt repeat 1}.

    \item[{\tt -roll} {\em n}] ~\\
        Rotate the top $n$ stack items, moving item $n$ to the top of
        the stack and pushing other items down.

    \item[{\tt -rot}] ~\\
        Rotate the top three stack items.  Item three becomes the top
        of the stack and the other items are pushed down.

    \item[{\tt -rrot}] ~\\
        Reverse rotate the top three stack items.  The seed on the top
        of the stack becomes the third item and the two items below it
        move up, with the second becoming the top.

    \item[{\tt -seed} {\em hex\_data}] ~\\
       The 256 bit seed, specified as 64 hexadecimal digits, is pushed
       onto the stack.  The seed may be preceded by ``{\tt 0x}'', but
       this is not required.

    \item[{\tt -sha256}] ~\\
        The seed on the top of the stack is replaced by its hash
        (digest) generated by the
        \href{https://en.wikipedia.org/wiki/SHA-2}{Secure Hash
        Algorithm 2} (SHA-2), 256 bit version (SHA-256).

    \item[{\tt -shuffle}] ~\\
        Shuffle all of the bytes of items on the stack using
        pseudorandom values generated as for the {\tt -pseudo} command.
        Shuffling bytes can mitigate the risk of interception of seeds
        generated remotely and transmitted across the Internet.
        (Secure {\tt https:} connections are used for all such
        requests, but you never know\ldots .)

    \item[{\tt -swap}] ~\\
        Exchange the top two items on the stack.

    \item[{\tt -test}] ~\\
        Use the Fourmilab
        \href{https://www.fourmilab.ch/random/}{\tt ent} random
        sequence tester to evaluate the apparent randomness of the
        top item on the stack.  You must have {\tt ent} installed
        on your system to use this command.
        Randomness is evaluated at the bit stream level.

    \item[{\tt -testall}] ~\\
        Use the Fourmilab
        \href{https://www.fourmilab.ch/random/}{\tt ent} random
        sequence tester to evaluate the apparent randomness of the
        entire contents of the stack.  You must have {\tt ent}
        installed on your system to use this command.
        Randomness is evaluated at the bit stream level.

    \item[{\tt -type} {\em Any text}] ~\\
        Display the text on the console.  This is often used in command
        files to inform the user what's going on.

    \item[{\tt -urandom}] ~\\
        Push one or more seeds read from the system's fast entropy
        source ({\tt /dev/urandom} on most Unix-like systems) onto the
        stack.  If the {\tt -repeat} command has been set to greater
        than one, that number of seeds will be generated and pushed.
        The fast generator has no limitation on generation rate, so you
        may request any amount of data without possibility of delay.

    \item[{\tt -wif} {\em private\_key}] ~\\
        Push the seed represented by the Bitcoin Wallet Import Format
        (WIF) key onto the stack.

    \item[{\tt -xor}] ~\\
        Perform a bitwise exclusive or of the top two items on the
        stack and push the result on the stack.

    \item[{\tt -zero}] ~\\
        Push an all zero seed on the stack.
\end{description}

\section{Multiple Key Manager}
\label{UG:MKM}

The Multiple Key Manager (@<MK@>) splits the private keys used to
access funds stored in Bitcoin or Ethereum addresses into multiple
independent parts, allowing them to be distributed among a number of
custodians or storage locations.  The original keys may subsequently be
reconstructed from a minimum specified number of parts.  Each secret
key is split into $n$ parts ($n\geq 2$), of which any $k, 2\leq k\leq n$ are
sufficient to reconstruct the entire original key, but from which the
key cannot be computed from fewer than $k$ parts.  In the discussion
below, we refer to $n$ as the number of {\tt parts} and $k$ as the
number {\tt needed}.  The splitting and reconstruction of keys is
performed using the
\href{https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing}{Shamir
Secret Sharing} technique.

The ability to split secret keys into parts allows implementing
a wide variety of custodial arrangements.  For example, a company
treasury's cold storage vault might have secret keys split
five ways, with copies entrusted to the chief executive officer,
chief financial officer, an inside director, an outside director,
and one kept in a safe at the office of the company's legal firm.
If the parts were generated so that any three would re-generate
the secret keys, then at at least three people would have to approve
access to the funds stored in the vault, which reduces the
likelihood of their misappropriation.  The existence of more
parts than required guards against loss or theft of one of the parts:
should that happen, three of the remaining copies can be used to
withdraw the funds and transfer them to new accounts
protected by new multi-part keys.

To create multiple keys, start with a comma-separated value (CSV)
file in the format created by @<BA@> with ``{\tt format CSV}''
selected.  Let's call this file {\tt keyfile.csv}.  Now, to split
the keys in this file into five parts, any three of which are
sufficient to reconstruct the original keys, use the command:

{\tt @<MK@> -parts 5 -needed 3 keyfile.csv}

This will generate five split key files named {\tt keyfile-1.csv},
{\tt keyfile-2.csv}, \ldots\ {\tt keyfile-5.csv}.  These are the
files which are distributed to the five custodians.  After verifying
independently that the parts can be successfully reconstructed (you
can't be too careful!), the original {\tt keyfile.csv} is destroyed,
leaving no copy of the complete keys.  (All of this should, of course,
be done on an ``air gapped'' machine not connected to any network or
external device which might compromise the complete keys while they
exist.)

When access to the keys is required, any three of the five parts
should be provided by their holders and combined with a command
like:

{\tt @<MK@> -join keyfile-4.csv keyfile-1.csv keyfile-2.csv}

Again, you can use any three parts and specify them in any order.
This will create a file named {\tt keyfile-merged.csv} containing
the original keys in the same format as was created by @<BA@>.  You
can then use this file with any of the other utilities in this
collection or use one or more of the secret keys to ``sweep'' the
funds into a new address.  To maximise security, once a set of
keys has been recombined, funds should be removed from all and those
not used transferred to new cold storage addresses, broken into parts
as you wish.  In many cases, it makes sense to split individual keys
rather than a collection of many so you need only join the ones
you immediately intend to use.

Once the parts have been generated on the air-gapped machine, they
are usually written to offline paper storage (using the @<PW@>
program, for example, which works with split key files as well as
complete key files) or archival media such as write-once
optical discs, perhaps with several identical redundant copies per
part.  Their custodians should store the copies of their parts in
multiple secure, private locations to protect against mishaps that
might destroy all copies of their part.

The ability to create multiple parts allows flexibility in their
distribution.  You might, for example, entrust two parts to the
company CEO, who would only need one part from another officer or
director to access the vault, while requiring three people other
than the CEO to access it.

Although primarily intended to split blockchain secret keys into
parts, @<MK@> may be used to protect and control access to any
kind of secret which can be expressed as 1024 or fewer text characters:
for example, passwords on root signing certificates, decryption keys
for private client information, or the formula for fizzy soft drinks.

\subsection{Command line options}

\begin{description}

    \item[{\tt -help}] ~\\
        Print how to call information.

    \item[{\tt -join}] ~\\
        Reconstruct the original private keys from the parts included
        in the files specified on the command line.  You must supply
        at least the {\tt -needed} number of parts when they were
        created (if you specify more, the extras are ignored).  The
        output is written to a file with the specified {\tt -name}
        or, if none is given, that of the first part with its number
        replaced with ``{\tt -merged}''.  The file will be will be in
        the comma-separated value (CSV) format in which @<BA@> writes
        addresses and keys it generates and is used by other programs
        in this collection.

    \item[{\tt -name} {\em name}] ~\\
        When splitting keys, the individual part files will be named
        ``{\em name}{\tt -}{\em n}{\tt .csv}'', where {\em n} is
        the part number.  If no {\tt -name} is specified, the name
        of the first key file supplied will be used.

    \item[{\tt -needed} {\em k}] ~\\
        When reconstructing the original keys, at least {\em k} parts
        (default 3) must be specified.  This option is ignored when
        joining the parts.

    \item[{\tt -parts} {\em n}] ~\\
        Keys will be split into {\em n} parts (default 3).  This option
        is ignored when joining parts.

    \item[{\tt -prime} {\em p}] ~\\
        Use the prime number {\em p} when splitting parts.  This should
        only be specified if you're a super expert who has read the
        code, understands the algorithm, and knows what you're doing,
        otherwise you're likely to mess things up.  The default is
        257.
\end{description}

\section{Paper Wallet Utilities}
\label{UG:PWU}

The safest way to store cryptocurrency assets not needed for
transactions in the near term is in ``cold storage'': kept offline
either on a secure (and redundant) digital medium or, safest of
all, paper (again, replicated and stored in multiple secure
locations).  A cold storage wallet consists simply of a list of one
or more pairs of blockchain public addresses and private keys.
Funds are sent to the public address and the corresponding private
key is never used until the funds are needed and they are ``swept''
into an online wallet by entering the public key.

The @<BA@> program makes it easy to generate address and key pairs for
offline cold storage, encoding them as comma-separated value (CSV)
files which can easily be read by programs.  For storage on paper,
a more legible human-oriented format is preferable, which the utilities
in this chapter aid in creating and verifying.

\subsection{Paper Wallet Generator}
\label{UG:PWg}

The @<PW@> program reads a list of Bitcoin or Ethereum public address and
private key pairs, generated by @<BA@> in comma-separated value
(CSV) format, and creates an HTML file which can be loaded into a
browser and then printed locally to create paper cold storage wallets.
In the interest of security, this process, as with generation of the
CSV file, should be done on a machine with no connection to the
Internet (``air gappped''), and copies of the files deleted from its
storage before the machine is connected to a public network.

\subsubsection{Creating a paper wallet}

Assume you've created a cold storage wallet with twenty Ethereum
addresses using the @<BA@> program, for example with the command:

{\tt @<BA@> -repeat 20 -urandom -outfile coldstore.csv -format CSV -eth}

This should be done on the same air-gapped machine on which you'll
now create the paper wallet.  Be careful to generate the
{\tt coldstore.csv} file in a location you'll erase before connecting
the machine to a public network.  If you wish to keep a
machine-readable cold storage wallet, copy the {\tt coldstore.csv} file
to multiple removable media (for example, flash storage devices
[perhaps encrypted], writeable compact discs, etc.)  Be aware that no
digital storage medium has unlimited data retention life, and
even if the data are physically present, it may be difficult to
near-impossible to find a drive which can read it in the not-so-distant
future.  By contrast, we have millennia of experience with ink on
paper, and if protected from physical damage, a printed cold storage
wallet will remain legible for centuries.

Now let's create a paper wallet.  Using the {\tt coldstore.csv} file
we've just generated and the default parameters, this can be done
with:

{\tt @<PW@> coldstore.csv >coldstore.html}

You can now load the {\tt coldstore.html} file into a Web browser with
a {\tt file:coldstore.html} URL, use print preview to verify it is
properly formatted, then print as many copies as you require for safe
storage to a local printer.

\subsubsection{Command line options}

\begin{description}
    \item[{\tt -date} {\em text}] ~\\
        The specified {\em text} will be used as the date in the
        printed wallet.  Any text may be used: enclose it in quotes if
        it contains spaces or special characters interpreted by the
        shell.  If no {\tt -date} is specified, the current date
        is used, in ISO-8601 {\tt YYYY-MM-DD} format.

    \item[{\tt -font} {\em fname}] ~\\
        Use HTML/CSS font name {\em fname} to display addresses
        and keys.  The default is {\tt monospace}.

    \item[{\tt -help}] ~\\
        Print a summary of the command line options.

    \item[{\tt -offset} {\em n}] ~\\
        The integer {\em n} will be added to the address numbers
        (first CSV field) in the input file.  If you've generated
        a number of cold storage wallets with the same numbers and
        wish to distinguish them in the printed versions, this
        allows doing so.

    \item[{\tt -perpage} {\em n}] ~\\
        Addresses will be printed {\em n} per page.  The default
        is 10 addresses per page.  The number which will fit on a
        page depends upon your paper size, font selection, and
        margins used when printing---experiment with print preview
        to choose suitable settings.

    \item[{\tt -prefix} {\em text}] ~\\
        Use {\em text} as a prefix for address numbers from
        the CSV file (optionally adjusted by the {\tt -offset}
        option).  This allows further distinguishing addresses in
        the printed document.

    \item[{\tt -separator} {\em text}] ~\\
        Display addresses and private keys as groups of four letters
        and number separated by the sequence {\em text}, which may be
        an HTML text entity such as ``\verb+&ndash;+''.

    \item[{\tt -size} {\em sspec}] ~\\
        Use HTML/CSS font size {\em sspec} to display addresses
        and keys.  The default is {\tt medium}.

    \item[{\tt -title} {\em text}] ~\\
        Use the specified {\tt text} as the title for the cold
        storage wallet.  If no title is specified, ``Bitcoin Wallet''
        or ``Ethereum Wallet'' will be used, depending upon the
        type of address in the CSV file.

    \item[{\tt -weight} {\em wgt}] ~\\
        Use HTML/CSS font weight {\em wgt} to display addresses
        and keys.  The default is {\tt normal}.
\end{description}

\subsection{Cold Storage Wallet Validator}
\label{UG:PWv}

When placing funds in offline cold storage wallets, an abundance of
caution is the prudent approach.  By their very nature, once funds
are sent to the public address of a cold storage wallet, that address
is never used again, nor is its private key ever used at all until
the time comes, perhaps years or decades later, to ``sweep'' the
funds from cold storage back into an online wallet.  Consequently,
if, for whatever reason, there should be an error in which the
private key in the offline wallet does not correspond to the public
address to which the funds were sent, those funds will be
irretrievably lost, with no hope whatsoever of recovery.  Entering
the private key into a machine connected to the Internet in order to
verify it would defeat the entire purpose of a cold storage wallet:
that its private keys, once generated on an air-gapped machine, are
never used prior to returning the funds from cold storage.

While the circumstances in which a bad address/key pair might be
generated and stored may seem remote, the consequences of this
happening, whether due to software or hardware errors, incorrect
operation of the utilities used to generate them, or malice, are
so dire that a completely independent way to verify their correctness
is valuable.

The @<VW@> program performs this validation on cold storage wallets,
either in the CSV format generated by @<BA@> or the printable
HTML produced by @<PW@>.  Further verification that the printed output
from the HTML corresponds to the file which was printed will require
manual inspection or scanning and subsequent verification.  The @<VW@>
program is a ``clean room'' re-implementation of the blockchain address
generation process used by @<BA@> to create cold storage wallets.  It
is written in a completely different programming language (Python
version 3 as opposed to Perl), and uses the Python cryptographic
libraries instead of Perl's.  While it is possible that errors
in lower-level system libraries shared by both programming languages
might corrupt the results, this is much less likely than an error
in the primary code or the language-specific libraries they use.

\section{Cold Storage Monitor}
\label{UG:CSM}

For safety, cryptocurrency balances which are not needed for active
transactions are often kept in ``cold storage'', either off-line in
redundant digital media not accessible over a network or printed on
paper (for example, produced with the @<PW@> program) kept in multiple
separate locations.  Once sent to these cold storage addresses, there
should be no further transactions whatsoever referencing them until
they are ``swept'' back into an active account for use.

But under the principle of
%Доверяй, но проверяй
\href{https://en.wikipedia.org/wiki/Trust,_but_verify}{\em doveryay, no
proveryay} (trust, but verify), a prudent custodian should monitor cold
storage addresses to confirm they remain intact and have not been
plundered by any means. (It's usually an inside job, but you never
know.)  One option is to run a ``hot monitor'' that constantly watches
transactions on the blockchain such as the @<AW@> utility included
here, but that requires you to operate a full Bitcoin node and does
not, at present, support monitoring of Ethereum addresses.

The @<CC@> utility provides a less intensive form of monitoring which
works for both Bitcoin and Ethereum cold storage addresses, does not
require access to a local node, but instead uses free query services
that return the current balance for addresses.  You can run this
job periodically (once a week is generally sufficient) with a list of
your cold storage addresses, producing a report of any
discrepancies between their expected balances and those returned
by the query.

Multiple query servers are supported for both Bitcoin and Ethereum
addresses, which may be selected by command line options, and
automatic recovery from transient errors while querying servers
is provided.

\subsection{Watching cold storage addresses}

The list of cold storage addresses to be watched is specified in a CSV
file in the same format produced by @<BA@> and read by @<PW@>,
plus an extra field giving the expected balance in the cold storage
address.  For example, an Ethereum address in which a balance of 10.25
Ether has been deposited might be specified as:

{\tt 1,"0x1F77Ea4C2d49fB89a72A5F690fc80deFbb712021","",10.25}

The private key field is not used by the @<CC@> program and should, in
the interest of security, be replaced by a blank field as has been done
here.  There is no reason to expose the private keys of cold storage
addresses on a machine intended only to monitor them.  You can use the
``{\tt b}'' and ``{\tt k}'' options on a {\tt -format~CSV} command to
generate a copy of the addresses without the private keys.  To query
all addresses specified in a file named {\tt coldstore.csv} and report
the current and expected balances, noting any discrepancies, use:

{\tt @<CC@> -verbose coldstore.csv}

If you don't specify {\tt -verbose}, only addresses whose balance
differs from that specified in the CSV file will be reported.

\subsection{Command line options}

The @<CC@> program is configured by the following command line options.

\begin{description}
    \item[{\tt -btcsource} {\em sitename}] ~\\
        Specify the site queried to obtain the balance
        of Bitcoin addresses.  The sites supported are:
        \begin{itemize}
        \dense
        \tt
            \item blockchain.info
            \item blockcypher.com
            \item btc.com
        \end{itemize}
        You must specify the site name exactly as given above.

    \item[{\tt -dust} {\em n}] ~\\
        Some miscreants use the blockchain as a means of ``spamming''
        users, generally to promote some shady, scammy scheme.  They
        do this by sending tiny amounts of currency to a large number
        of accounts, whose holders they hope will be curious and
        investigate the transaction that sent them, in which the
        spam message is embedded, usually as bogus addresses.  You
        might think getting paid to receive spam is kind of cool, but
        the amounts sent are smaller than the transaction cost it would
        take to spend or aggregate them with other balances.  This is
        an irritation to cold storage managers, who may find their
        inactive accounts occasionally receiving these tiny payments,
        which in blockchain argot are called ``dust''.  This option
        sets the threshold {\em n} (default 0.001) below which reported
        balances in excess of that expected will be ignored and not
        considered discrepancies.  If {\tt -verbose} is specified, they
        will be flagged in the report as ``Dust''.

    \item[{\tt -ethsource} {\em sitename}] ~\\
        Specify the site queried to obtain the balance
        of Ethereum addresses.  The sites supported are:
        \begin{itemize}
        \dense
        \tt
            \item blockchain.com
            \item etherscan.io
            \item ethplorer.io
        \end{itemize}
        You must specify the site name exactly as given above.

    \item[{\tt -help}] ~\\
        Print a summary of the command line options.

    \item[{\tt -loop}] ~\\
        Loop forever querying addresses.  After each pass through
        all the addresses, a pause of {\tt -waitloop} seconds will
        occur.

    \item[{\tt -retry} {\em n}] ~\\
        If a query fails, retry it {\em n} times before abandoning the
        request and reporting the failure (default 3).

    \item[{\tt -shuffle}] ~\\
        Shuffle the order in which addresses are queried before each
        pass checking them.  This may (or may not) make it less obvious
        they represent a single cold storage vault.

    \item[{\tt -verbose}] ~\\
        Report all addresses, even if an address's current balance is
        the same as expected.  Transient query failures and retries
        are also reported.

    \item[{\tt -waitconst} {\em n}] ~\\
        Wait {\em n} seconds (default 17) between queries for address
        balances.  This avoids overloading the sites providing this
        free service and getting banned for abusing them.

    \item[{\tt -waitloop} {\em n}] ~\\
        When using the {\tt -loop} option, pause for {\em n} seconds
        (default 3600) after completing queries for all the addresses
        in the list before commencing the next pass.

    \item[{\tt -waitrand} {\em n}] ~\\
        Add a random number between 0 and {\em n} seconds (default 20)
        to the constant set by {\tt waitconst} between individual
        queries.  This further reduces the load on the query sites
        and makes it less obvious they're coming from an automated
        process.
\end{description}

\section{Address Watch}
\label{UG:AW}

The @<AW@> program monitors the Bitcoin blockchain, watching for
transactions which involve one or more watched Bitcoin addresses,
specified on the command line, in a file listing addresses to watch,
or from the addresses in a Bitcoin Core wallet.  Address Watch can
be used by those who keep Bitcoin reserves in ``cold storage'', on
paper or offline devices for security, alerting them if one of these
addresses is used in a transaction, indicating its security
has been compromised.  The program can also display statistics of
blocks added to the blockchain and write a log that can be used for
analysis of the blockchain's behaviour.  This program requires access
to a Bitcoin node with a full copy of the blockchain,
configured with transaction indexing (``{\tt txindex=1}'').

\subsection{Command line options}

Address Watch is configured by the following command line options.
In addition to the options listed here, an additional set of options,
common to other programs in the collection, specify how the program
communicates with the Bitcoin Core Application Programming Interface
(API): see ``\hyperref[RPC:API]{RPC API configuration}'' for details.

\begin{description}
    \item[{\tt -bfile} {\em filename}] ~\\
        Specifies a file used to save the most recent block
        examined by the program.  When the program starts, it
        begins scanning at the next block.  As each block is processed,
        the block file is updated so a subsequent run of the program
        will start at the next block.

    \item[{\tt -end} {\em n}] ~\\
        Stop scanning and exit after processing block $n$.  If no
        {\tt -end} is specified, @<AW@> will continue scanning for
        newly-published blocks at the specified {\tt -poll} interval.

    \item[{\tt -help}] ~\\
        Print a summary of the command line options.

    \item[{\tt -lfile} {\em filename}] ~\\
        For each transaction involving a watched address, append an
        entry to a log file containing fields in Comma Separated Value
        (CSV) format as described in ``\hyperref[AW:LogWA]{Watched
        address log file}'' below.

    \item[{\tt -poll} {\em time}] ~\\
        After reaching the current end of the blockchain, check for
        newly-published blocks after the specified {\em time} in
        seconds.  If {\em time} is set to zero, @<AW@> will exit
        after scanning the last block.

    \item[{\tt -sfile} {\em filename}] ~\\
        As each block is processed, append an entry describing it to
        the statistics file {\em filename}.  Records are written in
        Comma Separated Value (CSV) format as described in
        ``\hyperref[AW:LogBS]{Block statistics log file}'' below.

    \item[{\tt -start} {\em n}] ~\\
        Start scanning the blockchain at block $n$.  If no {\tt -start}
        is specified, scanning will begin with the next block after
        that specified in the {\tt -bfile} file or with the next
        block published.

    \item[{\tt -stats}] ~\\
        For each block processed, print statistics about its content on
        the console.  The statistics are the same as written to a file
        by the {\tt -sfile} option, but formatted in a primate-readable
        format.

    \item[{\tt -type} {\em Any text}] ~\\
        Print the text on the console.

    \item[{\tt -verbose}] ~\\
        Print detailed information about the contents of blocks.  The
        more times you specify {\tt -verbose}, the more output you'll
        get.

    \item[{\tt -wallet}] ~\\
        Include addresses in the Bitcoin Core wallet with unspent
        balances in those watched for transactions.  Since every spend
        transaction in Bitcoin Core completely spends the source address
        and places unspent funds in a new change address, the option
        will automatically track these newly-generated addresses as they
        appear and are used.  The list of wallet addresses is updated
        before scanning each new block that arrives.

    \item[\hbox{{\tt -watch} [ {\em label}{\tt ,} ] {\em address}}] ~\\
        Add the specified Bitcoin {\em address} to the watch list.  You
        can specify a label before the address, separated by a comma,
        for example: {\tt "Money Bin,1ScroogeYebEqDTbdjk36WzLxjCZTkNe3w"}.

    \item[{\tt -wfile} {\em filename}] ~\\
        Add addresses read from the specified {\em filename} in
        Comma Separated Value (CSV) format to the watch list.  Each line
        in the file specified an address as:
            {\em Label}{\tt ,}{\em Bitcoin address}{\tt ,}{\em Private
                 key}{\tt ,}{\em Balance}.
        The {\em Label} is an optional human-readable name for the
        address, and the {\em Private key} and {\em Balance} fields are
        not used by this program.
\end{description}

\subsection{Log file formats}
\label{AW:Log}

The @<AW@> program can write two log files, both in Comma Separated
Value format, with fields as follows.  New items are appended to an
existing log file.

\subsection{Watched address log file}
\label{AW:LogWA}

The {\tt -lfile} option enables logging of transactions involving
watched addresses.  Each log item is as follows.

\begin{enumerate}
\dense
    \item Address label from wallet
    \item Bitcoin address
    \item Value (negative if spent, positive if received)
    \item Date and time (ISO 8601 format)
    \item Block number
    \item Transaction ID
    \item Block hash
\end{enumerate}

\subsection{Block statistics log file}
\label{AW:LogBS}

The {\tt -sfile} option logs statistics for blocks as they are added
to the blockchain, with records containing the following fields.

\begin{enumerate}
\dense
    \item Block number
    \item Date and time (Unix {\tt time()} format)
    \item Number of transactions in block
    \item Smallest transaction (bytes)
    \item Largest transaction (bytes)
    \item Mean transaction size (bytes)
    \item Transaction size standard deviation
    \item Total size of transactions (bytes)
    \item Smallest transaction value (BTC)
    \item Largest transaction value (BTC)
    \item Mean transaction value (BTC)
    \item Transaction value standard deviation
    \item Total transaction value (BTC)
    \item Total miner reward for block (including transaction fees)
    \item Base miner reward for block (less transaction fees)
\end{enumerate}

\section{Confirmation Watch}
\label{UG:CW}

When a Bitcoin transaction is posted to the network, it first is
placed in the  ``mempool'' by nodes which receive it.  Miner nodes
choose transactions from the mempool, usually based upon the
transaction fee per byte they offer, validate them against their
local copy of the entire Bitcoin blockchain and, if and when they
find a hash for a candidate block that meets the present
difficulty requirement, publish the block to the blockchain and
notify other nodes of its publication.  Other nodes indepedently
validate the transactions it contains and add their confirmations
to the transaction, which are recorded on the blockchain.  By
convention, a transaction is deemed fully confirmed once six or
more independent confirmations for it are recorded on the
blockchain.  Most Bitcoin wallet programs will not spend funds
received (even ``change'' from funds in your own wallet which
have been partially spent) until at least six confirmations are
received for its transfer to your wallet.

The @<CW@> utility monitors a transaction on the blockchain and
reports confirmations as they arrive.  It can be used to
monitor pending transactions and report when a specified number
of confirmations are received.  Depending upon the configuration, you
can run @<CW@> with the following command lines.

\begin{description}
    \item[@<CW@> {\em transaction\_id} {\em block\_hash}] ~\\
        This form of command may always be used, regardless of
        configuration.  It specifies the hexadecimal transaction ID
        and hash of the block which contains it.  Both of these
        can be found in the console output and log file generated
        by @<AW@>.

    \item[@<CW@> {\em transaction\_id}] ~\\
        If your Bitcoin Core node has been configured with
        with ``{\tt txindex=1}'', which maintains an index of
        transactions, you can specify just the {\em transaction\_id},
        with the block hash found from the transaction index.

    \item[@<CW@> {\em address/label}] ~\\
        If you have specified a log file maintained by @<AW@> on the
        command line with the {\tt -lfile} option, you may specify
        just the Bitcoin public address to which the transaction
        pertains or the label you have assigned to in the the Bitcoin
        Core wallet.  The most recent transaction involving that
        address will be retrieved from the log file and monitored
        for confirmations.
\end{description}

\subsection{Command line options}

Confirmation Watch is configured by the following command line options.
In addition to the options listed here, an additional set of options,
common to other programs in the collection, specify how the program
communicates with the Bitcoin Core Application Programming Interface
(API): see ``\hyperref[RPC:API]{RPC API configuration}'' for details.

\begin{description}
    \item[{\tt -confirmed} {\em n}] ~\\
        Specifies the number of confirmations which must be
        received before a transaction is deemed confirmed.  If
        a transaction is being monitored by the {\tt -watch}
        option, @<CW@> will exit after this number of
        confirmations arrive.

    \item[{\tt -help}] ~\\
        Print a summary of how to call and command line options.

    \item[{\tt -lfile} {\em filename}] ~\\
        Use the log file written by the @<AW@> program to locate
        transactions for a Bitcoin address specified either by its
        public address or a label given to it in the Bitcoin Core
        wallet.  If this option is not specified, transactions must
        be identified by their transaction ID.

    \item[{\tt -type} {\em Any text}] ~\\
        Print the text on the console.

    \item[{\tt -verbose} {\em n}] ~\\
        Print detailed information about transactions and confirmations.
        The more times you specify {\tt -verbose}, the more information
        you'll see.

    \item[{\tt -watch}] ~\\
        Poll for new confirmations every {\tt -poll} seconds until
        the {\tt -confirmed} number have arrived.
\end{description}

\section{Transaction Fee Watch}
\label{UG:TFW}

Bitcoin transactions submitted for inclusion in the blockchan are
accompanied by a transaction fee paid to the miner who
includes the transaction in a block published to the blockchain.
Transactions can be selected by miners at their discretion, but in
most cases will be chosen to maximise the reward for including them
in a block, which usually means those which offer the highest
transaction fee per byte (or, more precisely, ``virtual byte'') of
the transaction.  Whenever a block is added to the blockchain, Bitcoin
Core computes statistics of the fees for transactions within it.
In addition, Bitcoin Core computes an ``estimated smart fee'' as a
suggestion to those submitting transactions at the current time.

The @<FW@> program monitors the blockchain and reports the fee
statistics for each block published and fee recommendations from
Bitcoin Core, optionally writing both of these to a log file for
analysis by other programs.  The program is configured by the
following command line options.

\subsection{Command line options}

Fee Watch is configured by the following command line options.
In addition to the options listed here, an additional set of options,
common to other programs in the collection, specify how the program
communicates with the Bitcoin Core Application Programming Interface
(API): see ``\hyperref[RPC:API]{RPC API configuration}'' for details.

\begin{description}
    \item[{\tt -confirmed} {\em n}] ~\\
        Specifies the number of confirmations which must be
        received before a transaction is deemed confirmed.  This
        is used when requesting an estimate of the current
        transaction fee with the Bitcoin Core API call
        {\tt estimatesmartfee} to indicate the priority of
        the transaction.  The default, 6, corresponds to standard
        priority for this call.

    \item[{\tt -ffile} {\em filename}] ~\\
        Write a log file of fee information collected by
        @<FW@>.  The log is written in Comma Separated Value
        (CSV) format, and contains two kinds of records,
        distinguished by a digit in the first field.
        See ``\hyperref[FW:Log]{Log file format}'' below for
        details.

    \item[{\tt -help}] ~\\
        Print a summary of how to call and command line options.

    \item[{\tt -poll} {\em time}] ~\\
        Query and report transction fee estimates and statistics
        every {\em time} seconds, by default 300 seconds (five
        minutes).

    \item[{\tt -quiet}] ~\\
        Suppress console output for periodic transaction fee polls.
        Use this option when writing a log file with the {\tt -ffile}
        option if you don't want to also see information as it is
        collected.

    \item[{\tt -type} {\em Any text}] ~\\
        Print the text on the console.

    \item[{\tt -verbose} {\em n}] ~\\
        Print detailed information about operations. The more times you
        specify {\tt -verbose}, the more information you'll see.
\end{description}

\subsection{Log file format}
\label{FW:Log}

When the {\tt -ffile} option is specified, @<FW@> writes a log file
recording the transaction fee information it collects.  This file
is written in Comma Separated Value (CSV) format, and consists of
two type of records, as follows.

\subsubsection{Estimated fee record}

These records report the estimated fee, according to the Bitcoin
Core {\tt estimatesmartfee} API call, at the indicated time.
The estimated transaction fee in the record is expressed in
BTC per virtual kilobyte of transaction size, where virtual
transaction size is as defined in
\href{https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki}{Bitcoin
Improvement Proposal 141} section ``Transaction size calculations''.
One record of this type is generated for every {\tt -poll} interval.

\begin{enumerate}
\dense
    \item Record type, {\tt 1}
    \item Date and time (Unix {\tt time()} format)
    \item Date and time (ISO 8601 format)
    \item Estimated transaction fee, BTC per virtual kilobyte
\end{enumerate}

\subsubsection{Block fee statistics record}

If any blocks have been added to the blockchain since the last
{\tt -poll} interval, a record will be written, reporting
fee statistics for transactions in the block.  Note that the
time in these records is the time the block was added to the
blockchain, not the time of the @<FW@> poll.  The values
reported in these records are those returned by the
{\tt getblockstats} API call for the block, with fees reported
in units of satoshis (BTC 0.00000001) per virtual byte of
transaction, where virtual bytes are as defined for the
Estimated fee record above.

\begin{enumerate}
\dense
    \item Record type, {\tt 2}
    \item Block date and time (Unix {\tt time()} format)
    \item Block date and time (ISO 8601 format)
    \item Block number
    \item Minimum fee rate
    \item Mean (average) fee rate
    \item Maximum fee rate
    \item 10th percentile fee rate
    \item 25th percentile fee rate
    \item 50th percentile fee rate
    \item 75th percentile fee rate
    \item 90th percentile fee rate
\end{enumerate}

\section{RPC API configuration}
\label{RPC:API}

The @<AW@>, @<CW@>, and @<FW@> programs all require access to the
Application Programming Interface (API) provided by a Bitcoin Core
node.  Access to this interface can be via three mechanisms:

\begin{description}
    \item[{\tt local}]  Access to a Bitcoin Core node running on the
        same machine via the {\tt bitcoin-cli} command line program.

    \item[{\tt rpc}]    Access to a Bitcoin Core node via its Remote
        Procedure Call (RPC) interface.  The node may either be on the
        same machine or on a different machine configured
        to accept requests from the host submitting them.

    \item[{\tt ssh}]    Access a remote Bitcoin Core node by submitting
        commands to its {\tt bitcoin-cli} utility via the Secure Shell
        (SSH) facility.  The client and node machine must be configured
        to permit password-less access via public key authentication.
\end{description}

The following options, common to all of these programs, allow you to
confgure access to the API.  These options may be set on the command
line or via a configuration file common to all of the programs.

\begin{description}
    \item[{\tt -clipath} {\em path}] ~\\
        Specify the {\em path} used to invoke the {\tt bitcoin-cli}
        program on the node machine.  This option is used for the {\tt
        local} and {\tt ssh} access methods.  Note that on an SSH
        login, the user's terminal login scripts are not executed, so
        you may have to specify an explicit path even if {\tt
        bitcoin-cli} is in a directory included in the {\tt PATH}
        declared by those scripts.

    \item[{\tt -host} {\em hostname}] ~\\
        Specifies the host (machine network name) on which Bitcoin Core
        is running.  If this is the same computer, use {\tt localhost},
        otherwise specify the local machine name, fully qualified
        domain name, or IP address of the machine.

    \item[{\tt -method} {\em which}] ~\\
        Sets the method used to access the API\@@.  Use {\tt local} if
        accessing a Bitcoin Core node on the same machine, or {\tt ssh}
        to access a Bitcoin Core node on another machine.  The {\tt
        rpc} option selects direct access via the RPC interface on the
        same or a different host.  RPC access is the most efficient and
        should be used if available.

    \item[{\tt -rpccpass} {\em password}] ~\\
        Set the password for access via the {\tt rpc} method.  This
        password is configured in the {\tt bitcoin.conf} file via
        the {\tt rpcpassword} statement.  If the {\em password}
        specified is the null string ({\tt ""}), the user will be
        prompted to enter the password from the console, which is
        far more secure than specifying it on the command line.

    \item[{\tt -port} {\em number}] ~\\
        Sets the port used to communicate with the Bitcoin Core node
        when the {\tt rpc} method is selected.  The default is 8332.

    \item[{\tt -user} {\em userid}] ~\\
        Sets the User ID (login name) for access to a Bitcoin Core
        node on another machine via the {\tt ssh} method.
\end{description}

\section{Installation}

Fourmilab Blockchain Tools are written in the Perl and Python
programming languages, which are pre-installed on most modern versions
of Unix-like operating systems such as Linux, FreeBSD, and Macintosh OS
X, and available for many other systems.  Consequently, you can run any
of the pre-built versions of the tools, all of which have file types of
``{\tt .pl}'' or ``{\tt .py} by simply invoking them with the {\tt
perl} or {\tt python3} commands.  The programs use a number of modules,
some of which are ``core'' or ``standard''---included as part of
current language distributions, and others which may have to be
installed either from the operating system's software library or the
\href{https://www.cpan.org/}{Comprehensive Perl Archive Network} and
its search engine, \href{https://metacpan.org/}{MetaCPAN} ot with the
{\tt pip3} utility for Python.  If a module is available from your
operating system's distribution library, that's generally the best way
to install it, since it will be automatically updated by the system's
software update mechanism.

\subsection{Required Perl modules}

Here is a list of all Perl modules used by the programs.  Not all
programs use all modules: if you're only interested in some of the
programs, you need only install those they require.  Modules
marked as ``{\em core}'' will be pre-installed on most modern versions
of Perl.

\begin{itemize}
\dense
    \item {\tt Bitcoin::BIP39}
    \item {\tt Bitcoin::Crypto::Key::Private}
    \item {\tt Bitcoin::Crypto::Key::Public}
    \item {\tt Crypt::CBC}
    \item {\tt Crypt::Digest::Keccak256}
    \item {\tt Crypt::Random::Seed}
    \item {\tt Crypt::SSSS}
    \item {\tt Data::Dumper} {\em core}
    \item {\tt Digest::SHA} {\em core}
    \item {\tt Getopt::Long} {\em core}
    \item {\tt JSON} {\em core}
    \item {\tt List::Util} {\em core}
    \item {\tt LWP::Protocol::https}
    \item {\tt LWP::Simple}
    \item {\tt LWP}
    \item {\tt MIME::Base64} {\em core}
    \item {\tt Math::Random::MT}
    \item {\tt POSIX} {\em core}
    \item {\tt Statistics::Descriptive}
    \item {\tt Term::ReadKey}
    \item {\tt Text::CSV}
\end{itemize}

\subsection{Required Python modules}

To avoid commonality in language and libraries in the interest of
avoiding single points of failure when validating the correctness
of generated wallets, the @<VW@> program is written in the Python
language (version 3 or greater), and requires the following modules
be installed on systems that run it.  Modules marked ``{\em standard}''
are part of Python's standard libraries should be installed on most
systems that support the language.  If you don't run @<VW@>, you
needn't bother installing these modules.

\begin{itemize}
\dense
    \item {\tt base58}
    \item {\tt binascii} {\em standard}
    \item {\tt coincurve}
    \item {\tt cryptos}
    \item {\tt fileinput} {\em standard}
    \item {\tt re} {\em standard}
    \item {\tt sha3}
    \item {\tt sys} {\em standard}
\end{itemize}

\subsection{Building from original source code}

This software, including all programs, support files, utilities,
and documentation was developed using the
\href{http://literateprogramming.com/}{Literate Programming}
methodology, where the goal is that programs should be as
readable to humans as they are by computers.  The package
is written using the
\href{http://nuweb.sourceforge.net/}{\bf nuweb} literate programming
system, which is language-agnostic: it can be used to develop software
in any programming language, including multiple languages in a single
project, as is the case for this one.  The {\bf nuweb} tools are free
software written in portable C, with source code downloadable from the
link above.

Programs in {\bf nuweb} are called ``Web files'', which have nothing
whatsoever to do with the World-Wide Web (which it predates),
having a file type of ``{\tt .w}''.  All of the other files in the
distribution are generated automatically from the master Web.  If
you wish to modify one or more of the programs, it's best to modify
the master code in the Web file and re-generate the programs from it.
All of the building and maintenance operations are performed by a
{\tt Makefile} which is, itself, generated from the Web.  If you edit
any of the files associated with this program, be sure to use a text
editor which supports the Unicode-compatible
\href{https://en.wikipedia.org/wiki/UTF-8}{UTF-8} character set:
otherwise some special characters may be turned into gibberish.

Documentation is generated automatically in the
\href{https://www.latex-project.org/}{\LaTeX} document preparation
language, with the final PDF documents produced with
\href{https://en.wikipedia.org/wiki/XeTeX}{XeTeX}, a version of
\href{https://en.wikipedia.org/wiki/TeX}{\TeX} extended to support
the full Unicode character set.  These utilities can be installed
from the distribution archives of most Unix-like systems.

\subsection{Configuration parameters}

When you build from source code, a number of build-time configuration
parameters are incorporated from the Web file {\tt configuration.w}.
Please see the documentation for that file in the source code listing,
in the Introduction chapter, section ``Configuration''.  Most of the
configuration parameters set defaults which can be overridden by
command-line options, so usually setting them is a convenience to
avoid having to specify the options you prefer, not a necessity.

\expunge{begin}{userguide}

\chapter{Blockchain Address Generator}

This program generates Bitcoin and Ethereum public address and private
key pairs from a variety of sources of random and pseudorandom data,
including Fourmilab's HotBits radioactive random number generator.  The
program is implemented as a stack machine where command line
``options'' are actually commands and arguments that allow
specification, generation, and manipulation of random and pseudorandom
data, generation of Bitcoin and Ethereum private keys and public
addresses from them, and their output in a variety of formats.

\section{Main program}

\subsection{Program plumbing}

@o perl/blockchain_address.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    #   Configured HotBits access
    my $HotBits_API_key = "@<HotBits API key@>";
    my $HotBits_Query = "@<HotBits query URL@>";

    use Bitcoin::Crypto::Key::Private;
    use Bitcoin::Crypto::Key::Public;
    use Bitcoin::BIP39 qw(entropy_to_bip39_mnemonic bip39_mnemonic_to_entropy);
    use Digest::SHA qw(sha256_hex);
    use Crypt::CBC;
    use Crypt::Digest::Keccak256 qw(keccak256_hex);
    use Crypt::Random::Seed;
    use MIME::Base64;
    use LWP::Simple;
    use Getopt::Long qw(GetOptionsFromArray);
    use Data::Dumper;
@}

\subsection{Process command line options}

If project- or program-level configuration files are present, process
them, then process command line options.

@o perl/blockchain_address.pl
@{
    my $opt_Format = "";        # Format for generated keys

    my $repeat = 1;             # Repeat command this number of times
    my $outputFile = "-";       # Output file for keys
    my @@seeds;                 # Stack of seeds

    my %options = (
        "aes"       =>  \&arg_aes,
        "bindump=s" =>  \&arg_bindump,
        "binfile=s" =>  \&arg_binfile,
        "btc"       =>  \&arg_btc,
        "clear"     =>  \&arg_clear,
        "drop"      =>  \&arg_drop,
        "dump"      =>  \&arg_dump,
        "dup"       =>  \&arg_dup,
        "eth"       =>  \&arg_eth,
        "format=s"  =>  \$opt_Format,
        "hbapik=s"  =>  \$HotBits_API_key,
        "help"      =>  \&showHelp,
        "hexfile=s" =>  \&arg_hexfile,
        "hotbits"   =>  \&arg_hotbits,
        "inter"     =>  \&arg_inter,
        "mnemonic"  =>  \&arg_mnemonic,
        "not"       =>  \&arg_not,
        "outfile=s" =>  \&arg_outfile,
        "over"      =>  \&arg_over,
        "p"         =>  \&arg_printtop,
        "phrase=s"  =>  \&arg_phrase,
        "pick=i"    =>  \&arg_pick,
        "pseudo"    =>  \&arg_pseudo,
        "random"    =>  \&arg_random,
        "repeat=i"  =>  \$repeat,
        "roll=i"    =>  \&arg_roll,
        "rot"       =>  \&arg_rot,
        "rrot"      =>  \&arg_rrot,
        "seed=s"    =>  \&arg_seed,
        "sha256"    =>  \&arg_sha256,
        "shuffle"   =>  \&arg_shuffle,
        "swap"      =>  \&arg_swap,
        "test"      =>  \&arg_test,
        "testall"   =>  \&arg_testall,
        "type=s"    =>  sub { print("$_[1]\n"); },
        "urandom"   =>  \&arg_urandom,
        "wif=s"     =>  \&arg_wif,
        "xor"       =>  \&arg_xor,
        "zero"      =>  \&arg_zero
    );

    processConfiguration();

    GetOptions(
               %options
              ) ||
        die("Invalid command line option");
@}

Include local and utility functions we employ.

@o perl/blockchain_address.pl
@{
    #   Shared utility functions
    @<readHexfile: Read hexadecimal data from a file@>
    @<Pseudorandom number generator@>
    @<Command and option processing@>

    #   Local functions
    @<Command line argument handlers@>
    @<hexToBytes: Convert hexadecimal string to binary@>
    @<bytesToHex: Convert binary string to hexadecimal@>
    @<genBtcAddress: Generate Bitcoin address from one hexadecimal seed@>
    @<editBtcAddress: Edit Bitcoin private key and public address@>
    @<genEthAddress: Generate Ethereum address from one hexadecimal seed@>
    @<editEthAddress: Edit Ethereum private key and public address@>
    @<computeEthChecksum: Add checksum to Ethereum address@>
    @<BIP39encode: Encode seed as BIP39 mnemonic phrase@>
    @<shuffleBytes: Shuffle bytes@>
    @<showHelp: Show Bitcoin address help information@>
    @<stackCheck:  Check for stack underflow@>
@}

\section{Local functions}

\subsection{Command line argument handlers}

@d Command line argument handlers
@{
    @<arg\_aes: Encrypt second item with top of stack key@>
    @<arg\_bindump: Dump seeds from stack to binary file@>
    @<arg\_binfile: Push seeds from binary file on stack@>
    @<arg\_btc: Generate Bitcoin key/address from top of stack@>
    @<arg\_clear: Clear stack@>
    @<arg\_drop: Drop the top item from the stack@>
    @<arg\_dump: Dump the stack@>
    @<arg\_dup: Duplicate the top item from the stack@>
    @<arg\_eth: Generate Ethereum key/address from top of stack@>
    @<arg\_hexfile: Push seeds from hexfile on stack@>
    @<arg\_hotbits: Request seed(s) from HotBits@>
    @<arg\_mnemonic: Generate mnemonic phrase from stack top@>
    @<arg\_not: Invert bits in top of stack item@>
    @<arg\_outfile: Redirect generated address output to file@>
    @<arg\_over: Duplicate the second item from the stack@>
    @<arg\_pick: Duplicate the $n$th item from the stack@>
    @<arg\_pseudo: Generate pseudorandom seed and push on stack@>
    @<arg\_phrase: Specify seed as BIP39 phrase@>
    @<arg\_printtop: Print top of stack@>
    @<arg\_random: Request seed(s) from strong generator@>
    @<arg\_roll: Rotate item $n$ to top of stack@>
    @<arg\_rot: Rotate three stack items@>
    @<arg\_rrot: Reverse rotate three stack items@>
    @<arg\_seed: Push seed on stack@>
    @<arg\_sha256: Replace top of stack with its SHA256 hash@>
    @<arg\_shuffle: Shuffle bytes on stack@>
    @<arg\_swap: Swap the two top items on the stack@>
    @<arg\_test: Test the stack top item for randomness@>
    @<arg\_testall: Test entire stack contents for randomness@>
    @<arg\_urandom: Request seed(s) from fast generator@>
    @<arg\_wif: Load seed from Wallet Input Format (WIF) private key@>
    @<arg\_xor: Exclusive-or top two stack items@>
    @<arg\_zero: Push all zeroes on the stack@>
@}

\subsubsection{{\tt arg\_aes} --- {\tt -aes}: Encrypt second item with top of stack key}

@d arg\_aes: Encrypt second item with top of stack key
@{
    sub arg_aes {
        stackCheck(2);
        my $key = hexToBytes(pop(@@seeds));
        my $plaintext = hexToBytes(pop(@@seeds));
        my $crypt = Crypt::CBC->new(
                        -chain_mode => "ofb",
                        -pbkdf  => "pbkdf2",
                        -header => "none",
                        -key    => $key,
                        -cipher => "Crypt::OpenSSL::AES");
        my $codetext = $crypt->encrypt($plaintext);
        my $hexcode = bytesToHex($codetext);
        push(@@seeds, $hexcode);
    }
@| arg_aes @}

\subsubsection{{\tt arg\_bindump} --- {\tt -bindump}: Dump seeds from stack to binary file}

@d arg\_bindump: Dump seeds from stack to binary file
@{
    sub arg_bindump {
        my ($name, $value) = @@_;

        if (open(BO, ">$value")) {
            foreach my $seed (@@seeds) {
                print(BO hexToBytes($seed));
            }
            close(BO);
        } else {
            print("Cannot create file $value.\n");
        }
    }
@| arg_binfile @}

\subsubsection{{\tt arg\_binfile} --- {\tt -binfile}: Push seeds from binary file on stack}

@d arg\_binfile: Push seeds from binary file on stack
@{
    sub arg_binfile {
        my ($name, $value) = @@_;

        open(BI, "<$value") || die("Cannot open $value");
        my $dat;
        while (read(BI, $dat, 32) == 32) {
            push(@@seeds, bytesToHex($dat));
        }
        close(BI);
    }
@| arg_binfile @}

\subsubsection{{\tt arg\_btc} --- {\tt -btc}: Generate Bitcoin key/address}

@d arg\_btc: Generate Bitcoin key/address from top of stack
@{
    sub arg_btc {
        my ($name, $value) = @@_;
        stackCheck($repeat);

        my $keyn = 1;
        my $keep = ($opt_Format =~ m/k/);
        my @@kept;
        @<Open output file@>
        @<Begin command repeat@>
            my $seed = pop(@@seeds);
            if ($keep) {
                push(@@kept, $seed);
            }
            my ($priv, $pub) = genBtcAddress($seed, $opt_Format, 1);
            print(editBtcAddress($priv, $pub, $opt_Format, $keyn++));
        @<End command repeat@>
        @<Close output file@>
        if ($keep) {
            @<Begin command repeat@>
                push(@@seeds, pop(@@kept));
            @<End command repeat@>
        }
    }
@| arg_btc @}

\subsubsection{{\tt arg\_clear} --- {\tt -clear}: Clear stack}

@d arg\_clear: Clear stack
@{
    sub arg_clear {
        @@seeds = ();
    }
@| arg_clear @}

\subsubsection{{\tt arg\_drop} --- {\tt -drop}: Drop the top item from the stack}

@d arg\_drop: Drop the top item from the stack
@{
    sub arg_drop {
        stackCheck(1);
        pop(@@seeds);
    }
@| arg_drop @}

\subsubsection{{\tt arg\_dump} --- {\tt -dump}: Dump the stack}

@d arg\_dump: Dump the stack
@{
    sub arg_dump {
        @<Open output file@>
        if ($outputFile eq "-") {
            print("  ", join("\n  ", reverse(@@seeds)), "\n");
        } else {
            print(join("\n", @@seeds), "\n");
        }
        @<Close output file@>
    }
@| arg_dump @}

\subsubsection{{\tt arg\_dup} --- {\tt -dup}: Duplicate the top item from the stack}

@d arg\_dup: Duplicate the top item from the stack
@{
    sub arg_dup {
        stackCheck(1);
        push(@@seeds, $seeds[$#seeds]);
    }
@| arg_dup @}

\subsubsection{{\tt arg\_eth} --- {\tt -eth}: Generate Ethereum key/address}

@d arg\_eth: Generate Ethereum key/address from top of stack
@{
    sub arg_eth {
        my ($name, $value) = @@_;
        stackCheck($repeat);

        my $keyn = 1;
        my $keep = ($opt_Format =~ m/k/);
        my @@kept;
        @<Open output file@>
        @<Begin command repeat@>
            my $seed = pop(@@seeds);
            if ($keep) {
                push(@@kept, $seed);
            }
            my ($priv, $pub) = genEthAddress($seed, $opt_Format, 1);
            print(editEthAddress($priv, $pub, $opt_Format, $keyn++));
        @<End command repeat@>
        @<Close output file@>
        if ($keep) {
            @<Begin command repeat@>
                push(@@seeds, pop(@@kept));
            @<End command repeat@>
        }
    }
@| arg_eth @}

\subsubsection{{\tt arg\_hexfile} --- {\tt -hexfile}: Push seeds from hexfile on stack}

@d arg\_hexfile: Push seeds from hexfile on stack
@{
    sub arg_hexfile {
        my ($name, $value) = @@_;

        my $hf = readHexfile($value);
        while ($hf =~ s/^([\dA-F]{64})//i) {
            push(@@seeds, uc($1));
        }
    }
@| arg_hexfile @}

\subsubsection{{\tt arg\_hotbits} --- {\tt -hotbits}: Request seed(s) from HotBits}

@d arg\_hotbits: Request seed(s) from HotBits
@{
    sub arg_hotbits {
        my $n = 32 * $repeat;
        my $hbq = $HotBits_Query;
        $hbq =~ s/\[NBYTES\]/$n/;
        $hbq =~ s/\[APIKEY\]/$HotBits_API_key/;
        my $hbr = get($hbq);
        $hbr =~ m:<pre>(.*?\w+.*?)</pre>:s || die("Cannot parse HotBits reply: $hbr");
        my $hf = $1;
        $hf =~ s/\W//g;
        while ($hf =~ s/^([\dA-F]{64})//i) {
            push(@@seeds, $1);
        }
    }
@| arg_hotbits @}

\subsubsection{{\tt arg\_mnemonic} --- {\tt -mnemonic}: Generate BIP39 mnemonic phrase from stack top}

@d arg\_mnemonic: Generate mnemonic phrase from stack top
@{
    sub arg_mnemonic {
        stackCheck(1);
        print(BIP39encode("  ", pop(@@seeds), 64));
    }
@| arg_mnemonic @}

\subsubsection{{\tt arg\_not} --- {\tt -not}: Invert bits in top of stack item}

@d arg\_not: Invert bits in top of stack item
@{
    sub arg_not {
        stackCheck(1);
        my $b = hexToBytes(pop(@@seeds));
        my $bi = "";
        for (my $i = 0; $i < bytes::length($b); $i++) {
            $bi .= sprintf("%02X", ord(bytes::substr($b, $i, 1)) ^ 0xFF);
        }
        push(@@seeds, $bi);
    }
@| arg_not @}

\subsubsection{{\tt arg\_outfile} --- {\tt -outfile} {\em filename} Redirect generated address output to file}

@d arg\_outfile: Redirect generated address output to file
@{
    sub arg_outfile {
        my ($name, $value) = @@_;

        $outputFile = $value;
    }
@| arg_outfile @}

\subsubsection{{\tt arg\_over} --- {\tt -over}: Duplicate the second item from the stack}

@d arg\_over: Duplicate the second item from the stack
@{
    sub arg_over {
        stackCheck(2);
        push(@@seeds, $seeds[$#seeds - 1]);
    }
@| arg_over @}

\subsubsection{{\tt arg\_phrase} --- {\tt -phrase}: Specify seed as BIP39 phrase}

@d arg\_phrase: Specify seed as BIP39 phrase
@{
    sub arg_phrase {
        my ($name, $value) = @@_;

        my $seed = bip39_mnemonic_to_entropy(
            mnemonic => $value,
            encoding => "hex");
        push(@@seeds, uc($seed));
    }
@| arg_phrase @}

@d arg\_printtop: Print top of stack
@{
    sub arg_printtop {
        if (scalar(@@seeds) > 0) {
            print("  $seeds[-1]\n");
        } else {
            print("Stack empty.\n");
        }
    }
@| arg_printtop @}

\subsubsection{{\tt arg\_pick} --- {\tt -pick} $n$: Duplicate the $n$th item from the stack}

@d arg\_pick: Duplicate the $n$th item from the stack
@{
    sub arg_pick {
        my ($name, $value) = @@_;

        stackCheck($value + 1);
        push(@@seeds, $seeds[$#seeds - $value]);
    }
@| arg_pick @}

\subsubsection{{\tt arg\_pseudo} --- {\tt -pseudo}: Generate pseudorandom seed and push on stack}

@d arg\_pseudo: Generate pseudorandom seed and push on stack
@{
    sub arg_pseudo {
        randInit();
        @<Begin command repeat@>
            my $s = "";
            for (my $i = 0; $i < 32; $i++) {
                $s .= sprintf("%02X", randNext(256));
            }
            push(@@seeds, $s);
        @<End command repeat@>
    }
@| arg_pseudo @}

\subsubsection{{\tt arg\_random} --- {\tt -random}: Request seed(s) from strong generator}

@d arg\_random: Request seed(s) from strong generator
@{
    sub arg_random {
        my $n = 32 * $repeat;
        my $rgen = new Crypt::Random::Seed;
        if (defined($rgen)) {
            my $rbytes = $rgen->random_bytes($n);
            while ($rbytes =~ s/^(.{32})//s) {
                my $hn = $1;
                push(@@seeds, bytesToHex($hn));
            }
        } else {
            print("No strong random generator available.");
        }
    }
@| arg_random @}

\subsubsection{{\tt arg\_roll} --- {\tt -roll} $n$: Rotate item $n$ to top of stack}

@d arg\_roll: Rotate item $n$ to top of stack
@{
    sub arg_roll {
        my ($name, $value) = @@_;

        stackCheck($value + 1);
        my $itemn = splice(@@seeds, -($value + 1), 1);
        push(@@seeds, $itemn);
    }
@| arg_roll @}

\subsubsection{{\tt arg\_rot} --- {\tt -rot}: Rotate three stack items}

@d arg\_rot: Rotate three stack items
@{
    sub arg_rot {
        stackCheck(3);
        my $item3 = splice(@@seeds, -3, 1);
        push(@@seeds, $item3);
    }
@| arg_rot @}

\subsubsection{{\tt arg\_rrot} --- {\tt -rrot}: Reverse rotate three stack items}

@d arg\_rrot: Reverse rotate three stack items
@{
    sub arg_rrot {
        stackCheck(3);
        my $item1 = pop(@@seeds);
        splice(@@seeds, 2, 0, $item1);
    }
@| arg_rrot @}

\subsubsection{{\tt arg\_seed} --- {\tt -seed} {\em hex}: Push seed on stack}

@d arg\_seed: Push seed on stack
@{
    sub arg_seed {
        my ($name, $value) = @@_;

        $value =~ s/^0x//i;
        if ($value !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
        push(@@seeds, uc($value));
    }
@| arg_seed @}

\subsubsection{{\tt arg\_sha256} --- {\tt -sha256}: Replace top of stack with its SHA256 hash}

@d arg\_sha256: Replace top of stack with its SHA256 hash
@{
    sub arg_sha256 {
        stackCheck(1);
        my $bytes = hexToBytes(pop(@@seeds));
        my $sha256 = uc(sha256_hex($bytes));
        push(@@seeds, $sha256);
    }
@| arg_sha256 @}

\subsubsection{{\tt arg\_shuffle} --- {\tt -shuffle}: Shuffle bytes on stack}

Shuffle the bytes of all items on the stack.  Why would you want to do
this?  Suppose, for example, you've obtained entropy from a source on
the Internet and, despite retrieving it using {\tt https:}, are worried
about the data being intercepted along the way or archived by the site
that generated it.  You can allay that risk, in part, by generating a
much larger quantity of data than you need, shuffling the bytes using a
different seed generated locally, then using a key from the shuffled
bytes.  If the sample from which you select your actual key is
sufficiently large, guessing which bytes were chosen is intractable.

@d arg\_shuffle: Shuffle bytes on stack
@{
    sub arg_shuffle {
        stackCheck(1);
        my $allbytes = hexToBytes(join("", @@seeds));
        @@seeds = ( );
        my $sbytes = bytesToHex(shuffleBytes($allbytes));
        while ($sbytes =~ s/^(\w{64})//) {
            push(@@seeds, $1);
        }
    }
@| arg_shuffle @}

\subsubsection{{\tt arg\_swap} --- {\tt -swap}: Swap the two top items on the stack}


@d arg\_swap: Swap the two top items on the stack
@{
    sub arg_swap {
        my ($name, $value) = @@_;

        stackCheck(2);
        my $itemn = splice(@@seeds, -2, 1);
        push(@@seeds, $itemn);
    }
@| arg_swap @}

\subsubsection{{\tt arg\_test} --- {\tt -test}: Test randomness of top of stack}

Take the seed on the top of the stack and feed it to
\href{https://www.fourmilab.ch/random/}{\tt ent} to perform an
analysis of its randomness.  Note that when interpreting these results,
the brevity of the seed (just 256 bits) will cause it to appear less
than random compared to a larger sample.  We perform the randomness
tests on a bit-level basis, as byte-level tests are useless on such a
small sample.

@d arg\_test: Test the stack top item for randomness
@{
    sub arg_test {
        stackCheck(1);
        my $r = "Randomness analysis:\n";
        my $ent_analysis = `echo $seeds[$#seeds] | xxd -r -p - | ent -b`;
        $ent_analysis =~ s/\n\n/\n/gs;
        $ent_analysis =~ s/^/    /mg;
        $ent_analysis =~ s/(of this|would exceed)/  $1/gs;
        print("$ent_analysis");
    }
@| arg_test @}

\subsubsection{{\tt arg\_testall} --- {\tt -testall}: Test randomness of entire stack}

Tests the entire contents of the stack for randomness with
\href{https://www.fourmilab.ch/random/}{\tt ent}.  The
stack items are concatenated, from top to bottom, and the
resulting bit stream tested.  This can be used to evaluate
random sources used to generate multiple keys.

@d arg\_testall: Test entire stack contents for randomness
@{
    sub arg_testall {
        stackCheck(1);
        my $catseed = join("", @@seeds);
        my $r = "Randomness analysis:\n";
        my $ent_analysis = `echo $catseed | xxd -r -p - | ent -b`;
        $ent_analysis =~ s/\n\n/\n/gs;
        $ent_analysis =~ s/^/    /mg;
        $ent_analysis =~ s/(of this|would exceed)/  $1/gs;
        print("$ent_analysis");
    }
@| arg_testall @}

\subsubsection{{\tt arg\_urandom} --- {\tt -urandom}: Request seed(s) from fast generator}

@d arg\_urandom: Request seed(s) from fast generator
@{
    sub arg_urandom {
        my $n = 32 * $repeat;
        my $rgen = Crypt::Random::Seed->new(NonBlocking => 1);
        if (defined($rgen)) {
            my $rbytes = $rgen->random_bytes($n);
            while ($rbytes =~ s/^(.{32})//s) {
                my $hn = $1;
                push(@@seeds, bytesToHex($hn));
            }
        } else {
            print("No fast random generator available.");
        }
    }
@| arg_urandom @}

\subsubsection{{\tt arg\_wif} --- {\tt -wif} {\em key}: Push seed extracted from
    Wallet Input Format (WIF) private key on stack}

Extract the seed from the private key argument supplied in Wallet
Import Format (WIF) and push the seed on the stack.

@d arg\_wif: Load seed from Wallet Input Format (WIF) private key
@{
    sub arg_wif {
        my ($name, $value) = @@_;

        my $priv = Bitcoin::Crypto::Key::Private->from_wif($value);
        my $seed = $priv->to_hex();
        push(@@seeds, uc($seed));
    }
@| arg_wif @}


\subsubsection{{\tt arg\_xor} --- {\tt -xor}: Exclusive-or top two stack items}

Exclusive-or the two top items on the stack, removing them and pushing
the result.

@d arg\_xor: Exclusive-or top two stack items
@{
    sub arg_xor {
        stackCheck(2);
        my $ol = hexToBytes(pop(@@seeds));
        my $or = hexToBytes(pop(@@seeds));
        if (bytes::length($ol) != bytes::length($or)) {
            print("-xor: arguments are different lengths.\n");
            exit(1);
        }
        my $rbytes;
        for (my $i = 0; $i < bytes::length($ol); $i++) {
            $rbytes .= chr(ord(bytes::substr($ol, $i, 1))) ^
                       chr(ord(bytes::substr($or, $i, 1)));
        }
        push(@@seeds, bytesToHex($rbytes));
    }
@| arg_xor @}

\subsubsection{{\tt arg\_zero} --- {\tt -zero}: Push all zeroes on the stack}

Push a value of all zero bits on the stack.  This is shortcut for
explicitly specifying such a value with {\tt -seed}.

@d arg\_zero: Push all zeroes on the stack
@{
    sub arg_zero {
        @<Begin command repeat@>
            push(@@seeds, "00" x 32);
        @<End command repeat@>
     }
@| arg_zero @}

\subsubsection{Repeat command if {\tt -repeat} specified}

These macros are wrapped around sequences of code which should be
executed the number of times specified by the {\tt -repeat} command.

@d Begin command repeat
@{
    for (my $rpt = 0; $rpt < $repeat; $rpt++) {
@}

@d End command repeat
@{
    }
@}

\subsubsection{Open output file}

These macros enclose code whose output should be sent to the console
or written to the file named by a previous {\tt -outfile} command.

@d Open output file
@{
    if ($outputFile ne "-") {
        open(OFILE, ">$outputFile") || die("Cannot create file $outputFile");
        select OFILE;
    }
@}

@d Close output file
@{
    if ($outputFile ne "-") {
        select STDOUT;
        close(OFILE);
    }
@}

\subsection{{\tt genBtcAddress} --- Generate address from one hexadecimal seed}

A Bitcoin address and private key pair are generated from the
argument, which specifies the 256 bit random seed as 64 hexadecimal
digits.  The private key and public address objects are returned
in a list.

@d genBtcAddress: Generate Bitcoin address from one hexadecimal seed
@{
    sub genBtcAddress {
        my ($seed, $mode, $n) = @@_;

        if ($seed !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
@| genBtcAddress @}

Generate the private key from the hexadecimal seed.

@d genBtcAddress: Generate Bitcoin address from one hexadecimal seed
@{
        my $priv = Bitcoin::Crypto::Key::Private->from_hex($seed);
@}

Verify that we can decode the seed from the private key.

@d genBtcAddress: Generate Bitcoin address from one hexadecimal seed
@{
        my $dhex = uc($priv->to_hex());
        if ($dhex ne $seed) {
            die("Verify failed: Decoded " . $priv->to_hex() . "\n" .
                "               Encoded $seed");
        }
@}

Generate the public Bitcoin address from the private key.  Note that
if you're storing the private key, you needn't store the public
address with it, since you can always re-generate it in any form
you wish from the private key.

@d genBtcAddress: Generate Bitcoin address from one hexadecimal seed
@{
        my $pub = $priv->get_public_key();

        return ($priv, $pub);
    }
@}

\subsection{{\tt editBtcAddress} --- Edit private key and public address}

@d editBtcAddress: Edit Bitcoin private key and public address
@{
    sub editBtcAddress {
        my ($priv, $pub, $mode, $n) = @@_;
@| editBtcAddress @}

Extract the seed from the private key in hexadecimal and encode it
in base64.

@d editBtcAddress: Edit Bitcoin private key and public address
@{
        my $phex = uc($priv->to_hex());
        my $pb64 = encode_base64($priv->to_bytes());
        chomp($pb64);
@}

Generate compressed and uncompressed private keys, both encoded
in WIF (Wallet Import Format).  This is how private keys are usually
stored in an off-line or paper wallet.

@d editBtcAddress: Edit Bitcoin private key and public address
@{
        $priv->set_compressed(TRUE);
        my $WIFc = $priv->to_wif();

        $priv->set_compressed(FALSE);
        my $WIFu = $priv->to_wif();
@}

Generate the public Bitcoin address from the private key.  Note that if
you're storing the private key, you needn't store the public address
with it, since you can always re-generate it in any form you wish from
the private key.  We generate all forms of public addresses, compressed
and uncompressed.

@d editBtcAddress: Edit Bitcoin private key and public address
@{
        $pub->set_compressed(TRUE);
        my $pub_legacy = $pub->get_legacy_address();
        my $pub_compat = $pub->get_compat_address();
        my $pub_segwit = $pub->get_segwit_address();
        my $pub_hex = uc($pub->to_hex());

        $pub->set_compressed(FALSE);
        my $pub_legacy_u = $pub->get_legacy_address();
        my $pub_compat_u = $pub->get_compat_address();
        my $pub_segwit_u = $pub->get_segwit_address();
        my $pub_hex_u = uc($pub->to_hex());
@}

Compose the output representation of the private key and public
address.  The format is specified by \verb+$mode+, which can
be ``{\tt CSV}{\em t}'', where ``{\em t}'' is one or more of:

\begin{quote}
\begin{description}
\dense
    \item[{\tt b}]  Exclude private key from CSV file
    \item[{\tt q}]  Use uncompressed private key
    \item[{\tt u}]  Use uncompressed public address
    \item[{\tt l}]  Legacy (``{\tt 1}'') public address
    \item[{\tt c}]  Compatible (``{\tt 3}'') public address
    \item[{\tt s}]  Segwit ``{\tt bc1}'' public address
\end{description}
\end{quote}

@d editBtcAddress: Edit Bitcoin private key and public address
@{
        my $r = "";

        if ($mode =~ m/^CSV(\w*)$/) {
            my $CSVmodes = $1;

            #   Comma-separated value file

            my $privK = $WIFc;
            if ($CSVmodes =~ m/b/i) {       # b     Exclude private key
                $privK = "";
            }
            if ($CSVmodes =~ m/q/i) {       # q     Uncompressed private key
                $privK = $WIFu;
            }
            my $comp = $CSVmodes !~ m/u/i;  # u     Uncompressed public address
            my $pubK = $comp ? $pub_legacy : $pub_legacy_u;
            if ($CSVmodes =~ m/c/i) {       # c     Compatible ("3") public address
                $pubK = $comp ? $pub_compat : $pub_compat_u;
            } elsif ($CSVmodes =~ m/s/i) {  # s     Segwit "bc1" public address
                $pubK = $comp ? $pub_segwit : $pub_segwit_u;
            }

            $r = "$n,\"$pubK\",\"$privK\"\n";

        } else {
@}

If \verb+$mode+ is anything else, primate-readable output is generated.
This includes all formats of the private key and public address, from
which the user may choose whichever they prefer.

@d editBtcAddress: Edit Bitcoin private key and public address
@{
            #   Human-readable output

            #   Display private key seed in hexadecimal

            $r .= "Private key:\n";
            $r .= "    Hexadecimal:      $phex\n";
            $r .= "    Base64:           $pb64\n";
            $r .= BIP39encode("    BIP39:            ", $phex, 64);

            #   Display private key in both compressed and
            #   uncompressed  formats.

            $r .= "    WIF compressed:   $WIFc\n";
            $r .= "    WIF uncompressed: $WIFu\n";

            #   Display public Bitcoin address in various formats

            $r .= "\nPublic Bitcoin address:\n" .
                  "  Compressed:\n" .
                  "    Legacy:  $pub_legacy\n" .
                  "    Compat:  $pub_compat\n" .
                  "    Segwit:  $pub_segwit\n" .
                  "    Hex:     $pub_hex\n" .
                  "  Uncompressed:\n" .
                  "    Legacy:  $pub_legacy_u\n" .
                  "    Compat:  $pub_compat_u\n" .
                  "    Segwit:  $pub_segwit_u\n" .
                  "    Hex:     $pub_hex_u\n";

            return $r;
        }
    }
@}

\subsection{{\tt genEthAddress} --- Generate Ethereum address from one hexadecimal seed}

An Ethereum address and private key pair are generated from the
argument, which specifies the 256 bit random seed as 64 hexadecimal
digits.  The private key and public address objects are returned
in a list.  Note that we use the {\tt Bitcoin::Crypto::Key} package
here to generate the public and private keys from the seed.  This
is not an error---Bitcoin and Ethereum use identical elliptic curve
generator points and algorithms, so we can simply use the Bitcoin
code as-is and then proceed to the different subsequent encoding
employed by Ethereum.

@d genEthAddress: Generate Ethereum address from one hexadecimal seed
@{
    sub genEthAddress {
        my ($seed, $mode, $n) = @@_;

        if ($seed !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
@| genEthAddress @}

Generate the private key from the hexadecimal seed.

@d genEthAddress: Generate Ethereum address from one hexadecimal seed
@{
        my $priv = Bitcoin::Crypto::Key::Private->from_hex($seed);
@}

Verify that we can decode the seed from the private key.

@d genEthAddress: Generate Ethereum address from one hexadecimal seed
@{
        my $dhex = uc($priv->to_hex());
        if ($dhex ne $seed) {
            die("Verify failed: Decoded " . $priv->to_hex() . "\n" .
                "               Encoded $seed");
        }
@}

Generate the public Ethereum address from the private key.

@d genEthAddress: Generate Ethereum address from one hexadecimal seed
@{
        my $pub = $priv->get_public_key();

        return ($priv, $pub);
    }
@}

\subsection{{\tt editEthAddress} --- Edit Ethereum private key and public address}

@d editEthAddress: Edit Ethereum private key and public address
@{
    sub editEthAddress {
        my ($priv, $pub, $mode, $n) = @@_;
@| editEthAddress @}

Extract the seed from the private key in hexadecimal and encode it
in base64.

@d editEthAddress: Edit Ethereum private key and public address
@{
        my $phex = "0x" . $priv->to_hex();
@}


@d editEthAddress: Edit Ethereum private key and public address
@{
        $pub->set_compressed(FALSE);
        my $pub_hex_u = $pub->to_hex();
        my $pub_addr = "0x" .
            substr(keccak256_hex(hexToBytes(substr($pub_hex_u, 2))), -40);
        my $pub_addrc = computeEthChecksum($pub_addr);
@}

Compose the output representation of the private key and public
address.  The format is specified by \verb+$mode+, which can
be ``{\tt CSV}{em t}'', where ``{\tt t}'' is one or more of:

\begin{quote}
\begin{description}
\dense
    \item[{\tt b}]  Exclude private key from CSV file
    \item[{\tt n}]  No checksum on public address
    \item[{\tt p}]  Include full public key
\end{description}
\end{quote}

@d editEthAddress: Edit Ethereum private key and public address
@{
        my $r = "";

        if ($mode =~ m/^CSV(\w*)$/) {
            my $CSVmodes = $1;

            my $dpub_addr = ($CSVmodes =~ m/n/i) ? $pub_addr : $pub_addrc;
            my $pkey = ($CSVmodes =~ m/p/i) ? ",\"$pub_hex_u\"" : "";
            if ($CSVmodes =~ m/b/i) {       # b     Exclude private key
                $phex = "";
            }

            $r = "$n,\"$dpub_addr\",\"$phex\"$pkey\n";

        } else {
@}

If \verb+$mode+ is anything other than {\tt CSV}, primate-readable
output is generated. This includes all formats of the private key and
public address, from which the user may choose whichever they prefer.

@d editEthAddress: Edit Ethereum private key and public address
@{
            #   Human-readable output

            #   Display private key seed in hexadecimal

            $r .= "Private key:\n";
            $r .= "  Hexadecimal: $phex\n";

            #   Display public Ethereum address

            $r .= "\nPublic Ethereum address:\n" .
                  "  Address:     $pub_addr\n" .
                  "  Checksum:    $pub_addrc\n" .
                  "  Public key:  $pub_hex_u\n";

            return $r;
        }
    }
@}

\subsection{{\tt computeEthChecksum}: Add checksum to Ethereum address}

Ethereum addresses have an optional, most curious, checksum mechanism.
Originally, Ethereum addresses were just hexadecimal addresses
extracted from a hash of the public key as described above in
{\tt genEthAddress()} and {\tt editEthAddress()}.  A single character
error in entering or transcribing such an address, as long as it
remained a valid 40 digit hexadecimal number, would result in sending
funds to ``etherspace''---lost forever without any hope of recovery,
since finding a private key which maps to the incorrect address is
intractable.

Bitcoin addresses contain a checksum which catches, with a very high
probability, such errors.  To remedy the shortcoming in Ethereum
addresses, in 2016 a proposed standard was published,
``\href{https://eips.ethereum.org/EIPS/eip-55}{EIP-55:
Mixed-case checksum address encoding}'', which prescribed the following
upward-compatible scheme.

The computed hexadecimal address, with lower case letters for digits
``{\tt a}'' through ``{\tt f}'', is used to compute a Keccak256 digest
(the same hash algorithm used in computing the public address) of the
address (its hexadecimal text representation, not the binary value).
Next, scan the 40 character public hexadecimal address, ignoring all
digits from 0 to 9.  For each letter, check the hexadecimal digit at
the corresponding position in the hash (obviously, only the first 40
characters of the hash will be used).  If the digit is between 8 and F,
the letter in the address is converted from lower to upper case.

Clients unaware of checksums will ignore the case of the hexadecimal
digits.  Checksum-aware clients will, when presented with an address
containing mixed case characters, recompute the checksum and, if it
doesn't match, report the error.  Note that an address which contains
only digits from 0 to 9 or, when checksummed, happens to come out all
capitals or all lower case, will evade the checksum test.  Still, it's
better than nothing.

@d computeEthChecksum: Add checksum to Ethereum address
@{
    sub computeEthChecksum {
        my ($eaddr) = @@_;

        my $eal = lc($eaddr);
        #   Strip leading hex specification, if present
        $eal =~ s/^0x//;
        my $eahash = keccak256_hex($eal);
        for (my $i = 0; $i < length($eal); $i++) {
            my $ch = substr($eal, $i, 1);
            if ($ch =~ m/[a-f]/) {
                if (substr($eahash, $i, 1) =~ m/[89a-f]/) {
                    substr($eal, $i, 1) = uc($ch);
                }
            }
        }
        return "0x$eal";
    }
@| computeEthChecksum @}

\subsection{{\tt BIP39encode} --- Encode seed as BIP39 mnemonic phrase}

This function encodes a 256 bit seed as a sequence of words according
to \href{https://en.bitcoin.it/wiki/BIP_0039}{Bitcoin Improvement
Proposal 39} (BIP39), using the
\href{https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt}{English word list}
from the \href{https://github.com/trezor/python-mnemonic}{reference implementation}.
The words are arranged in multiple lines of maximum length
{\tt \$maxlen} using the specified {\tt \$prefix} on the first line.
The Perl {\tt
\href{https://metacpan.org/pod/Bitcoin::BIP39}{Bitcoin::BIP39}}
package we use supports word lists for several other languages, but
BIP39 states ``it is {\bf strongly discouraged} to use non-English
wordlists for generating the mnemonic sentences'' (emphasis in the
original).

@d BIP39encode: Encode seed as BIP39 mnemonic phrase
@{
    sub BIP39encode {
        my ($prefix, $seed, $maxlen) = @@_;

        my $s = $prefix;
        my $cont = " " x length($prefix);
        my $r = "";
        my $bip39 = entropy_to_bip39_mnemonic( entropy_hex => $seed );
        my @@b39 = split(/\s+/, $bip39);
        foreach my $word (@@b39) {
            if ((length($s) + length($word)) > $maxlen) {
                $s =~ s/\s+$//;
                $r .= "$s\n";
                $s = $cont;
            }
            $s .= "$word ";
        }
        $s =~ s/\s+$//;
        $r .= "$s\n";
        return $r;
    }
@| BIP39encode @}

\subsection{{\tt stackCheck} ---  Check for stack underflow}

@d stackCheck:  Check for stack underflow
@{
    sub stackCheck {
        my ($required) = @@_;

        if ($required > scalar(@@seeds)) {
            print("Stack underflow: $required item(s) needed, only " .
                scalar(@@seeds) . " present.\n");
            exit(1) if !$interactive;
            die("Stack underflow");
        }
    }
@| stackCheck @}

\subsection{{\tt hexToBytes} --- Convert hexadecimal string to binary}

@d hexToBytes: Convert hexadecimal string to binary
@{
    sub hexToBytes {
        my ($hex) = @@_;

        my $bytes;
        while ($hex =~ s/^([\dA-F]{2})//i) {
            $bytes .= chr(hex($1));
        }
        return $bytes;
    }
@| hexToBytes @}

\subsection{{\tt bytesToHex} --- Convert binary string to hexadecimal}

@d bytesToHex: Convert binary string to hexadecimal
@{
    sub bytesToHex {
        my ($bytes) = @@_;

        my $hex;
        for (my $i = 0; $i < bytes::length($bytes); $i++) {
            $hex .= sprintf("%02X", ord(bytes::substr($bytes, $i, 1)));
        }
        return $hex;
    }
@| bytesToHex @}

\subsection{{\tt showHelp} --- Show help information}

@d showHelp: Show Bitcoin address help information
@{
    sub showHelp {
        my $help = <<"    EOD";
perl blockchain_address.pl [ command... ]
  Commands and arguments:
    -aes                Encrypt second item on stack with top of stack key
    -bindump filename   Dump seeds from stack to binary file
    -binfile filename   Load seed(s) from binary file
    -btc                Generate Bitcoin public address/private key from stack seed
    -clear              Clear stack
    -drop               Drop top item on stack
    -dup                Duplicate top item on stack
    -eth                Generate Ethereum address/private key from stack seed
    -format f           Select CSV key output mode: CSVx, where x is
                            Bitcoin:
                              b   Suppress private key
                              c   Compatible public address ("3...")
                              k   Keep addresses on stack
                              l   Legacy public address ("1...")
                              q   Uncompressed private key
                              s   Segwit public address ("bc1...")
                              u   Uncompressed public address
                            Ethereum:
                              b   Suppress private key
                              k   Keep addresses on stack
                              n   No checksum on public address
                              p   Include full public key
    -hbapik hbapikey    Specify HotBits API key
    -help               Print this message
    -hexfile filename   Load hexadecimal seed(s) from filename
    -hotbits            Get seed(s) from HotBits, place on stack
@}

@d showHelp: Show Bitcoin address help information
@{    -inter              Process interactive commands
    -mnemonic           Generate BIP39 mnemonic phrase from stack top
    -not                Invert stack top
    -outfile filename   Redirect key generation output to file or - for console
    -over               Duplicate second item on stack to top
    -p                  Print top item on stack
    -phrase words...    Specify seed as BIP39 menemonic phrase
    -pick n             Duplicate the nth item on the stack to top
    -pseudo             Generate pseudorandom seed and push on stack
    -random             Obtain a seed from system strong generator, push on stack
    -repeat n           Repeat following commands n times
    -roll n             Rotate item n to top of stack
    -rot                Rotate the top three stack items
    -rrot               Reverse rotate top three stack items
    -seed hex           Push the hexadecimal seed on top of stack
    -sha256             Replace top of stack with its SHA256 digest
    -shuffle            Shuffle all bytes on stack
    -swap               Swap the two top items on the stack
    -test               Test randomness of top of stack
    -testall            Test entire stack contents for randomness
    -type Any text      Display text argument on standard output
    -urandom            Obtain a seed from system fast generator, push on stack
    -wif                Push seed extracted from Wallet Input Format private key
    -xor                Bitwise exclusive-or top two stack items
    -zero               Push zeroes on stack
EOD
        $help =~ s/^    //gm;
        print($help);
        if (!$interactive) {
            exit(0);
        }
    }
@}

\chapter{Multiple Key Manager}

The @<MK@> program implements
\href{https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing}{Shamir
Secret Sharing} for blockchain private keys, allowing them to be
distributed among multiple custodians or storage locations, then
reconstructed from a minimum specified number of parts.  Each secret
key is split into $n$ parts ($n\geq 2$), of which any $k, k\leq n$
are sufficient to reconstruct the entire original key, but from which
the key cannot be computed from fewer than $k$ parts.  In the
implementation below, we refer to $n$ as the number of {\tt parts}
and $k$ as the number {\tt needed}.  The heavy lifting is done by
the Perl library module
\href{https://metacpan.org/pod/Crypt::SSSS}{\tt Crypt::SSSS}.

The blockchain addresses and private keys are specified in a
Comma-Separated Value (CSV) file in the format produced by @<BA@>
and used by other utilities in the collection.  Both Bitcoin and
Ethereum addresses may be used.

\section{Program plumbing}

@o perl/multi_key.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    use Crypt::SSSS;
    use Digest::SHA qw(sha256 sha256_hex);
    use List::Util qw(shuffle);
    use Text::CSV qw(csv);
    use POSIX qw(log10);
    use Getopt::Long;
@}

\section{Settings and option processing}

@o perl/multi_key.pl
@{
    my $basename = "";                  # Base name for generated files
    my $join = FALSE;                   # Join parts into complete keys
    my $prime = 257;                    # Prime used to set security
    my $parts = 3;                      # Number of shared keys to generate
    my $needed = 3;                     # Shared keys to reassemble address

    GetOptions(
        "help"      =>  \&showHelp,
        "join"      =>  \$join,
        "name=s"    =>  \$basename,
        "needed=i"  =>  \$needed,
        "parts=i"   =>  \$parts,
        "prime=i"   =>  \$prime
    ) || die("Command line option error");

    my $csv = Text::CSV->new({ binary => 1 }) ||
        die("Cannot use CSV: " . Text::CSV->error_diag());

    if ($basename eq "") {
        if ((scalar(@@ARGV) > 0) && ($ARGV[0] ne "")) {
            $basename = $ARGV[0];
            $basename =~ s/\.\w*$//;
        }
        if ($basename eq "") {
            $basename = $join? "joined_keys-1" : "shared_keys";
        }
    }
@}

\section{First pass}

On the first pass, read the records from the input file(s) and save
them in the @@records array.  We use the {\tt Text::CSV} parser for the
standard first three fields (label, address, and private key), then
save any extra material which follows them to be re-appended when the
output file is written.  This allows preserving extra information, such
as balances, when keys are split and reassembled.

@o perl/multi_key.pl
@{
    my @@records;
    my $naddrs = 0;
    while (my $l = <>) {
        chomp($l);
        $l =~ s/^\s+//;
        $l =~ s/\s+$//;
        if (($l ne "") && ($l !~ m/^#/)) {
            my $extra;
            if (($l !~ m/\s*\-1,/) && ($l =~ s/^([^,]+,[^,]+,[^,]+)(,.*)$/$1/)) {
                $extra = $2;
            }
            if ($csv->parse($l)) {
                $naddrs++;
                my @@fields = $csv->fields;
                if ($extra) {
                    $fields[3] = $extra;
                }
                push(@@records, \@@fields);
           }
        }
    }
@}

After loading the records, if this is a join operation, invoke the
{\tt joinParts()} function to perform it.

@o perl/multi_key.pl
@{
    if ($join) {
        exit(joinParts());
    }
@}

\section{Split private keys into parts}

Each private key in the input file will be encoded into the
specified number of {\tt parts}, and written to separate CSV
output files which bear the base name of the first input file
with a hyphen and part number appended.

\subsection{Create part output files}

Start by creating the files of each of the split key parts.  These
are CSV files like those used for addresses and keys, except the
key field is replaced by the encoded part for that key.  The files
have headers with fields:

{\tt -1,}{\em parts}{\tt ,}{\em needed}{\tt ,}{\em prime}{\tt ,}{\em partno}

where {\em parts} is the number of parts, of which {\em needed} are
required to reconstruct the key, {\em prime} is the prime number used
in the encoding, and {\em partno} is the number of this part, from
1 to {\em parts}.

@o perl/multi_key.pl
@{
    my $fnd = int(log10($parts)) + 1;
    my @@files;
    for (my $f = 1; $f <= $parts; $f++) {
        my $fnx = sprintf("%s-%0${fnd}d.csv", $basename, $f);
        open($files[$f], ">$fnx") || die("Cannot create $fnx");
        $files[$f]->printf("-1,$parts,$needed,$prime,$f\n");
    }
@}

\subsection{Process key records}

Process records, replacing the original private key with the
shared key part in each file.

@o perl/multi_key.pl
@{
    my $fail = 0;

    for (my $r = 0; $r < scalar(@@records); $r++) {
@}

\subsubsection{Encode and checksum the private key}

To permit validation of the private key after it is reconstructed from
parts, encode it by prefixing it with its length, then compute and
append the double SHA256 checksum to the end.  It is this encoded key
which is actually split into parts.

@o perl/multi_key.pl
@{
        my $privkey = chr(32 + length($records[$r]->[2])) . $records[$r]->[2];
        $privkey .= compCheck($privkey);

        my $shares = ssss_distribute(
            message =>  $privkey,
            k       =>  $needed,
            n       =>  $parts,
            p       =>  $prime
        );
@}

\subsubsection{Write the split parts to part files}

Assemble the part item, prefixing it with the
type sentinel, part number, and delimiter, and
computing and appending the checksum of these.
We save a copy of the parts in @@hexpart, which we'll
use to confirm the ability to reconstruct the key
from the parts in the safety check below.  A record
is added to the part file, consisting of the fields from
the original key record but with the private key replaced
by the encoded part.  The part items are saved in the
{\tt @@hexpart} array for our subsequent reconstruction
quality check.

@o perl/multi_key.pl
@{
        my @@hexpart;
        for (my $f = 1; $f <= $parts; $f++) {
            my $hexcheck = sprintf("S%0${fnd}d-%s", $f,
                unpack("H*", $shares->{$f}->binary));
            $hexcheck .= compCheck($hexcheck);
            push(@@hexpart, $hexcheck);
            my $extra = $records[$r]->[3] ? $records[$r]->[3] : "";
            $files[$f]->printf("%s,\"%s\",\"%s\"%s\n", $records[$r]->[0],
                $records[$r]->[1], $hexcheck, $extra);
        }
@}

\subsubsection{Reconstruction quality check}

Now that we've generated the parts for this address and written them to
the parts files, using copies of the parts squirreled away in the
@@hexpart array, re-assemble them in random order as many different
ways as there are parts. This verifies that when the time comes we'll
actually be able to reconstruct the original keys from the parts files.

@o perl/multi_key.pl
@{
        for (my $l = 0; $l < $parts; $l++) {

            #   Shuffle order of parts before reconstruction
            @@hexpart = shuffle(@@hexpart);

            #   Perform reconstruction of key from groups of shuffled parts

            for (my $p = 0; $p <= ($parts - $needed); $p++) {
                my $rkey = { };
                for (my $q = $p; $q < ($p + $needed); $q++) {
                    my ($pstat, $pno, $hxp) =  parsePart($hexpart[$q]);
                    if ($pstat < 0) {
                        die("Cannot parse hex part $q " .
                            "$hexpart[$q]: ($pstat, $pno, $hxp)\n");
                    }
                    #   Unpack the hex part payload to bytes and save in parts hash
                    $rkey->{$pno} = pack('C*',  map({ hex($_) } ($hxp =~ /(..)/g)));
                }
                my $rpk = ssss_reconstruct(p => $prime, shares => $rkey);
                my ($kstat, $privad) = parseKey($rpk);
                if (!$kstat) {
                    die("Bad checksum in reconstructed record: $rpk\n  $privad");
                }
                if ($records[$r]->[2] ne $privad) {
                    $fail++;
                    printf(STDERR "** Reconstruction failure on key %d, " .
                        "parts %d through %d:\n   Exp: (%s)\n   Rcv: (%s)\n",
                        $r, ($p + 1), ($p + $needed), $records[$r]->[2], $privad);
                }
            }
        }
    }
@}

\subsection{Close part files}

When all keys have been split and written to the part files, we're
done.  Close the part files and exit.  If an error occurred in the
split or test reconstruction process, delete the part files to avoid
a tragedy which might occur were they kept and later used to try to
reconstruct keys.  The exit status indicates whether the parts were
successfully generated (0) or an error occurred (1).

@o perl/multi_key.pl
@{
    for (my $f = 1; $f <= $parts; $f++) {
        close($files[$f]);
    }

    #   If errors were detected, delete part files to avoid tragedy
    if ($fail > 0) {
        print(STDERR "Failures to reconstruct keys from parts: $fail.\n" .
                     "  Deleting part files.\n");
        for (my $f = 1; $f <= $parts; $f++) {
            unlink(sprintf("%s-%0${fnd}d.csv", $basename, $f));
        }
    }

    exit($fail > 0);
@}

\section{Join parts into complete keys}

When @<MK@> is invoked with the {\tt -join}, the input is expected
to be the concatenation of the {\em needed} number of split key files
produced by an earlier run.  These may be specified as multiple file
names on the command line, and may be in any order.  If more split
parts are supplied than needed, a warning is issued and the extras
ignored.

@o perl/multi_key.pl
@{
    sub joinParts {
        my $warn = 0;
        my $error = 0;

        my ($restParts, $restNeeded, $restPrime, $restPart);
        my %partsSeen;
        my @@addresses;
        my %parts;
@| joinParts @}

\subsection{Read split parts, validate, and save}

Process all of the records read from the input file, representing
the parts to be reconstructed.  Each is checked, and saved as an
object in a hash with a key of the public address to which it
corresponds.

@o perl/multi_key.pl
@{
        for (my $r = 0; $r < scalar(@@records); $r++) {
@}

\subsubsection{Process part definition record}

If this is a part definition record, identified by a value of
$-1$ in the {\em label} field, validate it and save for
subsequent processing.

@o perl/multi_key.pl
@{
            #   Test for part definition record and process
            if ($records[$r]->[0] eq "-1") {
                #   Check for inconsistency among parts and save
                #   the part generation parameters.
                if ($restParts && ($restParts != $records[$r]->[1])) {
                    printf("Warning: Record definition for part %d " .
                           "part count %d inconsistent " .
                           "with previous parts (%d).\n",
                           $records[$r]->[4], $records[$r]->[1], $restParts);
                    $warn++;
                } else {
                    $restParts = $records[$r]->[1];
                }

                if ($restNeeded && ($restNeeded != $records[$r]->[2])) {
                    printf("Warning: Record definition for part %d " .
                           "parts needed %d inconsistent " .
                           "with previous parts (%d).\n",
                           $records[$r]->[4], $records[$r]->[2], $restNeeded);
                    $warn++;
                } else {
                    $restNeeded = $records[$r]->[2];
                }

                if ($restPrime && ($restPrime != $records[$r]->[3])) {
                    printf("Warning: Record definition for part %d " .
                           "parts needed %d inconsistent " .
                           "with previous parts (%d).\n",
                           $records[$r]->[4], $records[$r]->[3], $restPrime);
                     $warn++;
               } else {
                    $restPrime = $records[$r]->[3];
                }

                #   Warn if this is a duplicate specification of this part
                $restPart = $records[$r]->[4];
                if ($partsSeen{$restPart}) {
                    printf("Warning: Duplicate specification for part %d.\n", $restPart);
                    $warn++;
                } else {
                    $partsSeen{$restPart} = TRUE;
                }
            } else {
@}

\subsubsection{Process private key part record}

Otherwise, this is a record specifying a part of the private key
for an address.  Parse it, validate the checksum in the part
item, verify the part number corresponds to that expected from
the previous header record, and save in a hash keyed by the
public address pointing to an array indexed by part number.

@o perl/multi_key.pl
@{
                my ($label, $pubaddr, $partkey, $extra) = ($records[$r]->[0],
                    $records[$r]->[1], $records[$r]->[2], $records[$r]->[3]);
                my ($pstat, $pno, $pvalue) = parsePart($partkey);

                if (!defined($extra)) {
                    $extra = "";
                }

                if ($pstat < 0) {
                    if ($pstat == -1) {
                        printf("Error: cannot parse part %d key: %s\n", $restPart,
                            $partkey);
                    } else {
                        printf("Error: bad checksum in part %d key: %s\n", $restPart,
                            $partkey);
                    }
                    $error++;
                } else {
                    if ($pno != $restPart) {
                        printf("Warning: part number (%d) for address %s " .
                            "differs from part number (%d) in header record.\n",
                            $pno, $pubaddr, $restPart);
                            $warn++;
                    }
                    my $ap = {
                        label   =>  $label,
                        partkey =>  $pvalue,
                        extra   =>  $extra
                    };
                    if (!$parts{$pubaddr}) {
                        $parts{$pubaddr} = [ ];
                        push(@@addresses, $pubaddr);
                    }
                    $parts{$pubaddr}->[$restPart] = $ap;
                }
            }
        }
@}

\subsection{Part validity and completeness checks}

Now that all of the parts specifications have been loaded, check
that the {\em needed} number of parts have been supplied (error if
too few, warning if too many, with the extras ignored), and that
all parts have been specified for all public addresses.

@o perl/multi_key.pl
@{
        #   Verify correct number of parts specified
        my $nps = scalar(keys(%partsSeen));
        if ($nps < $restNeeded) {
            printf("Error: fewer parts specified (%s) than needed (%s).\n",
                $nps, $restNeeded);
            $error++;
        } elsif ($nps > $restNeeded) {
            printf("Warning: more parts specified (%s) than needed (%s).\n",
                $nps, $restNeeded);
            $warn++;
        }

        #   Verify that all parts are specified for all addresses
        foreach my $a (@@addresses) {
            foreach my $pt (keys(%partsSeen)) {
                if (!($parts{$a}->[$pt])) {
                    print("Error: part $pt missing for address $a.\n");
                    $error++;
                }
            }
        }
@}

\subsection{Create output key file}

The output file containing the addresses and reassembled private keys
is given a name constructed from the base name of the first part
(after deleting its part number suffix) and appending
``{\tt -merged.csv}''.  The file is created and a comment written
to it identifying the parts from which it was assembled.

@o perl/multi_key.pl
@{
        $basename =~ s/\-\d+$//;
        $basename .= "-merged.csv";
        open(FO, ">$basename") ||
            die("Cannot create $basename");
        my $title = "# Private keys assembled from parts ";
        foreach my $pn (sort { $a <=> $b } (keys(%partsSeen))) {
            $title .= "$pn, ";
        }
        $title =~ s/, $/\n/;
        print(FO $title);
@}

\subsection{Reconstruct, validate, and output private keys}

We're finally ready to assemble the pieces into the
private keys.  We iterate using the {\tt @@addresses} array
to preserve the order of the keys in the first shared
key input file.  As each private key is reconstructed, its
internal checksum, appended when the original key was split, is
verified and any errors reported.  A record is appended to the
output file with the reassembled private key.

@o perl/multi_key.pl
@{
        foreach my $a (@@addresses) {
            my $rkey = { };
            my $lbl;
            my $rpts = 0;
            foreach my $pt (keys(%partsSeen)) {
                #   Unpack the hex part payload to bytes and save in parts hash
                if (defined($parts{$a}->[$pt])) {
                    my $hxp = $parts{$a}->[$pt]->{partkey};
                    $lbl = $parts{$a}->[$pt]->{label};
                    $rkey->{$pt} = pack('C*',  map({ hex($_) } ($hxp =~ /(..)/g)));
                    $rpts++;
                    #   If more parts were specified than needed, stop
                    #   after we've processed the number required.
                    if ($rpts >= $restNeeded) {
                        last;
                    }
                }
            }
            my $rpk = ssss_reconstruct(p => $prime, shares => $rkey);
            my ($kstat, $privad) = parseKey($rpk);
            if (!$kstat) {
                print("Bad checksum inreconstructed key for $a: $rpk\n  $privad");
                $error++;
            }
            #   We arbitrarily use the extra information from the last
            #   part (all parts should have identical extra information).
            my $ext = $parts{$a}->[-1]->{extra};
            printf(FO "%s,\"%s\",\"%s\"%s\n", $lbl, $a, $privad, $ext);
        }
        close(FO);

        return ($error > 0) ? 2 : (($warn > 0) ? 1 : 0);
    }
@}

\section{Local functions}

\subsection{{\tt parsePart} --- Parse and validate part record}

Parse a part record into components and validate.  Returns ({\em
status}, {\em partNumber}, {\em partValue}).

@o perl/multi_key.pl
@{
    sub parsePart {
        my ($part) = @@_;

        $part =~ m/^S(\d+)\-(\w+?)(\w{8})$/ || return (-1, "", "");
        my ($partNumber, $partValue, $checksum) = ($1, $2, $3);
        $partNumber =~ s/^0//g;
        my $rcheck = compCheck(substr($part, 0, -8));
        if ($rcheck ne $checksum) {
            return (-2, $checksum, $rcheck);
        }
        return (TRUE, $partNumber, $partValue);
    }
@| parsePart @}

\subsection{{\tt parseKey} --- Parse encoded key record}

Parse an encoded key record, extracting the length, key, and checksum,
then validate the checksum.  This used to validate key records after
they are reassembled from parts.  A list is returned with a status
indicating validity of the checksum and the extracted private key.

@o perl/multi_key.pl
@{
    sub parseKey {
        my ($rpk) = @@_;

        my $rlen = ord(substr($rpk, 0, 1)) - 32;
        my $privad = substr($rpk, 1, $rlen);
        my $cksum = substr($rpk, $rlen + 1, 8);

        my $kcheck = compCheck(substr($rpk, 0, $rlen + 1));
        if ($kcheck ne $cksum) {
            return (FALSE, "$cksum != $kcheck");
        }
        return (TRUE, $privad);
    }
@| parseKey @}

\subsection{{\tt compCheck} --- Compute checksum on string}

The checksum is a Bitcoin-address-like double SHA256 hash expressed in
hexadecimal and trimmed to just the first 8 hexadecimal digits (4
bytes).

@o perl/multi_key.pl
@{
    sub compCheck {
        my ($s) = @@_;

        return substr(sha256_hex(sha256($s)), 0, 8);
    }
@| compCheck @}

\subsection{{\tt showHelp} --- Show help information}

@o perl/multi_key.pl
@{
    sub showHelp {
        my $help = <<"EOD";
perl multi_key.pl [ option... ] file...
  Commands and arguments:
    -help               Print this message
    -join               Join parts and reconstruct keys
    -name filename      Specify name of part or joined key files
    -needed k           Set k parts required to reconstruct keys
    -parts n            Split keys into n parts, of which k are needed
    -prime p            Use p as prime number to encode (super-experts only!)
EOD
        print($help);
        exit(0);
    }
@}

\chapter{Paper Wallet Utilities}

These utilities, @<PW@> and @<VW@>, create and validate cold storage
paper wallets, starting with Bitcoin or Ethereum addresses in the CSV
format generated by @<BA@>.  Paper wallets are created by expressing
them as an HTML file, which may be loaded into a browser and printed.

\section{Paper Wallet Generator}

Read a list of addresses and private keys generated by @<BA@> and
output HTML which prints them in a format suitable for offline
cold storage.  You'll usually print multiple copies and store them
in redundant secure locations.  This program can also produce
printable documents from parts of multiple key wallets generated
by @<MK@>.

@o perl/paper_wallet.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    use Text::CSV qw(csv);
    use POSIX qw(strftime);
    use Getopt::Long;
#use Data::Dumper;
@}

\subsection{Modes and option processing}

@o perl/paper_wallet.pl
@{
    my $date = "";                  #   Date override for address page
    my $fontname = "monospace";     #   Font name for addresses
    my $fontsize = "medium";        #   Font size for addresses
    my $fontweight = "normal";      #   Font weight for addresses
    my $offset = 0;                 #   Add to address numbers in the input file
    my $perpage = 10;               #   Print this number of addresses per page
    my $prefix = "";                #   Prefix the address numbers with this string
    my $separator = "";             #   Separator for address groups
    my $title = "";                 #   Title for page

    GetOptions(
        "date=s"        =>  \$date,
        "font=s"        =>  \$fontname,
        "help"          =>  \&showHelp,
        "offset=i"      =>  \$offset,
        "perpage=i"     =>  \$perpage,
        "prefix=s"      =>  \$prefix,
        "separator=s"   =>  \$separator,
        "size=s"        =>  \$fontsize,
        "title=s"       =>  \$title,
        "weight=s"      =>  \$fontweight
    ) || die("Command line option error");

    my $csv = Text::CSV->new({ binary => 1 }) ||
        die("Cannot use CSV: " . Text::CSV->error_diag());

    #   If no date specified, use current UTC date
    if ($date eq "") {
        $date = strftime("%F", gmtime(time()));
    }
@}

\subsection{First pass: read address records}

In the first pass, read the records, determine which kind of blockchain
they represent, and save them in an array for processing on the second
pass.  This allows us to know how many pages we're going to generate if
the output is paginated.

@o perl/paper_wallet.pl
@{
    my $started = FALSE;
    my $inpage = 0;

    my @@records;
    my ($naddrs, $npages) = (0, 0);
    while (my $l = <>) {
        chomp($l);
        $l =~ s/^\s+//;
        $l =~ s/\s+$//;
        if (($l ne "") && ($l !~ m/^#/)) {
            if ($csv->parse($l)) {
                $naddrs++;
                my @@fields = $csv->fields;
                if (!$started) {
                    $started = TRUE;
                    if ($title eq "") {
                        $title = (($fields[1] =~ m/^0x/g) ?
                            "Ethereum" : "Bitcoin") . " Wallet";
                    }
                    $npages++;
                } elsif (($perpage > 0) && ($inpage >= $perpage)) {
                    $inpage = 0;
                    $npages++;
                }
                if (($offset != 0) && ($fields[0] =~ m/^\-?\d+$/)) {
                    $fields[0] += $offset;
                }
                $fields[0] = $prefix . $fields[0];
                push(@@records, \@@fields);
                $inpage++;
           }
        }
    }
@}

\subsection{Second pass: generate HTML output}

In the second pass we process the records from the first pass and
generate the HTML output.

@o perl/paper_wallet.pl
@{
    $inpage = 0;
    $started = FALSE;
    my $pageno = 1;
    my $pagetop = TRUE;
    for (my $i = 0; $i < scalar(@@records); $i++) {
        if (!$started) {
            HTMLstart($date, $title);
            pageHeader($pageno);
            $started = TRUE;
        } elsif (($perpage > 0) && ($inpage >= $perpage)) {
            pageFooter($pageno, $npages);
            $inpage = 0;
            $pagetop = TRUE;
            $pageno++;
            pageHeader($pageno);
        }
        HTMLrec($pagetop, $records[$i]->[0], $records[$i]->[1], $records[$i]->[2]);
        $pagetop = FALSE;
        $inpage++;
    }

    pageFooter($pageno, $npages);
    HTMLend();
@}

\subsection{Utility functions}

\subsubsection{{\tt addrFormat} --- Format address with separators}

Format a public address or private key.  If a nonblank separator has
been set, insert them between groups of four characters in the
string to make it more primate-readable.

@o perl/paper_wallet.pl
@{
    sub addrFormat {
        my ($addr) = @@_;

        if ($separator) {
            my $a = "";
            while ($addr =~ s/^(.+?)(....)$//) {
                $a = "<span class=\"s\"></span>$2$a";
                $addr = $1;
            }
            $addr = "$addr$a";
        }
        return $addr;
    }
@}

\subsubsection{{\tt pageHeader} --- Generate page header}

Generate the HTML for the page heading.

@o perl/paper_wallet.pl
@{
    sub pageHeader {
        my ($pageno) = @@_;

        my $headerdiv = ($pageno == 1) ? "firstpage" : "subsequentpage";
        print <<"EOD";
    <div class="$headerdiv">
        <h1 class="c">$title</h1>
        <h3 class="c">$date</h3>
    </div>
EOD
    }
@}

\subsubsection{{\tt pageFooter} --- Generate page footer}

Generate the HTML for the page footer.

@o perl/paper_wallet.pl
@{
    sub pageFooter {
        my ($pageno, $ofpages) = @@_;

        print <<"EOD";

    <div class="pagefooter">
        <p>Page $pageno of $ofpages</p>
    </div>
EOD
    }
@}

\subsubsection{{\tt HTMLstart} --- Generate HTML file prologue}

Generate the prologue at the start of the HTML file.  With the
exception of the title and date, this is entirely canned and
identical for every file we generate.  The bulk of the header is
the Cascading Style Sheet (CSS), which we define later and include
here.

@o perl/paper_wallet.pl
@{
    sub HTMLstart {
        my ($date, $title) = @@_;
        print <<"EOD";
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>$title</title>
<style>
@<Style sheet for paper wallets@>
</style>
</head>

<body class="standard">

EOD
    }
@}

\subsubsection{{\tt HTMLrec} --- Output one address record to HTML file}

Emit the record for one blockchain address / private key pair.  Note
that our @<VW@> program is sensitively dependent upon the
format of these records; if you change them indiscriminately, you're
likely to break that program.

@o perl/paper_wallet.pl
@{
    sub HTMLrec {
        my ($pagetop, $n, $pub, $priv) = @@_;

        $pub = addrFormat($pub);
        $priv = addrFormat($priv);
        print <<"EOD";

    <table class="addr">
        <tr class="pub">
            <th class="num" rowspan="2">
                $n
            </th>
            <td class="type">Pub:</td>
            <td class="pub">
                $pub
            </td>
        </tr>
        <tr class="priv">
            <td class="type">Priv:</td>
            <td class="priv">
                $priv
            </td>
        </tr>
    </table>
EOD
    }
@}

\subsubsection{{\tt HTMLend} --- Generate HTML file epilogue}

Emit the end of the HTML file.

@o perl/paper_wallet.pl
@{
    sub HTMLend {
        print <<"EOD";

</body>
</html>
EOD
    }
@}

\subsubsection{{\tt showHelp} --- Show help information}

@o perl/paper_wallet.pl
@{
    sub showHelp {
        my $help = <<"EOD";
perl paper_wallet.pl [ option... ] file...
  Commands and arguments:
    -date text          Use text as generation date
    -font fname         Display addresses and keys in CSS font fname
    -help               Print this message
    -offset n           Add n to the address numbers in the input file
    -perpage n          Print n addresses per page
    -prefix text        Prefix address labels with text
    -separator text     Show addresses as 4 character groups with separator text
    -size fsize         Display addresses with CSS font size fsize
    -title text         Use text as page title
    -weight wgt         Show addresses with CSS font weight wgt
EOD
        print($help);
        exit(0);
    }
@}

\subsection{Style sheet}

This CSS style sheet is embedded in the HTML file we generate.  It is
embedded in the interest of its being entirely self-contained and thus
more easily transferred from, for example, an air-gapped computer on
which it is generated and another machine with a direct connection
to a printer.

\subsubsection{Page-level formatting}

@d Style sheet for paper wallets
@{
    body.standard {
        background-color: #FFFFFF;
        color: #000000;
    }

    div.pagefooter {
        text-align: center;
    }

    div.subsequentpage {
        page-break-before: always;
    }
@}

\subsubsection{Table of addresses and keys}

@d Style sheet for paper wallets
@{
    table.addr {
        border-collapse: collapse;
        margin-bottom: 1.5ex;
        margin-left: auto;
        margin-right: auto;
    }

    th.num {
        border-bottom: 1px solid black;
        border-right: 1px solid black;
        font-size: 20pt;
        font-weight: bold;
        padding-left: 0.25em;
        padding-right: 0.5em;
        text-align: right;
        width: 12mm;
   }

    tr.priv {
        border-bottom: 1px solid black;
        border-left: 1px solid black;
        border-right: 1px solid black;
    }

    tr.pub {
        border-left: 1px solid black;
        border-right: 1px solid black;
        border-top: 1px solid black;
    }

    td.type {
        font-weight: bold;
        padding-left: 6px;
    }

    td.priv, td.pub {
        font-family: "$fontname";
        font-size: $fontsize;
        font-weight: $fontweight;
        padding-left: 6px;
        padding-right: 6px;
        width: 180mm;
    }
@}

\subsubsection{Formatting of items}

@d Style sheet for paper wallets
@{

    h1 {
        margin-bottom: 0px;
    }

    h3 {
        margin-top: 0px;
    }

    span.s:after {
        font-family: sans-serif;
        content: "";
    }

    .c {
        text-align: center;
    }
@}

\section{Cold Storage Wallet Validator}

This program, completely independent of the Perl blockchain utilities
that generate them, verifies that the private keys in a cold storage
wallet file correspond to the public addresses generated from them.  It
avoids the tragedy when, for whatever cause, funds are sent to a public
address for which the corresponding private key is not known.  It can
validate either a CSV wallet generated by @<BA@>, or a printable HTML
file created from it with @<PW@>.

To avoid any commonality with the wallet generation code, it is
written in a different programming language, Python, and used that
language's libraries.  This program requires Python version 3 or above.

\subsection{Bitcoin key and address functions}

\subsubsection{Bitcoin library modules}

The following Python library modules are used to manipulate Bitcoin
public addresses amd private keys.

@d Bitcoin library modules
@{
import base58
import binascii
from cryptos import Bitcoin
@}

\subsubsection{Extract private seed from WIF private address}

Private keys in cold storage wallets are stored in Wallet Input
Format, which consists of the 256-bit seed and a checksum, encoded
in Base 58 format.  This function decodes the private key,
extracts the binary key, and returns it as a hexadecimal string.

@d Extract private seed from WIF private address
@{
def getPrivateKey(WIF):
    first_encode = base58.b58decode(WIF)
    private_key_full = binascii.hexlify(first_encode)
    private_key = private_key_full[2:-8]
    return private_key
@}

\subsubsection{Generate public address from WIF private key}

Convert a Bitcoin private key in Wallet Import Format (WIF)
to the corresponding public address, in legacy ``{\tt 1}'' compressed
format.

@d Generate public address from WIF private key
@{
def WIF_to_Bitcoin_address(WIF):
    c = Bitcoin(testnet=False)
    pk = getPrivateKey(WIF)
    BTCaddr = c.privtoaddr(pk)
    return BTCaddr
@}

\subsection{Ethereum key and address functions}

\subsubsection{Ethereum library modules}

The following Python library modules are used to manipulate Ethereum
public addresses amd private keys.

@d Ethereum library modules
@{
from coincurve import PublicKey
from sha3 import keccak_256
@}

\subsubsection{Add ``checksum'' to Ethereum public address}

Add the ``checksum'' to public Ethereum address by computing its hash
and setting hexadecimal letter digits to upper case based upon the
magnitude of the byte of the hash.  Note that re-generating the public
address with checksum and comparing against the address in the file
guarantees that the checksum in the file's public address is correct.

@d Add ``checksum'' to Ethereum public address
@{
def checksumETHaddr(address):
    haddr = address.hex()
    formatted_address = ""
    addressHash = keccak_256(str(haddr).encode("UTF-8")).digest()[:40].hex()
    for i in range(40):
        if (int(addressHash[i], 16) >= 8 and int(haddr[i], 16) >= 10):
            formatted_address += str(haddr[i]).upper()
        else:
            formatted_address += str(haddr[i])
    return formatted_address
@}

\subsubsection{Generate checksummed Ethereum address from private key}

Generate a checksummed Ethereum address from a hexadecimal private key.

@d Generate checksummed Ethereum address from private key
@{
def Key_to_Ethereum_address(privkey_hex):
    private_key = bytes.fromhex(privkey_hex)
    public_key = PublicKey.from_valid_secret(private_key).format(compressed=False)[1:]
    public_addr_b = keccak_256(public_key).digest()[-20:]
    public_addr = checksumETHaddr(public_addr_b)
    return public_addr
@}

\subsection{Input parsing utilities}

\subsubsection{Remove separators from address}

In the interest of readability, @<PW@> allows inserting separators
between groups of characters in the long public address and private
key strings.  This function recognises these sequences and removes
them, allowing the raw addresses to be processed.

@d Remove separators from address
@{
sep = re.compile('<span class="s"></span>')

def removeSep(addr):
    return sep.sub("", addr, 0)
@}

\subsubsection{Get next address, key pair}

The {\tt nextAddr()} function returns the next quadruple of label,
public address, private key, and currency type from the wallet file.
It reads either machine-readable CSV wallets or the HTML files
generated from them by @<PW@>, which are intended to be printed to make
offline cold storage wallets.  This allows verifying the correctness of
both formats of wallets, guarding against corruption creating HTML from
the CSV master (or corruption after they are created).

Errors are dignosed internally, with error messages giving
the line number in the file.  At end of file, a triple consisting
of three blank strings is returned.  This function is agnostic
as to currency type and address variants.  It's up to the caller
to recognise what the record represents.

@d Get next address, key pair
@{
l = ""
lineno = 0
html = False
comment = re.compile(r'\s*#')
csv = re.compile(r'(\w+),"(\w+)","(\w+)"')
ifile = fileinput.input()
goodRec = 0
badRec = 0

def nextAddr():
    global l, lineno, html, badRec
    EXnum = EXpub = EXpriv = False
    Hstate = 0

    while True:
        l = ifile.readline()
        if not l:
            break
        lineno += 1
        l = l.rstrip()
        if l.find("<!DOCTYPE html>") >= 0:
            html = True
        else:
@}

For HTML input, we look for the table item which precedes the fields
and set a flag which causes the next line to be saved as the value for
that field.

@d Get next address, key pair
@{
            if html:
                if l.find('th class="num"') >= 0:
                    if Hstate == 0:
                        EXnum = True
                    else:
                        print("%d: HTML format error: %s" % (lineno, l))
                        badRec += 1
                        Hstate = 0
                elif l.find('td class="pub"') >= 0:
                    if Hstate == 1:
                        EXpub = True
                    else:
                        print("%d: HTML format error: %s" % (lineno, l))
                        badRec += 1
                        Hstate = 0
                elif l.find('td class="priv"') >= 0:
                    if Hstate == 2:
                        EXpriv = True
                    else:
                        print("%d: HTML format error: %s" % (lineno, l))
                        badRec += 1
                        Hstate = 0
                else:
                    #   If one of the field flags has been set on the
                    #   previous line, save this one as the value of
                    #   that field.
                    if EXnum:
                        Hnum = l.lstrip().rstrip()
                        EXnum = False
                        Hstate = 1
                    elif EXpub:
                        Hpub = removeSep(l.lstrip().rstrip())
                        EXpub = False
                        Hstate = 2
                    elif EXpriv:
                        #   If this is the private key, we've now seen
                        #   all of the fields for this record.  Return
                        #   the fields to the caller.  We leave things
                        #   set to start scanning for the next record
                        #   when we're next called.
                        Hpriv = removeSep(l.lstrip().rstrip())
                        EXpriv = False
                        return (Hnum, Hpub, Hpriv, currencyID(Hpub, Hpriv))
@}

If the input is CSV, parse the fields and validate they are correct for
one of the currencies we support.

@d Get next address, key pair
@{
            else:
                if not ((l == "") or comment.match(l)):
                    #   This is not a comment.  Try parsing as a CSV record
                    r = csv.match(l)
                    if r:
                        return (r.group(1), r.group(2), r.group(3),
                                currencyID(r.group(2), r.group(3)))
                    print("%d.  Cannot parse CSV record: %s" % (lineno, l))
                    badRec += 1
    return ("", "", "", "")
@}

\subsubsection{Identify currency from address format}

We allow users to validate cold storage wallets for either Bitcoin
or Ethereum without requiring them to identify the currency the wallet
uses.  This is done by recognising the distinctive format used by
the public address and private key for the respective currencies.
Any of the multitude of currencies which share the Ethereum format
may be verified by the Ethereum code.  The regular expressions used
to test address formats also serve to reject addresses which contain
invalid characters or are improperly formatted.

@d Identify currency from address format
@{
ETHpub = re.compile(r"0x([\da-fA-F]+)")
ETHpriv = re.compile(r"0x([\da-fA-F]+)")
BTCpub = re.compile(r"(1[1-9A-HJ-NP-Za-km-z]+)")
BTCpriv = re.compile(r"([KL][1-9A-HJ-NP-Za-km-z]+)")

def currencyID(pub, priv):
    curr = "?"
    if (ETHpub.match(pub)) and (ETHpriv.match(priv)):
        curr = "ETH"
    elif (BTCpub.match(pub)) and (BTCpriv.match(priv)):
        curr = "BTC"
    return curr
@}

\subsection{Validate addresses in file}

This is the main processing loop of @<VW@>.  It reads records from
the input stream, parses them into number, public address, and
private key, and verifies that the address can be re-generated from
the key.

@d Validate addresses in file
@{
currency = ""

fileinput.input()
while True:
    (label, pubaddrW, privkey, rcurr) = nextAddr()
    if label == "": break
    if rcurr == "?":
        print("%d.  Record represents no known currency: %s" %
              (lineno, l))
        badRec += 1
    else:
        if (currency != "") and (currency != rcurr):
            print("%d.  Currency (%s) differs from that of previous record (%s)." %
                  (lineno, rcurr, currency))
        currency = rcurr

        pubaddr = ""
        if currency == "BTC":
            pubaddr = WIF_to_Bitcoin_address(privkey)
        elif currency == "ETH":
            pubaddr = "0x" + Key_to_Ethereum_address(privkey[2:])

    if pubaddrW != pubaddr:
        print("%d.  Mismatch on address %s.\n    Computed: %s\n    Wallet:   %s" %
              (lineno, label, pubaddr, pubaddrW))
        badRec += 1
    else:
        goodRec += 1
@}

\subsection{Executable program}

Here we put the pieces together into the complete program.  Python does
not permit forward references to functions, so we take care to declare
all functions before they are referenced, independent of the logical
order in which they are presented in the previous sections.

@o python/validate_wallet.py -i
@{@<Explanatory header for Python files@>

import fileinput
import re
import sys

#   - - -  Bitcoin  - - -
@<Bitcoin library modules@>
@<Extract private seed from WIF private address@>
@<Generate public address from WIF private key@>

#   - - -  Ethereum  - - -
@<Ethereum library modules@>
@<Add ``checksum'' to Ethereum public address@>
@<Generate checksummed Ethereum address from private key@>

#   - - -  Utility functions  - - -
@<Remove separators from address@>
@<Get next address, key pair@>
@<Identify currency from address format@>

@<Validate addresses in file@>

print("Addresses: %d good, %d bad." % (goodRec, badRec))
sys.exit(0 if ((goodRec > 0) and (badRec == 0)) else 1)
@}

\chapter{Cold Storage Monitor}

The @<CC@> program monitors a list of Bitcoin or Ethereum addresses,
queries their current balance from free servers, compares it with
the expected balance, and reports any discrepancies.  This can be
employed by users of offline ``cold storage'' to detect any
unauthorised transactions referencing them.

\section{Program plumbing}

@o perl/cold_comfort.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>
@}

\section{Required library modules}

@o perl/cold_comfort.pl
@{
    use Crypt::Random::Seed;
    use Getopt::Long;
    use JSON;
    use LWP::Simple;
    use List::Util qw(shuffle);
    use Math::Random::MT;
    use Text::CSV qw(csv);
@}

\section{Definitions and mode settings}

@o perl/cold_comfort.pl
@{
    use constant SATOSHI => 0.00000001;
    use constant ERRFLAG => " ****";

    my $APIretry = 3;                   # Maximum attempts to make API query
    my $ignoreZero = FALSE;             # Ignore zero balance addresses
    my $dust = 0.001;                   # Don't report balance increases less than this
    my $loop = FALSE;                   # Loop forever checking addresses
    my $shuffle = FALSE;                # Shuffle order of address queries
    my $verbose = FALSE;                # Show all queries, not just alerts
    my $waitconst = 17;                 # Constant wait between queries, seconds
    my $waitloop = 3600;                # Wait between series of queries
    my $waitrand = 20;                  # Random wait between queries, seconds
@}

\section{Data sources for address balance queries}

The following sites can be queried for the balance of Bitcoin and
Ethereum addresses, respectively.  The user can select the site used
with the {\tt -btcsource} and {\tt -ethsource} command line options.
These sites tend to come and go, so we provide three alternatives
for each.  Note that adding a new site involves more than just adding
an entry to one of these tables: you must write a function which
composes a query, sends it to the site, and parses the result it
returns.

@o perl/cold_comfort.pl
@{
    #   Bitcoin data sources
    my $srcBTC = "blockchain.info";
    my %btcSource = (
        "blockchain.info"   =>  \&s_b_blockchain,
        "blockcypher.com"   =>  \&s_b_blockcypher,
        "btc.com"           =>  \&s_b_btc
    );

    #   Ethereum data sources
    my $srcETH = "blockchain.com";
    my %ethSource = (
        "blockchain.com"    =>  \&s_e_blockchain,
        "etherscan.io"      =>  \&s_e_etherscan,
        "ethplorer.io"      =>  \&s_e_ethplorer
    );
@}

\section{Initialisation and command line option processing}

@o perl/cold_comfort.pl
@{
    randInit();

    GetOptions(
        "btcsource=s"   =>  \$srcBTC,
        "dust=f"        =>  \$dust,
        "ethsource=s"   =>  \$srcETH,
        "help"          =>  \&showHelp,
        "loop"          =>  \$loop,
        "retry=i",      =>  \$APIretry,
        "shuffle"       =>  \$shuffle,
        "verbose"       =>  \$verbose,
        "waitconst=f"   =>  \$waitconst,
        "waitloop=f"    =>  \$waitloop,
        "waitrand=f"    =>  \$waitrand,
        "zero"          =>  \$ignoreZero
    ) || die("Command line option error");

    #   Validate address query source specifications

    if (!defined($btcSource{$srcBTC})) {
        print("Unknown Bitcoin query source.\n");
        exit(2);
    }

    if (!defined($ethSource{$srcETH})) {
        print("Unknown Ethereum query source.\n");
        exit(2);
    }
@}

\section{First pass: Read list of addresses to be monitored}

Read the list of addresses from the input stream.  The addresses to
be watched are specified in CSV format with the following fields.

\begin{quote}
\begin{enumerate}
\dense
    \item   Label
    \item   Public address
    \item   Private key (ignored if specified)
    \item   Expected balance
\end{enumerate}
\end{quote}

These are stored in an array of arrays, with an additional item,
initialised to zero, added to the end which is used to keep track
of the number of retries for queries that failed.

@o perl/cold_comfort.pl
@{
    my $csv = Text::CSV->new({ binary => 1 }) ||
        die("Cannot use CSV: " . Text::CSV->error_diag());

    my $adrs = [ ];
    while (my $l = <>) {
        chomp($l);
        $l =~ s/^\s+//;
        $l =~ s/\s+$//;
        if (($l ne "") && ($l !~ m/^#/)) {
            if ($csv->parse($l)) {
                push(@@$adrs, [ $csv->fields, 0 ]);
           }
        }
    }
@}

\section{Second pass: Query addresses and report discrepancies}

If {\tt -shuffle} is specified, we shuffle the order in which
addresses are queried.  This makes is more difficult for API services
to identify our queries as representing a fixed collection of cold
storage addresses.

@o perl/cold_comfort.pl
@{
    my ($balErrs, $APIerrs);

    do {
        if ($shuffle) {
            @@$adrs = shuffle(@@$adrs);
        }
@}

Query the balance of the addresses and compare against the expected
balance, reporting any discrepancies.

@o perl/cold_comfort.pl
@{
        ($balErrs, $APIerrs) = (0, 0);
        for (my $i = 0; $i < scalar(@@$adrs); $i++) {
            my ($label, $bcaddr, $balance, $tries) =
                ($adrs->[$i][0], $adrs->[$i][1], $adrs->[$i][3], $adrs->[$i][4]);
            if ((!$ignoreZero) || ($balance > 0)) {
                $balance += 0;
                my $warn = "";
                my $cbal;
                my $cbalf;
                if ($bcaddr =~ m/^0x/i) {
                    $cbal = $ethSource{$srcETH}($bcaddr);
                } else {
                    $cbal = $btcSource{$srcBTC}($bcaddr);
                }
                if (defined($cbal)) {
@}

We compare the balance reported by the query with the expected balance
using a slightly complicated set of rules.  Due to floating point
round-off and rounding in values reported by servers, we ignore any
discrepancy less than one {\tt SATOSHI} ($10^{-8}$).  If the reported
balance is less than expected by greater than this threshold, we treat
it as an error.  If the reported balance is greater, we compare it with
the {\tt -dust} setting.  Cryptocurrency blockchains, particularly
Bitcoin at this writing, are afflicted by spammers who send nugatory
funds to addresses with significant balances to promote a variety of
scams.  These small deposits are referred to as ``dust'', in that the
transaction cost to spend or transfer them exceeds their value.  But
they can cause discrepancies in the balance comparison.  We ignore
these balance increases up to the {\tt -dust} threshold.  If you're
getting dust reports and confirm that's what they are, just update the
balance in your cold storage database to include the dust.

@o perl/cold_comfort.pl
@{
                    my $bdiff = $cbal - $balance;
                    $cbalf = sprintf("%16.8f", $cbal);
                    if ($bdiff < -(SATOSHI)) {
                         $warn = ERRFLAG;
                         $balErrs++;
                    } elsif ($bdiff > SATOSHI) {
                         $warn = ($cbal < ($balance + $dust)) ? " Dust" : ERRFLAG;
                    }
                } else {
@}

If the API query for the address balance fails, we increment the number
of queries made for it.  If we've made fewer than the number of tries
set by {\tt -retry}, increment the try count re-queue the query at the
end of the address list for next try.  If the number of tries has been
exhausted, this is flagged as a hard fail and abandoned.

@o perl/cold_comfort.pl
@{
                    $cbalf = " " x 16;
                    $tries++;
                    if ($tries < $APIretry) {
                        if ($verbose) {
                            $warn = " API fail, try $tries/$APIretry";
                        }
                        push(@@$adrs, [ $label, $bcaddr, $adrs->[$i][2], $balance, $tries ]);
                    } else {
                        $warn = " API failure";
                        $APIerrs++;
                    }
                }
                if ($verbose || ($warn ne "")) {
                    printf("%-12s  %-42s  %16.8f  %s%s\n",
                           $label, $bcaddr, $balance, $cbalf, $warn);
                }
                if ($i < (scalar(@@$adrs) - 1)) {
                    sleep($waitconst + randNext($waitrand));
                }
            }
        }
        if ($loop && ($waitloop > 0)) {
            sleep($waitloop);
        }
    } while ($loop);

    exit(($balErrs > 0) ? 1 : (($APIerrs > 0) ? 2 : 0));
@}

\section{Local functions}

\subsection{{\tt showHelp}: Show how to call information}

@o perl/cold_comfort.pl
@{
    sub showHelp {
        my $btcsites = join(", ", sort(keys(%btcSource)));
        my $ethsites = join(", ", sort(keys(%ethSource)));
        my $help = <<"EOD";
perl cold_comfort.pl [ options... ] address_file...
  Options:
    -btcsource site     Site to query for Bitcoin balances: $btcsites
    -dust n             Ignore "dust" sent to address less than n units
    -ethsource site     Site to query for Ethereum balances: $ethsites
    -help               Print this message
    -loop               Loop forever polling addresses
    -retry n            Try failed API query requests n times
    -shuffle            Shuffle order in which addresses queried
    -verbose            Show all polls, regardless of error status
    -waitconst n        Wait constant n seconds between queries
    -waitloop n         Wait n seconds between re-polls in -loop
    -waitrand n         Wait random time 0 to n seconds between address polls
    -zero               Ignore addresses with zero expected balance
EOD
        print($help);
        exit(0);
    }
@}

\section{Utility functions}

@o perl/cold_comfort.pl
@{
    @<Pseudorandom number generator@>
@}

\section{Address query source handlers}

These functions query different services to obtain the balance for a
specified Bitcoin or Ethereum address.  The argument is the address
and the value returned is the balance as a floating point value of
currency units or {\tt undef} if the query fails.

\subsection{Bitcoin}

\subsubsection{{\tt blockcypher.com}}

@o perl/cold_comfort.pl
@{
    sub s_b_blockcypher {
        my ($address) = @@_;

        my $balance;
        my $reply = get("https://api.blockcypher.com/v1/btc/main/addrs/$address/balance");
        if (defined($reply)) {
            my $r = decode_json($reply);
            $balance = $r->{balance} * SATOSHI;
        }

        return $balance;
    }
@| s_b_blockcypher @}

\subsubsection{{\tt blockchain.info}}

@o perl/cold_comfort.pl
@{
    sub s_b_blockchain {
        my ($address) = @@_;

        my $balance = get("https://blockchain.info/q/addressbalance/$address");

        if (defined($balance)) {
            $balance *= SATOSHI;
        }

        return $balance;
    }
@| s_b_blockchain @}

\subsubsection{{\tt btc.com}}

@o perl/cold_comfort.pl
@{
    sub s_b_btc {
        my ($address) = @@_;

        my $balance;

        my $request = LWP::UserAgent->new();
        $request->agent("cold_comfort");
        my $response = $request->get("https://btc.com/btc/search?q=$address");
        if ($response->is_success) {
            my $reply = $response->content;
            if ($reply =~ m:Balance</div><div\s+class="ant-col\s+ant-col-24\s+text-c">([\d\.\,]+)\s+BTC</div>:) {
                $balance = $1;
                $balance =~ s:[,<>/b]::g;
                $balance = $balance + 0;
            }
        }

        return $balance;
    }
@| s_b_btc @}

\subsection{Ethereum}

\subsubsection{{\tt blockchain.com}}

@o perl/cold_comfort.pl
@{
    sub s_e_blockchain {
        my ($address) = @@_;

        my $balance;
        my $reply = get("https://www.blockchain.com/eth/address/$address");
        if (defined($reply)) {
            if ($reply =~ m/The\s+current\s+value\s+of\s+this\s+address\s+is\s+([\d\.,]+)\s+ETH/) {
                $balance = $1;
                $balance =~ s/,//g;
                $balance = $balance + 0;
            }
        }

        return $balance;
    }
@| s_e_blockchain @}

\subsubsection{{\tt etherscan.io}}

@o perl/cold_comfort.pl
@{
    sub s_e_etherscan {
        my ($address) = @@_;

        my $balance;
        my $request = LWP::UserAgent->new();
        $request->agent("cold_comfort");
        my $response = $request->get("https://etherscan.io/address/$address");
        if ($response->is_success) {
            my $reply = $response->content;
            if ($reply =~ m:<div\s+class="col\-md\-8">([\d\.,<>/b]+)\s+Ether</div>:) {
                $balance = $1;
                $balance =~ s:[,<>/b]::g;
                $balance = $balance + 0;
            }
        }

        return $balance;
    }
@| s_e_etherscan @}

\subsubsection{{\tt ethplorer.io}}

@o perl/cold_comfort.pl
@{
    sub s_e_ethplorer {
        my ($address) = @@_;

        my $balance;
        my $reply = get("https://api.ethplorer.io/getAddressInfo/$address?apiKey=freekey");
        if (defined($reply)) {
            my $r = decode_json($reply);
            if ($r->{address} eq lc($address)) {
                $balance = $r->{ETH}->{balance};
            }
        }

        return $balance;
    }
@| s_e_ethplorer @}

\chapter{Bitcoin Address Watcher}

This program monitors the blockchain and, whenever new blocks are
added, scans them for transactions involving a watch list, which may be
specified on the command line, from a file, or from the user's wallet.
For every transaction inolving that address, whether as input or
output, a message on standard output and an optional permanent log
entry is generated showing:

\begin{quote}
\begin{enumerate}
\dense
    \item   Label (if any) from the watch list file or wallet
    \item   Bitcoin address
    \item   Value of transaction in BTC
    \item   Date and time
    \item   Block number (height)
    \item   Transaction ID
    \item   Block hash
\end{enumerate}
\end{quote}

\section{Main program}

We start with the usual start of program definitions and defining and
processing the command-line options.

@o perl/address_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
    use Term::ReadKey;
    use Statistics::Descriptive;

    use Data::Dumper;

    my $block_start = @<AW block start@>;           # Starting block
    my $block_end = @<AW block end@>;               # End block
    my $block_file = "@<AW block file@>";           # Incremental scanning block file
    my @@watch_addrs;                               # Addresses to watch
    my $watch_file = "@<AW watch file@>";           # File containing watch addresses
    my $log_file = "@<AW log file@>";               # Log file
    my $verbose = @<Verbosity level@>;              # Verbose output ?
    my $poll_time = @<Blockchain poll interval@>;   # Poll interval in seconds
    my $last_block_time = -1;                       # Time of last block
    my $b_interval_smoothed = -1;                   # Smoothed inter-block interval, seconds
    my $b_interval_smoothing = 0.2;                 # Interval smoothing factor
    my $stats = FALSE;                              # Show statistics of blocks ?
    my $statlog = "";                               # Block statistics log file
    my $wallet = @<AW monitor wallet@>;             # Monitor unspent funds in wallet ?
    @<RPC configuration variables@>

    my %options = (
        @<RPC command line options@>
        "bfile=s"       => \$block_file,
        "end=i"         => \$block_end,
        "help"          => \&showHelp,
        "lfile=s"       => \$log_file,
        "poll=i"        => \$poll_time,
        "sfile=s"       => \$statlog,
        "start=i"       => \$block_start,
        "stats"         => \$stats,
        "type=s"        =>  sub { print("$_[1]\n"); },
        "verbose+"      => \$verbose,
        "wallet"        => \$wallet,
        "watch=s"       => \@@watch_addrs,
        "wfile=s"       => \$watch_file
    );

    processConfiguration();

    GetOptions(
        %options
    ) || die("Command line option error");

    my $statc = $stats || ($statlog ne "");
@}

\subsection{Build list of watched addresses}

Now, we build the list of Bitcoin addresses we'll be watching.  These
may be specified on the command line with the {\tt -watch} option, or
read from a (single) file specified by the {\tt -wfile} option.  In
addition, addresses in the user's wallet with an unspent balance can
be automatically monitored by specifying the {\tt -wallet} option.
When watching wallet addresses, we re-fetch the list for every poll
of the blockchain to accommodate any changes due to transactions since
the previous poll.

When reading the list of addresses from a {\tt -wfile} CSV file, we
ignore blank lines, comments which begin with ``\verb+#+'', and Ethereum
addresses which begin with ``{\tt 0x}''.

@o perl/address_watch.pl
@{
    my %adrh;

    #   Add watch addresses specified on the command line
    foreach my $a (@@watch_addrs) {
        my ($label, $balance) = ("", "");

        if ($a =~ s/^(\w+),//) {
            $label = $1;
        }
        if ($a =~ s/,[\d\.]+$//) {
            $balance = $1;
        }
        $adrh{$a} = [ $label, $balance ];
    }
    undef(@@watch_addrs);

    #   Add watch addresses specified in a -wfile
    if ($watch_file ne "") {
        my $csv = Text::CSV->new({ binary => 1 }) ||
            die("Cannot use CSV: " . Text::CSV->error_diag());
        open(WF, "<$watch_file") || die("Cannot open $watch_file");
        while (my $l = <WF>) {
            chomp($l);
            $l =~ s/^\s+//;
            $l =~ s/\s+$//;
            if (($l ne "") && ($l !~ m/^#/)) {
                if ($csv->parse($l)) {
                    my @@fields = $csv->fields;
                    if ($fields[1] !~ m/^0x/i) {
                        $adrh{$fields[1]} = [ $fields[0], $fields[3] ];
                    }
                }
            }
        }
        close(WF);
    }

    if (scalar(keys(%adrh)) == 0) {
        print(STDERR "No watch addresses specified.\n");
        exit(2);
    }
@}

\subsection{Prompt for RPC password}

If the ``{\tt rpc}'' query method was selected and no password was
specified, ask the user for it from standard input.

@o perl/address_watch.pl
@{
    if (($RPCmethod eq "rpc") &&
        ((!defined($RPCpass)) || ($RPCpass eq ""))) {
        $RPCpass = getPassword("Bitcoin RPC password: ");
    }
@}

\subsection{Determine range of blocks to scan}

Determine the start and ending blocks to scan.  This depends in a
non-trivial but convenient way on the {\tt -start}, {\tt -end},
and {\tt -bfile} options.  If {\tt bfile} is specified, the start
block will be read from it.  Otherwise, the start block will be that
specified by {\tt -start} or, if $-1$ (the default), the most recent
block.  If a negative start block is specified, the scan will start
at that number of blocks before the most recent block.

If no end block is specified, the most recent block is used.  This
means that if we've already scanned the most recent block, it will
not be re-scanned.

@o perl/address_watch.pl
@{
    #   If a block file is present, read start block from it
    if ($block_file ne "") {
        open(BF, "<$block_file") || die("Cannot open block file $block_file");
        my $l = <BF>;
        close(BF);
        chomp($l);
        if ($l =~ m/(\d+)/) {
            $block_start = $1 + 1;
        } else {
            print(STDERR "Invalid value in block file.\n");
            exit(2);
        }
    }

    #   If no end block specified, use most recent block

    if ($block_end < 0) {
        $block_end = sendRPCcommand([ "getblockcount" ]);
    }

    #   If negative start block specified, start that number
    #   before the last block.

    if ($block_start < 0) {
        $block_start = $block_end + $block_start
    }

    if (($block_start > $block_end) && ($poll_time == 0)) {
        print("No blocks to scan.\n");
        exit(0);
    }
@}

\subsection{Retrieve and scan blocks}

Having determined the range to blocks to scan, proceed to scan them
and accumulate references to addresses we're watching within them.
Before entering the scanning loop, we perform an initial scan of the
wallet for addresses with unspent balances.  This avoids missing
any address which was spent between the time we started the program
and the first block we receive after starting.

@o perl/address_watch.pl
@{
    updateWalletAddresses();

    do {
        my $myaddrs = [];

        if ($block_start <= $block_end) {
            print("Scanning blocks $block_start to $block_end.\n") if $verbose;
        }

        my $scanned = 0;
        for (my $j = $block_start; $j <= $block_end; $j++) {
            if ($wallet && ($j == $block_start)) {
                updateWalletAddresses();
            }
            print("  Scanning block $j.\n") if $verbose;
            my $mine = scanBlock($j, $verbose);
            if (scalar(@@$mine) > 0) {
                push(@@$myaddrs, $mine);
            }
            $scanned++;
        }
@}

\subsection{Display references to watched addresses}

We've finished scanning all specified blocks.  Output references we've
found in them to addresses we're watching.

@o perl/address_watch.pl
@{
        my $nref = (scalar(@@$myaddrs) == 0) ? 0 : scalar(@@{$myaddrs->[0]});
        if (scalar($nref) > 0) {
            printf("%d reference%s to watched addresses:\n",
                $nref, ($nref > 1) ? "s" : "");
            for (my $i = 0; $i < $nref; $i++) {
                my ($b_height, $b_hash, $b_time, $t_txid, $a_addr, $t_value) =
                   ($myaddrs->[0]->[$i]->[0], $myaddrs->[0]->[$i]->[1],
                    $myaddrs->[0]->[$i]->[2], $myaddrs->[0]->[$i]->[3],
                    $myaddrs->[0]->[$i]->[4], $myaddrs->[0]->[$i]->[5]);
                my $utime = etime($b_time);

                my $logItem = sprintf("%-12s  %36s  %11.8f  %19s  %8d  %64s  %64s\n",
                    $adrh{$a_addr}->[0], $a_addr, $t_value, $utime, $b_height, $t_txid, $b_hash);
                print($logItem);
                if ($log_file ne "") {
                    open(LF, ">>$log_file")|| die("Cannot open log file $log_file");
                    printf(LF "\"%s\",%s,%.8f,%s,%d,%s,%s\n",
                        $adrh{$a_addr}->[0], $a_addr, $t_value, $utime,
                        $b_height, $t_txid, $b_hash);
                    close(LF);
                }
           }
        }
@}

\subsection{Save last block scanned for next run}

If a block file is specified, save last block scanned so we can resume
with the next block on a subsequent run.

@o perl/address_watch.pl
@{
        if (($block_file ne "") && ($scanned > 0)) {
            open(BF, ">$block_file") || die("Cannot open block file for update");
            print(BF "$block_end\n");
            close(BF);
            print("Updated block file to last block $block_end.\n") if $verbose;
        }
@}

\subsection{If polling, wait and resume scan}

If we're polling, sleep for the specified polling interval and
resume the scan with the next block after the one we've just
examined.

@o perl/address_watch.pl
@{
        if ($poll_time > 0) {
            $block_start = $block_end + 1;
            sleep($poll_time);
            print("Resuming scan after $poll_time seconds at " .
                etime(time()) . ".\n") if $verbose;
            $block_end = sendRPCcommand([ "getblockcount" ]);
        }
    } while ($poll_time > 0);
@}

\subsection{Local and utility functions}

Import local (program-specific) functions defined below and utlity
functions common to multiple programs.

@o perl/address_watch.pl
@{
    #   Local functions
    @<scanBlock: Scan a block by index on the blockchain@>
    @<updateWalletAddresses: Watch unspent wallet addresses@>
    @<showHelp: Show address watch help information@>

    #   Utility functions
    @<etime: Edit time to ISO 8601@>
    @<Command and option processing@>
    @<sendRPCcommand: Send a Bitcoin RPC/JSON command@>
    @<getPassword: Prompt user to enter password@>
    @<blockReward: Compute reward for mining block@>
@}

\section{Local functions}

\subsection{{\tt scanBlock} --- Scan a block by index on the blockchain}

The transactions in the block are scanned for references to addresses
on the watch list.  Any found are returned as an array of arrays, with
each containing:

\begin{quote}
\begin{enumerate}
\dense
    \item[0.]    Block number
    \item[1.]    Block hash
    \item[2.]    Time of block
    \item[3.]    Transaction ID
    \item[4.]    Address referenced
    \item[5.]    Value from transaction
\end{enumerate}
\end{quote}

From this, the user can recover the details of the transaction and see
what's going on.

@d scanBlock: Scan a block by index on the blockchain
@{
    sub scanBlock {
        my ($height, $verbose) = @@_;

        my @@hits;
@| scanBlock @}

Get hash for block from its number (height), then fetch the block
from the blockchain.

@d scanBlock: Scan a block by index on the blockchain
@{
        my $bh = sendRPCcommand([ "getblockhash", "$height" ]);
        print("    Block hash $bh\n") if $verbose;
        my $blk = sendRPCcommand([ "getblock",  $bh, "2" ]);
        my $r = decode_json($blk);
@}

Scan the block for references to addresses we're watching.  We start
by extracting the block-level information.

@d scanBlock: Scan a block by index on the blockchain
@{
        my $b_height = $r->{height};        # Block height (index)
        my $b_hash = $r->{hash};            # Block hash
        my $b_time = $r->{time};            # Block time
        my $b_nTx = $r->{nTx};              # Transactions in block

        print("    Block $b_height " . gmtime($b_time) .
              " Transactions $b_nTx\n") if $verbose >= 1;

        my ($stat_value, $stat_size);
        my $stat_reward = 0;
        if ($statc) {
            $stat_value = Statistics::Descriptive::Sparse->new();
            $stat_size = Statistics::Descriptive::Sparse->new();
        }
@}

Now loop over the transactions in the block, saving any which cite one
of the addresses we're watching.  After we've scanned them all, return
any references to watched addresses.

@d scanBlock: Scan a block by index on the blockchain
@{
        my %vincache;

        for (my $t = 0; $t < $b_nTx; $t++) {
            #   Transaction ID
            my $t_txid = $r->{tx}->[$t]->{txid};
            if ($statc) {
                $stat_size->add_data($r->{tx}->[$t]->{vsize});
            }
@}

The source of funds for the transaction is specified by one or more
``{\tt vin}'' items.  These do not directly specify the address, but
rather give the transaction in which the funds may be found and the
``{\tt vout}'' item within it that contains the address(es).  To
check for references to our addresses, we must look up each of
these transactions, which requires that Bitcoin Core be configured
with ``{\tt txindex=1}'', causing it to build and maintain a
transaction index.  If this index is absent, we cannot monitor input
addresses.

Because looking up transactions and decoding them from JSON is costly,
we cache transactions we query in \verb+%vincache+ and serve
previously-retrieved and decoded objects from the cache.  This
dramatically speeds up processing queries for many blocks.

One additional wrinkle is that an input transaction may have its source
be the ``coinbase'': newly-created Bitcoin paid to miners as incentive
for publishing blocks.  These transactions have no previous transaction
and hence no addresses in their ``{\tt vout}'' section.  Since there
are no addresses to check, we needn't examine such transactions
further.

@d scanBlock: Scan a block by index on the blockchain
@{
            my $t_nvin = scalar(@@{$r->{tx}->[$t]->{vin}});
            my $t_nvout = scalar(@@{$r->{tx}->[$t]->{vout}});

            print("  $t.  $t_txid  In: $t_nvin  Out: $t_nvout\n") if $verbose >= 2;

            for (my $v = 0; $v < $t_nvin; $v++) {
                if (defined($r->{tx}->[$t]->{vin}->[$v]->{txid}) &&
                    defined($r->{tx}->[$t]->{vin}->[$v]->{vout})) {
                    my ($vintx, $vinn) = ($r->{tx}->[$t]->{vin}->[$v]->{txid},
                        $r->{tx}->[$t]->{vin}->[$v]->{vout});
                    my $vi;
                    if (!defined($vi = $vincache{$vintx})) {
                        my $vitx = sendRPCcommand([ "getrawtransaction",  $vintx, "true" ]);
                        $vi = decode_json($vitx);
                        $vincache{$vintx} = $vi;
                    }
                    if (defined($vi->{vout}->[$vinn]->{scriptPubKey}->{addresses})) {
                        #   This is not a "coinbase" transaction.  Scan source addresses
                        my $vi_naddr = scalar(@@{$vi->{vout}->[$vinn]->{scriptPubKey}->{addresses}});
                        #   Loop over addresses in vout item
                        for (my $a = 0; $a < $vi_naddr; $a++) {
                            my $a_addr = $vi->{vout}->[$vinn]->{scriptPubKey}->{addresses}->[$a];
                            my $t_value = $vi->{vout}->[$vinn]->{value};
                            if (!defined($t_value)) {
                                $t_value = 0;
                            }
                            my $flag = $adrh{$a_addr};
                            if ($verbose >= 3) {
                                my $pflag = $flag ? " *****" : "";
                                print("      In  $v.$a.  $a_addr$pflag\n");
                            }
                            if ($flag) {
                                #   This is one of the addresses we're watching: add to the hit list
                                push(@@hits, [ $b_height, $b_hash, $b_time, $t_txid, $a_addr, -$t_value ]);
                            }
                        }
                    }
                }
            }
@}

The ``{\tt vout}'' items in the transaction specify the addresses (or
scripts) to which the funds are to be sent.  These are more
straightforward to process than ``{\tt vin}'' items, as they contain
the actual address and do not require us to look up a transaction to
find it.

@d scanBlock: Scan a block by index on the blockchain
@{
            #   Loop over vout items
            for (my $v = 0; $v < $t_nvout; $v++) {
                if (defined($r->{tx}->[$t]->{vout}->[$v]->{scriptPubKey}) &&
                    defined($r->{tx}->[$t]->{vout}->[$v]->{scriptPubKey}->{addresses})) {
                    my $v_naddr = scalar(@@{$r->{tx}->[$t]->{vout}->[$v]->{scriptPubKey}->{addresses}});
                    #   Loop over addresses in vout item
                    for (my $a = 0; $a < $v_naddr; $a++) {
                        my $a_addr = $r->{tx}->[$t]->{vout}->[$v]->{scriptPubKey}->{addresses}->[$a];
                        my $t_value = $r->{tx}->[$t]->{vout}->[$v]->{value};
                        if (!defined($t_value)) {
                            $t_value = 0;
                        }
                        if ($t == 0) {
                            $stat_reward += $t_value;
                        }
                        my $flag = $adrh{$a_addr};
                        if ($verbose >= 3) {
                            my $pflag = $flag ? " *****" : "";
                            print("      Out $v.$a.  $a_addr$pflag\n");
                        }
                        if ($flag) {
                            #   This is one of the addresses we're watching: add to the hit list
                            push(@@hits, [ $b_height, $b_hash, $b_time, $t_txid, $a_addr, $t_value ]);
                        }
                        if ($statc && ($t_value > 0)) {
                            $stat_value->add_data($t_value);
                        }
                    }
                }
            }
        }
        if ($statc) {
            @<Show statistics for block@>
        }
        $last_block_time = $b_time;
        return \@@hits;
    }
@}

\subsubsection{Show statistics for block}

If we're collecting statistics for blocks, output them in either/or
primate readable form on standard output and a record appended to
the log file specified by the {\tt -sfile} option.  Statistics include:

\begin{quote}
\begin{itemize}
\dense
    \item Block number (``height'')
    \item Date and time
    \item Number of transactions
    \item Transaction size: minimum, maximum, mean, standard deviation,
          and total
    \item Value: minimum, maximum, mean, standard deviation,
          and total
\end{itemize}
\end{quote}

@d Show statistics for block
@{
    if ($stats) {
        print("  Block $b_height  " . etime($b_time) . " $b_nTx transactions\n");
        my $brw = blockReward($b_height);
        printf("    Reward %.2f (mining block %.2f, transaction fees %.2f)\n",
               $stat_reward, $brw, $stat_reward - $brw);
        printf("    Size: min %d  max %d  mean %.2f  SD %.2f  Total %d\n",
            $stat_size->min(), $stat_size->max(), $stat_size->mean(),
            $stat_size->standard_deviation(), $stat_size->sum());
        printf("    Value: min %.8f  max %.8g  mean %.8g  SD %.8g  Total %.8g\n",
            $stat_value->min(), $stat_value->max(), $stat_value->mean(),
            $stat_value->standard_deviation(), $stat_value->sum());
        if ($last_block_time > 0) {
            my $b_interval = $b_time - $last_block_time;
            if ($b_interval_smoothed >= 0) {
                $b_interval_smoothed = $b_interval_smoothed +
                    ($b_interval_smoothing *
                        ($b_interval - $b_interval_smoothed));
            } else {
                $b_interval_smoothed = $b_interval;
            }
            printf("    Time since last block: %.2f minutes, smoothed %.2f.\n",
                $b_interval / 60, $b_interval_smoothed / 60);
        }

    }
    if ($statlog) {
        open(SL, ">>$statlog");
            printf(SL "%12d,%d,%d,%d,%d,%.2f,%.2f,%d,%.8f,%.8g,%.8g,%.8g,%.8g,%.8g,%.8g\n",
                $b_height, $b_time, $b_nTx,
                $stat_size->min(), $stat_size->max(), $stat_size->mean(),
                $stat_size->standard_deviation(), $stat_size->sum(),
                $stat_value->min(), $stat_value->max(), $stat_value->mean(),
                $stat_value->standard_deviation(), $stat_value->sum(),
                $stat_reward, blockReward($b_height));
        close(SL);
    }
@}

\subsection{{\tt updateWalletAddresses} --- Watch unspent wallet addresses}

When the {\tt -wallet} option is specified, every time we begin a poll
for new blocks on the blockchain, we obtain the current list of
addresses within the wallet which have a nonzero balance.  These are
automatically added to the watch list, so we'll monitor them without
the need for the user to manually watch them.  Since any spend
transaction will result in a wallet address disappearing and a new
change address replacing it, wallet addresses are dynamic, and this
keeps the monitor up to date.  On every scan, addresses previously
added from the wallet are removed, so on each scan the list is current
as of the time it began.

We start by removing any expired wallet addresses from the watch list.
When a wallet address is added to the watch list or updated if already
present, we append the time to the record for the address.  When an
address disappears from the wallet, this may mean that its balance has
been zeroed out due to being spent and replaced by a new address with
the change from the transaction. We still want to monitor the original
address, however, in order to log the transaction in which the funds
from it were spent.  Thus, we only purge an address from the wallet
watch list after the time specified by ``AW wallet purge interval'' has
expired.  This should be set to a time greater than the longest time
expected between a transaction's being sent to the mempool and the
first confirmation arriving on the blockchain.

@d updateWalletAddresses: Watch unspent wallet addresses
@{
    sub updateWalletAddresses {
        my $now = time();

        foreach my $adr (keys(%adrh)) {
             if (($adrh{$adr}->[1] =~ m/^W/) &&
                 (($now - $adrh{$adr}->[2]) > @<AW wallet purge interval@>)) {
                 printf("Purged wallet address $adr, age %d seconds.\n",
                    $now - $adrh{$adr}->[2]); # if ($verbose >= 2);
                 delete($adrh{$adr});
             }
        }
@| updateWalletAddresses @}

Retrieve addresses with an unspent balance from the wallet and add them
to the watch list.  Any addresses already on the list will have their
time of last presence updated to reset the expiration purge time.

@d updateWalletAddresses: Watch unspent wallet addresses
@{
        #   Retrieve unspent addresses from wallet and add to watch hash
        my $uw = sendRPCcommand([ "listunspent" ]);
        if (defined($uw)) {
            my $w = decode_json($uw);
            for (my $i = 0; $i < scalar(@@$w); $i++) {
                my $addr = $w->[$i]->{address};
                my $balance = $w->[$i]->{amount};
                my $label = $w->[$i]->{label};
                if (!defined($label)) {
                    $label = "Wallet" . ($i + 1);
                }
                print("Watching wallet $label,$addr,W$balance,$now\n") if ($verbose >= 2);
                $adrh{$addr} = [ $label, "W$balance", $now ];
            }
        }
    }
@}

\subsection{{\tt showHelp} --- Show help information}

@d showHelp: Show address watch help information
@{
    sub showHelp {
        my $help = <<"    EOD";
perl address_watch.pl [ option... ] address_file
  Commands and arguments:
    -bfile filename     Set file to save last block scanned
    -end n              Last block to scan
    -help               Print this message
    -lfile filename     Set log file
    -poll n             Poll for new block every n seconds, 0 = never
    -sfile filename     Write block statistics to named file
    -start n            First block to scan
    -stats              Generate block statistics
    -type Any text      Display text argument on standard output
    -verbose            Print debug information, more for every -verbose
    -wallet             Scan wallet for addresses to watch
    -wfile filename     CSV file of addresses to watch
  @<RPC options help information@>
EOD
        $help =~ s/^    //gm;
        print($help);
        exit(0);
    }
@}

\chapter{Bitcoin Confirmation Watcher}

This utility queries the status of a transaction and reports changes
in the number of confirmations it has received.  It can monitor a
recent transaction and report new confirmations as they arrive,
exiting when a specified number of confirmations (default 6) have
been received.  The transaction can be specified by its transaction
ID and the hash of the block containing it.  If the server running
Bitcoin Core is configured with ``{\tt txindex=1}'', the block hash
need not be specified.

\begin{quote}
    {\tt confirmation\_watch} {\em transaction\_id} {\em block\_hash}
\end{quote}

If you are running {\tt address\_watch} on the same machine and have
configured it to write a log file, you can specify either the Bitcoin
address or the label you've assigned to it, with the transaction ID and
block hash retrieved from the log.  If, for some screwball reason, a
label is the same as a transaction ID, the label takes precedence; we
only look for a transaction ID if the specification does not match a
label.

\begin{quote}
    {\tt confirmation\_watch} {\em address}/{\em label}
\end{quote}

\section{Main program}

\subsection{Program plumbing}

@o perl/confirmation_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    @<RPC configuration variables@>

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
    use Term::ReadKey;

    use Data::Dumper;
@}

\subsection{Command line option processing}

@o perl/confirmation_watch.pl
@{
    my $log_file = "@<AW log file@>";               # Log file from Bitwatch
    my $watch = @<CW watch confirmations@>;         # Watch for confirmations ?
    my $poll_time = @<Blockchain poll interval@>;   # Poll time for watch check
    my $verbose = @<Verbosity level@>;              # Verbose output ?
    my $confirmed = @<CW deem confirmed@>;          # Number of confirmations required

    my %options = (
        @<RPC command line options@>
        "confirmed=i"   => \$confirmed,
        "help"          => \&showHelp,
        "lfile=s"       => \$log_file,
        "poll=i"        => \$poll_time,
        "type=s"        =>  sub { print("$_[1]\n"); },
        "verbose+"      => \$verbose,
        "watch"         => \$watch
    );

    processConfiguration();

    GetOptions(
        %options
    ) || die("Command line option error");
@}

\subsection{Look up address or label in {address\_watch} log}

If an address is specified, try looking up in the Bitwatch log to find
the transaction ID and block hash.  We accept either the Bitcoin
address or the label the user assigned to it.  If a single argument
if specified, we have a kludgelet to decide whether it's a label or
a transaction ID: if the length is less than 48 characters or it
contains a character which isn't a valid hexadecimal digit, we deem it
a label, otherwise it's interpreted as a transaction ID.

@o perl/confirmation_watch.pl
@{
    if (scalar(@@ARGV) == 1) {
        my $addr = $ARGV[0];
        if ((length($addr) < 48) || ($addr !~ m/[^\da-f]/i)) {
            if ($log_file eq "") {
                print("Cannot look up address or label unless log file (-lfile) specified.\n");
                exit(2);
            }
            my $found = FALSE;
            #   If the address has not yet appeared in the Bitwatch log,
            #   continue to poll until it shows up.
            do {
                open(LI, "<$log_file") || die("Cannot open log file $log_file");
                my ($txid, $blockhash);
                while (my $l = <LI>) {
                    if (($l =~ m/^"[^"]*",$addr,\S+,\S+\s+\S+,\S+,(\S+),(\S+)/) ||
                        ($l =~ m/^"$addr",\S+,\S+,\S+\s+\S+,\S+,(\S+),(\S+)/)
                       ) {
                        ($txid, $blockhash) = ($1, $2);
                        $found = TRUE;
                    }
                }
                close(LI);
                if ($watch && (!$found)) {
                    print("No transaction for this address found in address_watch log.\n" .
                          "Waiting $poll_time seconds before next check.\n") if $verbose;
                    sleep($poll_time);
                }
                if ($found) {
                    @@ARGV = ( $txid, $blockhash );
                }
            } while ($watch && (!$found));
            if (!$found) {
                print("Bitcoin address not found in Bitwatch log file.\n");
                exit(1);
            }
        } else {
            #   This looks like a transaction index alone, assuming
            #   txindex=1 allows queries without the block hash.
            $ARGV[1] = "";
        }
    } else {
        if (scalar(@@ARGV) < 2) {
            print("usage: confirmation_watch transaction_id block_hash\n");
            exit(0);
        }
    }

    my $txID = $ARGV[0];
    my $blockHash = $ARGV[1];
    @@ARGV = ( );
@}

\subsection{Prompt for RPC password}

If the ``{\tt rpc}'' query method was selected and no password was
specified, ask the user for it from standard input.

@o perl/confirmation_watch.pl
@{
    if (($RPCmethod eq "rpc") && ($RPCpass eq "")) {
        $RPCpass = getPassword("Bitcoin RPC password: ");
    }
@}

\subsection{Retrieve confirmations for transaction}

Now retrieve the confirmations for the transaction. If {\tt -watch} is
specified, continue to watch until we've received the {\tt -confirm}
number of confirmations, at which point we exit.

@o perl/confirmation_watch.pl
@{
    my $l_confirmations = -1;

    do {
        my $query = [ "getrawtransaction", $txID, "true" ];
        if ($blockHash ne "") {
            push(@@$query, $blockHash);
        }
        my $txj = sendRPCcommand($query);
        my $tx = decode_json($txj);

        print(Data::Dumper->Dump([$tx], [ qw(Transaction) ])) if $verbose >= 2;

        my $t_confirmations = $tx->{confirmations};
        my $t_time = $tx->{time};

        if ((!$watch) || ($t_confirmations != $l_confirmations)) {
            $l_confirmations = $t_confirmations;

            #   Show date and time and number of confirmations
            print(etime($t_time) . "  Confirmations: $t_confirmations\n");

            #   Number of "vout" items in transaction
            my $t_nvout = scalar(@@{$tx->{vout}});
            #   Loop over vout items
            for (my $v = 0; $v < $t_nvout; $v++) {
                if (defined($tx->{vout}->[$v]->{scriptPubKey}) &&
                    defined($tx->{vout}->[$v]->{scriptPubKey}->{addresses})) {
                    my $v_naddr = scalar(@@{$tx->{vout}->[$v]->{scriptPubKey}->{addresses}});
                    my $v_value = $tx->{vout}->[$v]->{value};
                    #   Loop over addresses in vout item
                    for (my $a = 0; $a < $v_naddr; $a++) {
                        #   Show destination addresses and amounts
                        my $a_addr = $tx->{vout}->[$v]->{scriptPubKey}->{addresses}->[$a];
                        printf("  => %-42s  %12.8f\n", $a_addr, $v_value);
                    }
                }
            }
        }
@}

\subsection{Test for confirmation and wait until next poll}

If we've received the specified number of confirmations, exit.  If
{\tt -watch} is specified, wait until the next poll time and check
for new confirmations.

@o perl/confirmation_watch.pl
@{
         if ($watch && ($l_confirmations < $confirmed)) {
            sleep($poll_time);
        }
   } while ($watch && ($l_confirmations < $confirmed));
@}

\subsection{Utility functions}

Define our local functions.

@o perl/confirmation_watch.pl
@{
    @<showHelp: Show confirmation watch help information@>
@}

Import utility functions we share with other programs.

@o perl/confirmation_watch.pl
@{
    @<etime: Edit time to ISO 8601@>
    @<Command and option processing@>
    @<sendRPCcommand: Send a Bitcoin RPC/JSON command@>
    @<getPassword: Prompt user to enter password@>
@}

\subsection{{\tt showHelp} --- Show help information}

@d showHelp: Show confirmation watch help information
@{
    sub showHelp {
        my $help = <<"    EOD";
perl confirmation_watch.pl [ option... ] transaction\_id/address/label [ block\_hash ]
  Commands and arguments:
    -confirmed n        Confirmations to deem transaction confirmed
    -help               Print this message
    -lfile filename     Log file from address_watch for looking up labels
    -poll n             Poll for new block every n seconds, 0 = never
    -type Any text      Display text argument on standard output
    -verbose            Print debug information, more for every -verbose
    -watch              Poll waiting for -confirmed confirmations
  @<RPC options help information@>
EOD
        $help =~ s/^    //gm;
        print($help);
        exit(0);
    }
@}

\chapter{Bitcoin Transaction Fee Watcher}

This utility collects data which may be used to plot, analyse, and
predict the evolution of Bitcoin transaction fees over time.  Data are
collected at a specified polling interval and may be displayed on
standard output and/or written to a log file in comma-separated format.
Both Bitcoin Core's estimated fees and actual fee data from blocks
added to the blockchain are reported.  No analysis is done---that's up
to programs which read and process the log.

\section{Main program}

\subsection{Program plumbing}

@o perl/fee_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    @<RPC configuration variables@>

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
    use Term::ReadKey;

    use Data::Dumper;
@}

\subsection{Command line option processing}

@o perl/fee_watch.pl
@{
    my $conf_target = @<CW deem confirmed@>;        # Confirmation target in blocks
    my $fee_file = "";                              # Fee watch log file
    my $poll_time = @<Blockchain poll interval@>;   # Poll time for watch check
    my $quiet = FALSE;                              # Suppress console output
    my $verbose = @<Verbosity level@>;              # Verbose output ?

    my %options = (
        @<RPC command line options@>
        "confirmed=i"   => \$conf_target,
        "ffile=s"       => \$fee_file,
        "help"          => \&showHelp,
        "poll=i"        => \$poll_time,
        "quiet"         => \$quiet,
        "type=s"        =>  sub { print("$_[1]\n"); },
        "verbose+"      => \$verbose
    );

    processConfiguration();

    GetOptions(
        %options
    ) || die("Command line option error");
@}

\subsection{Prompt for RPC password}

If the ``{\tt rpc}'' query method was selected and no password was
specified, ask the user for it from standard input.

@o perl/fee_watch.pl
@{
    if (($RPCmethod eq "rpc") && ($RPCpass eq "")) {
        $RPCpass = getPassword("Bitcoin RPC password: ");
    }
@}

\subsection{Poll fees at the specified interval}

We poll for the current fees at each specified interval.  This occurs
at an even multiple of the interval, not at intervals based upon when
the program started.  For example, if you set the interval to 10
minutes, polls will be at the top of the hour, 10, 20,\ldots\ etc.\
thereafter.  In each poll, we begin by making an {\tt estimatesmartfee}
query, which provides the estimate which the Bitcoin Core wallet
recommends for transactions it submits.  If logging is enabled, this is
logged as a type 1 record.

@o perl/fee_watch.pl
@{
    my $block_start = -1;               # Last block processed
    my $lastfee = -1;                   # Last estimated fee

    while (TRUE) {
        my $t = time();
        my $wait = $poll_time - ($t % $poll_time);
        print("Waiting $wait seconds until next poll.\n") if $verbose;
        sleep($wait);
        $t = time();

        my $efj = sendRPCcommand([ "estimatesmartfee", $conf_target ]);
        my $ef = decode_json($efj);
        print(Data::Dumper->Dump([$ef], [ qw(estimatesmartfee) ])) if $verbose >= 2;

        my $estimatedFee = $ef->{feerate};

        if (!$quiet) {
            my $feediff = "";
            if ($lastfee >= 0) {
                if ($lastfee != $estimatedFee) {
                    $feediff = sprintf("  %+.8f  %+.2f%%",
                        $estimatedFee - $lastfee,
                        100 * (($estimatedFee - $lastfee) / $lastfee));
                }
            }
            $lastfee = $estimatedFee;
            printf("%s  Estimated fee %10.8f%s\n", etime($t), $estimatedFee, $feediff);
        }

        if ($fee_file ne "") {
            open(FO, ">>$fee_file");
            print(FO "1,$t," . etime($t) . ",$estimatedFee\n");
        }
@}

Now we query block-level statistics for all blocks which have arrived
since the last poll.  These are obtained with {\tt getblockstats},
which provides the minimum, maximum. mean, and median fees paid by
transactions in the block, as well as a histogram of fees at the
10, 25, 50, 75, and 90 percentile levels.  If logging is enabled,
these are logged as type 2 item.

@o perl/fee_watch.pl
@{
        my $block_end = sendRPCcommand([ "getblockcount" ]);
        if ($block_start < 0) {
            $block_start = $block_end;
        }

        for (my $j = $block_start; $j <= $block_end; $j++) {
            my $bsj = sendRPCcommand([ "getblockstats", $j ]);
            my $bs = decode_json($bsj);
            print(Data::Dumper->Dump([$bs], [ qw(getblockstats) ])) if $verbose >= 2;
            my $btime = $bs->{time};
            my ($feerate_min, $feerate_mean, $feerate_max) =
                ($bs->{minfeerate}, $bs->{avgfeerate}, $bs->{maxfeerate});
            my @@feerate_percentiles = @@{$bs->{feerate_percentiles}};

            if (!$quiet) {
                printf("  Block %d  %s\n    Fee rate min %d, mean %d, max %d\n",
                    $j, etime($btime),
                    $feerate_min, $feerate_mean, $feerate_max);
                printf("    Fee percentiles: " .
                    "10%% $feerate_percentiles[0]  25%% $feerate_percentiles[1]  " .
                    "50%% $feerate_percentiles[2]  75%% $feerate_percentiles[3]  " .
                    "90%% $feerate_percentiles[4]\n");
            }
            if ($fee_file ne "") {
                print(FO "2,$btime," . etime($btime) . ",$j," .
                    "$feerate_min,$feerate_mean,$feerate_max," .
                    "$feerate_percentiles[0],$feerate_percentiles[1]," .
                    "$feerate_percentiles[2],$feerate_percentiles[3]," .
                    "$feerate_percentiles[4]\n");
            }
        }
        if ($fee_file ne "") {
            close(FO);
        }
        $block_start = $block_end + 1;
    }
@}

\subsection{Local functions}

Define our local functions.

@o perl/fee_watch.pl
@{
    @<showHelp: Show fee watch help information@>
@}

\subsection{Utility functions}

Import utility functions we share with other programs.

@o perl/fee_watch.pl
@{
    @<etime: Edit time to ISO 8601@>
    @<Command and option processing@>
    @<sendRPCcommand: Send a Bitcoin RPC/JSON command@>
    @<getPassword: Prompt user to enter password@>
@}

\subsection{{\tt showHelp} --- Show help information}

@d showHelp: Show fee watch help information
@{
    sub showHelp {
        my $help = <<"    EOD";
perl fee_watch.pl [ option... ]
  Commands and arguments:
    -confirmed n        Confirmations to deem transaction confirmed
    -ffile filename     Log file for fee statistics
    -help               Print this message
    -poll n             Poll for new block every n seconds, 0 = never
    -quiet              Suppress console output
    -type Any text      Display text argument on standard output
    -verbose            Print debug information, more for every -verbose
  @<RPC options help information@>
EOD
        $help =~ s/^    //gm;
        print($help);
        exit(0);
    }
@}

\chapter{Utility Functions}

\section{{\tt etime} --- Edit time to ISO 8601}

@d etime: Edit time to ISO 8601
@{
    sub etime {
        my ($t) = @@_;

        return strftime("%F %T", gmtime($t));
    }
@| etime @}

\section{Command and option processing}

These functions provide an integrated way to handle option
specifications and commands whether provided as command-line
options, from a configuration file, or entered interactively
by the user.  All of these functions are driven by a hash
defining commands and actions in the same form as used by
{\tt Getopt::Long}.  Any option not defined in the hash
will be ignored if in a configuration file (allowing the
same file to be used by multiple programs with only some
options in common) or reported as an error message if entered
interactively.

\subsection{{\tt processCommand} --- Parse and process command}

@d Command and option processing
@{
    sub processCommand {
        my ($command, $interactive) = @@_;

        my ($verb, $noun) = ("", "");
        $command =~ s/\s+$//;
        #   Ignore blank lines and comments
        if (($command ne "") && ($command !~ m/^\s*#/)) {
            $command =~ m/^\s*(\w+)(?:\s+(\S.*?))?\s*$/ ||
                die("Unable to parse command \"$command\"\n");
            ($verb, $noun) = ($1, $2);
            my $inop = TRUE;
            foreach my $op (keys(%options)) {
                $op =~ s/(?:\+|=\w+)$//;
                if ($op eq $verb) {
                    $inop = FALSE;
                    last;
                }
            }
            if ($inop) {
                if ($interactive) {
                    return ("", "") if ($verb =~ m/^(?:en|ex|qu)/);
                    print("Unknown command/option \"$verb\".\n");
                    return ("?", "");
                } else {
                    return ("", "");
                }
            }
            $noun = "" if (!defined($noun));
            my @@optarr = ( "-$verb" );
            if ($noun ne "") {
                push(@@optarr, $noun);
            }
            if (!GetOptionsFromArray(\@@optarr, %options)) {
                if ($interactive) {
                    print("Error in command \"$command\".\n");
                }
            }
        }
        return ($verb, $noun);
    }
@| processCommand @}

\subsection{{\tt arg\_inter} --- Process interactive commands}

A utility may process interactive commands from the user by processing
the @{-inter@} option and calling this handler.  It prompts the user
for commands and arguments and executes them interactively.
Interactive mode is exited by any of the commands ``@{end@}'',
``@{exit@}'', or ``@{quit@}'', all of which may be abbreviated to
two characters.

@d Command and option processing
@{
    my $interactive = FALSE;

    sub arg_inter {
        $interactive = TRUE;
        while (TRUE) {
            print("> ");
            my $l = <> || last;
            chomp($l);
            my ($v, $n);
            eval {
                ($v, $n) = processCommand($l, TRUE);
            };
            last if ($v eq "");
        }
        $interactive = FALSE;
    }
@| arg_inter @}

\subsection{{\tt processCommandFile} --- Process commands from file}

Read and execute commands from the file named by the argument.
Errors are ignored, allowing a general configuration file to
be used for multiple programs, not all of which support options
it declares.

@d Command and option processing
@{
    sub processCommandFile {
        my ($fname) = @@_;

        open(CI, "<$fname") ||
            die("Cannot open command file $fname");

        while (my $l = <CI>) {
            chomp($l);
            my ($v, $n) = processCommand($l, FALSE);
        }
        close(CI);
    }
@| processCommandFile @}

\subsection{{\tt processConfiguration} --- Process program configuration}

We first look for a project-wide configuration file and, if present,
process it.  Then, we look for a configuration file for a specific
program, which will be named {\em program\_name}{\tt .conf}; if
present, options it sets will override those in the project
configuration file.  Options in both files can be overridden by
those on the command line, which are processed after both configuration
files.

@d Command and option processing
@{
    sub processConfiguration {
        if (-f "@<Project File Name@>.conf") {
            processCommandFile("@<Project File Name@>.conf");
        }
        my $progName = "@f";
        $progName =~ m|^(?:[^/]*/)?(\w+)\.\w+$| ||
            die("Cannot extract program name from $progName");
        $progName = $1;
        if (-f "$progName.conf") {
            processCommandFile("$progName.conf");
        }
    }
@| processConfiguration @}


\section{{\tt getPassword} --- Prompt user to enter password}

The user is prompted to enter a password by the message
argument, which is output on standard error (in case standard
output has been redirected), then the user's input is accepted
with echo turned off in the interest of security.

@d getPassword: Prompt user to enter password
@{
    sub getPassword {
        my ($prompt) = @@_;

        ReadMode("noecho");
        print(STDERR $prompt);
        my $pw = <STDIN>;
        chomp($pw);
        ReadMode("original");
        return $pw;
    }
@| getPassword @}

\section{{\tt sendRPCcommand}  ---  Send a Bitcoin RPC/JSON command}

This function sends a command to the Bitcoin RPC/JSON API and returns
its result, or an undefined value in case of error. Its argument is a
reference of an array of arguments in precisely the form they would be
submitted on the {\tt bitcoin-cli} command line.  The query is sent by
the means specified by the {\tt \$RPCmethod} variable, as follows.

\begin{quote}
\begin{description}
    \item[{\tt local}] Request via command line {\tt bitcoin-cli}
    on the local machine, which is a Bitcoin
    node.

    \item[{\tt ssh}] Submit request via ssh to {\tt bitcoin-cli}
    installed on Bitcoin node running on
    host {\tt \$RPChost} at path name {\tt \$RPCcli}.

    \item[{\tt rpc}] Make a direct RPC call to the Bitcoin
    daemon running on {\tt \$RPChost} at port
    {\tt \$RPCport}, logging in as {\tt \$RPCuser} with
    password {\tt \$RPCpass}.  The Bitcoin daemon
    on that host must be configured to accept
    requests from the submitting host and user.
\end{description}
\end{quote}

@d sendRPCcommand: Send a Bitcoin RPC/JSON command
@{
    sub sendRPCcommand {
        my ($args) = @@_;

        my $result;

        if ($RPCmethod eq "local") {
            @<Request via bitcoin-cli on the local machine@>

        } elsif ($RPCmethod eq "ssh") {
            @<Request via bitcoin-cli on a remote machine via ssh@>

         } elsif ($RPCmethod eq "rpc") {
            @<Request via direct RPC call@>

       } else {
            print(STDERR "Unknown -method configured: \"$RPCmethod\".\n");
            exit(1);
        }

        if (defined($result)) {
            chomp($result);
        }

        return $result;
    }
@| sendRPCcommand @}

\subsection{Request via {\tt bitcoin-cli} on the local machine}

@d Request via bitcoin-cli on the local machine
@{
    my $cmd = join(" ", @@$args);
    $result = `$RPCcli $cmd`;

@}

\subsection{Request via {\tt bitcoin-cli} on a remote machine via {\tt ssh}}

@d Request via bitcoin-cli on a remote machine via ssh
@{
    my $cmd = join(" ", @@$args);
    $result = `ssh $RPChost $RPCcli $cmd`;
@}

\subsection{Request via direct RPC call}

We first extract the query type (or ``method''), which is the first
item in the argument list.

@d Request via direct RPC call
@{
    my $method = shift(@@$args);
@}

Next, we translate the arguments in the remainder of the list
into JSON-encoded values.  This isn't as simple as it might seem,
since numbers and the reserved words ``{\tt true}'', ``{\tt false}'',
and ``{\tt null}'' must not be quoted, while strings must be
quoted.  We accept string arguments either pre-quoted or as bare
strings, to which quotes are added and embedded quotes escaped.

@d Request via direct RPC call
@{
    for (my $i = 0; $i < scalar(@@$args); $i++) {
        if ($args->[$i] !~ m/^(?:true|false|null|[\d\.]+|".*")$/) {
            my $s = $args->[$i];
            $s =~ s/"/\\"/g;
            $args->[$i] = "\"$s\"";
        }
    }
@}

Assemble the query to be sent to the server.  This is encoded
as a \href{https://en.wikipedia.org/wiki/JSON}{JSON} object
containing the method and array of parameters.

@d Request via direct RPC call
@{
    my $params = join(",\n        ", @@$args);
    my $request = LWP::UserAgent->new();
    $request->agent("trans_watch");
    #   Specify requester's credentials, including user and password
    $request->credentials("$RPChost:$RPCport", "jsonrpc",
        $RPCuser, $RPCpass);
    #   Compose JSON query to be sent via POST
    my $query = <<"                EOD";
{
"jsonrpc": "1.0",
"id": "trans_watch",
"method": "$method",
"params": [
$params
]
}
EOD
@}

Build HTTP request.  Since we're sending a pure text string via POST
rather than a set of key, value pairs, we have to roll our own {\tt
HTTP::Request}.

@d Request via direct RPC call
@{
    my $rq = HTTP::Request->new("POST",
                                "http://$RPChost:$RPCport/",
                                [ "Content-Type" => "text/plain" ],
                                $query);
    my $reply = $request->request($rq);
@}

If the request succeeded (result code 200), extract the content.  Note
that unlike the result returned by {\tt bitcoin-cli}, this is wrapped
in an outer ``{\tt result}'' object, from which we must extract the
actual content. We further check the error status within the reply,
returning {\tt undef} if it is non-null.

@d Request via direct RPC call
@{
    if ($reply->{_rc} == 200) {
        $result = $reply->{_content};
        $result =~ s/^\{"result":(.*?)(,"error":[^\{]+\})$/$1/ ||
            die("Cannot extract RPC result");
        my $errstat = $2;
        if ($errstat !~ m/"error"\s*:\s*null/) {
            $result = undef;
        }
    }
@}

\subsection{RPC configuration}

Define the variables specifying the RPC configuration.

@d RPC configuration variables
@{
    my $RPCmethod = "@<RPC query method@>"; # RPC query method: "local", "ssh", "rpc"
    my $RPChost = "@<RPC host@>";           # Host where bitcoind runs
    my $RPCport = @<RPC port@>;             # bitcoind RPC query port (standard 8332)
    my $RPCcli = "@<Bitcoin CLI path@>";    # Path to run bitcoin-cli
    my $RPCuser = "@<RPC user@>";           # RPC user name
    my $RPCpass = "@<RPC password@>";       # RPC password
@| $RPCmethod $RPChost $RPCport $RPCcli $RPCuser $RPCpass @}

Define the command-line options to set the RPC configuration variables.

@d RPC command line options
@{
    "clipath=s"     => \$RPCcli,
    "host=s"        => \$RPChost,
    "method=s"      => \$RPCmethod,
    "rpcpass=s"     => \$RPCpass,
    "port=i"        => \$RPCport,
    "user=s"        => \$RPCuser,
@}

Define the {\tt -help} output for the RPC configuration options.

@d RPC options help information
@{
Bitcoin API access configuration options:
  -clipath path       Path name to execute bitcoin-cli command line utility
  -host hostname      Host (name or IP address) where Bitcoin Core runs
  -method which       Query method: local, rpc, ssh
  -rpcpass "text"     Bitcoin RPC API password
  -port n             Port for RPC API requests (default @<RPC port@>)
  -user userid        User name for requests via ssh@}

\section{{\tt blockReward} --- Compute reward for mining block}

When a miner solves a hash and publishes a block, they receive a
reward composed of a fee for the block plus all of the fees for
transactions packed into the block.  The block reward in
Bitcoin, $R_b$, is
computed on a scale which declines with the block number $b$
according to:

\[
    R_b = \frac{50}{2^{\lfloor (b+1)/210000\rfloor}}
\]

@d blockReward: Compute reward for mining block
@{
    sub blockReward {
        my ($b) = @@_;

        return 50 / 2 ** int(($b + 1) / 210000);
    }
@| blockReward @}

\section{{\tt readHexfile} --- Read hexadecimal data from a file}

Read a ``hexfile'' containing hexadecimal data.  We ignore everything
until we find a line with at least 32 characters of valid hexadecimal
data and nothing else.  We then read successive lines containing
nothing but valid hexadecimal data and white space until encountering a
line which doesn't pass this test or end of file.  Returns the
hexadecimal data stream with no embedded white space.

@d readHexfile: Read hexadecimal data from a file
@{
    sub readHexfile {
        my ($fname) = @@_;

        my $data = "";
        my $ignore = TRUE;
        my $hex = qr/[\dA-Fa-f]/;

        open(FI, "<$fname") || die("Cannot open $fname");
        while (my $l = <FI>) {
            chomp($l);
            $l =~ s/\s+//g;
            my $isHex = $l =~ m/^$hex+$/;
            if ($ignore) {
                if ($isHex && (length($l) >= 32)) {
                    $ignore = FALSE;
                }
            }
            if (!$ignore) {
                if ($isHex) {
                    $data .= $l;
                } else {
                    last;
                }
            }
        }
        close(FI);
        if (length($data) & 1) {
            die("Number of hexadecimal digits is odd");
        }
        return $data;
    }
@| readHexfile @}

\section{Pseudorandom number generator}

We use the \href{https://en.wikipedia.org/wiki/Mersenne_Twister}{Mersenne
Twister} algorithm as a pseudorandom number generator.  It is
implemented in the Perl module {\tt Math::Random::MT}, which we import
and use to create and initialise our generator, {\tt \$randGen}.

\subsection{{\tt randInit} --- Initialise pseudorandom generator}

Any code which requires the random generator should call {\tt
randInit()} before requesting any data.  If the generator has not been
initialised, a 2496 byte random seed is obtained from non-blocking {\tt
Crypt::Random::Seed} and used to initialise a new generator.  If the
generator has been previously initialised, the call is ignored, so
there's no need for application code to check whether a call to {\tt
randInit()} is needed.

@d Pseudorandom number generator
@{
    use Math::Random::MT;

    my $randGen;                    # Pseudorandom number generator

    sub randInit {
        if (!defined($randGen)) {
            my (@@seed, $rbuf);

            my $rgen = Crypt::Random::Seed->new(NonBlocking => 1);
            $rbuf = $rgen->random_bytes(624 * 4);
            @@seed = unpack("L4", $rbuf);
            $randGen = Math::Random::MT->new(@@seed);
        }
    }
@| randInit @}

\subsection{{\tt randNext} --- Get next value from pseudorandom generator}

The next pseudorandom value is returned by {\tt randNext(}$n${\tt )},
where $n$ specifies the range of values returned, in the half-open
interval $[0,n)$, that is, $0\leq r<n$, where $r$ is the random
variate returned.  Thus, to return the value of a pseudorandom byte,
use {\tt randNext(256)}.

@d Pseudorandom number generator
@{
    sub randNext {
        my ($n) = @@_;

        return $randGen->rand($n);
    }
@| randNext @}

\section{{\tt shuffleBytes} --- Shuffle bytes in string}

Shuffle the bytes in a string using the
\href{https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle}{Fisher-Yates
shuffle} algorithm.  The pseudorandom values for the shuffle are
obtained from the Mersenne Twister generator {\tt randNext()}.

@d shuffleBytes: Shuffle bytes
@{
    sub shuffleBytes {
        my ($in) = @@_;

        randInit();
        my @@bytes = unpack("C*", $in);

        my $n = scalar(@@bytes);
        for (my $i = $n - 1; $i >= 1; $i--) {
            my $j = randNext($i + 1);
            my $temp = $bytes[$j];
            $bytes[$j] = $bytes[$i];
            $bytes[$i] = $temp;
        }

        return pack("C*", @@bytes);
    }
@| shuffleBytes @}

\chapter{Meta and Miscellaneous}

This is a collection of items which are about building the programs and
tools used in the process.

\section{Perl language modes}

@d Perl language modes
@{
    require 5;
    use strict;
    use warnings;
    use utf8;

    use constant FALSE => 0;
    use constant TRUE => 1;
@}

\section{Explanatory header for shell-like files}

@d Explanatory header for shell-like files
@{
    #   NOTE: This program was automatically generated by the Nuweb
    #   literate programming tool.  It is not intended to be modified
    #   directly.  If you wish to modify the code or use it in another
    #   project, you should start with the master, which is kept in the
    #   file @<Project File Name@>.w in the public GitHub repository:
    #       https://github.com/Fourmilab/@<Project File Name@>.git
    #   and is documented in the file @<Project File Name@>.pdf in the root directory
    #   of that repository.
@}

\section{Explanatory header for Perl files}

This header comment appears at the top of all Perl files generated
from this web.  It explains where to go for the master source code.

@d Explanatory header for Perl files
@{#! @<Perl directory@>

@<Explanatory header for shell-like files@>
    #
    #   Build @<Build number@>  @<Build date and time@>
@}

\section{Explanatory header for Python files}

This header comment appears at the top of all Python files generated
from this web.  It explains where to go for the master source code.

@d Explanatory header for Python files
@{#! @<Python directory@>

@<Explanatory header for shell-like files@>
    #
    #   Build @<Build number@>  @<Build date and time@>
@}

\section{Makefile}

The {\tt Makefile} is used to control all build and maintenance
operations.  Due to a regrettable episode in the ancient history of
Unix, the distinction between hardware tab characters and other white
space is significant.  Nuweb always uses space characters, which would
break {\tt make}, so the {\tt Makefile} incorporates a little trick:
after performing a {\tt make~build} from the web, if this file has been
expanded to {\tt Makefile.mkf} and it is newer than the current {\tt
Makefile}, it is processed with {\tt sed} and {\tt unexpand} to restore
the tabs as required.

@o Makefile.mkf
@{
@<Explanatory header for shell-like files@>

PROJECT = @<Project File Name@>

#       Path names for build utilities

NUWEB = nuweb
LATEX = xelatex
PDFVIEW = evince
GNUFIND = find

duh:
        @@echo "What'll it be, mate?  build view peek lint stats clean"
@}

\subsection{Build program files}

Rebuild all changed files from the master Nuweb {\tt .w} files.
Here is where we perform the dirty trick to convert spaces to tabs
so a newly-generated {\tt Makefile} will work.

@o Makefile.mkf
@{
build:
        perl tools/build/update_build.pl
        $(NUWEB) -t $(PROJECT).w
        chmod 755 perl/*.pl
        chmod 755 python/*.py
        @@if [ \( ! -f Makefile \) -o \( Makefile.mkf -nt Makefile \) ] ; then \
                echo Makefile.mkf is newer than Makefile ; \
                sed "s/ \*$$//" Makefile.mkf | unexpand >Makefile ; \
        fi
@}

\subsection{Generate and view PDF document}

The {\tt view} target re-generates the master document containing
all documentation and code, while {\tt peek} simply views the
most-recently-generated document (without checking if it is current).
We delete the \LaTeX\ intermediate files so an error in an
earlier run which might, for example, have corrupted the table of
contents, does not wreck this one.

@o Makefile.mkf
@{
view:
        rm -f $(PROJECT).log $(PROJECT).toc $(PROJECT).out $(PROJECT).aux
        $(NUWEB) -o -r $(PROJECT).w
        $(LATEX) $(PROJECT).tex
        # We have to re-run Nuweb to incorporate the updated TOC
        $(NUWEB) -o -r $(PROJECT).w
        $(LATEX) $(PROJECT).tex
        $(PDFVIEW) $(PROJECT).pdf

peek:
        $(PDFVIEW) $(PROJECT).pdf
@}

\subsection{Generate and view User Guide PDF document}

Build the composite document for the program, then process it with
{\tt sed} filters which extract the User Guide as a separate
\LaTeX\ document, compile it into a PDF, and view it.

@o Makefile.mkf
@{
guide:
        rm -f $(PROJECT)_user_guide.log $(PROJECT)_user_guide.toc \
              $(PROJECT)_user_guide.out $(PROJECT)_user_guide.aux
        $(NUWEB) -o -r $(PROJECT).w
        sed -e '/^\\expunge{begin}{userguide}$$/,/^\\expunge{end}{userguide}$$/d' \
            $(PROJECT).tex | \
            sed -e 's/\\impunge{userguide}//' >$(PROJECT)_user_guide.tex
        $(LATEX) $(PROJECT)_user_guide.tex
        $(LATEX) $(PROJECT)_user_guide.tex
        $(PDFVIEW) $(PROJECT)_user_guide.pdf

geek:
        $(PDFVIEW) $(PROJECT)_user_guide.pdf
@}

\subsection{Syntax check all Perl programs}

All Perl programs in the directory tree are checked with {\tt perl -c}.
This requires the GNU {\tt find} utility, which supports the ``{\tt
-quit}'' action that allows us to stop after the first error it
detects.

@o Makefile.mkf
@{
lint:
        @@# Uses GNU find extension to quit on first error
        $(GNUFIND) perl tools -type f -name \*.pl -print \
                \( -exec perl -c {} \; -o -quit \)
@}

\subsection{Build and syntax check Perl programs}

The ``{\tt bl}'' target is a convenience which causes an error in
the build to avoid running the subsequent lint.

@o Makefile.mkf
@{
bl:
        make --no-print-directory build
        make --no-print-directory lint
@}

\subsection{Show statistics of the project}

``How's it coming along?''  Compute and print statistics about the
project at the present time.

@o Makefile.mkf
@{
stats:
        @@echo Build `grep "Build number" build.w | sed 's/[^0-9]//g'` \
                `grep "Build date and time " build.w | \
                sed 's/[^:0-9 \-]//g' | sed 's/^ *//'`
        @@echo Web: `wc -l *.w`
        @@echo Lines: `find . -type f \( -wholename ./perl/\*.pl \
                -o -wholename ./python/\*.py \) -exec cat {} \; | wc -l`
        @@if [ -f $(PROJECT).log ] ; then \
                echo -n "Pages: " ; \
                tail -5 $(PROJECT).log | grep pages | sed 's/[^0-9]//g' ; \
        fi
@}

\subsection{Clean up intermediate files from earlier builds}

Delete intermediate files from the build process, or all files
generated from the web.

@o Makefile.mkf
@{
clean:
        rm -f nw[0-9]*[0-9] rm *.aux *.log *.out *.pdf *.tex *.toc \
            perl/*.pl

squeaky:
        #make clean
        #rm -f Makefile.mkf
        #find scripts -type f -name \*.pl -exec rm -f {} \;
        #  Need to clean tools directory after all integrated here
@}

\section{Build number and date maintenance}

This Perl program is run by the {\tt Makefile} every time a ``{\tt make
build}'' is run.  It increments the build number and places the current
UTC date and time in the {\tt build.w} file which is included here to
implement build number consistency checking.

@o tools/build/update_build.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    use POSIX qw(strftime);

    my $bfile = "build.w";              # Build file name

    #   Read current file into string

    open(FI, "<$bfile") || die("Cannot open $bfile");
    my $btext = do {
        local $/ = undef;
        <FI>;
    };
    close(FI);

    #   Update build number and date

    my $date = strftime("%F %H:%M", gmtime(time()));

    $btext =~ m/\@@d\s+Build\s+number\s+\@@\{(\d+)\@@/s;
    my $buildno = $1;
    $buildno++;

    #   Substitute build number and date into file

    $btext =~ s/(\@@d\s+Build\s+number\s+\@@\{)\d+/$1$buildno/s ||
        die("Cannot substitute build number");
    $btext =~ s/(\@@d Build date and time \@@\{)[^\@@]+/$1$date/s ||
        die("Cannot substitute date");

    #   Write out the updated file

    open(FO, ">$bfile") || die("Cannot open $bfile for writing");
    print(FO $btext);
    close(FO);

    print("Build $buildno $date\n");
@}

\section{Git configuration}

The project's source code is managed with Git.  This {\tt .gitignore}
file excludes all files generated automatically from this master
document from version control.

@o .gitignore
@{
.gitignore
Makefile
Makefile.mkf
*.aux
*.log
*.out
*.pdf
*.tex
*.toc
run
tools
*.pl
*.py
@}

\clearpage
\stepcounter{chapter}
\vbox{
\chapter*{Indices} \label{indices}
\addcontentsline{toc}{chapter}{Indices}

Three indices are created automatically: an index of file
names, an index of macro names, and an index of user-specified
identifiers. An index entry includes the name of the entry, where it
was defined, and where it was referenced.
}

\section{Files}

@f

\section{Macros}

@m

\section{Identifiers}

Sections which define identifiers are underlined.

@u

\font\df=cmbx12
\def\date#1{{\medskip\noindent\df #1\medskip}}
\parskip=1ex
\parindent=0pt

\begin{appendices}

\chapter{Abbreviations used in this document}

@d AW @{{\tt address\_watch}@}
@d BA @{{\tt blockchain\_address}@}
@d CC @{{\tt cold\_comfort}@}
@d CW @{{\tt confirmation\_watch}@}
@d FW @{{\tt fee\_watch}@}
@d MK @{{\tt multi\_key}@}
@d PW @{{\tt paper\_wallet}@}
@d VW @{{\tt validate\_wallet}@}

\chapter{Development Log} \label{log}

@i log.w
\end{appendices}
\expunge{end}{userguide}

\end{document}
