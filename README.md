# IntRec-Pack
Intelligence and Reconnaissance Package/Bundle installer.

IntRec-Pack is a Bash script designed to download, install and deploy several quality OSINT, Recon and Threat Intelligence tools. Due to the fact it manages the installation of the various dependencies related to these programs as well it aims to be a comprehensive assistant in setting up your intelligence gathering environment. Below is an overview of the tools and utilities it will help you set up.

```
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
+-----------------------+-------------------------------------------+
```

Furthermore I have included functionality within the Bash script that allows the user to easily pull up two web based resources. Namely [OSINT-Framework](http://osintframework.com) and [HoneyDB](http://riskdiscovery.com/honeydb). The former serves as a curated list of open source intelligence tools, websites and related materials for use as a comprehensive reference guide. While the latter is an OSINT aggregative threat intelligence pool that collects and organizes data provided by HoneyPy honeypots. My [Command Line Interface](https://github.com/NullArray/Mimir) for which is included in the selection of tools available for download with IntRec-Pack as well.

## Usage

Clone the tool from the repo and make it executable like so.

```
git clone https://github.com/NullArray/IntRec-Pack.git
cd IntRec-pack
chmod +x intrec.sh
```
After which it can be started from the command line with `./intrec.sh`. Upon doing so you will be presented with a menu the options for which are as follows:

```
1) Help	                 4) Specify Install Location
2) List and Install      5) Online Resources
3) Install All           6) Quit
```

The **`help`** option displays further usage information and general details about the tool. **`List and Install`** will list all the tools available for download/installation and lets you select the ones you would like. Upon doing so the tool plus it's dependencies will be installed in the current working directory. Unless the **`Specify Install Location`** has been used to provide a path to a custom location. **`Install All`** will download and install all the tools available with this script and **`Online Resources`** will open the web applications previously mentioned.

### Note

Since the **`Online Resource`** features employs functionality derived from Python, Selenium and the Mozilla Geckodriver, I have added some logic to the script that will automatically install the proper version of each component needed in order for the script to function as it should.

While this functionality has been tested and the script is designed to automate as much as possible for ease of use. Should you find you have any issues or perhaps encounter a bug please feel free to [Open a Ticket](https://github.com/NullArray/IntRec-Pack/issues) or [Submit a Pull Request](https://github.com/NullArray/IntRec-Pack/pulls)

Thank you.
