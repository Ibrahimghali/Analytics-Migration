# dbt SQL Server Setup on Windows

## Overview
Successfully configured dbt to connect to Microsoft SQL Server on Windows using Python 3.13 with all dependency and compatibility issues resolved.

## Environment Details
- **OS**: Windows 11
- **Python**: 3.13.3
- **dbt Core**: 1.10.2
- **dbt SQL Server Adapter**: 1.9.0
- **ODBC Driver**: ODBC Driver 17 for SQL Server
- **Authentication**: Windows Authentication

## Installed Packages (requirements.txt)
The following packages were installed and tested to work together:

```
dbt-core==1.10.2
dbt-sqlserver==1.9.0
dbt-fabric==1.9.3
pyodbc==5.2.0
azure-identity==1.21.0
azure-keyvault-secrets==4.9.0
azure-storage-blob==12.24.0
```

## Key Configuration

### profiles.yml
Located at: `C:\Users\Ibrahim\.dbt\profiles.yml`

```yaml
sql_server_project:
  outputs:
    dev:
      database: analytics_migration
      driver: 'ODBC Driver 17 for SQL Server'
      host: localhost
      port: 1433
      schema: dbo
      threads: 1
      type: sqlserver
      windows_login: true
      encrypt: false
      trust_cert: true
  target: dev
```

### Critical Settings for Local SQL Server
- `windows_login: true` - Use Windows Authentication
- `encrypt: false` - Disable SSL encryption for local connections
- `trust_cert: true` - Trust the server certificate
- `database: analytics_migration` - Custom database (created during setup)

## Setup Process

### 1. Python Environment
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

### 2. Package Installation
```powershell
pip install pyodbc==5.2.0
pip install dbt-core==1.10.2
pip install dbt-sqlserver==1.9.0
pip install dbt-fabric==1.9.3
pip install azure-identity==1.21.0
pip install azure-keyvault-secrets==4.9.0
pip install azure-storage-blob==12.24.0
```

### 3. Database Creation
```sql
sqlcmd -E -S localhost -Q "CREATE DATABASE analytics_migration;"
```

### 4. dbt Project Initialization
```powershell
dbt init sql_server_project
```

## Troubleshooting Issues Resolved

### 1. Python 3.13 Compatibility
- **Issue**: `pyodbc` build errors with Python 3.13
- **Solution**: Install `pyodbc==5.2.0` (compatible version)

### 2. SSL Certificate Errors
- **Issue**: Certificate chain not trusted
- **Solution**: Set `encrypt: false` and `trust_cert: true`

### 3. Database Access
- **Issue**: Database "analytics_migration" didn't exist
- **Solution**: Created database using `sqlcmd`

### 4. Windows Authentication
- **Issue**: Initial connection failures
- **Solution**: Use `windows_login: true` instead of username/password

## Verification Commands

### Test Connection
```powershell
dbt debug
```

### Compile Project
```powershell
dbt compile
```

### Run Models
```powershell
dbt run
```

## Project Structure
```
sql_server_project/
├── dbt_project.yml
├── models/
│   └── example/
│       ├── my_first_dbt_model.sql
│       ├── my_second_dbt_model.sql
│       └── schema.yml
├── analyses/
├── tests/
├── snapshots/
├── macros/
└── seeds/
```

## Status
✅ **COMPLETE**: dbt is successfully configured and connected to SQL Server
✅ **TESTED**: All checks pass with `dbt debug`
✅ **REPRODUCIBLE**: Environment documented in requirements.txt

## Next Steps
1. Develop dbt models for your analytics use case
2. Set up source tables in the `analytics_migration` database
3. Create transformations and tests
4. Consider setting up CI/CD pipeline for production
