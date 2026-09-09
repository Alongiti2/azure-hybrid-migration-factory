# Contoso Manufacturing - Identity and Security Design

## 1. Purpose

This document defines the target identity and security architecture for the Contoso Manufacturing Azure Hybrid Migration Factory.

The goal is to secure the migration from Azure Stack Hub and Azure Stack Edge into a modern hybrid architecture using:

- Microsoft Entra ID
- Active Directory
- Multi-Factor Authentication
- Conditional Access
- Privileged Identity Management
- Azure RBAC
- Managed Identities
- Group Managed Service Accounts where appropriate
- Azure Key Vault
- Microsoft Defender for Cloud
- Microsoft Defender for Endpoint
- Microsoft Sentinel
- Log Analytics
- Azure Policy
- Azure Bastion
- Just-In-Time access
- Centralized logging
- Zero Trust principles

---

## 2. Identity and Security Design Principles

The target design follows these principles:

1. Verify explicitly
2. Use least privilege
3. Assume breach
4. Require MFA for privileged access
5. Remove unnecessary standing privileges
6. Centralize secrets and keys
7. Prefer managed identities over passwords
8. Minimize legacy authentication
9. Centralize security logging
10. Use policy-driven governance
11. Secure hybrid identities
12. Separate administrative duties
13. Protect emergency access
14. Validate security before every migration wave
15. Preserve auditability during migration

---

## 3. High-Level Identity Architecture

