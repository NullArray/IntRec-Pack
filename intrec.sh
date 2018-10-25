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
{	echo -e "\n$CYAN [-] $1 $RESET\n"
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
#---Author:  NullArray/Vector--#	IntRec-Pack,		#
#---Twitter: @Real__Vector-----#	Intelligence		#
#---Type:    Bundle Installer--#	and Reconnaissance	#
#---Version: 1.2.1-------------#	Package Installer	#
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
|2. DNSRecon            | Advanced DNS Enumeration & Domain Utility |
|3. Sublist3r           | OSINT Based Subdomain Enumeration         |
|4. TekDefense-Automator| OSINT Based IP, URL and Hash Analyzer     |
|5. TheHarvester        | eMail, vHost, Domain and PII Enumeration  |
|6. IOC-Parser          | Threat Intel, parses IOC data from reports|
|7. PyParser-CVE        | Multi Source Exploit Parser/CVE Lookup    |
|8. Mimir               | HoneyDB CLI/Threat Intelligence Utility   |
|9. Tadpole		| Open AWS bucket, file search and Download |
|10.Harbinger           | Cymon.io, Virus Total, Threat Feed Parser |
|11.Inquisitor          | OSINT Recon/data visualization utility    |
|12.BirdWatch           | SOCMINT Utility with a focus on Twitter   |
|13.Spiderfoot          | Advanced OSINT/Reconnaissance Framework   |
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

The 'Online Resources' option employs the Mozilla Geckodriver in order to load
two web based OSINT resource aggregators and an OSINT Threat Intel service as well.
The first entry under this category is 'osintframework.com' which serves as a 
curated list of OSINT oriented web services, documentation, and provides a catalog
of utilities and assorted programs to help customize and expand your intel gathering
environment and OSINT toolkit in general. 

The second item under 'Online Resources' loads 'toddignton.com/resources'. 
This website serves as an additional knowledge hub, which can be used as a
comprehensive reference guide geared towards tooling, techniques, and documentation.
 
The third and final item under this category is HoneyDB which is an OSINT based threat
intelligence aggregator. HoneyPy honeypots provide the data accesible here and the 
HoneyDB web application provides a data visualization service and Thread Feed 
functionality as well.
\n"
	}

# Function to check for the existence of common Linux utilities needed to perform
# some of the install operations. Distros like Debian might not have some of these
# available by default.
function nix_util()
{	notification_b "Checking Linux utilities required by the installer."
	sleep 2
	
	# Check for sudo
	su_do=$(which sudo)
	case $su_do in
		*/usr/bin/sudo*)
		sd=1
		;;
	esac
	
	if [[ $sd != 1 ]]; then
		warning "Heuristics indicate sudo is not installed on this system."
		read -p 'Automatically resolve? Y/n : ' choice
		if [[ $choice == 'y' || $choice == 'Y' ]]; then
			notification "Please enter root password."
			su -
			apt-get install sudo && notification "Sudo was succesfully installed" || warning "An error was encountered while trying to install sudo. Quitting..." && exit 1
			printf "Please add your regular user account to sudoers and restart the script."
			printf "Quitting..."
			sleep 2 && exit 1
		else
			warning "Not resolving."
			sleep 2 && exit 1
		fi
	fi
	
	# Check to see if we have wget
	wgt=$(which wget)
	case $wgt in 
		*/usr/bin/wget*)
		wg=1
		;;
	esac
	
	if [[ $wg != 1 ]]; then
		warning "Heuristics indicate wget is not installed on this system."
		notification "Attempting to resolve."
		sleep 2
		
		sudo apt-get install wget
		notification "Wget has been succesfully installed."
		sleep 2
	fi
	
	# Check to see if we have git
	get_git=$(which git)
	case $get_git in 
		*/usr/bin/git*)
		ggit=1
		;;
	esac

	if [[ $ggit != 1 ]]; then
		warning "Heuristics indicate git is not installed on this system."
		notification "Attempting to resolve."
		sleep 2
		
		sudo apt-get install git
		notification "Git has been succesfully installed."
		sleep 2
	fi
	
	# Check to see if we have pip, if not get setuptools and install pip
	pypip=$(which pip)
	case $pypip in
		*/usr/bin/pip*) 
		pp=1
		;;
	esac
	
	if [[ pp != 1 ]]; then
		case $pypip in
			*/usr/local/bin/pip*) 
			pp=2
			;;
		esac
	fi
	
	if [[ $pp != 1 ]]; then
		if [[ $pp != 2 ]]; then
		warning "Heuristics indicate pip is not installed on this system."
		notification "Attempting to resolve."
		sleep 2
		
		notification "Installing Python setuptools and pip"
		sudo apt-get install python-setuptools python-pip
		notification "Operation completed"
		sleep 2
		
		fi
	fi
		
	notification "All Linux utilities required by the installer appear to be present. Proceeding to main menu."
	sleep 2 && clear
	logo
	
	}

