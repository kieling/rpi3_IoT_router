# setup nordic router and forwardings, connect to ipv6 modules
sudo sh start_nordic.sh
sleep 2s
# start status service to monitor ipv6 modules
sudo bash ipv6_status_service.bash &
sleep 2s
# start BTLE Gateway and NaviBLE front end 
sudo sh start_gateway.sh & 
