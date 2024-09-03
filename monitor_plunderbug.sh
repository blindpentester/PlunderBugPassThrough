#!/bin/bash

# Variables
PLUNDERBUG_INTERFACE="br0"  # Update with the actual PlunderBug interface
MONITOR_INTERFACE="br0"     # Update with the actual interface providing internet to the victim
CAPTURE_FILE="/home/username/Documents/plunderbug_capture.pcap"

# Function to enable sharing and start monitoring
enable_monitoring() {
    echo "Enabling internet sharing and starting PlunderBug monitoring..."

    # Enable IP forwarding on attacker machine
    sudo sysctl -w net.ipv4.ip_forward=1

    # Set up NAT to share internet from MONITOR_INTERFACE to PLUNDERBUG_INTERFACE
    sudo iptables -t nat -A POSTROUTING -o $MONITOR_INTERFACE -j MASQUERADE
    sudo iptables -A FORWARD -i $PLUNDERBUG_INTERFACE -o $MONITOR_INTERFACE -j ACCEPT
    sudo iptables -A FORWARD -i $MONITOR_INTERFACE -o $PLUNDERBUG_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Start capturing traffic on PlunderBug
    echo "Starting tcpdump on $PLUNDERBUG_INTERFACE..."
    sudo tcpdump -i $PLUNDERBUG_INTERFACE -w $CAPTURE_FILE &
    TCPDUMP_PID=$!
    echo "tcpdump running with PID $TCPDUMP_PID"
}

# Function to disable sharing and stop monitoring
disable_monitoring() {
    echo "Disabling internet sharing and stopping PlunderBug monitoring..."

    # Stop IP forwarding
    sudo sysctl -w net.ipv4.ip_forward=0

    # Clear iptables rules
    sudo iptables -t nat -D POSTROUTING -o $MONITOR_INTERFACE -j MASQUERADE
    sudo iptables -D FORWARD -i $PLUNDERBUG_INTERFACE -o $MONITOR_INTERFACE -j ACCEPT
    sudo iptables -D FORWARD -i $MONITOR_INTERFACE -o $PLUNDERBUG_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Stop tcpdump
    if [ ! -z "$TCPDUMP_PID" ]; then
        sudo kill $TCPDUMP_PID
        echo "tcpdump stopped."
    fi
}

# Main script logic
if [ "$1" == "enable" ]; then
    enable_monitoring
elif [ "$1" == "disable" ]; then
    disable_monitoring
else
    echo "Usage: $0 {enable|disable}"
    exit 1
fi