# Function to check CPU architecture and install the proper version of Geckodriver
function get_gdriver() 
{	printf "\n\n"
	MACHINE_TYPE=`uname -m`
	if [[ ${MACHINE_TYPE} == 'x86_64' ]]; then
		notification "x86_64 architecture detected..."
		sleep 1

		wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz
		tar -xvf geckodriver-v0.23.0-linux64.tar.gz
		rm geckodriver-v0.23.0-linux64.tar.gz
		chmod +x geckodriver
		mv geckodriver /usr/sbin
		sudo ln -s /usr/sbin/geckodriver /usr/bin/geckodriver

		notification "Geckodriver has been succesfully installed"
	else
		notification "x32 architecture detected..."
		sleep 1
		wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux32.tar.gz
		tar -xvf geckodriver-v0.23.0-linux32.tar.gz
		rm geckodriver-v0.23.0-linux32.tar.gz 
		chmod +x geckodriver 
		mv geckodriver /usr/sbin 
		sudo ln -s /usr/sbin/geckodriver /usr/bin/geckodriver
		notification "Geckodriver has been succesfully installed."
	fi
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
		notification "Installing Mimir. Please do not interrupt this process until all dependencies and supporting features have been installed as well." && sleep 1

		git clone https://github.com/NullArray/Mimir.git

		notification "Installing dependencies."
		sleep 1.5

		sudo -H pip install selenium blessings ipwhois
		sudo apt-get install python-pycurl
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
			notification "Heuristics indicate your PyCurl version Supports OpenSSL"
		else
			warning "Heuristics indicate your version of PyCurl does not support OpenSSL"
			notification "Attempting to resolve..."

			cwd=$(pwd)
			cd Mimir
			chmod +x rebuild.sh

			# Invoke 'rebuild.sh' to rebuild PyCurl with OpenSSL support
			sudo ./rebuild.sh && cd $cwd && sleep 1
			notification "PyCurl has been rebuilt with OpenSSL support." && sleep 1
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
			notification "Heuristics indicate Geckodriver is currently installed."
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
			notification "Heuristics indicate Nmap is currently installed."
		else
			notification "Installing nmap..."
			sudo apt-get install nmap
		fi
	fi


		notification "Mimir installation and configuration has been completed succesfully."
		notification "Returning to menu."
		sleep 2
		tools

	}

# This function will be called in the event Ruby gets installed without RubyGems
# See birdwatcher install below for details
function gems_install()
{	notification "Attempting to resolve..."
	sleep 1

	git clone https://github.com/rubygems/rubygems.git
	cd rubygems && git submodule update --init
	sudo ruby setup.rb install
	
	gem pristine rake
	sudo gem update --system
	
	notification "Operation complete."
	sleep 1
	
	}
	
	
function BirdWatcher()
{	if [[ -d "birdwatcher" ]]; then
		warning "BirdWatcher is already installed."
		clear
	else
		notification "Installing BirdWatcher"
		sleep 1
		
		git clone https://github.com/michenriksen/birdwatcher.git
		notification "Installing dependencies."
		sleep 1
		
		sudo apt-get install graphviz
		sudo apt-get install libmagickwand-dev imagemagick
		
		rby=$(which ruby)
		case $rby in
			*/usr/bin/ruby*)
			rb=1
			;;
		esac

		if [[ $rb == 1 ]]; then
			notification "Heuristics indicate Ruby is already installed."
		else
			notification "Installing Ruby..."
			sleep 1
			
			sudo apt-get install ruby
		fi
		
		notification "Updating gems..."
		sleep 1
			
		sudo gem update --system || warning "Heuristics indicate RubyGems are not installed on this system." && gems_install
		
		notification "Checking to see if PostgreSQL is installed."
		sleep 1
		
		sudo service postgresql status > /dev/null || $check='failed'
		if [[ $check == 'failed' ]]; then
			notification "Installing PostgreSQL..."
			sleep 1
			
			sudo apt-get install postgresql
			sudo apt-get install libpq-dev
			
			notification "Operation completed."
		else
			notification "Heuristics indicate PostgreSQL is already installed."

		fi
		
	fi
		notification "BirdWatcher was succesfully installed."
		echo "Please reference the BirdWatcher README.md for instructions on"
		echo "how to set up a PostgreSQL database and configure it for use"
		echo "with Birdwatcher"

	}
		
