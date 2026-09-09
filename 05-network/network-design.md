# Contoso Manufacturing - Target Network Design

## 1. Purpose

This document defines the target network architecture for the Contoso Manufacturing Azure Hybrid Migration Factory.

The objective is to provide secure, segmented, resilient, observable, and migration-ready connectivity between:

- Microsoft Azure
- Azure Local
- Existing Azure Stack Hub workloads during transition
- Azure Stack Edge / factory workloads
- Active Directory and DNS
- Application tiers
- Databases
- Monitoring
- Backup
- Administrative services

---

## 2. Target Network Design Principles

The network design follows these principles:

1. Hub-and-spoke architecture
2. Segmentation by workload function
3. Deny-by-default security posture
4. Private connectivity wherever practical
5. Centralized firewall inspection
6. Centralized hybrid connectivity
7. Private DNS integration
8. Controlled administrative access
9. Explicit routing
10. High observability
11. Migration coexistence support
12. Reversible cutover
13. Least-privilege network access
14. No direct public database exposure
15. Scalable address planning

---

## 3. High-Level Network Architecture

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
                      10.100.0.0/16
                            |
          +-----------------+------------------+
          |                 |                  |
          v                 v                  v
     WEB SPOKE          APP SPOKE          DATA SPOKE
   10.110.0.0/16      10.120.0.0/16      10.130.0.0/16
          |                 |                  |
       WEB01             APP01               SQL
       WEB02             APP02
                          API01

                            |
                            |
                    Hybrid Connectivity
                            |
                  VPN / ExpressRoute
                            |
                            v
                        Azure Local
                            |
                          EDGE01
                            |
                     Factory Devices 
                     4. Address Space Plan

Recommended target address spaces:

Network	CIDR	Purpose
Hub VNet	10.100.0.0/16	Shared services and hybrid connectivity
Web Spoke	10.110.0.0/16	Web workloads
App Spoke	10.120.0.0/16	Application and API workloads
Data Spoke	10.130.0.0/16	Databases and private endpoints
Management Spoke	10.140.0.0/16	Administration and monitoring
Security Spoke	10.150.0.0/16	Security tooling if required
Azure Local	10.200.0.0/16	Local hybrid workloads
Factory Edge	10.20.0.0/16	Existing edge network during transition

Existing source environment:

10.10.0.0/16

Existing edge environment:

10.20.0.0/16

No overlapping IP ranges should exist between source and target networks.

5. Hub VNet

Recommended:

10.100.0.0/16

The Hub VNet will provide shared network services.

Suggested subnets:

Subnet	CIDR	Purpose
AzureFirewallSubnet	10.100.1.0/24	Azure Firewall
AzureBastionSubnet	10.100.2.0/26	Azure Bastion
GatewaySubnet	10.100.3.0/27	VPN / ExpressRoute Gateway
DNS-Resolver-Inbound	10.100.4.0/28	DNS inbound resolver
DNS-Resolver-Outbound	10.100.5.0/28	DNS outbound resolver
Shared-Services	10.100.10.0/24	Shared network services
6. Web Spoke

Recommended:

10.110.0.0/16

Suggested subnets:

Subnet	CIDR	Purpose
Web-Frontend	10.110.10.0/24	Web servers
AppGateway	10.110.20.0/24	Application Gateway
PrivateEndpoints-Web	10.110.30.0/24	Web-tier private endpoints

Workloads:

WEB01
WEB02

Primary allowed traffic:

Internet
   |
   v
Front Door / WAF
   |
   v
Application Gateway
   |
   v
WEB01 / WEB02
7. Application Spoke

Recommended:

10.120.0.0/16

Suggested subnets:

Subnet	CIDR	Purpose
App-Servers	10.120.10.0/24	APP01 / APP02
API-Servers	10.120.20.0/24	API01
App-PrivateEndpoints	10.120.30.0/24	Application private endpoints

Workloads:

APP01
APP02
API01

Primary dependencies:

Web tier
Database tier
DNS
Identity
Key Vault
Monitoring
8. Data Spoke

Recommended:

10.130.0.0/16

Suggested subnets:

Subnet	CIDR	Purpose
Data-Services	10.130.10.0/24	Data workloads
SQL-PrivateEndpoints	10.130.20.0/24	Azure SQL private endpoints
Backup-Endpoints	10.130.30.0/24	Backup-related endpoints

Potential workloads:

Azure SQL Managed Instance
Azure SQL Database private endpoints
Azure Database for PostgreSQL private connectivity

No database service should require direct public Internet exposure.

9. Management Spoke

Recommended:

10.140.0.0/16

Suggested subnets:

Subnet	CIDR	Purpose
Management	10.140.10.0/24	Management services
Monitoring	10.140.20.0/24	Monitoring tools
Automation	10.140.30.0/24	Automation runners

Administrative access should flow through:

Administrator
     |
     v
Microsoft Entra ID
     |
     v
