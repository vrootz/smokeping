#!/bin/bash

#Send a SmokePing status alert to the teams #smokeping channel
function send_alert {
    

    alertname="$1"
    target="$2"
    losspattern="$3"
    rtt="$4"
    hostname="$5"
    date=$(date)
    ### CHANGE URL ###
    url=("https://smokeping.example.com/smokeping/smokeping.cgi?target="$target)

    losspattern=$(echo $losspattern | rev | cut -d',' -f 1 | rev)

    IFS='%'
    read -ra ADDR <<< "${losspattern}"
    for i in "${ADDR[@]}"; do
     echo "$i"
    done

    if [[ "${i}" -eq 0  ]]
    then
     echo "[$date] Sending Teams alert, Alert: $alertname, Target: $target, Loss Pattern: $losspattern, RTT: $rtt, Hostname: $hostname" >> /tmp/teams_notify.log
notify_resolved()
{
    cat <<EOF
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "00b300",
    "summary": "Resolved: ${alertname}",
    "sections": [{
        "activityTitle": "Resolved: ${alertname}",
        "activitySubtitle": "Due date: ${date}",
        "facts": [{
            "name": "Affected Host",
            "value": "${target}"
        }, {
            "name": "Affected IP",
            "value": "${hostname}"
        }, {
            "name": "Recent RTTs",
            "value": "${rtt}"
        }, {
            "name": "Packet Loss (%)",
            "value": "${losspattern}",
        }],
        "markdown": true
    }],
    "potentialAction": [{
        "@type": "OpenUri",
        "name": "View Graph",
        "targets": [{
            "os": "default",
            "uri": "${url}"
        }]
    }]
}
EOF
}
     ### CHANGE URL ###
     curl -H 'Content-Type: application/json' https://example.webhook.office.com/webhookb2/092fdnsn-89b8-4a13-9b9e-fhksdhfas@1cec0da2-6e19-4691-a081-977f9654224f/IncomingWebhook/41aaf7717af5426b97fca93ebe66b8a0/6576caeb-da4d-48be-9b75-972beb9b1766 -d "$(notify_resolved)"
     exit 0
    fi

    echo "[$date] Sending Teams alert, Alert: $alertname, Target: $target, Loss Pattern: $losspattern, RTT: $rtt, Hostname: $hostname" >> /tmp/teams_notify.log

notify_problem()
{
    cat <<EOF
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "b20000",
    "summary": "Problem: ${alertname}",
    "sections": [{
        "activityTitle": "Problem: ${alertname}",
        "activitySubtitle": "Due date: ${date}",
        "facts": [{
            "name": "Affected Host",
            "value": "${target}"
        }, {
            "name": "Affected IP",
            "value": "${hostname}"
        }, {
            "name": "Recent RTTs",
            "value": "${rtt}"
        }, {
            "name": "Packet Loss (%)",
            "value": "${losspattern}",
        }],
        "markdown": true
    }],
    "potentialAction": [{
        "@type": "OpenUri",
        "name": "View Graph",
        "targets": [{
            "os": "default",
            "uri": "${url}"
        }]
    }]
}
EOF
}

    ### CHANGE URL ###
    curl -H 'Content-Type: application/json' https://example.webhook.office.com/webhookb2/092fdnsn-89b8-4a13-9b9e-fhksdhfas@1cec0da2-6e19-4691-a081-977f9654224f/IncomingWebhook/41aaf7717af5426b97fca93ebe66b8a0/6576caeb-da4d-48be-9b75-972beb9b1766 -d "$(notify_problem)"
}

send_alert "$1" "$2" "$3" "$4" "$5"

exit 0