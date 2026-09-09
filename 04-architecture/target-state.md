                         INTERNET
                            |
                    Azure Front Door/WAF
                            |
                     Azure Firewall
                            |
                   Azure Hub VNet
                            |
          +-----------------+-----------------+
          |                                   |
     Azure Workloads                    Azure Local
          |                                   |
    +-----+------+                      Factory / Edge
    |            |                           |
 Web/App       Data                      EDGE workloads
    |            |                           |
    |       Azure SQL Services               |
    |                                        |
    +-------------------+--------------------+
                        |
                    Azure Arc
                        |
             Central Azure Management
                        |
       +----------------+----------------+
       |                |                |
   Entra ID        Azure Monitor     Defender/Sentinel
       |
   PIM / MFA
       |
   RBAC
   # Contoso Manufacturing - Target-State Architecture

## 1. Purpose

This document defines the target-state architecture for the Contoso Manufacturing Azure Hybrid Migration engagement.

The design provides a secure, resilient, governed, and supportable hybrid platform using:

- Microsoft Azure
- Azure Local
- Azure Arc
- Microsoft Entra ID
- Azure Virtual Network
- Azure Firewall
- Azure Bastion
- Azure Key Vault
- Microsoft Defender for Cloud
- Microsoft Sentinel
- Azure Monitor
- Log Analytics
- Azure Policy
- Azure Backup
- Azure SQL services
- Privileged Identity Management
- Just-In-Time access
- Hybrid DNS
- VPN and future ExpressRoute capability

The architecture is designed to support phased migration from Azure Stack Hub and Azure Stack Edge while preserving workload dependencies and rollback capability.

---

## 2. Target-State Design Principles

The target architecture follows these principles:

1. Security by design
2. Least privilege
3. Zero-trust administration
4. Hybrid workload flexibility
5. Centralized governance
6. Centralized monitoring
7. Repeatable migration automation
8. Tested backup and recovery
9. Explicit rollback capability
10. Workload placement based on business and technical requirements
11. Segmented networking
12. Identity modernization
13. Secrets centralization
14. Policy-driven compliance
15. High observability

---

## 3. High-Level Target-State Architecture

```text
                            INTERNET
                               |
                               v
                      Azure Front Door / WAF
                               |
                               v
                         Azure Firewall
                               |
                               v
                         HUB VNET
                               |
             +-----------------+-----------------+
             |                                   |
             v                                   v
        AZURE WORKLOADS                     AZURE LOCAL
             |                                   |
     +-------+--------+                     Factory / Edge
     |                |                           |
     v                v                           v
 Web / App          Data                     EDGE01
     |                |                           |
     |          Azure SQL Services                |
     |                                            |
     +-------------------+------------------------+
                         |
                         v
                      Azure Arc
                         |
                         v
                Central Azure Management
                         |
      +------------------+------------------+
      |                  |                  |
      v                  v                  v
 Microsoft Entra ID   Azure Monitor    Defender / Sentinel
      |
      v
 PIM / MFA / RBAC