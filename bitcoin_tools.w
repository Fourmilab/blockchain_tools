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
Fourmilab's HotBits radioactive random number generator.

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
#       "<pre>\n4F010C07C1C06F90929CECB53A8377D98F8406CB8ECEFFE16378A14BBE492972\n</pre>\n";
#    ;

    use Bitcoin::Crypto::Key::Private;
    use Bitcoin::Crypto::Key::Public;
    use Bitcoin::BIP39 qw(entropy_to_bip39_mnemonic bip39_mnemonic_to_entropy);
    use MIME::Base64;
    use LWP::Simple;
    use Getopt::Long;
@}

\subsection{Process command line options}

@o bitcoin_address.pl
@{
    my $opt_Format = "";

    my $repeat = 1;             # Repeat command this number of times
    my @@seeds;                 # Stack of seeds

    GetOptions(
               "api=s"      =>  \$HotBits_API_key,
               "dump"       =>  \&arg_dump,
               "format=s"   =>  \$opt_Format,
               "hexfile=s"  =>  \&arg_hexfile,
               "hotbits"    =>  \&arg_hotbits,
               "key"        =>  \&arg_key,
               "phrase=s"   =>  \&arg_phrase,
               "random"     =>  \&arg_random,
               "repeat=i"   =>  \$repeat,
               "seed=s"     =>  \&arg_seed,
               "urandom"    =>  \&arg_urandom
              ) ||
        die("Invalid command line option");

exit(0);

    #   Get hexadecimal seed from the command line or HotBits

    my $HotBits;
    if (scalar(@@ARGV) == 0) {
        my $hbr;
        if ($HotBits_Query =~ m|^https?://|) {
            $hbr = get($HotBits_Query);
        } else {
            $hbr = $HotBits_Query;
        }
        $hbr =~ m:<pre>.*?(\w+).*?</pre>:s || die("Cannot parse HotBits reply: $hbr");
        $HotBits = $1;
    } else {
        $HotBits = uc($ARGV[0]);
    }

    my ($priv, $pub) = genAddress($HotBits, $opt_Format, 1);
    print(editAddress($priv, $pub, $opt_Format, 1));

#my $hf = readHexfile("hotbits.html");
#print("Read " . (length($hf) / 2) . " bytes.\n");
#print(genFromFile($hf, $opt_Format));

    #   Local functions

    @<Command line argument handlers@>
    @<genFromFile: Generate keys from seeds specified in a Hexfile@>
    @<genAddress: Generate address from one hexadecimal seed@>
    @<editAddress: Edit private key and public address@>
    @<BIP39encode: Encode seed as BIP39 mnemonic phrase@>
@}

Include utility functions we employ.

@o bitcoin_address.pl
@{
    @<readHexfile: Read hexadecimal data from a file@>
@}

\section{Local functions}

\subsection{Command line argument handlers}

@d Command line argument handlers
@{
    @<arg\_dump: Dump the stack@>
    @<arg\_hexfile: Push seeds from hexfile on stack@>
    @<arg\_hotbits: Request seed(s) from HotBits@>
    @<arg\_key: Generate key/address from top of stack@>
    @<arg\_phrase: Specify seed as BIP39 phrase@>
    @<arg\_random: Request seed(s) from /dev/random@>
    @<arg\_seed: Push seed on stack@>
    @<arg\_urandom: Request seed(s) from /dev/urandom@>
@}

\subsubsection{{\tt arg\_dump} --- {\tt -dump}: Dump the stack}

@d arg\_dump: Dump the stack
@{
    sub arg_dump {
        print("  ", join("\n  ", reverse(@@seeds)), "\n");
    }
@}

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
@}

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
@}

\subsubsection{{\tt arg\_key} --- {\tt -key}: Generate key/address from top of stack}

