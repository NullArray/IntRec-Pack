#!/bin/bash

# Coloring scheme for notfications and logo
ESC="\x1b["
RESET=$ESC"39;49;00m"
CYAN=$ESC"33;36m"
RED=$ESC"31;01m"
GREEN=$ESC"32;01m"

# Warning
function warning() 
{	echo -e "\n$RED [!] $1 $RESET\n"
	}

# Green notification	
function notification()	
{	echo -e "\n$GREEN [+] $1 $RESET\n"
	}

# Cyan notification	
function notification_b()	
{	echo -e "\n$CYAN [-] $1 [-] $RESET\n"
	}

# Print logo and general info
function logo()
{	echo -e "$CYAN"
	echo -e "\
 _____ _____ _____ _____ _____ _____     _____ _____ _____ _____ 
|     |   | |_   _| __  |   __|     |___|  _  |  _  |     |  |  |
|-   -| | | | | | |    -|   __|   --|___|   __|     |   --|    -|
|_____|_|___| |_| |__|__|_____|_____|   |__|  |__|__|_____|__|__|
									   	
#################################################################	 
#---Author: NullArray/Vector---#	IntRec-Pack,		#	
#---Twitter: @AntiSec_Inc------#	Intelligence		#
#------------------------------#	and Reconnaissance	#
#---Type: Bundle Installer-----#	Package Installer	#
#################################################################" && echo -e "$RESET\n"
	
	main_menu
	}

# print tool list	
function tools()
{	notification_b "Available tools, select a number to install"
	printf "\
+-----------------------+-------------------------------------------+
| Tool                  | Utility type and feature summary          |
+-----------------------+-------------------------------------------+
|1. QuickScan	        | Port Scanner/WHOIS/Domain Resolver        | 
|2. DNSRecon	        | Advanced DNS Enumeration & Domain Utility |
|3. Sublist3r           | OSINT Based Subdomain Enumeration         |
|4. TekDefense-Automator| OSINT Based IP, URL and Hash Analyzer     |
|5. TheHarvester        | eMail, vHost, Domain and PII Enumeration  |
|6. IOC-Parser          | Threat Intel, parses IOC data from reports|
|7. PyParser-CVE        | Multi Source Exploit Parser/CVE Lookup    |
|8. Mimir               | HoneyDB CLI/Threat Intelligence Utility   |
|9. Harbinger           | Cymon.io, Virus Total, Threat Feed Parser |
|10.Spiderfoot          | Advanced OSINT/Reconnaissance Framework   |
+-----------------------+-------------------------------------------+\n"
	list
	}

function opt_list()
{	notification_b "Welcome to IntRec-Pack"
	printf "
1) Help	                 4) Specify Install Location
2) List and Install      5) Online Resources
3) Install All           6) Quit\n"

	main_menu
	}

# Display usage information and details
function usage()
{	notification_b "Welcome to IntRec-Pack"
	printf "This script fetches and installs a selection
of tools used in open source intelligence gathering, and
reconnaissance. Functionality to install any dependencies needed 
by the tools in question is included in this script in order to
facilitate quick and easy deployment. 

Below is an overview of the options available to you.

The 'help' option displays this informational message. The 'List and Install'
option shows you a list of tools available to download and install with
IntRec-Pack. The 'Install All' options automatically downloads and installs
every utility that is featured in this script including their individual 
dependencies respectively. 'Specify Install Location' allows you to input
a path to a directory to which you'd like the utilities saved to. The default 
location is the current working directory.

Lastly the 'Online Resources' option will employ the Geckodriver in order
to open osintframework.com in browser. Which is a web application that
serves as a curated list of open source intelligence tools, websites and related
materials for use as a comprehensive reference guide. The second item in the
'Online Resources' option is HoneyDB which is a threat intelligence aggregator.
\n"	
	}	

