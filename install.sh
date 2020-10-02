
#!/bin/bash

echo "127.0.0.1 $HOSTNAME" >> /etc/hosts;

while getopts :n:i:m:j: OPTION; do
	case $OPTION in
 		n)
       			SERVERNAME1=$OPTARG
		;;
	
		i)
			SERVERIP1=$OPTARG
		;;
	
		m)
			SERVERNAME2=$OPTARG
		;;
	
		j)
			SERVERIP2=$OPTARG
		;;
	
		*)
			echo "error: unknown option $FLAG"
                	exit 1
		;;

	esac
done

sudo add-apt-repository ppa:vbernat/haproxy-1.7
sudo apt update
sudo apt install -y haproxy



echo "

frontend http_front
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   server <server1 name> <private IP 1>:80 check
   server <server2 name> <private IP 2>:80 check

"  | sudo tee -a /etc/haproxy/haproxy.cfg


sudo sed -i "s/<server1 name>/$SERVERNAME1/g" /etc/haproxy/haproxy.cfg

sudo sed -i "s/<private IP 1>/$SERVERIP1/g" /etc/haproxy/haproxy.cfg

sudo sed -i "s/<server2 name>/$SERVERNAME2/g" /etc/haproxy/haproxy.cfg

sudo sed -i "s/<private IP 2>/$SERVERIP2/g" /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy

