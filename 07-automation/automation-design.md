# Contoso Manufacturing - Migration Automation Design

## 1. Purpose

This document defines the automation architecture for the Contoso Manufacturing Azure Hybrid Migration Factory.

The goal is to make migration activities:

- Repeatable
- Secure
- Auditable
- Testable
- Idempotent
- Recoverable
- Version controlled
- Suitable for multiple migration waves

Primary automation technologies:

- Azure CLI
- PowerShell
- Bicep
- GitHub Actions
- YAML
- JSON
- Azure Resource Manager
- Microsoft Entra workload identity
- Azure Key Vault
- Azure Monitor

---

## 2. Automation Design Principles

The automation design follows these principles:

1. Infrastructure as Code
2. No hard-coded secrets
3. Least privilege
4. Idempotent deployments
5. Source control for all scripts
6. Peer review before production execution
7. Automated validation
8. Explicit rollback procedures
9. Environment separation
10. Logging and auditability
11. Reusable modules
12. Parameterization
13. Fail-fast validation
14. Production approval gates
15. Secure authentication

---

## 3. High-Level Automation Architecture

```text
Developer / Migration Engineer
             |
             v
          GitHub
             |
             v
      Pull Request / Review
             |
             v
       GitHub Actions
             |
       +-----+-----+
       |           |
       v           v
    Validate     Security
       |           |
       +-----+-----+
             |
             v
      Azure Authentication
             |
             v
    Bicep / Azure CLI / PowerShell
             |
             v
          Azure
             |
             v
    Post-Deployment Validation
             |
        +----+----+
        |         |
        v         v
      Pass       Fail
        |         |
        v         v
    Continue   Rollback
    4. Repository Structure

Recommended automation structure:

07-automation/
├── automation-design.md
├── bicep/
│   ├── main.bicep
│   ├── modules/
│   └── parameters/
├── powershell/
│   ├── discovery/
│   ├── validation/
│   ├── migration/
│   └── rollback/
├── azure-cli/
├── scripts/
├── tests/
└── workflows/

GitHub Actions workflows will ultimately live under:

.github/workflows/
5. Infrastructure as Code

Use Bicep for Azure infrastructure deployment.

Potential resources:

Resource groups
VNets
Subnets
NSGs
Route tables
Azure Firewall
Bastion
VPN Gateway
Log Analytics
Key Vault
Azure Policy assignments
Monitoring resources
Private Endpoints
6. Bicep Deployment Model

Recommended model:

main.bicep
    |
    +-- network.bicep
    +-- security.bicep
    +-- monitoring.bicep
    +-- keyvault.bicep
    +-- governance.bicep

Each module should have a defined responsibility.

7. Environment Parameters

Use separate parameter files for:

dev
test
stage
prod

Example:

parameters/
├── dev.bicepparam
├── test.bicepparam
├── stage.bicepparam
└── prod.bicepparam

Do not embed environment-specific values directly into reusable modules.

8. Naming Automation

Resource naming should follow a predictable convention.

Example:

<resource>-<application>-<environment>-<region>

Examples:

vnet-contoso-prod-westus2
kv-contoso-prod-westus2
log-contoso-prod-westus2
9. Tagging Automation

Deployment code should apply required tags automatically.

Recommended tags:

Environment
Application
BusinessOwner
TechnicalOwner
CostCenter
Criticality
DataClassification
MigrationWave
ManagedBy
BackupPolicy
10. Authentication

Preferred GitHub-to-Azure authentication:

GitHub Actions
      |
      v
OIDC Federation
      |
      v
Microsoft Entra ID
      |
      v
Azure RBAC

Avoid long-lived Azure client secrets where possible.

11. Workload Identity Federation

Use workload identity federation for GitHub Actions.

Benefits:

No stored Azure password
No long-lived secret
Short-lived tokens
Better auditability
Reduced secret-management overhead
12. Azure RBAC for Automation

Automation identity should receive only required permissions.

Avoid:

Owner

unless genuinely required.

Prefer scoped access at:

Resource Group

or other minimum necessary scope.

13. Secrets

Never place production secrets in:

Git repositories
Bicep files
PowerShell scripts
YAML files
README files
Plaintext variables

Use:

Azure Key Vault
GitHub encrypted secrets where necessary
OIDC federation
Managed identities
14. Azure CLI Automation

Azure CLI can support:

Resource validation
Subscription checks
Resource inventory
Network checks
Azure Arc operations
Resource deployment
Policy checks

Example pattern:

az account show
az group list
az network vnet list

Scripts should check command exit codes.

15. PowerShell Automation

PowerShell can support:

Windows discovery
Active Directory checks
DNS validation
Network connectivity checks
Server inventory
Migration pre-checks
Post-migration tests
Rollback automation
16. PowerShell Script Standards

Scripts should include:

Set-StrictMode
ErrorActionPreference
Parameter validation
Structured logging
Try/Catch
Exit codes

Production scripts should fail clearly rather than silently continuing after errors.

17. Discovery Automation

Discovery scripts should collect:

Servers
OS versions
CPU
Memory
Disks
IP addresses
DNS settings
Domain membership
Services
Ports
Installed applications

Output should be structured.

Preferred formats:

CSV
JSON
18. Network Validation Automation

Automated checks should validate:

DNS
TCP connectivity
Routes
VPN connectivity
SQL connectivity
HTTPS connectivity
Domain-controller connectivity

Example PowerShell:

Test-NetConnection server.contoso.local -Port 443
19. DNS Validation

Automation should test:

Forward lookup
Reverse lookup
Private DNS
On-prem DNS
Target records

Example:

Resolve-DnsName app.contoso.local
20. Database Validation

Automated database validation should check:

Endpoint reachability
Authentication
Connection success
Query execution
Expected database presence

Do not place database passwords directly in scripts.

21. Application Validation

Automated tests may check:

HTTP status
API response
Authentication
Application health endpoint
Expected response time

Example:

GET /health
Expected: HTTP 200
22. GitHub Actions Workflow

Recommended workflow stages:

Checkout
   |
   v
Authenticate
   |
   v
Lint
   |
   v
Validate
   |
   v
Security Scan
   |
   v
Deploy
   |
   v
Post-Deployment Validation
   |
   v
Approval / Completion
23. Pull Request Workflow

Production changes should follow:

Engineer
   |
   v
Feature Branch
   |
   v
Pull Request
   |
   v
Automated Checks
   |
   v
Peer Review
   |
   v
Approval
   |
   v
Merge

Avoid uncontrolled direct production changes.

24. Branch Strategy

Recommended:

main

for approved code.

Feature work:

feature/<name>

Examples:

feature/network-foundation
feature/migration-wave-1
feature/rollback-automation
25. Production Approval

Production deployment should require an approval gate.

Example:

Build
  |
  v
Validation
  |
  v
Approval
  |
  v
Production Deployment
26. Automated Bicep Validation

Before deployment:

az bicep build --file main.bicep

Also validate the deployment where appropriate before applying changes.

27. What-If Analysis

Use Azure what-if functionality before significant infrastructure changes.

Purpose:

Identify additions
Identify deletions
Identify modifications
Reduce accidental changes
28. Deployment Sequence

Recommended foundation automation sequence:

1. Resource Groups
2. Logging
3. Network
4. Firewall
5. DNS
6. Identity integrations
7. Key Vault
8. Security controls
9. Monitoring
10. Private Endpoints
11. Workloads
29. Idempotency

Automation should be safe to run more than once.

Desired behavior:

Run 1 -> Create desired state
Run 2 -> No unintended duplicate resources
Run 3 -> Preserve desired state
30. Logging

Automation should log:

Timestamp
Workflow
Script
Environment
Resource
Operation
Result
Error message

Do not log secrets.

31. Error Handling

Automation should stop when critical operations fail.

Example logic:

Operation
   |
   v
Success?
 |     |
Yes    No
 |      |
 v      v
Next   Stop
        |
        v
      Log Error
        |
        v
   Rollback Decision
32. Pre-Migration Validation Pipeline

Before each migration wave:

Network Validation
       |
       v
DNS Validation
       |
       v
Identity Validation
       |
       v
Backup Validation
       |
       v
Security Validation
       |
       v
Application Validation
       |
       v
Migration Gate
33. Migration Wave Automation

Each migration wave should have parameters.

Example:

Wave_ID
Application
Source
Target
Maintenance_Window
RTO
RPO
Rollback_Threshold
Owner
34. Wave Status

Suggested status model:

Planned
Ready
Approved
Executing
Validating
Completed
RolledBack
Failed
35. Migration Execution

Migration automation should separate:

Pre-check
Replication
Cutover
Validation
Rollback

Do not combine every operation into one monolithic script.

36. Cutover Automation

Cutover may include:

Stop source writes
Final synchronization
Target activation
DNS change
Traffic redirection
Application startup
Validation

Every cutover action should be logged.

37. Validation Automation

Post-cutover validation should test:

DNS
Network
Identity
Application
Database
Performance
Monitoring
Security
Backup
38. Rollback Automation

Rollback automation may include:

Stop target
Restore source traffic
Revert DNS
Revert routes
Restore connection strings
Restore firewall rules
Start source services
Validate source
39. Rollback Decision

Automation should not automatically trigger destructive rollback without appropriate governance.

Recommended:

Validation Failure
      |
      v
Pause
      |
      v
Migration Lead Review
      |
      +---- Continue
      |
      +---- Rollback
40. Rollback Safety

Rollback scripts must be tested before production use.

Never treat an untested rollback script as a valid recovery control.

41. Backup Validation Automation

Before cutover verify:

Backup job completed
Backup timestamp acceptable
Recovery point exists
Restore procedure documented

Critical workloads should also have restore-test evidence.

42. Security Validation Automation

Automated checks should verify:

Required logging enabled
Defender enabled where required
Public exposure restricted
NSGs assigned
Key Vault configured
Required tags present
Security baseline passes
43. Policy Validation

Automation can query Azure Policy compliance.

Production workloads should not be accepted with unresolved critical policy failures unless explicitly approved.

44. Monitoring Validation

Verify:

Azure Monitor data arriving
Log Analytics receiving logs
Alerts configured
Application health visible
Network health visible
Security events visible
45. Deployment Artifacts

Every migration deployment should produce evidence.

Potential artifacts:

Deployment logs
Validation results
What-if result
Approval record
Migration timestamp
Test output
Rollback status
Final signoff
46. Automation Security Controls

Required controls:

Least privilege
OIDC
No plaintext secrets
Repository access control
Pull-request review
Protected environments
Logging
Audit history
Restricted production deployment
47. GitHub Repository Security

Recommended:

Branch protection
Require pull request
Require review
Secret scanning
Dependabot
Protected production environment
Minimum necessary collaborators
48. Failure Handling

Common failure classes:

Authentication Failure
Authorization Failure
Network Failure
DNS Failure
Deployment Failure
Application Failure
Database Failure
Validation Failure

Each class should have documented troubleshooting actions.

49. Retry Strategy

Retries are acceptable for transient errors.

Do not endlessly retry:

Authentication failures
Authorization failures
Invalid configuration
Policy violations
Destructive operation failures
50. Automation Testing

Testing should include:

Syntax tests
Linting
Unit tests where practical
Deployment validation
Non-production testing
Failure-path testing
Rollback testing
51. Dev/Test Before Production

Automation progression:

Development
     |
     v
Test
     |
     v
Stage
     |
     v
Production

Do not use production as the first test environment.

52. Migration Dashboard

Eventually create a migration dashboard displaying:

Wave
Workload
Status
Start time
End time
Validation status
Rollback state
Owner
Risk
53. Automation Success Criteria

Automation is considered ready when:

Authentication is secure
Scripts are version controlled
Bicep validates
No secrets exist in source code
Pre-checks execute
Deployment succeeds
Validation executes
Logs are retained
Rollback has been tested
Production approval exists
54. Initial Automation Deliverables

The first executable artifacts should include:

07-automation/
├── bicep/
│   └── main.bicep
├── powershell/
│   ├── Test-NetworkReadiness.ps1
│   └── Test-MigrationReadiness.ps1
└── scripts/
    └── validate-environment.sh
55. Next Project Phase

After the automation foundation is created, move to:

08-migration/

Primary deliverables:

migration-waves.yaml
migration-runbook.md

These documents and automation artifacts will define how Contoso workloads move from source to target in controlled migration waves.