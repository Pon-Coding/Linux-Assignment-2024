#!/bin/bash

default="$0"
option="$1"
name="$2"

case $option in 
	#User
	[Uu]|[Uu][Ss][Ee][Rr])
		if [ -z $name ]; then
		    echo "Usage: $defualt <username>"
		    exit 1
		fi

		fullname=$(getent passwd "$name" | cut -d: -f5 | awk -F. '{print $1}' | tr ',' ' ')
		group=$(id -gn "$name")
		uid=$(id -u "$name")
		gid=$(id -g "$name")
		home_dir=$(getent passwd "$name" | cut -d: -f6)
		last_log=$(last -n -1 -w "$name" | awk 'NR==1{print $1 " "$3" "$4}')

		echo "Username: $name"
		echo "Full Name: $fullname"
		echo "UID,GID: $uid,$gid"
		echo "Group(s): $group"
		echo "Home Dir: $home_dir"
		echo "Last Login: $last_log"
		;;
	#Hostname/H
	[Ii]|[Ii][Pp]|[Hh]|[Hh][Oo][Ss][Tt])
	    if [ -z $name ]; then
		echo "Usage: $default [I|IP|H|HOST] <hostname|ip>"
		exit 1
	    fi

	    # Determine the IP address based on input (hostname or IP)
	    ip_address=$name
	    if [[ ! "$name" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then  # Check if it's not an IP address
		ip_address=$(getent ahosts "$name" | awk '{print $1; exit}')  # Use getent for comprehensive resolution
		if [[ -z "$ip_address" ]]; then  # Handle potential resolution failure
		    echo "Error: Could not resolve hostname $name"
		    exit 1
		fi
	    fi

	    hostname=$(hostname -I | awk '{print $1}')  # Get hostname from system
	    gateway=$(traceroute -n $hostname 2>&1 | awk 'NR==2 {print $2}')

	    whois_output=$(whois $ip_address)
	    organization=$(echo "$whois_output" | grep -i "organization:" | awk '{print $2}')
	    country=$(echo "$whois_output" | grep -i "country:" | awk '{print $2}')

	    reachable="No"
	    if ping -c 4 $ip_address &> /dev/null; then
		reachable="Yes"
	    fi

	    echo "IP Address: $ip_address"
	    echo "Hostname: $hostname"
	    echo "Reachable? $reachable"
	    echo "Route/Gateway: $gateway"
	    echo "Organization: $organization"
	    echo "Country: $country"
	    ;;

	#F/File
	[Ff]|[Ff][Ii][Ll][Ee]|[Pp]|[Pp][Aa][Tt][Hh])
		if [ -z $name ]; then
			echo "Usage: $default [F|FILE|P|PATH] <pathname>"
			exit 1
		fi
		if [ ! -e $name ]; then
			echo "Error: Pathname does not exist."
			exit 1
		fi
		
		owner_user=$(stat -c "%U" $name)
		owner_group=$(stat -c "%G" $name)
		
		if [ -f $name ]; then
			type="File"
		elif [ -d $name ]; then
			type="Folder"
		else
			type="Unknown"
		fi
		
		permissions_user=$(stat -c "%A" $name | cut -c 1-4)
		permissions_group=$(stat -c "%A" $name | cut -c 5-7)
		permissions_others=$(stat -c "%A" $name | cut -c 8-10)
		last_modified=$(stat -c "%y" $name)
		
		size=$(stat -c "%s" $name)
		
		echo "Full Pathname: $name"
		echo "Owner: User=$owner_user, Group=$owner_group"
		echo "File or Folder? $type"
		echo "Permission: user=$permission_user, group=$permissions_group, others=$permissions_others"
		echo "Last Modified: $last_modified"
		echo "Size: $size"
		;;
	*)
		echo "Invalid ooption. Please use [U|USER], [F|FILE|P|PATH], [I|IP|H|HOST]."
		exit 1
		;;
esac
