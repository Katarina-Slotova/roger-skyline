## Evaluation commands

- check that __docker__, etc is not installed: 
  ```sudo apt list --installed  | grep 'docker\|vagrant\|traefik'```
- check disk __partitions__: 
  ```run sudo parted command```
- see __partitions__ displayed in specific unit
  ```unit GB/GiB print```
- check if __packages__ are up to date
  ```sudo apt-get upgrade```
- which packages are installed:
  ```sudo apt list --installed | less```
- create a new user:
  - while logged in as non-root user (yourself) on VM (not iTerm), run ```sudo adduser <NEW_USER_NAME>```
  - then run ```su -``` 
    - NOTE: dash is very importnat here to have completely new environment variables, otherwise the new user inherits the variables from the original user
    - give privileges to new user with ```sudo usermod -aG sudo <NEW_USER_NAME>```
    - log in with the new user’s credentials and run the commands below to copy the public key to the new user’s .ssh directory, then give permissions to the file
      - ```mkdir ~/.ssh```
      - ```sudo cp /home/katarina/.ssh/authorized_keys /home/new_user/.ssh/```
      - ```sudo chmod 644 /home/new_user/.ssh/authorized_keys```
      - connect from iTerm with the new user’s credentials
- for __DHCP__ service:
  - show with ```ip a```
  - then show also enp0s3.conf file, should say static in there
- changing the __netmask and IP__:
  - go [here](https://jodies.de/ipcalc) and calculate how to change the netmask and what IP addresses range is available
  - check if chosen IP address in available and not in use by someone else by pinging it ```ping <IP_GOES_HERE>```
  - change the netmask and IP address in ```/etc/network/interfaces.d``` in the enp0s3 file 
  - restart networking: ```sudo systemctl restart networking```
  - check with ```ip a``` that the netmask and IP address are changed
  - log in via iTerm to see if it works on the guest side, too
  - once all is checked and OK, change the netmask and IP address back to th eoriginal ones, otherwise setting for DOS, etc. will not work
- check __SSH__ port, public key auth, no password and no root login possibility
  - see in the ```/etc/ssh/sshd_config``` file
- check __firewall__ rules:
  ```sudo ufw status```
- __DOS__
  - use slowloris
  - to unban IP: ```sudo fail2ban-client set http-get-dos unbanip <YOUR_IP_HERE>```
- check open __ports__
  ```sudo netstat -tulpn```
- list enabled __services__
  ```sudo systemctl list-unit-files --type service --state=enabled```
- scheduled update in __cron__
  ```cat /usr/local/bin/update.sh```
  ```sudo crontab -e```
- monitor cron changes
	```cat /usr/local/bin/monitor_cron.sh```
  ```sudo crontab -e```
	- make a modification by opening crontab in nano/vim
  ```crontab -e```
	- add a task to check for modif upon reboot
	- reboot the machine with ```sudo reboot```
  - run ```mail``` to see if email was received
- self-signed __SSL__ on all services
	- show ```/etc/nginx/snippets/self-signed.conf``` file
  - also show in the browser, when you open your website, when you click on “Not secured” in the address line
- check that web server is not __listening_ on default localhost
	- in here: /etc/nginx/sites-enabled, in default file 
  - ```netstat --listening```