MFA / PIM
     |
     v
Azure Bastion
     |
     v
Private Workload
10. Azure Firewall

Azure Firewall should provide centralized traffic inspection.

Primary responsibilities:

North-south traffic control
East-west traffic control where appropriate
Hybrid traffic inspection
Egress filtering
Application rules
Network rules
Threat intelligence
Central logging

Recommended principle:

Default deny

Allow only required traffic.

11. Firewall Rule Categories
Internet Inbound

Permit only approved public entry points.

Examples:

HTTPS 443 to WAF / Application Gateway
No direct RDP
No direct SSH
No direct database access
Internet Outbound

Allow only approved destinations where practical.

Examples:

Azure service endpoints
Microsoft security services
Package repositories
Approved SaaS services
Hybrid Traffic

Allow only required source-to-target migration and application flows.

Examples:

DNS
Kerberos
LDAP/LDAPS
SQL
HTTPS
Monitoring
Backup
Azure Arc
Migration replication
12. Network Security Groups

Each workload subnet should have its own NSG.

Recommended NSGs:

nsg-web
nsg-app
nsg-api
nsg-data
nsg-management
nsg-monitoring
nsg-backup

Do not reuse broad NSGs across unrelated tiers unless intentionally designed.

13. Web NSG Rules

Example inbound rules:

Priority	Source	Destination	Port	Action
100	Application Gateway	Web subnet	443	Allow
200	Management subnet	Web subnet	Required admin ports	Allow
4096	Any	Any	Any	Deny

Example outbound rules:

Destination	Port	Purpose
App subnet	443	Application traffic
DNS	53	Name resolution
Monitoring	Required	Telemetry
14. Application NSG Rules

Expected flows:

Web Tier
   |
   v
Application Tier
   |
   v
Database Tier

Allow only necessary communication.

Example:

Source	Destination	Port
Web subnet	App subnet	443
App subnet	DB services	1433
App subnet	DNS	53
App subnet	AD	88 / 389 / 636
App subnet	Key Vault	443
15. Data NSG Rules

Data tier rules should be highly restrictive.

Allow only:

Application subnet
API subnet where required
Approved management services
Backup services
Monitoring services

Block direct Internet access.

16. User Defined Routes

UDRs should direct traffic through approved security controls.

Example:

0.0.0.0/0
   |
   v
Azure Firewall

Spoke-to-spoke traffic may also be forced through centralized inspection depending on security requirements.

17. VNet Peering

Peer:

Hub <-> Web
Hub <-> App
Hub <-> Data
Hub <-> Management

Use hub routing for centralized security.

Avoid uncontrolled spoke-to-spoke connectivity.

18. Hybrid Connectivity

Initial migration connectivity:

Site-to-Site VPN

Potential long-term enterprise option:

ExpressRoute

Decision factors:

Bandwidth
Latency
Availability
Cost
Data-transfer volume
Application sensitivity
Migration duration
19. VPN Requirements

Validate:

Encryption
Tunnel availability
Throughput
Latency
Packet loss
Routing
BGP where applicable
Redundancy
Monitoring

The VPN must support migration coexistence.

20. ExpressRoute Consideration

ExpressRoute should be considered if Contoso requires:

Predictable latency
Higher throughput
Greater reliability
Large migration datasets
Long-term hybrid connectivity

ExpressRoute should not be assumed automatically.

A cost and performance assessment is required.

21. Hybrid DNS

Target DNS design:

Azure Workloads
      |
      v
Azure Private DNS
      |
      v
Azure DNS Private Resolver
      |
      v
On-Premises AD DNS

Requirements:

Azure-to-on-prem resolution
On-prem-to-Azure resolution
Private Endpoint DNS
Active Directory DNS
Application DNS
Reverse lookup where required
22. DNS Cutover Strategy

DNS changes must be reversible.

Before migration:

Reduce TTL where appropriate
Validate target records
Test target resolution
Document rollback record
Confirm propagation
Monitor queries

During cutover:

Source DNS Record
       |
       v
Target Endpoint

If validation fails:

Target DNS Record
       |
       v
Restore Source Endpoint
23. Private DNS Zones

Potential private DNS zones include Azure Private Link zones for supported services.

Private zones must be linked only to required VNets.

Resolution paths must be tested before production migration.

24. Private Endpoints

Use Private Endpoints for services such as:

Azure SQL
Key Vault
Storage
Backup-related services where supported
Other supported PaaS services

Objective:

Workload -> Private IP -> Azure Service

rather than public Internet access.

25. Azure Bastion

Use Azure Bastion for controlled administrative access.

Architecture:

Administrator
    |
    v
Azure Portal
    |
    v
Azure Bastion
    |
    v
Private VM

Benefits:

No public RDP IP required
No public SSH IP required
Central administrative entry point
26. Administrative Security

Administrative network controls should require:

