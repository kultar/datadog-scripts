#!/bin/sh
# Make sure you replace the API and/or APP key below
# with the ones for your account

api_key=
app_key=
ret=""


$(curl --silent -G "https://app.datadoghq.com/api/v1/monitor" \
     -d "api_key=${api_key}" \
     -d "application_key=${app_key}" >/tmp/dd_status )


count=`jq '.|length' < /tmp/dd_status `
count=`expr $count - 1`

for f in `seq 0 ${count}`
do
	
	name=$(jq .[$f].name /tmp/dd_status)
	id=$(jq .[$f].id /tmp/dd_status)
	state=$(jq .[$f].overall_state /tmp/dd_status)

	if [[ $state == '"Warn"' ]];then
	  ret="${ret}${name} : $state \n"
	elif [[ $state == '"Alert"' ]]; then
	  ret="${ret}${name} : $state \n"
	fi
	
done

if [[ -z $ret ]]; then
	echo "All systems normal"
else
    echo -e $ret
fi


