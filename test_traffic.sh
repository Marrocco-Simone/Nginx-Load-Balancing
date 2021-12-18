url=localhost
requests=4
users=7

siege -v -r $requests -c $users http://$url/load/3
#siege -p -r $requests -c $users http://$url/load/3
