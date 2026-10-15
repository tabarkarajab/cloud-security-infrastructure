# cloud-security-infrastructure
A multi-cloud security project integrating AWS and DigitalOcean through a WireGuard site-to-site VPN, with a private database, public web service, network segmentation, IDS/IPS, WAF, Infrastructure as Code, CI/CD, security hardening, and cost monitoring.

## Project Overview

This project implements a secure multi-cloud architecture using **Amazon Web Services (AWS)** and **DigitalOcean** for the Cloud Computing Security course.

The objective is to establish secure communication between two cloud providers while implementing network segmentation, access control, intrusion detection, web application protection, automated deployment, and infrastructure management.

## Cloud Architecture

* **Provider A — Microsoft Azure:** Hosts the private PostgreSQL database and the first VPN gateway.

<img width="1665" height="1199" alt="image" src="https://github.com/user-attachments/assets/e63c1fef-639d-421c-b2ed-91f218ae003c" />

* **Provider B — DigitalOcean:** Hosts the public web service and the second VPN gateway.
* **Site-to-Site VPN:** WireGuard provides an encrypted connection between the two cloud networks.
* **Database connectivity:** The web service accesses the private database through the VPN tunnel.
* **Web Application Firewall (WAF):** Protects the web service against common web attacks, including SQL injection.
* **IDS/IPS:** Monitors and, where configured, blocks suspicious traffic targeting the VPN endpoints.

## Security Requirements

The implementation follows the principle of least privilege:

* The database is not directly accessible from the public Internet.
* Only required network ports and connections are permitted.
* The VPN gateways communicate through a restricted set of firewall rules.
* The web service is publicly accessible over HTTPS.
* Administrative access is restricted.
* Services are hardened using appropriate cloud and operating-system security controls.

## Automation and Deployment

* **Infrastructure as Code:** Terraform is used to define and manage cloud infrastructure where supported.
* **Configuration management:** Ansible may be used to configure and harden the virtual machines.
* **CI/CD:** GitHub Actions automates application testing and deployment.
* **Cost monitoring:** AWS Budgets and DigitalOcean spending alerts are used where available to monitor expenditure.

## Technology Stack

* Amazon Web Services (AWS)
* DigitalOcean
* WireGuard
* PostgreSQL
* Python and Flask
* Nginx
* ModSecurity and OWASP Core Rule Set
* Suricata
* Terraform
* Ansible
* GitHub Actions
* Docker, if used

## Documentation

The project report documents the architecture, implementation steps, configuration decisions, security controls, validation tests, screenshots, limitations, and detailed cost breakdown.

## Project Status

Implementation and validation are documented as the project progresses. Features are marked as completed only after they have been configured and tested.

