# PostgreSQL Installation Guide

This guide explains how to install PostgreSQL and verify the installation on:

- Windows
- Linux (Ubuntu/Debian)
- WSL Ubuntu

---

# 1. PostgreSQL Installation on Windows

## Step 1 — Download PostgreSQL

Go to the official PostgreSQL download page:

https://www.postgresql.org/download/windows/

Download the Windows installer.

The PostgreSQL Windows installer is the easiest method for most Windows users.

---

## Step 2 — Install PostgreSQL

Run the downloaded installer.

During installation:

1. Select the installation directory.
2. Keep PostgreSQL Server selected.
3. Keep pgAdmin selected.
4. Keep Command Line Tools selected.
5. Choose a data directory.
6. Create a password for the PostgreSQL `postgres` user.
7. Keep the default port:

```text
5432
```

8. Complete the installation.

### Important

Remember the password you create for the `postgres` user.

You will need it when connecting to PostgreSQL.

---

# Step 3 — Open Command Prompt

Press:

```text
Windows + R
```

Type:

```text
cmd
```

Press Enter.

---

# Step 4 — Verify PostgreSQL Installation

Run:

```cmd
psql --version
```

Expected output:

```text
psql (PostgreSQL 18.x)
```

The exact version number may be different.

---

# Step 5 — Check PostgreSQL Service

Run:

```cmd
sc query postgresql-x64-18
```

If your installed PostgreSQL version is different, the service name may also be different.

You can find PostgreSQL services with:

```cmd
sc query type= service state= all | findstr /I postgres
```

If PostgreSQL is running, you should see:

```text
STATE : 4 RUNNING
```

---

# Step 6 — Connect to PostgreSQL

Run:

```cmd
psql -U postgres
```

Enter the password created during installation.

If successful, you should see something similar to:

```text
psql (18.x)
Type "help" for help.

postgres=#
```

You are now inside PostgreSQL.

---

# Step 7 — Test SQL

Run:

```sql
SELECT version();
```

Then:

```sql
SELECT 1 + 1;
```

Expected:

```text
2
```

Exit PostgreSQL:

```sql
\q
```

---

# Windows Quick Verification

Run:

```cmd
psql --version
```

Then:

```cmd
psql -U postgres
```

Inside PostgreSQL:

```sql
SELECT version();
SELECT 1 + 1;
```

Exit:

```sql
\q
```

---

# 2. PostgreSQL Installation on Linux

## Ubuntu / Debian

Open the terminal.

---

## Step 1 — Update Package Information

```bash
sudo apt update
```

---

## Step 2 — Install PostgreSQL

```bash
sudo apt install postgresql postgresql-contrib
```

Microsoft's current Ubuntu/WSL documentation also uses this package installation approach.

---

## Step 3 — Verify Installation

```bash
psql --version
```

Expected:

```text
psql (PostgreSQL 18.x)
```

The exact version depends on the packages available on your system.

---

# Step 4 — Check PostgreSQL Service

```bash
sudo systemctl status postgresql
```

You should see:

```text
Active: active (running)
```

If PostgreSQL is not running:

```bash
sudo systemctl start postgresql
```

Enable PostgreSQL to start automatically:

```bash
sudo systemctl enable postgresql
```

---

# Step 5 — Switch to PostgreSQL User

```bash
sudo -u postgres -i
```

---

# Step 6 — Open PostgreSQL

```bash
psql
```

You should see:

```text
psql (18.x)
Type "help" for help.

postgres=#
```

---

# Step 7 — Test PostgreSQL

Run:

```sql
SELECT version();
```

Then:

```sql
SELECT 1 + 1;
```

Expected:

```text
2
```

Exit PostgreSQL:

```sql
\q
```

Return to your normal Linux user:

```bash
exit
```

---

# Linux Quick Verification

```bash
psql --version
```

```bash
sudo systemctl status postgresql
```

```bash
sudo -u postgres psql
```

Inside PostgreSQL:

```sql
SELECT version();
SELECT 1 + 1;
```

Exit:

```sql
\q
```

---

# 3. PostgreSQL Installation on WSL Ubuntu

If you are using Ubuntu through WSL on Windows:

## Step 1

Open Ubuntu/WSL.

```bash
sudo apt update
```

## Step 2

Install PostgreSQL:

```bash
sudo apt install postgresql postgresql-contrib
```

## Step 3

Check the version:

```bash
psql --version
```

## Step 4

Check the service:

```bash
sudo service postgresql status
```

If it is not running:

```bash
sudo service postgresql start
```

## Step 5

Connect:

```bash
sudo -u postgres psql
```

## Step 6

Test:

```sql
SELECT version();
SELECT 1 + 1;
```

Exit:

```sql
\q
```

---

# 4. Final Verification Checklist

## Windows

```text
[ ] PostgreSQL installed
[ ] pgAdmin installed
[ ] psql command works
[ ] PostgreSQL service is running
[ ] Can connect using postgres user
[ ] SELECT version() works
[ ] SELECT 1 + 1 works
```

## Linux

```text
[ ] PostgreSQL installed
[ ] psql command works
[ ] PostgreSQL service is running
[ ] Can connect using postgres user
[ ] SELECT version() works
[ ] SELECT 1 + 1 works
```

---

# 5. Useful PostgreSQL Commands

Once connected to `psql`:

### Show databases

```sql
\l
```

### Create database

```sql
CREATE DATABASE practice_db;
```

### Connect to database

```sql
\c practice_db
```

### Show tables

```sql
\dt
```

### Show current database

```sql
SELECT current_database();
```

### Show PostgreSQL version

```sql
SELECT version();
```

### Exit

```sql
\q
```

---

# 6. First SQL Test

After installing PostgreSQL:

```sql
CREATE DATABASE sql_learning;
```

Connect:

```text
\c sql_learning
```

Create a table:

```sql
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
```

Insert data:

```sql
INSERT INTO students (name, age)
VALUES
('Alice', 20),
('Bob', 21),
('Charlie', 22);
```

Read the data:

```sql
SELECT * FROM students;
```

Expected result:

```text
 id |  name   | age
----+---------+-----
  1 | Alice   |  20
  2 | Bob     |  21
  3 | Charlie |  22
```

If you can successfully execute this, your PostgreSQL installation and basic SQL environment are working.

---

# 7. Troubleshooting

## `psql is not recognized` — Windows

If you get:

```text
'psql' is not recognized as an internal or external command
```

PostgreSQL's `bin` directory may not be in your PATH.

Typical location:

```text
C:\Program Files\PostgreSQL\<version>\bin
```

You can temporarily test it with:

```cmd
"C:\Program Files\PostgreSQL\<version>\bin\psql.exe" --version
```

If this works, add the PostgreSQL `bin` directory to your Windows PATH.

---

## PostgreSQL service is not running — Linux

Check:

```bash
sudo systemctl status postgresql
```

Start:

```bash
sudo systemctl start postgresql
```

Check again:

```bash
sudo systemctl status postgresql
```

---

## Cannot connect to PostgreSQL

Check whether the server is running.

Linux:

```bash
sudo systemctl status postgresql
```

Windows:

```cmd
sc query type= service state= all | findstr /I postgres
```

---

# Installation Complete

Verify one final time:

```sql
SELECT version();
```

and:

```sql
SELECT 1 + 1;
```

If both commands execute successfully, PostgreSQL is ready for SQL learning.
