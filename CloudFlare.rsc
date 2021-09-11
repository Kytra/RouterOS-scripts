:local pppoe ""

:local CFdomain ""
:local CFtoken ""
:local CFzoneID ""
:local CFdnsID ""

:local CFapi "https://api.cloudflare.com/client/v4/zones/$CFzoneID/dns_records/$CFdnsID"

:local resolvedIP [:resolve $CFdomain]
:local ipaddr [/ip address get [/ip address find interface=$pppoe] address]
:set ipaddr [:pick $ipaddr 0 ([len $ipaddr] -3)]

:log info ("Local address:".$ipaddr)
:log info ("Resolved address:".$resolvedIP)

:if ($ipaddr!=$resolvedIP) do={
    /tool fetch http-method=put mode=https url="$CFapi" http-header-field="Authorization:Bearer $CFtoken,content-type:application/json" as-value output=user http-data="{\"type\":\"A\",\"name\":\"$CFdomain\",\"content\":\"$ipaddr\",\"ttl\":1,\"proxied\":false}"
    :log info ("New address updated.")
} else={
    :log info ("Same address,no need to update.")
}