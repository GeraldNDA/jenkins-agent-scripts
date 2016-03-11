#! /bin/sh

export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

slavename=`/bin/hostname`

cd /jenkins/jenkins-slave-scripts || exit 1

if [ -f slave.secret ]; then
	secret=`cat slave.secret`
else
	echo "no slave secret found" >&2
	exit 1
fi

while [ ! -f slave.dontstart ]
do
	/bin/date
	# mirror mode, update it if there's a timestamp change on the master
	/usr/bin/fetch -m -o slave.jar http://jenkins-master.freebsd.org/jnlpJars/slave.jar
	/usr/local/bin/java -Djava.net.preferIPv6Addresses=true \
		-jar slave.jar \
		-jnlpUrl http://jenkins-master.freebsd.org/computer/${slavename}/slave-agent.jnlp \
		-secret ${secret}
	/bin/sleep 30
done
