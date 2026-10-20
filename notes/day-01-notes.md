# Day 1: Databases, DBMS vs SQL, and PostgreSQL Setup

| Field | Value |
|---|---|
| Day | 1 |
| Date | 20-Oct-2026 |
| Phase | 1. Foundations (Week 1) |
| Type | Learn |
| Concept | What a database is; DBMS vs SQL; install PostgreSQL, `psql`, and pgAdmin |
| Task | Run `SELECT version();` and `SELECT 1 + 1;` in both `psql` and pgAdmin |
| Status | Done |
| Hours spent | 1.5 |
| Environment | Windows, PostgreSQL 18.6, `psql` 18.6, pgAdmin 4 |

---

## 1. Core Concepts

| Term | Definition | Example |
|---|---|---|
| **Database** | An organized collection of data that can be stored, accessed, and managed. In PostgreSQL, also a named container holding tables, indexes, views, etc. | `postgres`, `practice_db` |
| **DBMS** | Software that stores, manages, and protects databases. Besides running commands, it handles many users at once, crash recovery, access control, and efficient storage and search. | PostgreSQL, MySQL, MongoDB |
| **SQL** | A language for working with relational databases. It retrieves data (`SELECT`), changes data (`INSERT`, `UPDATE`, `DELETE`), defines structure (`CREATE`, `ALTER`), and controls permissions (`GRANT`). | `SELECT * FROM students;` |
| **Client tool** | A program that sends SQL to the server and shows results. Holds no data itself. | `psql`, pgAdmin |

Common misconceptions corrected:
- "SQL is a database" is wrong. SQL is a language; PostgreSQL is the software that understands it.
- "Database means tables" is only true for relational databases. MongoDB (documents) and Redis (key-value) are databases too.
- MongoDB is a DBMS that does not use SQL as its main language, which proves DBMS and SQL are different things.

## 2. Client-Server Architecture

```
 You type SQL
      |
 +----v-----+      TCP connection        +---------------------+     +------------+
 | psql or  | ------ port 5432/5433 ----> | PostgreSQL server   | --> | Data files |
 | pgAdmin  | <----- results ------------ | (background service)|     | on disk    |
 +----------+                             +---------------------+     +------------+
   CLIENT                                        SERVER
```

- PostgreSQL runs as a background service and waits for connections.
- Clients hold no data. If the server is unreachable, every client fails.
- The server listens on a port. The default is 5432; mine is **5433**.
- PostgreSQL creates **one server process per connection**. `netstat` showed the main process (PID 7928) listening, and my `psql` session got its own backend process (PID 15788, shown by `\conninfo`).

## 3. Installation Summary (Windows)

1. Download the installer from `postgresql.org/download/windows`.
2. Keep PostgreSQL Server, pgAdmin 4, and Command Line Tools selected.
3. Set a password for the `postgres` superuser (store it safely, never in a repository).
4. Note the port the installer shows. It may not be 5432.

Verification:

```
psql --version
psql -U postgres -p 5433
```

```sql
SELECT version();
SELECT 1 + 1;
```

## 4. Troubleshooting Log

### Problem 1: `'psql' is not recognized`

- **Root cause:** The PostgreSQL `bin` folder was not in PATH. Windows searches only the folders listed in PATH, so it could not find `psql.exe`. The program was installed; it was just not findable.
- **Why pgAdmin still worked:** pgAdmin is a separate program that does not depend on PATH.
- **Diagnosis:** `where postgres` found `C:\Program Files\PostgreSQL\18\bin\postgres.exe`.
- **Fix:** Add `C:\Program Files\PostgreSQL\18\bin` to the user PATH, then open a **new** Command Prompt (old windows keep the old PATH).
- **Verify:** `psql --version` and `where psql`.

### Problem 2: `Connection refused (10061)` on port 5432

Symptom:

```
psql: error: connection to server at "localhost" (::1), port 5432 failed: Connection refused
Is the server running on that host and accepting TCP/IP connections?
```

Diagnostic order:

| Step | Command | Result | Conclusion |
|---|---|---|---|
| 1. Is the service running? | `sc query postgresql-x64-18` | `STATE: 4 RUNNING` | Not a stopped service |
| 2. What port is open? | `netstat -ano \| findstr LISTENING \| findstr 543` | `0.0.0.0:5433 LISTENING` | Server is on 5433 |
| 3. Fix | `psql -U postgres -p 5433` | Connected | Wrong port was the cause |

- **Root cause:** `psql` assumes port 5432 unless told otherwise. The server was on 5433. pgAdmin had 5433 saved in its server entry.
- **Key lesson:** The error message is a *symptom*, not a *cause*. Port 5432 (wrong port, service running) and port 5999 (nothing there) produced **identical** errors. The message cannot distinguish a stopped service, a wrong port, or a wrong host. I check whether the service is running with `sc query`, and which port is actually listening with `netstat`.
- **Mistake to avoid:** `net start` failed with "Access is denied" because it needs an Administrator prompt, and it was unnecessary because the service was already running. Read the diagnostic output before acting.
- **Convenience:** `set PGPORT=5433` applies only to the current Command Prompt window. The "SQL Shell (psql)" Start menu shortcut carries the installer's port settings.

### Problem 3: Leftover PostgreSQL 17 files

`dir "C:\Program Files\PostgreSQL"` showed folders `17` and `18`.

