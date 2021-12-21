url=localhost
requests=20
users=250

siege -v -r $requests -c $users http://$url/load/5
#siege -p -r $requests -c $users http://$url/load/3
