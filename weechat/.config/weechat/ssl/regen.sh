openssl req -newkey rsa:2048 -nodes -days 1337 -x509 -keyout irc-5225225.key -out irc-5225225.cert
cat irc-5225225.cert irc-5225225.key > irc-5225225.pem
openssl x509 -sha1 -noout -fingerprint -in irc-5225225.pem | sed -e 's/^.*=//;s/://g;y/ABCDEF/abcdef/'
rm irc-5225225.cert irc-5225225.key
