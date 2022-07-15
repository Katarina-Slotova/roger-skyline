# roger-skyline
Hive Helsinki school project focusing on initiation to system and network administration. I installed a Virtual Machine, learned about the basics about system and network administration, configured a web server, protected it from DOS attacks and port scans and wrote a simple deployment script. All of the work was done on Debian machine.

You can follow this step-by-step guide if you need help setting up your web server! I included few tips to make the work a bit easier.

### Setting up the VM
  1. For the project, we will need 8GB (fixed size) virtual hard drive. Do the disk partitioning with one part of precisely 4.2GB (1 GB for swap and the rest for the third part).

<hr>

### Getting the installations & initial configs done
  2. Install sudo, it is not pre-installed (su -> apt-get update -> apt-get upgrade -y -> apt-get install sudo -y)
  3. Check disk partitioning with parted-command
     - Install parted, it is not pre-installed (sudo apt-get)
     - Run “sudo parted” command
     - Run “print” to see partitions
     - For seeing partitions displayed in specific unit, run “unit GB/GiB print” (*Something to pay attention to: If partitions checked with lsblk, they         display sizes in GiB, NOT GB*). 
  4. Create a non-root user to connect to the VM. Use sudo, with this user, to be able to perform operations requiring special rights.
      - Modify user privileges in sudoers file located in ~/etc/sudoers
      - First, temporarily change the permissions of this file (initially, it only has read right) by using “chmod +w sudoers”
      - Open sudoers file with nano, go to user privileges and add: username ALL=(ALL:ALL) ALL to have superuser privileges (like root)
      - Put the permissions back to only read with “chmod -w sudoers”
      - Exit root
  5. Install the net-tools package, which contains network tools (like ip, ifconfig, …) with “sudo apt-get install -y net-tools”

<hr>

### Setting up a static IP address
  6. First, find the name of your network device with “ip -c link show”
     - ip - net-tool used for configuring network interfaces
     - -c - shows the result in pretty colors, so it’s easier to read (optional)
     - link show - Shows the state of all network interfaces on the system
  7. From the result, it is possible to see at least two devices (*lo for loopback device - typically used for diagnostics and troubleshooting AND            another one, with name like enp0s3*).
  8. Now configure the enp0s3 device to use a specified static IP address, such as 10.13.15.16.
     - The first part 10.13 refers to Hive computers located in cluster 3
     - The third part would specify row
     - The fourth part would specify computer 
     - Since there are 5 rows with 6 PC in each, it is safe to use 15 and 16
  9. Location of network configuration: /etc/networks/interfaces file. As the primary network interface, I set “auto enp0s3”. 
  10. It is better to set your own configuration in a separate file located in configurations.d directory. The interfaces file will load whatever               additional config file stored there. In the /etc/networks/interfaces.d directory, create a separate file called enp0s3.conf. In that file, it is         necessary to add:
      ```
      *iface enp0s3 inet static
      address 10.13.15.16
      netmask 255.255.255.252 (netmask must be set to /30, this specifies the correct netmask: https://www.aelius.com/njh/subnet_sheet.html)
      gateway 10.13.254.254 (find the gateway with route -n get default | grep "gateway" | cut -d ":" -f2)*
      ```
  11. To apply the changes, restart the networking service with “sudo systemctl restart networking”.
  12. To check if the changes are applied, check the static IP with  ```ip a```.

<hr>

### SSH
  13. Turn off password authentication by <u>first</u>: copying public key from VM on the host system using command (in Mac terminal, not VM terminal):      ssh-copy-id -i id_rsa.pub katarina@static_IP_address -p 22 (in my case, static IP address is 10.13.15.16) –> this is necessary to connect to the VM      later without password; and <u>second</u> (optional) if there is a warning coming up, add VM’s fingerprint to the host system: 
```
ssh-keyscan -H 10.13.11.14 >> ~/.ssh/known_hosts
```
  14. Edit sshd_config file on VM by:
    - changing the permissions for the file: sudo chmod +w sshd_config
    - modify two following lines in the file:
    ```
    PasswordAuthentication no
    ```
    <br/>
    ```
    PubkeyAuthentication yes
    ```
    <br/>
    - remove the root login by changing ```PermitRootLogin``` to no
    - change port number in the same file to anything between 49152–65535 (these ports are used for private or customized services, for temporary             purposes, etc.). I changed it to 49999.
  15. Remove the write permission for the file with ```sudo chmod -w sshd_config```.
  16. Restart the service with ```sudo service ssh restart``` to apply changes.
  17. Log in to VM from iTerm using command: ```ssh -p 49999 katarina@10.13.15.16```.
  
  <hr>