# Function to check CPU architecture and install the proper version of Geckodriver
function get_gdriver()
{	printf "\n\n"
	MACHINE_TYPE=`uname -m`
	if [[ ${MACHINE_TYPE} == 'x86_64' ]]; then
		notification "x86_64 architecture detected..."
		sleep 1
      
		wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz 
		tar -xvf geckodriver-v0.18.0-linux64.tar.gz
		rm geckodriver-v0.18.0-linux64.tar.gz 
		chmod +x geckodriver
		mv geckodriver /usr/sbin
		sudo ln -s /usr/sbin/geckodriver /usr/bin/geckodriver 
      
		notification "Geckodriver has been succesfully installed"
	else
		notification "x32 architecture detected..."
		sleep 1
      
		wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux32.tar.gz | tee -a $cwd/IntRec-Logs/gdriver_install.log
		tar -xvf geckodriver-v0.18.0-linux32.tar.gz | tee -a $cwd/IntRec-Logs/gdriver_install.log
		rm geckodriver-v0.18.0-linux32.tar.gz | tee -a $cwd/IntRec-Logs/gdriver_install.log
		chmod +x geckodriver | tee -a $cwd/IntRec-Logs/gdriver_install.log
		mv geckodriver /usr/sbin | tee -a $cwd/IntRec-Logs/gdriver_install.log
		sudo ln -s /usr/sbin/geckodriver /usr/bin/geckodriver | tee -a $cwd/IntRec-Logs/gdriver_install.log
      
		notification "Geckodriver has been succesfully installed."
	fi
	}

# Component of the mass install operation
function mass_depend()	
{	notification "Installing remaining dependencies."
	
	sudo pip install ioc_parser 
	sudo pip install lxml M2Crypto cherrypy mako requests bs4 
	sudo pip install cymon beautifulsoup4 argparse dnspython 
	sudo pip install blessings shodan pycurl netaddr whois 
	
	notification "All operations completed."
	
	logo
	}

# The Mimir install operation will be a little more involved since we will need 
# to check and make sure we have OpenSSL support in the PycURL module 
# Mimir depends on. This is important in order for Mimir 
# to be compatible with HoneyDB and retrieve the data we want via the API.					
function mimir_install()
{	printf "\n\n"
	if [[ -d "Mimir" ]]; then
		warning "Mimir is already installed."
	else
		notification "Installing Mimir. Please do not interrupt this process until all dependencies
and supporting features have been installed as well." && sleep 1
		
		git clone https://github.com/NullArray/Mimir.git 
		
		notification "Installing dependencies."
		sleep 1.5
		
		sudo pip install selenium blessings ipwhois pycurl
		
		notification "Checking PyCurl for OpenSSL support..."
		sleep 1.5
		
		# Save version to var
		pcurl=$(python -c "import pycurl; print pycurl.version")
		case $pcurl in 
			*OpenSSL*)
			openssl=1
			;;
		esac
		
		if [[ $openssl == 1 ]]; then
			notification "Hueristics indicate your PyCurl version Supports OpenSSL"
		else
			warning "Heuristics indicate your version of PyCurl does not support OpenSSL"
			notification "Attempting to resolve..."
			
			cwd=$(pwd)
			cd Mimir
			chmod +x rebuild.sh
			
			# Invoke 'rebuild.sh' to rebuild PyCurl with OpenSSL support
			sudo ./rebuild.sh && cd $cwd && sleep 1
			notfication "PyCurl has been rebuilt with OpenSSL support." && sleep 1
		fi	
		
		notification "Checking to see if the Mozilla Geckodriver is installed on this system."
		sleep 1.5
			
		gdrive=$(which geckodriver)
		case $gdrive in 
			*/usr/bin/geckodriver*)
			gd=1
			;;
		esac
	
		if [[ $gd == 1 ]]; then
			notification "Hueristics indicate Geckodriver is currently installed."
		else
			notification "Installing Mozilla Geckodriver..."
				
			get_gdriver && sleep 1.5
			notification "Operation completed."
		fi
				
		notification "Finally Intrec-Pack will now check to see if Nmap is installed on this system."
		sleep 1
		
		net_mapper=$(which nmap)
		case $net_mapper in 
			*/usr/bin/nmap*)
			nm=1
			;;
		esac
		
		if [[ $nm == 1 ]]; then
			notification "Hueristics indicate Nmap is currently installed."
		else
			notification "Installing nmap..."
			sudo apt-get install nmap
		fi
	fi	
		
		if [[ $mass_install == 1 ]]; then
			mass_depend
		else
			notification "Mimir installation and configuration has been completed succesfully."
			notification "Returning to menu."
			sleep 2
			tools
		fi
	}