- Folder `17` contains only `data` and `pg_env.bat`. The program files were removed, but the **data directory was left behind** (uninstallers do this to avoid destroying databases).
- `17\data\base` contains `16432`, a user-created database (IDs of 16384 or higher are user-created; `1`, `4`, `5` are built-in).
- `SHOW data_directory;` confirmed the running server uses `C:/Program Files/PostgreSQL/18/data`. The old 17 data is dead storage and does not affect the live server.
- **Status:** Not deleted. Decide whether the old data is needed, and back up (zip to another drive) before any deletion. Deleting is permanent.
- **Open question:** Why the installer chose 5433 is unresolved. `port = 5433` is written explicitly in `postgresql.conf`, but the reason it was chosen is not proven by the evidence.

## 5. psql Meta-commands vs SQL Statements

| | SQL statements | psql meta-commands |
|---|---|---|
| Examples | `SELECT`, `CREATE TABLE` | `\conninfo`, `\l`, `\dt`, `\q` |
| Handled by | The PostgreSQL server | The `psql` program itself |
| Ending | Need `;` | Ends at the line break, **no semicolon** |

Errors I produced and learned from:
- `\conninfo;` failed with `invalid command \conninfo;` because the `;` became part of the command name.
- `\\conninfo` failed because `\\` is a special psql separator, not an escaped backslash.

`\conninfo` fields worth knowing: Server Port, Host Address (`::1` is IPv6 localhost), Password Used, SSL Connection (false on localhost), Superuser, Backend PID.

## 6. Integer vs Numeric Division

| Query | Result | Why |
|---|---|---|
| `SELECT 10 / 3;` | `3` | Both `integer`: fractional part dropped |
| `SELECT 10 / 3.0;` | `3.3333333333333333` | `3.0` is `numeric`; `10` is converted to `numeric` |
| `SELECT 10 / 4;` | `2` | Integer division |
| `SELECT -7 / 2;` | `-3` | Truncates **toward zero**, not floor (floor would give -4) |
| `SELECT pg_typeof(10), pg_typeof(3.0);` | `integer`, `numeric` | Confirms the types |

Lesson: integer division silently discards the fractional part with no error. Choosing the wrong data type produces wrong answers quietly. Data types are the topic of Day 3.

## 7. Server Configuration and Security Notes

```
SHOW port;           -> 5433
SHOW data_directory; -> C:/Program Files/PostgreSQL/18/data
SHOW config_file;    -> C:/Program Files/PostgreSQL/18/data/postgresql.conf
```

From `postgresql.conf`:

```
listen_addresses = '*'
port = 5433
```

- `listen_addresses = '*'` means the server accepts connections on all network interfaces (matches `netstat` showing `0.0.0.0:5433`). For a local practice database, `'localhost'` is the safer setting.
- Layers of defense: `listen_addresses` (is the door open), firewall (can traffic reach the port), `pg_hba.conf` (is this client and user allowed), password (does the person know the secret).
- `postgres` is a **superuser**. Use a strong password, and never use the superuser for applications.
- A default that works is not the same as a default that is secure.
- Planned for a later security lesson: edit `listen_addresses`, read `pg_hba.conf`, back up config files before editing.

## 8. Corrections to the Original Install Guide (`Installation/`)

1. Linux: `apt install postgresql` installs the version in the distro's repositories (Ubuntu 22.04 gives 14, 24.04 gives 16), so "Expected: 18.x" is wrong unless the PGDG repository is added.
2. Windows: the installer often does not add `bin` to PATH, so `psql --version` can fail right after install. The PATH fix belongs next to Step 4.
3. The installer may choose a port other than 5432. Check with `netstat -ano | findstr LISTENING | findstr 543` and connect with `psql -U postgres -p <port>`.
4. The last line of the guide is truncated ("ready for SQL learnin").
5. Section 6 should state that SQL commands are typed inside the `psql` prompt (`postgres=#`).
6. `postgresql-contrib` is not needed separately on recent versions.
7. pgAdmin does not come with the Linux `apt` package.

## 9. Command Reference

| Command | What it does | Notes |
|---|---|---|
| `psql --version` | Shows the client version | Fails if PATH is not set |
| `where psql` | Shows which file Windows found | Good for any "command not found" |
| `psql -U postgres -p 5433` | Connects as `postgres` on port 5433 | `-p` sets the port |
| `sc query postgresql-x64-18` | Shows the Windows service state | `4 RUNNING` or `1 STOPPED` |
| `netstat -ano \| findstr LISTENING` | Lists listening ports with PIDs | Find which port the server uses |
| `tasklist /FI "PID eq <pid>"` | Shows which program owns a PID | Confirms it is `postgres.exe` |
| `\conninfo` | Shows connection details | No semicolon |
| `\q` | Quits `psql` | No semicolon |
| `SELECT version();` | Shows server version | Needs `;` |
| `SHOW <setting>;` | Shows a server setting | `port`, `data_directory`, `config_file` |

## 10. Skills Demonstrated and Weak Spots

Solid:
- Client-server model, ports, services
- Diagnosing a connection failure in a structured order
- Reading command output and finding config files
- Running and interpreting `psql` commands

Needs more practice:
- Stating conclusions precisely in my own words
- Reading the question fully before pasting output
- Keeping my account of events consistent
- Writing predictions *before* running commands

## 11. Open Items

- [✅] Decide whether the old `17\data` database (`16432`) is needed; back up before deleting.
- [✅] Check Settings, Apps, Installed apps for a leftover PostgreSQL 17 entry.
- [✅] Later: secure `listen_addresses` and read `pg_hba.conf`.
- [✅] Warm-up question: why is a `price` column a poor fit for `integer`?

## 12. Next: Day 2 (21-Oct)

- Tables, rows, columns
- psql meta-commands: `\l`, `\c`, `\dt`, `\d`
- Task: create a practice database and list it with `\l`; draw a `students` table on paper