function QuickScan() 
{	if [[ -d "QuickScan" ]]; then
		warning "QuickScan is already installed."
		clear
	else
		notification "Installing QuickScan."
		sleep 1
		git clone https://github.com/NullArray/QuickScan.git
		notification "Installing dependencies."
		sleep 1
		sudo -H pip install blessings whois
		notification "QuickScan was successfully installed."
	fi
	}

function TadPole()
{	if [[ -d "tadpole" ]]; then
		warning "TadPole is already installed"
		clear
	else
		notification "Installing TadPole"
		sleep 1
		git clone https://github.com/Ekultek/tadpole.git
		notification "Installing dependencies."
		sudo -H pip install beautifulsoup4 requests
		notification "TadPole was successfully installed."
		
	fi
	}

function DNSRecon() 
{	if [[ -d "dnsrecon" ]]; then
		warning "DNSRecon is already installed."
		clear
	else
		notification "Installing DNSRecon"
		sleep 1
		git clone https://github.com/darkoperator/dnsrecon.git
		notification "Installing dependencies"
		sleep 1
		sudo -H pip install dnspython netaddr
		notification "DNSRecon was successfully installed."
	fi
	}

function Sublist3r() 
{	if [[ -d "Sublist3r" ]]; then
		warning "Sublist3r is already installed."
		clear
	else
		notification "Installing Sublist3r."
		sleep 1
		git clone https://github.com/aboul3la/Sublist3r.git
		notification "Installing dependencies."
		sleep 1
		sudo -H pip install argparse dnspython requests
		notification "Sublist3r was successfully installed."
	fi
	}

function TekDefense() 
{	if [[ -d "TekDefense-Automater" ]]; then
		warning "TekDefense-Automater is already installed."
		clear
	else
		notification "Installing TekDefense-Automater."
		sleep 1
		git clone https://github.com/1aN0rmus/TekDefense-Automater.git
		notification "Installing dependencies."
		sleep 1
		sudo -H pip install argparse requests
		notification "TekDefense-Automater was successfully installed."
	fi
	}

function theHarvester() 
{	if [[ -d "theHarvester" ]]; then
		warning "TheHarvester is already installed."
		clear
	else
		notification "Installing TheHarvester."
		sleep 1
		git clone https://github.com/laramies/theHarvester.git
		notification "Installing dependencies."
		sleep 1
		sudo -H pip install requests
		notification "TheHarvester was successfully installed."
	fi
}

function ioc_parser() 
{	if [[ -d "ioc_parser" ]]; then
		warning "IOC-Parser is already installed."
		clear
	else
		notification "Installing IOC-Parser."
		sleep 1
		git clone https://github.com/armbues/ioc_parser.git
		sleep 1
		notification "Installing dependencies."
		sudo -H pip install ioc_parser beautifulsoup4 requests
		notification "IOC-Parer was successfully installed."
	fi
	}

function pyparser() 
{	if [[ -d " PyParser-CVE" ]]; then
		warning "PyParser-CVE is already installed."
		clear
	else
		notification "Installing PyParser-CVE."
		sleep 1
		git clone https://github.com/NullArray/PyParser-CVE.git
		notification "Installing dependencies."
		sleep 1
		sudo -H pip install blessings shodan
		sudo apt-get install python-pycurl
		notification "PyParser-CVE was successfully installed."
	fi
	}

function harbinger() 
{	if [[ -d "harbinger" ]]; then
		warning "Harbinger is already installed."
		clear
	else
		notification "Installing Harbinger."
		sleep 1
		git clone https://github.com/exp0se/harbinger.git
		notification "Installing dependencies"
		sleep 1
		sudo -H pip install requests cymon beautifulsoup4
		notification "Harbinger was successfully installed."
	fi
	}

function inquisitor()
{	if [[ -d "inquisitor" ]]; then
		warning "Inquisitor is already installed"
		clear
	else
		notification "Installing Inquisitor..."
		sleep 1
		git clone https://github.com/penafieljlm/inquisitor.git
		notification "Installing dependencies"
		sleep 1
		sudo -H pip install cython
		
		notification "Building..."
		sleep 1
		cwd=$(pwd)
		cd inquisitor
		sudo -H python setup.py install
		cd $cwd
		
		notification "Inquisitor was succesfully installed."
	fi
	}