MFA
Privileged Identity Management
Time-limited role activation
Bastion
Logging
Approved devices if Conditional Access requires it
Least privilege
27. Azure Local Connectivity

Azure Local network:

10.200.0.0/16

Azure Local should connect securely to Azure for:

Azure Arc
Policy
Monitoring
Security
Management
Updates where applicable

Factory workloads must retain local connectivity.

28. Factory Edge Connectivity

EDGE01 requires connectivity to:

Factory devices
Local storage
Local applications
Azure synchronization endpoints
Monitoring
Management

Critical principle:

Cloud connectivity loss must not stop required local factory processing.
29. Azure Arc Network Requirements

Arc-enabled resources require outbound connectivity to required Azure endpoints.

Do not allow unrestricted Internet access only because Arc requires connectivity.

Use controlled outbound access.

30. Migration Network Flows

Migration may require:

Replication traffic
Azure management endpoints
DNS
Identity
Monitoring
Backup
API traffic
Database synchronization

All flows should be documented before execution.

31. Migration Flow Matrix

Example:

Source	Destination	Protocol	Port	Purpose
WEB01	APP01	HTTPS	443	App communication
APP01	DB01	SQL	1433	Database
APP01	AD01	Kerberos	88	Authentication
APP01	AD01	LDAP	389/636	Directory
All workloads	DNS	DNS	53	Name resolution
Migration system	Azure	HTTPS	443	Migration control
Servers	Monitor	HTTPS	443	Telemetry
32. Network Migration Validation

Before each migration wave validate:

Source connectivity
Target connectivity
DNS
Routes
NSGs
Firewall
VPN
Private Endpoints
Hybrid services
Application flows
Database flows
Identity flows
33. Performance Baseline

Capture before migration:

Round-trip latency
Packet loss
Bandwidth
Throughput
DNS response time
Application response time
SQL connection time

Compare target results after migration.

34. Network Monitoring

Use:

Azure Monitor
Network Watcher
Connection Monitor
Firewall logs
NSG flow information where applicable
VPN metrics
DNS logging where appropriate
35. Network Alerts

Important alerts:

VPN tunnel down
Packet loss
Excess latency
Firewall deny anomalies
Gateway health
DNS failure
Routing failure
Application connectivity failure
36. High Availability

Critical network components should avoid single points of failure.

Consider redundancy for:

VPN Gateway
ExpressRoute circuits where required
DNS
Azure Firewall
Application Gateway
On-premises connectivity
37. Network Security Logging

Send relevant logs to:

Log Analytics
     |
     v
Microsoft Sentinel

Sources should include:

Azure Firewall
Application Gateway
VPN Gateway
Network services
Identity services
Security appliances
38. Migration Rollback Networking

Rollback must include network restoration.

Rollback may require:

DNS rollback
Route rollback
Firewall rollback
Load-balancer rollback
Private Endpoint rollback
Application Gateway rollback
Traffic redirection to source
39. Rollback Trigger Examples

Rollback may be triggered when:

Application connectivity fails
DNS resolution fails
Authentication fails
Database connectivity fails
Performance exceeds agreed threshold
Critical security controls fail
Business validation fails
40. Network Change Control

All migration network changes require:

Change ticket
Technical owner
Business impact
Implementation plan
Validation plan
Rollback plan
Maintenance window
Approval
41. Network Migration Sequence

Recommended sequence:

1. Address Planning
2. Hub Deployment
3. Firewall Deployment
4. VPN Deployment
5. DNS Deployment
6. Spoke Deployment
7. Peering
8. NSGs
9. Routing
10. Private Endpoints
11. Monitoring
12. Connectivity Tests
13. Pilot
14. Production Waves
42. Network Readiness Gates

Network status becomes GREEN only when:

No overlapping CIDRs exist
Hybrid routing is validated
DNS is validated
Firewall rules are validated
NSGs are validated
VPN is stable
Required bandwidth is available
Private Endpoints resolve correctly
Monitoring is active
Rollback is tested
43. Security Principles

The network architecture should enforce:

Verify Explicitly
Use Least Privilege
Assume Breach

Traffic should not be trusted simply because it originates inside the corporate network.

44. Expected Target Outcome

The final network architecture should provide:

Strong segmentation
Central firewall inspection
Private service connectivity
Secure hybrid connectivity
Central administrative access
Hybrid DNS
Migration coexistence
Visibility
Policy control
Reversible cutover
45. Next Deliverable

After the network design is completed, create:

06-identity-security/identity-security-design.md

That document will define:

Microsoft Entra ID
Active Directory coexistence
MFA
Conditional Access
PIM
RBAC
Managed identities
Service accounts
Key Vault
Defender
Sentinel
Security logging

After pasting all of that, press:

```text
Ctrl + S

Then copy and paste these commands into the terminal:

git add 05-network/network-design.md
git commit -m "Add Contoso target network design"
git push
git status

The final result should say:

nothing to commit, working tree clean