# List and download function
function list()
{	printf "\n\n"
	
	PS3='Please enter your choice: '
	options=("QuickScan" "DNSRecon" "Sublist3r" "TekDefense" "TheHarvester" "IOC-Parser" "PyParser-CVE" "Mimir" "Harbinger" "Spiderfoot" "Main Menu")
	select opt in "${options[@]}"
	do
		case $opt in
			"QuickScan")
				
				if [[ -d "QuickScan" ]]; then
					warning "QuickScan is already installed."
				else
					notification "Installing QuickScan."
					sleep 1
				
					git clone https://github.com/NullArray/QuickScan.git
				
					notification "Installing dependencies."
					sleep 1
				
					sudo pip install blessings whois
				
					notification "QuickScan was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"DNSRecon")
				
				if [[ -d "dnsrecon" ]]; then
					warning "DNSRecon is already installed."
				else
					notification "Installing DNSRecon"
					sleep 1
					
					git clone https://github.com/darkoperator/dnsrecon.git
					
					notification "Installing dependencies"
					sleep 1
					
					sudo pip install dnspython netaddr

					
					notification "DNSRecon was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"Sublist3r")
				
				if [[ -d "Sublist3r" ]]; then
					warning "Sublist3r is already installed."
				else
					notification "Installing Sublist3r."
					sleep 1
					
					git clone https://github.com/aboul3la/Sublist3r.git
					
					notification "Installing dependencies."
					sleep 1
					
					sudo pip install argparse dnspython requests
					
					notification "Sublist3r was nstalled succesfully."
				fi
				tools
				printf "%b \n"
				;;
			"TekDefense")
				
				if [[ -d "TekDefense-Automater" ]]; then
					warning "TekDefense-Automater is already installed."
				else
					notification "Installing TekDefense-Automater."
					sleep 1
					
					git clone https://github.com/1aN0rmus/TekDefense-Automater.git
					
					notification "Installing dependencies."
					sleep 1
					
					sudo pip install argparse requests
					
					notification "TekDefense-Automater was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"TheHarvester")
				
				if [[ -d "theHarvester" ]]; then
					warning "TheHarvester is already installed."
				else
					notification "Installing TheHarvester."
					sleep 1
					
					git clone https://github.com/laramies/theHarvester.git
					
					notification "Installing dependencies."
					sleep 1
					
					sudo pip install requests
					
					notification "TheHarvester was succefully installed."
				fi
				tools				
				printf "%b \n"
				;;
			"IOC-Parser")
				
				if [[ -d "ioc_parser" ]]; then
					warning "IOC-Parser is already installed."
				else
					notification "Installing IOC-Parser."
					sleep 1
				
					git clone https://github.com/armbues/ioc_parser.git 
					sleep 1
					
					notification "Installing dependencies."
				
					sudo pip install ioc_parser 
					sudo pip install beautifulsoup4 requests 
				
					notification "IOC-Parer was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"PyParser-CVE")
				
				if [[ -d " PyParser-CVE" ]]; then
					warning "PyParser-CVE is already installed."
				else
					notification "Installing PyParser-CVE."
					sleep 1
					
					git clone https://github.com/NullArray/PyParser-CVE.git
					
					notification "Installing dependencies."
					sleep 1
					
					sudo pip install blessings shodan pycurl

					notification "PyParser-CVE was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"Mimir")
				# Call Mimir install/config function
				mimir_install
				
				printf "%b \n"
				;;
			"Harbinger")
				
				if [[ -d "harbinger" ]]; then
					warning "Harbinger is already installed."
				else
					notification "Installing Harbinger."
					sleep 1
				
					git clone https://github.com/exp0se/harbinger.git
					
					notification "Installing dependencies"
					sleep 1
				
					sudo pip install requests cymon beautifulsoup4
					
					notification "Harbinger was succesfully installed."
				fi
				tools
				printf "%b \n"
				;;
			"Spiderfoot")
				if [[ -d "spiderfoot" ]]; then
					warning "Spiderfoot is already installed."
				else
					notification "Installing Spiderfoot."
					sleep 1
					
					git clone https://github.com/smicallef/spiderfoot.git
					
					notification "Installing dependencies."
					sleep 1
				
					sudo pip install lxml netaddr M2Crypto cherrypy mako requests bs4
					
					notification "Spiderfoot was succesfully installed"
				fi
				tools
				printf "%b \n"
				;;
			"Main Menu")
				printf "\nReturning to main menu."
				sleep 2 && logo
				;;				
			*) echo invalid option;;
		esac
	done
	}
	