@d arg\_key: Generate key/address from top of stack
@{
    sub arg_key {
        @<Begin command repeat@>
        my $seed = pop(@@seeds);
        my ($priv, $pub) = genAddress($seed, $opt_Format, 1);
        print(editAddress($priv, $pub, $opt_Format, 1));
        @<End command repeat@>
    }
@}

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
@}

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
print("Requested " . ($n - $l) . " bytes, read $r\n");
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
            my $xv;
            while ($hn =~ s/^(.)//s) {
                $xv .= sprintf("%02X", ord($1));
            }
            push(@@seeds, $xv);
        }
    }
@}

\subsubsection{{\tt arg\_seed} --- {\tt -seed}: Push seed on stack}

@d arg\_seed: Push seed on stack
@{
    sub arg_seed {
        my ($name, $value) = @@_;

        if ($value !~ m/^[\dA-F]{64}/i) {
            die("Invalid seed.  Must be 64 hexadecimal digits");
        }
        push(@@seeds, $value);
    }
@}

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
print("Requested " . ($n - $l) . " bytes, read $r\n");
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
            my $xv;
            while ($hn =~ s/^(.)//s) {
                $xv .= sprintf("%02X", ord($1));
            }
            push(@@seeds, $xv);
        }
    }
@}

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
@}

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
@}

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
@}

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
@}

Take the decoded hex seed and feed it to {\tt ent} to perform an
analysis of its randomness.  Note that when interpreting these results,
the brevity of the seed (just 256 bits) will cause it to appear less
than random compared to a larger sample.  We perform the randomness
tests on a bit-level basis, as byte-level tests are useless on such a
small sample.

@d editAddress: Edit private key and public address
@{
            $r .= "\nRandomness analysis:\n";
            my $ent_analysis = `echo $phex | xxd -r -p - | ent -b`;
            $ent_analysis =~ s/\n\n/\n/gs;
            $ent_analysis =~ s/^/    /mg;
            $ent_analysis =~ s/(of this|would exceed)/  $1/gs;
            $r .= $ent_analysis;
       }
        return $r;
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
@}

\chapter{Bitcoin Address Watcher}

This program monitors the blockchain and, whenever new blocks are
added, scans them for transactions involving a watch list, which may
be specified on the command line or in a file.  For every transaction
inolving that address, output and an optional permanent log entry
is generated showing:

\begin{quote}
\begin{enumerate}
\dense
    \item   Label (if any) from the watch list file
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
    use Getopt::Long;
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

    GetOptions(
        @<RPC command line options@>
        "bfile=s"       => \$block_file,
        "end=i"         => \$block_end,
        "lfile=s"       => \$log_file,
        "poll=i"        => \$poll_time,
        "sfile=s"       => \$statlog,
        "start=i"       => \$block_start,
        "stats"         => \$stats,
        "verbose+"      => \$verbose,
        "wallet"        => \$wallet,
        "watch=s"       => \@@watch_addrs,
        "wpass=s"       => \$wallet_pass,
        "wfile=s"       => \$watch_file
    ) || die("Command line option error");

    my $statc = $stats || ($statlog ne "");
@}

\subsection{Build list of watched addresses}

