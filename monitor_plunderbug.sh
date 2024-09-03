#!/bin/bash

# Define interface names
BRIDGE="br0"  # Bridged Interface
INTERFACE1="enp6s0" # Attacker PC's Internet Interface
INTERFACE2="enx001337a72c94" # PlunderBug Interface
BRIDGE_IP="192.168.102.100/24" # VLan to get it onto

# Function to enable the bridge
enable_bridge() {
    echo "Enabling network bridge $BRIDGE..."
    
    # Check if bridge already exists
    if ip link show $BRIDGE &>/dev/null; then
        echo "$BRIDGE already exists, skipping creation..."
    else
        # Create the bridge
        sudo ip link add name $BRIDGE type bridge
        echo "$BRIDGE created."
    fi
    
    # Add interfaces to the bridge
    sudo ip link set $INTERFACE1 master $BRIDGE
    sudo ip link set $INTERFACE2 master $BRIDGE
    
    # Bring up the interfaces and the bridge
    sudo ip link set $INTERFACE1 up
    sudo ip link set $INTERFACE2 up
    sudo ip link set $BRIDGE up
    
    # Assign IP address to the bridge
    sudo ip addr add $BRIDGE_IP dev $BRIDGE
    
    # Optionally request a DHCP IP address
    sudo dhclient $BRIDGE
    
    echo "Bridge $BRIDGE enabled with IP $BRIDGE_IP."
}

# Function to disable the bridge
disable_bridge() {
    echo "Disabling network bridge $BRIDGE..."
    
    # Check if bridge exists
    if ip link show $BRIDGE &>/dev/null; then
        # Bring down the bridge and interfaces
        sudo ip link set $BRIDGE down
        sudo ip link set $INTERFACE1 down
        sudo ip link set $INTERFACE2 down
        
        # Remove the bridge
        sudo ip link delete $BRIDGE
        echo "Bridge $BRIDGE removed."
    else
        echo "$BRIDGE does not exist, nothing to do."
    fi
}

# Main script logic
if [ "$1" == "enable" ]; then
    enable_bridge
elif [ "$1" == "disable" ]; then
    disable_bridge
else
    echo "Usage: $0 {enable|disable}"
    exit 1
fi
