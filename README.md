# dq-packer-ansible

This simply takes Hashicorp's Packer, adds Ansible v2.4.6.0 and publishes the Docker image to quay.io.

## Packages
As this is the Docker image that is used to do all of our Packer/Ansible builds 
(e.g. `dq-packer-tableau-linux`), we add several Alpine Packages (e.g. krb5-dev) 
so that they do not need to be included in several `dq-packer-*` repos.

## Vulnerabilities
We base our "packer-ansible" image on Hashicorp's latest "Packer" Docker image. <br>
However, their image is not updated very frequently (at time of writing it is 3 months old)
therefore vulnerabilities will creep in. <br>
We attempt to fix these by updating and upgrading the Alpine packages. <br>
However, some (e.g. golang) do not appear to be resolvable so they are added to the `.trivyignore` file. <br>
These counter-measures (added packages and ignorefile) should be revisited every month 
when our routine vulnerability process is run.