function Spiderfoot() 
{	if [[ -d "spiderfoot" ]]; then
		warning "Spiderfoot is already installed."
		clear
	else
		notification "Installing Spiderfoot."
		sleep 1
		git clone https://github.com/smicallef/spiderfoot.git
		
		notification "Installing required SSL components."
		sleep 1
		sudo apt-get install libssl-dev
		
		notification "Installing M2Crypto Python OpenSSL wrapper."
		sleep 1
		sudo apt-get install python-m2crypto
		
		notification "Installing remaining python dependencies."
		sleep 1
		
		sudo -H pip install lxml netaddr cherrypy mako requests bs4
		notification "Spiderfoot was successfully installed."
	fi
	}

# List and download function
function list() 
{	printf "\n\n"
	options=("QuickScan" "TadPole" "DNSRecon" "Sublist3r" "TekDefense" "TheHarvester" "IOC-Parser" "PyParser-CVE" "Mimir" "Harbinger" "Inquisitor" "BirdWatcher" "Spiderfoot" "Main Menu")
	PS3='Please enter your choice: '
	select opt in "${options[@]}"
	do
		case $opt in
			"QuickScan")
			    QuickScan
				tools
				printf "%b \n"
				;;
			"TadPole")
			    TadPole
				tools
				printf "%b \n"
				;;
			"DNSRecon")
			    DNSRecon
				tools
				printf "%b \n"
				;;
			"Sublist3r")
			    Sublist3r
				tools
				printf "%b \n"
				;;
			"TekDefense")
			    TekDefense
				tools
				printf "%b \n"
				;;
			"TheHarvester")
			    theHarvester
				tools
				printf "%b \n"
				;;
			"IOC-Parser")
			    ioc_parser
				tools
				printf "%b \n"
				;;
			"PyParser-CVE")
			    pyparser
				tools
				printf "%b \n"
				;;
			"Mimir")
			    mimir_install
				printf "%b \n"
				;;
			"Harbinger")
			    harbinger
				tools
				printf "%b \n"
				;;
			"Inquisitor")
			    inquisitor
				tools
				printf "%b \n"
				;;
			"BirdWatcher")
			    BirdWatcher
				tools
				printf "%b \n"
				;;
			"Spiderfoot")
			    Spiderfoot
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
        QuickScan
        TadPole
        DNSRecon
        Sublist3r
        TekDefense
        theHarvester
        ioc_parser
        pyparser
        harbinger
        inquisitor
        BirdWatcher
        Spiderfoot
	mimir_install
	}

# Function to interact with online OSINT/Threat Intel resources.
function online() 
{	notification_b "Online Resources"
	printf "
+-----------------------+---------------------------------------+
| 1. osintframework.com | Comprehensive OSINT Resource Pool     |
| 2. toddington.com     | Additional OSINT Resource References  | 
| 3. riskdiscovery.com  | Hosts HoneyDB/Aggregates Honeypot Data|
+-----------------------+---------------------------------------+
\n"

	PS3='Please enter your choice: '
	options=("osintframework.com" "toddignton.com" "riskdiscovery.com" "Main Menu")
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
			"toddignton.com")
				notification "Opening toddington.com/resources with Geckodriver..."
				sleep 1.5
				
				# Python one liner in order to open online resource/web application
				python -c "from selenium import webdriver; driver = webdriver.Firefox(); driver.get('https://www.toddington.com/resources/')"
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
{	options=("Help" "List and Install" "Install All" "Specify Install Location" "Online Resources" "Quit")
	PS3='Please enter your choice: '
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

				if [[ $choice == 'y' || $choice == 'Y' ]]; then
					read -p 'Enter target location : ' cwd
					cd $cwd > /dev/null || mkdir $cwd && notification "Directory created." && cd $cwd || warning "Invalid format."
				else
					notification "Using default setting."
				fi
				;;
			"Online Resources")
				gecko=$(which geckodriver)

				case $gecko in
					*/usr/sbin/geckodriver*)
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
					if [[ $choice == 'y' || $choice == 'Y' ]]; then
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

if [[ "$EUID" -ne 0 ]]; then
   warning "It is recommended that this script is run as root"
   printf "Running it without super user privilege may result "
   printf "in the utility failing to install critical components correctly \n"
   
   read -p 'Continue without root? Y/n : ' choice
   if [[ $choice == 'y' || $choice == 'Y' ]]; then
       nix_util
   else
       warning "Aborted"
       exit 1
   fi
else
	nix_util
fi
