\documentclass{report}

%    ****** TURN OFF HARDWARE TABS BEFORE EDITING THIS DOCUMENT ******
%
%   Should you ignore this admonition, tabs in the program code will
%   not be respected in the LaTeX-generated program document.
%   If that should occur, simply pass this file through
%   expand to replace the tabs with sequences of spaces.

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

\let\cleardoublepage\clearpage

%   Space between paragraphs, don't indent
\usepackage[parfill]{parskip}
%   Keep section numbers from colliding with title in TOC
\usepackage{tocloft}
\cftsetindents{subsection}{4em}{4em}
\cftsetindents{subsubsection}{6em}{5em}

%   Enable PDF output and hyperlinks within PDF files
\usepackage[unicode=true,pdftitle={Fourmilab Bitcoin Tools},pdfauthor={John Walker},colorlinks=true,linkcolor=blue,urlcolor=blue]{hyperref}

%   Enable inclusion of graphics files
\usepackage{graphicx}

%   Enable proper support for appendices
\usepackage[toc,titletoc,title]{appendix}

%   Support text wrapping around figures
\usepackage{wrapfig}

%   Add additional math notation, including \floor and \ceil
\usepackage{mathtools}

\title{\bf Fourmilab Bitcoin Tools}

\author{
    by \href{http://www.fourmilab.ch/}{John Walker}
}
\date{
    April 2021 \\
    \vspace{12ex}
    \includegraphics[width=3cm]{figures/fourlogo_640.png}
}

\begin{document}

\pagenumbering{roman}
\maketitle
\tableofcontents

\chapter{Introduction}
\pagenumbering{arabic}

This collection of programs and utilities provides a set of tools for
advanced users, explorers, and researchers of the Bitcoin blockchain.
Most of the tools require access to a system (either local or remote)
which runs a ``full node'' using the
\href{https://bitcoin.org/en/bitcoin-core/}{Bitcoin Core} software
and maintains a complete copy of the up-to-date Bitcoin blockchain.
In order to use the Address Watcher, the node must maintain a
transaction index, which is enabled by setting ``{\tt txindex=1}''
in its {\tt bitcoin.conf} file.

Some utilities (for example, the Bitcoin address generator) do not
require access to a Bitcoin node and others may be able to be used
on nodes which have ``pruned'' the blockchain to include only more
recent blocks.

@d Project Title @{Bitcoin Tools@}
@d Project File Name @{bitcoin_tools@}

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

@d Perl directory @{/usr/bin/perl@}

\chapter{Bitcoin Address Generator}

This program generates Bitcoin public address and private key pairs
from a variety of sources of random and pseudorandom data, including
Fourmilab's HotBits radioactive random number generator.  The program
is implemented as a stack machine where command line ``options'' are
actually commands and arguments that allow specification, generation,
and manipulation of random and pseudorandom data, generation of Bitcoin
private keys and public addresses from them, and their output in a
variety of formats.

\section{Main program}

\subsection{Program plumbing}

@o bitcoin_address.pl
@{@<Explanatory header for Perl files@>

    #   Generate Bitcoin private keys and public address pairs
    #   from HotBits-generated data.

    @<Perl language modes@>

    #   Your HotBits API key
    my $HotBits_API_key = "@<HotBits API key@>";

    my $HotBits_Query = "@<HotBits query URL@>";
#        #   Radioactive decay generator for production use
#       "https://www.fourmilab.ch/cgi-bin/Hotbits.api?nbytes=32&fmt=hex&apikey=$HotBits_API_key"
#        #   Pseudorandom generator for testing during development
#        "https://www.fourmilab.ch/cgi-bin/Hotbits.api?nbytes=32&fmt=hex&pseudo=pseudo"
#        #   Local generator for use at Fourmilab
#        "http://10.2.0.50:5739/-h32"
#        #   Canned constant value for testing on air-gapped machines
#       "<pre>\n4F010C07C1C06F90929CECB53A8377D98F8406CB8ECEFFE16378A14BBE492972\n</pre>\n"
#    ;

    use Bitcoin::Crypto::Key::Private;
    use Bitcoin::Crypto::Key::Public;
    use Bitcoin::BIP39 qw(entropy_to_bip39_mnemonic bip39_mnemonic_to_entropy);
    use Digest::SHA qw(sha256_hex);
    use Crypt::CBC;
    use MIME::Base64;
    use LWP::Simple;
    use Getopt::Long qw(GetOptionsFromArray);
    use Data::Dumper;
@}

\subsection{Process command line options}

If project- or program-level configuration files are present, process
them, then process command line options.

@o bitcoin_address.pl
@{
    my $opt_Format = "";

    my $repeat = 1;             # Repeat command this number of times
    my @@seeds;                 # Stack of seeds

    my %options = (
        "aes"       =>  \&arg_aes,
        "binfile=s" =>  \&arg_binfile,
        "drop"      =>  \&arg_drop,
        "dump"      =>  \&arg_dump,
        "dup"       =>  \&arg_dup,
        "format=s"  =>  \$opt_Format,
        "hbapik=s"  =>  \$HotBits_API_key,
        "help"      =>  \&showHelp,
        "hexfile=s" =>  \&arg_hexfile,
        "hotbits"   =>  \&arg_hotbits,
        "inter"     =>  \&arg_inter,
        "key"       =>  \&arg_key,
        "not"       =>  \&arg_not,
        "over"      =>  \&arg_over,
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

@o bitcoin_address.pl
@{
    #   Local functions
    @<Command line argument handlers@>
    @<stackCheck:  Check for stack underflow@>
    @<hexToBytes: Convert hexadecimal string to binary@>
    @<bytesToHex: Convert binary string to hexadecimal@>
    @<genFromFile: Generate keys from seeds specified in a Hexfile@>
    @<genAddress: Generate address from one hexadecimal seed@>
    @<editAddress: Edit private key and public address@>
    @<BIP39encode: Encode seed as BIP39 mnemonic phrase@>
    @<Pseudorandom number generator@>
    @<shuffleBytes: Shuffle bytes@>
    @<showHelp: Show Bitcoin address help information@>

    #   Shared utility functions
    @<readHexfile: Read hexadecimal data from a file@>
    @<Command and option processing@>
@}

\section{Local functions}

\subsection{Command line argument handlers}

@d Command line argument handlers
@{
    @<arg\_aes: Encrypt second item with top of stack key@>
    @<arg\_binfile: Push seeds from binary file on stack@>
    @<arg\_drop: Drop the top item from the stack@>
    @<arg\_dump: Dump the stack@>
    @<arg\_dup: Duplicate the top item from the stack@>
    @<arg\_hexfile: Push seeds from hexfile on stack@>
    @<arg\_hotbits: Request seed(s) from HotBits@>
    @<arg\_key: Generate key/address from top of stack@>
    @<arg\_not: Invert bits in top of stack item@>
    @<arg\_over: Duplicate the second item from the stack@>
    @<arg\_pick: Duplicate the $n$th item from the stack@>
    @<arg\_pseudo: Generate pseudorandom seed and push on stack@>
    @<arg\_phrase: Specify seed as BIP39 phrase@>
    @<arg\_random: Request seed(s) from /dev/random@>
    @<arg\_roll: Rotate item $n$ to top of stack@>
    @<arg\_rot: Rotate three stack items@>
    @<arg\_rrot: Reverse rotate three stack items@>
    @<arg\_seed: Push seed on stack@>
    @<arg\_sha256: Replace top of stack with its SHA256 hash@>
    @<arg\_shuffle: Shuffle bytes on stack@>
    @<arg\_swap: Swap the two top items on the stack@>
    @<arg\_test: Test the stack top item for randomness@>
    @<arg\_urandom: Request seed(s) from /dev/urandom@>
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
#my $rplain = $crypt->decrypt($codetext);
#print("Plain " . length($plaintext) . " Code " . length($codetext) . "\n");
        my $hexcode = bytesToHex($codetext);
        push(@@seeds, $hexcode);
#push(@@seeds, bytesToHex($rplain));
    }
@| arg_aes @}

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
        print("  ", join("\n  ", reverse(@@seeds)), "\n");
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

\subsubsection{{\tt arg\_hexfile} --- {\tt -hexfile}: Push seeds from hexfile on stack}

@d arg\_hexfile: Push seeds from hexfile on stack
@{
    sub arg_hexfile {
        my ($name, $value) = @@_;

        my $hf = readHexfile($value);
        while ($hf =~ s/^([\dA-F]{64})//i) {
            push(@@seeds, $1);
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

\subsubsection{{\tt arg\_key} --- {\tt -key}: Generate key/address from top of stack}

@d arg\_key: Generate key/address from top of stack
@{
    sub arg_key {
        stackCheck($repeat);
        @<Begin command repeat@>
            my $seed = pop(@@seeds);
            my ($priv, $pub) = genAddress($seed, $opt_Format, 1);
            print(editAddress($priv, $pub, $opt_Format, 1));
        @<End command repeat@>
    }
@| arg_key @}

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

\subsubsection{{\tt arg\_random} --- {\tt -random}: Request seed(s) from {\tt /dev/random}}

@d arg\_random: Request seed(s) from /dev/random
@{
    sub arg_random {
        my $n = 32 * $repeat;
        open(RI, "</dev/random") || die("Cannot open /dev/random");
        my $l = 0;
        my $rbytes;
        while ($l < $n) {
            my $dat;
            my $r = read(RI, $dat, $n - $l);
#print("Requested " . ($n - $l) . " bytes, read $r\n");
            $rbytes .= $dat;
            $l += $r;
            if ($l < $n) {
                #   /dev/random exhausted: give it a rest
                sleep(0.1);
            }
        }
        close(RI);
        while ($rbytes =~ s/^(.{32})//s) {
            my $hn = $1;
            push(@@seeds, bytesToHex($hn));
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

        if ($value !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
        push(@@seeds, $value);
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

Shuffle the bytes of all items on the stack.  Why would you want
to do this?  Suppose, for example, you've obtained entropy from a
source on the Internet and, despite retrieving it using https:, you're
worried about the data being intercepted along the way or archived
by the site which generated it.  You can ally that risk, in part, by
generating a much larger quantity of data than you need, shuffling
the bytes using a different seed generated locally, then selecting
a key from the shuffled bytes.  If the sample from which you select
your actual key is sufficiently large, guessing which bytes were
chosen is intractable.

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
        print("$ent_analysis\n");
    }
@| arg_test @}

\subsubsection{{\tt arg\_urandom} --- {\tt -urandom}: Request seed(s) from {\tt /dev/urandom}}

@d arg\_urandom: Request seed(s) from /dev/urandom
@{
    sub arg_urandom {
        my $n = 32 * $repeat;
        open(RI, "</dev/urandom") || die("Cannot open /dev/urandom");
        my $l = 0;
        my $rbytes;
        while ($l < $n) {
            my $dat;
            my $r = read(RI, $dat, $n - $l);
#print("Requested " . ($n - $l) . " bytes, read $r\n");
            $rbytes .= $dat;
            $l += $r;
            if ($l < $n) {
                #   /dev/urandom exhausted: give it a rest
                sleep(0.1);
            }
        }
        close(RI);
        while ($rbytes =~ s/^(.{32})//s) {
            my $hn = $1;
            push(@@seeds, bytesToHex($hn));
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

@d Begin command repeat
@{
    for (my $rpt = 0; $rpt < $repeat; $rpt++) {
@}

@d End command repeat
@{
    }
@}

\subsection{{\tt genFromFile} --- Generate keys from seeds specified in a Hexfile}

Generate one or multiple key/address pairs from seeds specified in
a Hexfile.  For every 64 hexadecimal digits, a pair is generated
with the specified \verb+$mode+.

@d genFromFile: Generate keys from seeds specified in a Hexfile
@{
    sub genFromFile {
        my ($hf, $mode) = @@_;

        my $out = "";
        my $n = 0;
        while ($hf =~ s/^(\w{64})//) {
            my $seed = $1;
            $n++;
            my ($priv, $pub) = genAddress($seed, $mode, $n);
            $out .= editAddress($priv, $pub, $mode, 1);
        }

        return $out;
    }
@| genFromFile @}

\subsection{{\tt genAddress} --- Generate address from one hexadecimal seed}

A bitcoin address and private key pair are generated from the
argument, which specifies the 256 bit random seed as 64 hexadecimal
digits.  The private key and public address objects are returned
in a list.

@d genAddress: Generate address from one hexadecimal seed
@{
    sub genAddress {
        my ($seed, $mode, $n) = @@_;

        if ($seed !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
@| genAddress @}

Generate the private key from the hexadecimal seed.

@d genAddress: Generate address from one hexadecimal seed
@{
        my $priv = Bitcoin::Crypto::Key::Private->from_hex($seed);
@}

Verify that we can decode the seed from the private key.

@d genAddress: Generate address from one hexadecimal seed
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

@d genAddress: Generate address from one hexadecimal seed
@{
        my $pub = $priv->get_public_key();

        return ($priv, $pub);
    }
@}

\subsection{{\tt editAddress} --- Edit private key and public address}

@d editAddress: Edit private key and public address
@{
    sub editAddress {
        my ($priv, $pub, $mode, $n) = @@_;
@| editAddress @}

Extract the seed from the private key in hexadecimal and encode it
in base64.

@d editAddress: Edit private key and public address
@{
        my $phex = uc($priv->to_hex());
        my $pb64 = encode_base64($priv->to_bytes());
        chomp($pb64);
@}

Generate compressed and uncompressed private keys, both encoded
in WIF (Wallet Import Format).  This is how private keys are usually
stored in an off-line or paper wallet.

@d editAddress: Edit private key and public address
@{
        $priv->set_compressed(TRUE);
        my $WIFc = $priv->to_wif();

        $priv->set_compressed(FALSE);
        my $WIFu = $priv->to_wif();
@}

Generate the public Bitcoin address from the private key.  Note that
if you're storing the private key, you needn't store the public
address with it, since you can always re-generate it in any form
you wish from the private key.  We generate all of the forms of
public addresses, compressed and uncompressed.

@d editAddress: Edit private key and public address
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
be ``{\tt CSV}{em t}'', where ``{\tt t}'' is one of:

\begin{quote}
\begin{description}
\dense
    \item[{\tt q}]  Use uncompressed private key
    \item[{\tt u}]  Use uncompressed public address
    \item[{\tt l}]  Public (``{\tt 1}'') public address
    \item[{\tt c}]  Compatible (``{\tt 3}'') public address
    \item[{\tt s}]  Segwit ``{\tt bc1}'' public address

\end{description}
\end{quote}

@d editAddress: Edit private key and public address
@{
        my $r = "";

        if ($mode =~ m/^CSV(\w*)$/) {
            my $CSVmodes = $1;

            #   Comma-separated value file

            my $privK = $WIFc;
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
which the user may choose whatever they prefer.

@d editAddress: Edit private key and public address
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

\subsection{{\tt BIP39encode} --- Encode seed as BIP39 mnemonic phrase}

The function encodes a 256 bit seed as a sequence of words according
to \href{https://en.bitcoin.it/wiki/BIP_0039}{Bitcoin Improvement
Proposal 39} (BIP39), using the
\href{https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt}{English word list}
from the \href{https://github.com/trezor/python-mnemonic}{reference implementation}.
The words are arranged in multiple lines of maximum length
{\tt \$maxlen} using the specified {\tt \$prefix} on the first line.
The Perl {\tt
\href{https://metacpan.org/pod/Bitcoin::BIP39}{Bitcoin::BIP39}}
package we use supports word lists for serveral other languages, but
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
            exit(1);
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
perl bitcoin_address.pl [ command... ]
  Commands and arguments:
    -aes                Encrypt second item on stack with top of stack key
    -binfile filename   Load seed(s) from binary file
    -drop               Drop top item on stack
    -dup                Duplicate top item on stack
    -format f           Select CSV key output mode: CSVx, where x is
                            l   Legacy public address ("1...")
                            c   Compatible public address ("3...")
                            s   Segwit public address ("bc1...")
                            u   Uncompressed public address
                            q   Uncompressed private key
    -hbapik hbapikey    Specify HotBits API key
    -help               Print this message
    -hexfile filename   Load hexadecimal seed(s) from filename
    -hotbits            Get seed(s) from HotBits, place on stack
    -inter              Process interactive commands
    -key                Generate public address/private key from stack seed
    -not                Invert stack top
    -over               Duplicate second item on stack to top
    -phrase "words..."  Specify seed as BIP36 menemonic phrase
    -pick n             Duplicate the nth item on the stack to top
    -pseudo             Generate pseudorandom seed and push on stack
    -random             Obtain a seed from /dev/random, push on stack
    -repeat n           Repeat following commands n times
    -roll n             Rotate item n to top of stack
    -rot                Rotate the top three stack items
    -rrot               Reverse rotate top three stack items
    -seed hex           Push the hexadecimal seed on top of stack
    -sha256             Replace top of stack with its SHA256 digest
    -shuffle            Shuffle all bytes on stack
    -swap               Swap the two top items on the stack
    -test               Test randomness of top of stack
    -type Any text      Display text argument on standard output
    -urandom            Obtain a seed from /dev/urandom, push on stack
    -wif                Push seed extracted from Wallet Input Format private key
    -xor                Bitwise exclusive-or top two stack items
    -zero               Push zeroes on stack
EOD
        $help =~ s/^    //gm;
        print($help);
        exit(0);
    }
@}

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

We start with the usual start of program definition and defining and
processing the command-line options.

@o address_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
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
    my $stats = FALSE;                              # Show statistics of blocks ?
    my $statlog = "";                               # Block statistics log file
    my $wallet = @<AW monitor wallet@>;             # Monitor unspent funds in wallet ?
    my $wallet_pass = @<AW wallet password@>;       # Wallet password
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
        "wpass=s"       => \$wallet_pass,
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

@o address_watch.pl
@{
    my %adrh;

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

    if ($watch_file ne "") {
        my $adrs = csv(in => $watch_file) || die(Text::CSV->error_diag);

        #   Convert watch list to a hash addressed by Bitcoin address
        for (my $i = 0; $i < scalar(@@$adrs); $i++) {
            $adrh{$adrs->[$i][1]} = [ $adrs->[$i][0], $adrs->[$i][2] ];
        }
        undef(@@$adrs);
    }

    if (scalar(keys(%adrh)) == 0) {
        print(STDERR "No watch addresses specified.\n");
        exit(2);
    }
@}

\subsection{Prompt for RPC password}

If the ``{\tt rpc}'' query method was selected and no password was
specified, ask the user for it from standard input.

@o address_watch.pl
@{
    if (($RPCmethod eq "rpc") && (!defined($RPCpass))) {
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

@o address_watch.pl
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

@o address_watch.pl
@{
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

@o address_watch.pl
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
                    print(LF $logItem);
                    close(LF);
                }
           }
        }
@}

\subsection{Save last block scanned for next run}

If a block file is specified, save last block scanned so we can resume
with the next block on a subsequent run.

@o address_watch.pl
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

@o address_watch.pl
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

@o address_watch.pl
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

\subsection{{\tt scanBlock} --  Scan a block by index on the blockchain}

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

Scan the block for reference to addresses we're watching.  We start
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
with ``{\tt txindex=1}'', which causes it to build and maintain a
transaction index.  If this index is absent, we cannot monitor input
addresses.

Because looking up transactions and decoding them from JSON is costly,
we cache transactions we query in \verb+%vincache+ and serve the
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
#else { print("Served $vintx from cache\n"); }
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
straightforward to process than ``{\tt vin}'' items, as the contain the
actual address and do not require us to look up a transaction to find
it.

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

We start by removing any previously-added wallet addresses from the
watch list.

@d updateWalletAddresses: Watch unspent wallet addresses
@{
    sub updateWalletAddresses {
        foreach my $adr (keys(%adrh)) {
            if ($adrh{$adr}->[1] =~ m/^W/) {
                delete($adrh{$adr});
                print("Purged wallet address $adr\n") if ($verbose >= 2);
            }
        }
@| updateWalletAddresses @}

If the user has password-protected the wallet, attempt to unlock it.
If the password has not been previously specified, prompt the user
for it.

@d updateWalletAddresses: Watch unspent wallet addresses
@{
        #   Check wallet status and unlock if necessary
        my ($wLocked, $wUnlocked) = (FALSE, FALSE);
        my $wi = sendRPCcommand([ "getwalletinfo" ]);
        if (defined($wi)) {
            my $ws = decode_json($wi);
            #   If "unlocked_until" not present, wallet locking not used
            if (defined($ws->{unlocked_until})) {
                $wLocked = ($ws->{unlocked_until} - time()) > 1;
            }
        }

        #   If the wallet is locked, attempt to unlock it
        if ($wLocked) {
            #   If the wallet is locked and we have not yet obtained the
            #   password (either from the command line or previously from
            #   the user), prompt the user to enter it.
            if (!defined($wallet_pass)) {
                $wallet_pass = getPassword("Bitcoin wallet password: ");
            }

            #   Unlock the wallet for two seconds (should be more than enough)
            sendRPCcommand([ "walletpassphrase",  "\"$wallet_pass\"", "2" ]);
            $wUnlocked = TRUE;
        }
@}

Retrieve addresses with an unspent balance from the wallet and add them
to the watch list.

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
                print("Watching wallet $label,$addr,W$balance\n") if ($verbose >= 2);
                $adrh{$addr} = [ $label, "W$balance" ];
            }
        }

@}

If we unlocked the wallet, lock it again.

@d updateWalletAddresses: Watch unspent wallet addresses
@{
        if ($wUnlocked) {
            sendRPCcommand([ "walletlock" ]);
        }
    }
@}

\subsection{{\tt showHelp} --- Show help information}

@d showHelp: Show address watch help information
@{
    sub showHelp {
        my $help = <<"    EOD";
perl address_watch.pl [ command... ]
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
    -wpass "pass"       Password to unlock encrypted wallet
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

@o confirmation_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    @<RPC configuration variables@>

#$RPCmethod = "local";
$RPCmethod = "rpc";
$RPChost = "localhost";

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
    use Term::ReadKey;

    use Data::Dumper;
@}

\subsection{Command line option processing}

@o confirmation_watch.pl
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

@o confirmation_watch.pl
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
                while (my $l = <LI>) {
                    if (($l =~ m/^(?:\w+)?\s+$addr\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)/) ||
                        ($l =~ m/^$addr\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)/)
                       ) {
                        my ($txid, $blockhash) = ($1, $2);
                        @@ARGV = ( $txid, $blockhash );
                        $found = TRUE;
                        last;
                    }
                }
                close(LI);
                if ($watch && (!$found)) {
                    print("No transaction for this address found in address_watch log.\n" .
                          "Waiting $poll_time seconds before next check.\n") if $verbose;
                    sleep($poll_time);
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

@o confirmation_watch.pl
@{
    if (($RPCmethod eq "rpc") && ($RPCpass eq "")) {
        $RPCpass = getPassword("Bitcoin RPC password: ");
    }
@}

\subsection{Retrieve confirmations for transaction}

Now retrieve the confirmations for the transaction. If {\tt -watch} is
specified, continue to watch until we've received the {\tt -confirm}
number of confirmations, at which point we exit.

@o confirmation_watch.pl
@{
    my $l_confirmations = -1;

    do {
        my $query = [ "getrawtransaction", $txID, "true" ];
        if ($blockHash ne "") {
            push(@@$query, $blockHash);
        }
#print(Dumper(\$query));
        my $txj = sendRPCcommand($query);
#print("TXJ $txj\n");
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

@o confirmation_watch.pl
@{
         if ($watch && ($l_confirmations < $confirmed)) {
            sleep($poll_time);
        }
   } while ($watch && ($l_confirmations < $confirmed));
@}

\subsection{Utility functions}

Define our local functions.

@o confirmation_watch.pl
@{
    @<showHelp: Show confirmation watch help information@>
@}

Import utility functions we share with other programs.

@o confirmation_watch.pl
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
perl address_watch.pl [ command... ]
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

@o fee_watch.pl
@{@<Explanatory header for Perl files@>

    @<Perl language modes@>

    @<RPC configuration variables@>

#$RPCmethod = "local";
#$RPCmethod = "rpc";
#$RPChost = "localhost";

    use LWP;
    use JSON;
    use Text::CSV qw(csv);
    use Getopt::Long qw(GetOptionsFromArray);
    use POSIX qw(strftime);
    use Term::ReadKey;

    use Data::Dumper;
@}

\subsection{Command line option processing}

@o fee_watch.pl
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

@o fee_watch.pl
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

@o fee_watch.pl
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

@o fee_watch.pl
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
            my ($feerate_min, $feerate_mean, $feerate_median,
                $feerate_max) = ($bs->{minfeerate}, $bs->{avgfeerate},
                    $bs->{medianfee}, $bs->{maxfeerate});
            my @@feerate_percentiles = @@{$bs->{feerate_percentiles}};

            if (!$quiet) {
                printf("  Block %d  %s\n    Fee rate min %d, mean %d, median %d, max %d\n",
                    $j, etime($btime),
                    $feerate_min, $feerate_mean, $feerate_median, $feerate_max);
                printf("    Fee percentiles: " .
                    "10%% $feerate_percentiles[0]  25%% $feerate_percentiles[1]  " .
                    "50%% $feerate_percentiles[2]  75%% $feerate_percentiles[3]  " .
                    "90%% $feerate_percentiles[4]\n");
            }
            if ($fee_file ne "") {
                print(FO "2,$btime," . etime($btime) . ",$j," .
                    "$feerate_min,$feerate_mean,$feerate_median,$feerate_max," .
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

@o fee_watch.pl
@{
    @<showHelp: Show fee watch help information@>
@}

\subsection{Utility functions}

Import utility functions we share with other programs.

@o fee_watch.pl
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
perl address_watch.pl [ command... ]
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
specification and command whether provided as command-line
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

\subsection{{\tt arg\_inter} -- Process interactive commands}

A utility may process interactive commands from the user by processing
the @{-inter@} option and calling this handler.  It prompts the user
for commands and arguments and executes them interactively.
Interactive mode is exited by any of the commands ``@{end@}'',
``@{exit@}'', or ``@{quit@}'', all of which may be abbreviated to
two characters.

@d Command and option processing
@{
    sub arg_inter {
        while (TRUE) {
            print("> ");
            my $l = <> || last;
            chomp($l);
            my ($v, $n) = processCommand($l, TRUE);
            last if ($v eq "");
        }
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
        $progName =~ s/\.\w+$//;
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
    "password=s"    => \$RPCpass,
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
  -password "text"    Bitcoin RPC API password
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
initialised, a 2496 byte random seed is obtained from {\tt
/dev/urandom} and used to initialise a new generator.  If the generator
has been previously initialised, the call is ignored, so there's no
need for application code to check whether a call to {\tt randInit()}
is needed.

@d Pseudorandom number generator
@{
    use Math::Random::MT;

    my $randGen;                    # Pseudorandom number generator

    sub randInit {
        if (!defined($randGen)) {
            my (@@seed, $rbuf);

            open(RI, "</dev/urandom") || die("Cannot open /dev/urandom");
            read(RI, $rbuf, 624 * 4) == (624 * 4) ||
                die("Cannot read data from /dev/urandom");
            @@seed = unpack("L4", $rbuf);
            $randGen = Math::Random::MT->new(@@seed);
            close(RI);
        }
    }
@| randInit @}

\section{{\tt randNext} --- Get next value from pseudorandom generator}

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
        chmod 755 *.pl
        @@if [ \( ! -f Makefile \) -o \( Makefile.mkf -nt Makefile \) ] ; then \
                echo Makefile.mkf is newer than Makefile ; \
                sed "s/ \*$$//" Makefile.mkf | unexpand >Makefile ; \
        fi
@}

\subsection{Generate and view PDF document}

The {\tt view} target re-generates the master document containing
all documentation and code, while {\tt peek} simply view the
most-recently-generated document (without check if it is current).
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

\subsection{Syntax check all Perl programs}

All Perl programs in the directory tree are checked with {\tt perl -c}.
This requires the GNU {\tt find} utility, which supports the ``{\tt
-quit}'' action that allows us to stop after the first error it
detects.

@o Makefile.mkf
@{
lint:
        @@# Uses GNU find extension to quit on first error
        $(GNUFIND) . -type f -name \*.pl -print \
                \( -exec perl -c {} \; -o -quit \)
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
        @@echo Lines: `find . -type f -name \*.pl -exec cat {} \; | wc -l`
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
        rm -f nw[0-9]*[0-9] rm *.aux *.log *.out *.pdf *.tex *.toc *.pl

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
tools
*.pl
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

\chapter{Development Log} \label{log}

@i log.w
\end{appendices}

\end{document}
