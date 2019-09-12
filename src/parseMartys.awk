BEGIN{
  dhcp = 0
  print "Cache-control: private, max-age=0, no-cache"
  print "Access-Control-Allow-Origin: *"
  print "Content-Type: application/json\n"
  print "{\"martys\": ["
}
{  
  # we're going to be piped two files with "DHCP LEASES" between them, so set a flag to flip when we see that
  # first file is the output from iwinfo, and the second is the dhcp leases                                  
  if ($0 == "DHCP LEASES"){ dhcp = 1}                                      
  # first file, iwinfo               
  if (dhcp == 0){                                                                                
    # look for MAC addresses
    if (match($1, "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")){
      # the interesting bits are the MAC, SNR, and last seen time 
      # the SNR has a ) on the end of it, so let's get rid of that
      snr = int(substr($8,1,length($8)-1))                        
      #printf "%6d %s %6d %s\n", FNR, $1, snr, $9                                            
      # the toupper is important as the iwinfo tends to use caps, and the dhcp user lowercase
      macs[toupper($1)] = $1                                                                 
      snr[toupper($1)] = snr
      lastseen[toupper($1)] = int($9)
    }
  } else {
    # check if MAC address was found in the associated devices list, and if the hostname starts with ESP
    if (macs[toupper($2)] && substr($4, 1, 3) == "ESP"){
      #print "{\"ip\": \"", $3, "\", \"SNR\"=", snr[toupper($2)], "\", \"lastseen\":\", lastseen[toupper($2)], "}," 
      #print "{\"ip\": \"", $3#, "\", \"SNR\"=", snr[toupper($2)], "\", \"lastseen\":\", lastseen[toupper($2)], "},"
      if (dhcp > 1){print ","}
      dhcp++
      printf "{\"ip\": \"%s\", \"SNR\":%6d, \"lastseen\":%6d}", $3, snr[toupper($2)], lastseen[toupper($2)]
    }
  }
}
END{print "]}"}
