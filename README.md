# Running the MyInfo.sh Script
# Prepared and uploaded by Ropon POV

This script provides information about users, hosts, and files/directories on a Linux system.

Prerequisites:

-> Ensure you have a Bash shell environment.
-> The script requires standard Linux utilities like getent, awk, last, traceroute, whois, ping, and stat. These are usually pre-installed on most Linux distributions.

Steps:

#1. Download the script:
    - Clone this repository or download the MyInfo.sh file directly.
#2. Make the script executable:
    - Open a terminal in the directory where you saved the script.
    - Run the following command to grant execute permissions:

            chmod +x MyInfo.sh

#3. Run the script with options:
- Use the following format to execute the script:

            ./MyInfo.sh <option> <argument>

- Replace <option> with one of the following options:
  + U or USER: To get information about a user.
  + I, IP, H, or HOST: To get information about a host or IP address.
  + F, FILE, P, or PATH: To get information about a file or directory.
- Replace <argument> with the specific username, hostname/IP, or file/pathname you want to query.

Examples:

=> To get information about the user "john":

    ./MyInfo.sh U john


=> To get information about the host "example.com":

    ./MyInfo.sh HOST example.com

=> To get information about the file "/etc/passwd":

    ./MyInfo.sh FILE /etc/passwd

