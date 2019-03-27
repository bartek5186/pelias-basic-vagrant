#!/bin/bash                                                                     
         
european_countries=( "PL" "DE" "AD" "AL" "AT" "AX" "BA" "BG" "BE"
 "BY" "CH" "CY" "CZ" "DK" "EE" "ES" "FI" "FO" "FR" "GB" 
 "GG" "GI" "GR" "HR" "HU" "IE" "IM" "IS" 
 "IT" "JE" "XK" "LI" "LT" "LU" "LV" "MC" "MD" 
 "ME" "MK" "MT" "NL" "NO" "PT" "RO" "RS" 
 "RU" "SE" "SI" "SJ" "SK" "SM" "UA" "VA" "CS")
                                                                                 
for country in ${european_countries[@]}; do                                     
 sed -i 's/"countryCode".*/"countryCode": "'${country}'"/g' /home/ubuntu/pelias.json
 npm start
done