```text
                    Microsoft Entra ID
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
         MFA              PIM        Conditional Access
          |                |                |
          +----------------+----------------+
                           |
                           v
                        Azure RBAC
                           |
                           v
                Azure / Azure Local / Arc
                           |
                           v
                   Active Directory
                           |
              +------------+------------+
              |                         |
             AD01                      AD02
              |                         |
              +------------+------------+
                           |
                    DNS / Kerberos
                    LDAP / Legacy Auth
                    4. Microsoft Entra ID Strategy

Microsoft Entra ID will serve as the strategic identity control plane for:

Azure portal access
Azure RBAC
Administrative authentication
MFA
Conditional Access
Privileged Identity Management
Managed identities
Service principals
Workload identities
Azure Local management
Azure Arc management

Where supported, cloud resources should authenticate through Entra ID rather than static credentials.

5. Active Directory Coexistence

Active Directory remains required because current workloads depend on:

Kerberos
LDAP
NTLM
Domain authentication
Service accounts
DNS
SQL integrated authentication
Windows server authentication

Current domain controllers:

AD01
AD02

During coexistence:

Preserve AD01 and AD02
Maintain DNS availability
Validate replication
Monitor domain controller health
Preserve time synchronization
Preserve Kerberos
Reduce NTLM gradually
Review LDAP dependencies
Use LDAPS where required

Do not retire Active Directory until dependency analysis confirms all workloads are ready.

6. Authentication Modernization

Legacy authentication should be reduced.

Priority review areas:

NTLM
LDAP
Local Accounts
Static Passwords
SQL Authentication
Service Account Passwords

Preferred target authentication:

Microsoft Entra ID
Managed Identity
Kerberos where required
gMSA where required
Certificate-based authentication where appropriate
7. Multi-Factor Authentication

MFA should be mandatory for:

Azure administrators
Subscription owners
Security administrators
Privileged role activation
Break-glass governance review
Sensitive administrative operations

Migration administrators should not perform privileged operations using password-only authentication.

8. Conditional Access

Conditional Access should be used to control access based on:

User identity
Role
Device
Location
Sign-in risk
Application
Authentication strength

Recommended baseline:

Require MFA for administrators
Block legacy authentication where possible
Require stronger authentication for sensitive roles
Protect Azure management access
Monitor risky sign-ins

Emergency accounts must be excluded only where necessary and tightly controlled.

9. Privileged Identity Management

Use Microsoft Entra Privileged Identity Management for privileged Azure roles.

Target model:

Administrator
     |
     v
Eligible Role
     |
     v
MFA
     |
     v
Role Activation
     |
     v
Time-Limited Privilege
     |
     v
Administrative Task

Avoid permanent Owner and Contributor assignments unless operationally justified.

10. Azure RBAC

Use Azure RBAC to control permissions.

Recommended role separation:

Platform Administrators
Network Administrators
Security Administrators
Identity Administrators
Database Administrators
Application Teams
Monitoring Team
Backup Team
Migration Team
Auditors

Use built-in roles where practical.

Create custom roles only when built-in roles cannot meet the requirement.

11. Least Privilege Model

Permissions should be assigned at the narrowest practical scope:

Management Group
      |
      v
Subscription
      |
      v
Resource Group
      |
      v
Resource

Avoid assigning subscription-wide privileges for tasks that only require resource-group access.

12. Administrative Role Separation

Separate high-risk responsibilities.

Example:

Role	Responsibility
Identity Administrator	Identity and authentication
Security Administrator	Security controls
Network Administrator	Network configuration
Database Administrator	Database administration
Application Administrator	Application services
Backup Administrator	Recovery services
Migration Engineer	Migration execution
Auditor	Read-only review

This reduces the risk of excessive administrative authority.

13. Break-Glass Accounts

Maintain emergency access accounts for identity emergencies.

Requirements:

Cloud-only accounts
Strong credentials
Not used for normal administration
Highly monitored
Access reviewed regularly
Credentials stored securely
Alert on every sign-in
Document emergency procedure

Emergency accounts should not become normal administrative accounts.

14. Service Account Strategy

Current service accounts present significant migration risk.

Examples include accounts used by:

APP01
APP02
API01
MON01
BACKUP01
Database services

For each service account document:

Owner
Purpose
Permissions
Password age
Rotation process
Dependencies
Logon rights
Interactive logon status
15. Service Account Modernization

Preferred target order:

1. Managed Identity
2. Workload Identity
3. gMSA
4. Restricted Service Account
5. Static Password only when unavoidable

Static credentials should be minimized.

16. Managed Identities

Use managed identities for supported Azure resources.

Potential use cases:

Applications accessing Key Vault
Automation scripts
Azure services
Monitoring components
Deployment automation

Benefits:

No password storage
Automatic credential lifecycle
Azure RBAC integration
Reduced secret exposure
17. Azure Key Vault

Azure Key Vault should become the centralized platform for:

Passwords
API secrets
Certificates
Encryption keys
Application secrets
Deployment secrets where appropriate

Architecture:

Application
    |
    v
Managed Identity
    |
    v
Azure Key Vault
    |
    v
Secret / Certificate / Key
18. Key Vault Security

Key Vault should use:

Private networking where appropriate
RBAC
Soft delete
Purge protection
Logging
Alerts
Managed identities
Rotation
Least privilege

Avoid hard-coded secrets in application configuration.

19. Secret Migration Process

Before migrating an application:

Inventory existing credentials
Identify application owner
Determine target secret model
Create Key Vault secret
Configure managed identity where possible
Rotate old credentials
Test application access
Remove plaintext secrets
Monitor access
Document rollback
20. Certificate Security

Create an inventory of:

TLS certificates
Application certificates
Client certificates
Code-signing certificates
Internal PKI certificates

Track:

Subject
Issuer
Expiration
Owner
Key length
Algorithm
Application dependency

Certificate expiration must not disrupt migration.

21. Microsoft Defender for Cloud

Microsoft Defender for Cloud should provide:

Security posture management
Recommendations
Secure score
Regulatory compliance view
Defender plans
Workload protection
Security alerts

Use Defender for Cloud across:

Azure VMs
Azure SQL
Storage
Azure Local where supported
Arc-enabled servers where supported
22. Defender for Endpoint

Microsoft Defender for Endpoint should protect supported servers and endpoints.

Migration requirements:

Confirm agent deployment
Confirm sensor health
Confirm policy assignment
Confirm endpoint visibility
Confirm alert generation
Confirm no monitoring gap during cutover
23. Microsoft Sentinel

Microsoft Sentinel will provide centralized SIEM and security analytics.

Architecture:

Identity Logs
Server Logs
Azure Logs
Firewall Logs
Application Logs
Database Logs
Defender Alerts
Azure Local Logs
      |
      v
Log Analytics
      |
      v
Microsoft Sentinel
      |
      v
Security Operations
24. Security Logging

Collect at minimum:

Azure Activity Logs
Microsoft Entra sign-in logs
Entra audit logs
Windows security logs
Linux syslog
Firewall logs
Application Gateway logs
Azure SQL auditing
Key Vault logs
Defender alerts
Backup logs
Azure Arc logs
Azure Local security events

Retention should follow business, security, and compliance requirements.

25. Security Monitoring

Security Operations should monitor:

Failed logins
Privileged-role activation
Suspicious sign-ins
New administrator assignments
Firewall anomalies
Endpoint threats
Malware
Vulnerability findings
Key Vault access anomalies
Security policy violations
Unusual data access
26. Azure Policy

Use Azure Policy for preventive and detective controls.

Potential policies:

Require diagnostic settings
Require tags
Restrict public IPs
Restrict deployment regions
Require secure transfer
Require encryption
Require Defender plans
Require private endpoints where appropriate
Restrict unsupported SKUs
Audit missing backup
Audit insecure configurations
27. Security Baseline

All target workloads should meet a security baseline before production cutover.

Baseline areas:

Identity
Network
Compute
Database
Secrets
Logging
Monitoring
Backup
Encryption
Patch Management
Endpoint Protection
28. Azure Bastion

Azure Bastion should be the preferred administrative access path for supported Azure VMs.

Target model:

Administrator
    |
    v
Entra Authentication
    |
    v
MFA / PIM
    |
    v
Azure Bastion
    |
    v
Private VM

Avoid direct public RDP and SSH exposure.

29. Just-In-Time Access

Use Just-In-Time access where supported.

Purpose:

Reduce exposure of administrative ports
Permit access only when requested
Limit access duration
Limit source IP
Improve auditability
30. Vulnerability Management

Before migration:

Perform vulnerability scan
Review critical findings
Review high findings
Patch supported systems
Document exceptions
Re-test remediation

Do not move known critical vulnerabilities into the target without explicit risk acceptance.

31. Patch Management

Target patch management should use standardized processes.

Potential platform:

Azure Update Manager

Track:

Missing patches
Critical updates
Reboot requirements
Maintenance windows
Compliance status
32. Security of Migration Automation

Migration automation must not expose credentials.

GitHub repository rules:

Never commit passwords
Never commit API keys
Never commit private keys
Never commit database passwords
Never commit production certificates
Never commit connection strings containing secrets

Use:

GitHub encrypted secrets where necessary
OIDC / workload identity where possible
Azure Key Vault
Managed identities
33. GitHub Security

Recommended controls:

Branch protection
Pull requests for production changes
Code review
Secret scanning
Dependency scanning
Dependabot
Limited repository privileges
Protected environments
Approval gates
34. Infrastructure-as-Code Security

Bicep and automation should be reviewed for:

Excessive permissions
Public exposure
Open NSG rules
Hard-coded secrets
Unencrypted resources
Missing logging
Missing backup
Unsupported regions
Incorrect resource scope
35. Database Security

Target database security should include:

Private connectivity
Entra authentication where supported
TLS
Encryption at rest
Auditing
Restricted firewall access
Defender for SQL
Backup
Recovery testing
Least privilege
36. Network Security Integration

Identity and network security must work together.

Administrative traffic:

Admin
 |
 v
Entra ID
 |
 v
MFA/PIM
 |
 v
Bastion
 |
 v
Private Network
 |
 v
Target Resource

Application traffic must follow the approved network flow matrix.

37. Data Protection

Data protection controls should consider:

Data classification
Encryption
Key management
Retention
Backup
DLP
Logging
Access control
Data residency

Microsoft Purview may be used where appropriate.

38. Encryption

Require encryption:

At Rest

For:

Disks
Databases
Backups
Storage
Secrets
In Transit

Use:

TLS
HTTPS
LDAPS where required
Encrypted VPN/ExpressRoute-associated controls where applicable

Deprecated cryptographic protocols should be removed where possible.

39. Incident Response

Migration-specific incident-response procedures should define:

Incident owner
Severity
Communication
Evidence preservation
Containment
Escalation
Recovery
Rollback decision
Post-incident review
40. Security During Migration Waves

Before every migration wave verify:

MFA
PIM
RBAC
Defender
Monitoring
Logging
Key Vault
Network controls
Backup
Vulnerability status
Patch status
Rollback readiness
41. Security Migration Gates

A workload cannot migrate when:

Critical vulnerability is unresolved
Backup is invalid
Rollback is unavailable
Required logging is unavailable
Privileged access is uncontrolled
Required secret migration is incomplete
Network security validation fails
Identity validation fails
Business approval is missing
42. Pre-Migration Security Checklist

Before cutover:

 Application owner identified
 Security owner identified
 MFA enabled
 Privileged roles reviewed
 Service accounts reviewed
 Secrets migrated
 Certificates validated
 Vulnerabilities reviewed
 Critical patches installed
 Logging enabled
 Defender enabled
 Sentinel integration confirmed
 Backup validated
 Rollback tested
 Firewall rules validated
 DNS validated
43. Post-Migration Security Validation

After migration confirm:

Authentication works
MFA works
RBAC works
PIM works
Application identities work
Key Vault access works
Logging works
Defender reports healthy
Sentinel receives logs
Endpoint security is active
Network security rules work
No unintended public exposure exists
44. Security Rollback

If security validation fails:

Target Workload
      |
      v
Security Validation Failure
      |
      v
Stop Cutover
      |
      v
Restore Source Path
      |
      v
Validate Security

Security failures may independently trigger migration rollback.

45. Target Security Outcome

The target state should provide:

Strong authentication
Least privilege
Time-limited privileged access
Managed identities
Centralized secrets
Centralized logs
Cloud security posture management
SIEM integration
Endpoint protection
Policy enforcement
Secure hybrid identity
Auditable administration
Reduced legacy authentication
Secure migration automation
46. Next Deliverable

After the identity and security design is complete, create:

07-automation/automation-design.md

That document will define:

Azure CLI
PowerShell
Bicep
GitHub Actions
deployment validation
secure authentication
repeatable migration automation
rollback automation