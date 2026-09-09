# Contoso Manufacturing - Current-State Architecture

## 1. Purpose

This document describes the current-state architecture for the Contoso Manufacturing Azure Hybrid Migration engagement.

The objective is to establish an accurate technical baseline before designing the target architecture or executing migration activities.

---

## 2. Current Environment Overview

Contoso Manufacturing currently operates workloads across:

- Azure Stack Hub
- Azure Stack Edge
- Hybrid network connectivity
- Active Directory
- Microsoft Entra ID
- Enterprise backup infrastructure
- Central monitoring infrastructure
- Microsoft SQL Server
- Windows Server workloads
- Linux workloads
- Factory edge workloads

The current environment supports customer-facing applications, internal business systems, identity services, monitoring, backup, databases, and manufacturing edge workloads.

---

## 3. High-Level Current-State Architecture

```text
                         INTERNET
                            |
                            |
                     Perimeter Firewall
                            |
                            |
                    Azure Stack Hub
                            |
        +-------------------+-------------------+
        |                   |                   |
        |                   |                   |
    WEB-SUBNET          APP-SUBNET          DB-SUBNET
   10.10.10.0/24       10.10.20.0/24       10.10.30.0/24
        |                   |                   |
   WEB01 / WEB02       APP01 / APP02           DB01
        |                   |                   |
        +-------------------+-------------------+
                            |
                            |
                  IDENTITY-SUBNET
                   10.10.40.0/24
                            |
                       AD01 / AD02
                            |
                    DNS / Kerberos
                     LDAP / NTLM

                            |
                            |
                     MGMT-SUBNET
                   10.10.50.0/24
                            |
                      MGMT01 / MON01

                            |
                            |
                    BACKUP-SUBNET
                   10.10.60.0/24
                            |
                         BACKUP01


------------------------------------------------------------


                    AZURE STACK EDGE
                            |
                        EDGE01
                            |
                    Factory Devices
                            |
                    Local Processing
                            |
                    Cloud Synchronization
                            |
                           Azure