Now, we build the list of Bitcoin addresses we'll be watching.  These
may be specified on the command line with the {\tt -watch} option, or
read from a (single) file specified by the {\tt -wfile} option.  In
addition, addresses in the user's wallet with an unspent balance can
be automatically monitored by specifying the {\tt -wallet} option.

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

    #   Utility functions
    @<etime: Edit time to ISO 8601@>
    @<sendRPCcommand: Send a Bitcoin RPC/JSON command@>
    @<getPassword: Prompt user to enter password@>
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
        for (my $t = 0; $t < $b_nTx; $t++) {
            #   Transaction ID
            my $t_txid = $r->{tx}->[$t]->{txid};
            if ($statc) {
                $stat_size->add_data($r->{tx}->[$t]->{vsize});
            }
            #   Number of "vout" items in transaction
            my $t_nvout = scalar(@@{$r->{tx}->[$t]->{vout}});

            print("  $t.  $t_txid  $t_nvout\n") if $verbose >= 2;

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
                        my $flag = $adrh{$a_addr};
                        if ($verbose >= 3) {
                            my $pflag = $flag ? " *****" : "";
                            print("      $v.$a.  $a_addr$pflag\n");
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
        printf("    Size: min %d  max %d  mean %.2f  SD %.2f  Total %d\n",
            $stat_size->min(), $stat_size->max(), $stat_size->mean(),
            $stat_size->standard_deviation(), $stat_size->sum());
        printf("    Value: min %.8f  max %.8g  mean %.8g  SD %.8g  Total %.8g\n",
            $stat_value->min(), $stat_value->max(), $stat_value->mean(),
            $stat_value->standard_deviation(), $stat_value->sum());
    }
    if ($statlog) {
        open(SL, ">>$statlog");
            printf(SL "%12d %d %d %d %d %.2f %.2f %d %.8f %.8g %.8g %.8g %.8g\n",
                $b_height, $b_time, $b_nTx,
                $stat_size->min(), $stat_size->max(), $stat_size->mean(),
                $stat_size->standard_deviation(), $stat_size->sum(),
                $stat_value->min(), $stat_value->max(), $stat_value->mean(),
                $stat_value->standard_deviation(), $stat_value->sum());
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

\chapter{Bitcoin Confirmation Watcher}

This utility queries the status of a transaction and reports changes
in the number of confirmations it has received.  It can monitor a
recent transaction and report new confirmations as they arrive,
exiting when a specified number of confirmations (default 6) have
been received.  The transaction can be specified by its transaction
ID and the hash of the block containing it.

\begin{quote}
    {\tt confirmation\_watch} {\em transaction\_id} {\em block\_hash}
\end{quote}

If you are running {\tt address\_watch} on the same machine and have
configured it to write a log file, you can specify either the Bitcoin
address or the label you've assigned to it, with the transaction ID and
block hash retrieved from the log.

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
    use Getopt::Long;
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

    GetOptions(
        @<RPC command line options@>
        "watch"         => \$watch,
        "verbose+"      => \$verbose,
        "lfile=s"       => \$log_file,
        "poll=i"        => \$poll_time,
        "confirmed=i"   => \$confirmed
    ) || die("Command line option error");
@}

\subsection{Look up address or label in {address\_watch} log}

If an address is specified, try looking up in the Bitwatch log to find
the transaction ID and block hash.  We accept either the Bitcoin
address or the label the user assigned to it.

@o confirmation_watch.pl
@{
    if (scalar(@@ARGV) == 1) {
        if ($log_file eq "") {
            print("Cannot look up address or label unless log file (-lfile) specified.\n");
            exit(2);
        }
        my $addr = $ARGV[0];
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
                print("No transaction for this address found in Bitwatch log.\n" .
                      "Waiting $poll_time seconds before next check.\n") if $verbose;
                sleep($poll_time);
            }
        } while ($watch && (!$found));
        if (!$found) {
            print("Bitcoin address not found in Bitwatch log file.\n");
            exit(1);
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
        my $txj = sendRPCcommand([ "getrawtransaction", $txID, "true", $blockHash ]);
        my $tx = decode_json($txj);

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

Import utility functions we share with other programs.

@o confirmation_watch.pl
@{
    @<etime: Edit time to ISO 8601@>
    @<sendRPCcommand: Send a Bitcoin RPC/JSON command@>
    @<getPassword: Prompt user to enter password@>
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
        @@if [ \( ! -f Makefile \) -o \( Makefile.mkf -nt Makefile \) ] ; then \
                echo Makefile.mkf is newer than Makefile ; \
                sed "s/ \*$$//" Makefile.mkf | unexpand >Makefile ; \
        fi
@}

\subsection{Generate and view PDF document}

The {\tt view} target re-generates the master document containing
all documentation and code, while {\tt peek} simply view the
most-recently-generated document (without check if it is current).

@o Makefile.mkf
@{
view:
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

All Perl programs in the directory tree are
checked with {\tt perl -c}.  This requires the GNU
{\tt find} utility, which supports the ``{\tt -quit}''
action that allows us to stop after the first error it detects.

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