# Download and install all
function install_all()
{	printf "\n\n"
	notification_b "Installing all available tools plus dependencies."
	if [[ ! -d "QuickScan" ]]; then
		git clone https://github.com/NullArray/QuickScan.git 
	fi
	
	if [[ ! -d "dnsrecon" ]]; then
		git clone https://github.com/darkoperator/dnsrecon.git 
	fi
	
	if [[ ! -d "Sublist3r" ]]; then
		git clone https://github.com/aboul3la/Sublist3r.git 
	fi
	
	if [[ ! -d "TekDefense-Automater" ]]; then
		git clone https://github.com/1aN0rmus/TekDefense-Automater.git 
	fi
	
	if [[ ! -d "theHarvester" ]]; then
		git clone https://github.com/laramies/theHarvester.git 
	fi
	
	if [[ ! -d "ioc_parser" ]]; then
		git clone https://github.com/armbues/ioc_parser.git 
	fi
	
	if [[ ! -d " PyParser-CVE" ]]; then
		git clone https://github.com/NullArray/PyParser-CVE.git 
	fi
	
	if [[ ! -d "harbinger" ]]; then
		git clone https://github.com/exp0se/harbinger.git 
	fi
	
	if [[ ! -d "spiderfoot" ]]; then
		git clone https://github.com/smicallef/spiderfoot.git 
	fi
	
	if [[ ! -d "Mimir" ]]; then
		mass_install=1
		mimir_install 
	fi
	}

# Function to interact with online OSINT/Threat Intel resources.
function online()
{	notification_b "Online Resources"
	printf "
+-----------------------+---------------------------------------+
| 1. osintframework.com | Comprehensive OSINT Resource Pool     |
| 2. riskdiscovery.com  | Hosts HoneyDB/Aggregates Honeypot Data|
+-----------------------+---------------------------------------+
\n"

	PS3='Please enter your choice: '
	options=("osintframework.com" "riskdiscovery.com" "Main Menu")
	select opt in "${options[@]}"
	do
		case $opt in
			"osintframework.com")
				notification "Opening osintframework.com with Geckodriver..."
				sleep 1.5
			
				# Python one liner in order to open online resource/web application
				python -c "from selenium import webdriver; driver = webdriver.Firefox(); driver.get('http://osintframework.com/')"
				printf "%b \n"
				;;
			"riskdiscovery.com")
				notification "Opening riskdiscovery.com/honeydb with Geckodriver..."
				sleep 1.5
			
				# Python one liner in order to open online resource/web application
				python -c "from selenium import webdriver; driver = webdriver.Firefox(); driver.get('http://riskdiscovery.com/honeydb')"
				printf "%b \n"
				;;
			"Main Menu")
				printf "\nReturning to Main Menu"
				sleep 1.5 && logo
		esac
	done
		
	}

function main_menu()
{	PS3='Please enter your choice: '
	options=("Help" "List and Install" "Install All" "Specify Install Location" "Online Resources" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Help")
				usage
				printf "%b \n"
				;;
			"List and Install")
				tools
				printf "%b \n"
				;;
			"Install All")
				install_all
				printf "%b \n"
				;;
			"Specify Install Location")
				printf "\nBy default utilities will be installed in the current working directory."
				read -p 'Would you like to change install location? Y/n : ' choice
			
				if [[ $choice == 'y' ]]; then
					read -p 'Enter target location : ' cwd
					stat $cwd > /dev/null || mkdir $cwd && notification "Directory created." && cd $cwd || warning "Invalid format."			
				else
					notification "Using default setting."
				fi
				;;
			"Online Resources")
				gecko=$(which geckodriver)
						
				case $gecko in
					*/usr/bin/geckodriver*)
					gdriver=1
					;;
				esac
            
				if [[ $gdriver == 1 ]]; then 
					online
				else
					warning "Heuristics indicate Geckodriver is not installed on this system."
					printf "The Online Resource option invokes Python and Selenium to open "
					printf "these resources in browser. Without the Mozilla Geckodriver this is not" 
					printf "possible within the scope of this script.\n"
				
					read -p 'Would you like to automatically resolve this issue? Y/n : ' choice
					if [[ $choice == 'y' ]]; then
						sudo pip install selenium
						get_gdriver
					else
						warning "Not Resolving"
					fi
				fi
            
				printf "%b \n"
				;;
			"Quit")
				exit 1
				;;
			*) echo invalid option;;
		esac
	done
	}

logo
