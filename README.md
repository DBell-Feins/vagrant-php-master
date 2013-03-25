Vagrant PHP
===========
This is a [Vagrant](http://www.vagrantup.com) box setup with a LAMP stack and various add-ons.

Requirements:

- Ubuntu 12.0.4.2 LTS (Precise Pangolin) "precise32" base box (http://files.vagrantup.com/precise32.box)

PHP:

- version 5.3
- PEAR packaging system

MySQL:

- username: root
- password: root

Additional packages:

- PHPUnit
- XDebug
- phpMyAdmin
- SQL Buddy

How to use
----------

1) add the packaged box generated from this source code to vagrant 

````
    vagrant box add vagrant-php PATH TO PACKAGE\package.box
````

2) in your project folder, initialize vagrant 

````
    vagrant init
````

3) startup your vagrant virtual machine 

````
    vagrant up
````

4) the "www/public" folder is configured as the default Apache vhost, and accessible through http://localhost:3000 (port 80 has been mapped to port 3000)

5) phpMyAdmin and SQL Buddy are always mapped to the /phpMyAdmin folder and /SQLBuddy folders respectively.

Remarks
-------

Using a MySQL database on your Vagrant setup
********************************************

When destroying a Vagrant virtual machine, all data that has been saved in the virtual machine will be lost. This means that if you choose to use the MySQL database in Vagrant, you should only suspend the virtual machine so you can easily resume it later without loss of data.
Another option is to connect from Vagrant to a MySQL database running on your physical machine.
Your project code is safe since it is accessed using Oracle VirtualBox shared folder functionality (so it is on your physical machine).