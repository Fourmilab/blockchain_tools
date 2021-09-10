#! /bin/bash

#   Regression test for stand-alone Fourmilab Blockchain utilities

MYDIR="`dirname \"$0\"`"
PATH=$MYDIR/../bin:$PATH
TESTOUT=$MYDIR/test_output

rm -rf $TESTOUT
mkdir $TESTOUT

O=$TESTOUT/test_log.txt

#   Generate test addresses.  Note that we must make them deterministic
#   in order to compare with reference output.

echo -e         \\nGenerate Bitcoin and Ethereum address/key pairs\\n >$O

blockchain_address.pl \
    -seed 0x1b34f57bcdc7bd5368136ebe1e019bc7013884d0f7d8754d5b0ff6fb5f923f9a \
    -dup        \
    -pseudoseed \
    -dup        \
    -sha2       \
    -swap       \
    -sha3       \
    -over       \
    -over       \
    -swap       \
    -xor        \
    -not        \
    -rot        \
    -rrot       \
    -dup        \
    -shuffle    \
    -test       \
    -wif L1eqjiRSttGmZFiWqmzF43PJHNt64NgyvGFKUeqQj4G3LXw2hLaU \
    -wif 5JpYS5rVXLKXV9mkTunbT4iJWYEqizvvDyUG4YgWqx7acLEbecW  \
    -pick 2     \
    -zero       \
    -xor        \
    -dump       \
    -clear      \
    -repeat 3   \
    -pseudo     \
    -format k   \
    -btc        \
    -eth        \
    -format CSVk    \
    -btc        \
    -eth        \
    -format CSVbk   \
    -btc        \
    -eth        \
    -format CSVk    \
    -outfile $TESTOUT/btc.csv \
    -btc        \
    -outfile $TESTOUT/eth.csv \
    -eth        \
        >>$O

echo -e         \\nValidate generated addresses\\n >>$O

validate_wallet.py $TESTOUT/btc.csv >>$O
validate_wallet.py $TESTOUT/eth.csv >>$O

echo -e         \\nGenerate paper wallet HTML from the addresses\\n >>$O

paper_wallet.pl -date Today $TESTOUT/btc.csv >$TESTOUT/btc.html
paper_wallet.pl -date Today $TESTOUT/eth.csv >$TESTOUT/eth.html
sha256sum $TESTOUT/btc.html $TESTOUT/eth.html >>$O

echo -e         \\nValidate the HTML paper wallets\\n >>$O

validate_wallet.py $TESTOUT/btc.html >>$O
validate_wallet.py $TESTOUT/eth.html >>$O

echo -e         \\nSplit the generated addresses into parts, different for BTC and ETH\\n >>$O

multi_key.pl -parts 5 -needed 3 $TESTOUT/btc.csv
sha256sum $TESTOUT/btc-*.csv >>$O
multi_key.pl -parts 11 -needed 7 $TESTOUT/eth.csv
sha256sum $TESTOUT/eth-*.csv >>$O

echo -e         \\nJoin the parts of the generated address into reconstituted address/key files\\n >>$O

multi_key.pl -join $TESTOUT/btc-5.csv $TESTOUT/btc-3.csv $TESTOUT/btc-1.csv
multi_key.pl -join $TESTOUT/eth-10.csv $TESTOUT/eth-06.csv $TESTOUT/eth-09.csv \
    $TESTOUT/eth-02.csv $TESTOUT/eth-01.csv $TESTOUT/eth-08.csv $TESTOUT/eth-04.csv

echo -e         \\nCompare the re-constructed keys with the originals. >>$O
echo -e         They should differ only in the comment specifying the parts used.\\n >>$O

diff $TESTOUT/btc.csv $TESTOUT/btc-merged.csv >>$O
diff $TESTOUT/eth.csv $TESTOUT/eth-merged.csv >>$O

echo -e         \\nValidate keys re-constructed from parts\\n >>$O

validate_wallet.py $TESTOUT/btc-merged.csv >>$O
validate_wallet.py $TESTOUT/eth-merged.csv >>$O

echo -e         \\nRun Cold Comfort on some large Bitcoin and Ethereum addresses\\n >>$O

cold_comfort.pl -verbose -waitconst 5 -waitrand 0 -zero \
    $MYDIR/watch_addrs.csv >>$O

#   Compare the test report with the reference results and set status

diff $MYDIR/test_log_expected.txt $O
if [ $? -ne 0 ]
then
    echo "Discrepancies found in test results."
    exit 1
fi
exit 0