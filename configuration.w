
Default level of verbosity.

@d Verbosity level @{0@}

Interval to poll the blockchain in seconds.

@d Blockchain poll interval @{300@}

The following definitions configure the defaults for RPC access
to a host running {\tt bitcoind}.  All of these may be overridden
by command line options.

@d RPC query method @{ssh@}
@d RPC host @{localhost@}
@d RPC port @{8332@}
@d Bitcoin CLI path @{bitcoin-cli@}
@d RPC user @{myuser@}
@d RPC password @{@}

These definitions specify defaults for {\tt address\_watch}.

@d AW block start @{-1@}
@d AW block end @{-1@}
@d AW block file @{@}
@d AW watch file @{@}
@d AW log file @{@}
@d AW monitor wallet @{FALSE@}
@d AW wallet purge interval @{3600@}

Defaults for {\tt confirmation\_watch}.

@d CW watch confirmations @{FALSE@}
@d CW deem confirmed @{6@}

If you want the {\tt bitcoin\_address} generator to be able to
query the HotBits radioactive random number generator, enter
your API key and the query URL below.

@d HotBits query URL @{https://www.fourmilab.ch/cgi-bin/Hotbits.api?nbytes=[NBYTES]&fmt=hex&apikey=[APIKEY]@}
@d HotBits API key @{Pseudorandom@}

