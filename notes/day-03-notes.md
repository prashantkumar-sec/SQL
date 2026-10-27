# Day 3: SQL Data Types

| Field | Value |
|---|---|
| Day | 3 |
| Date | 27-Oct-2026 |
| Phase | 1. Foundations (Week 1) |
| Type | Learn |
| Concept | Data types: INTEGER, NUMERIC, TEXT, VARCHAR, BOOLEAN, DATE, TIMESTAMP |
| Task | Create a `students` table with 6 columns, each with a well-chosen type |
| Status | In progress (table design pending review) |
| Hours spent | 1.5 |
| Environment | Windows, PostgreSQL 18.6, psql 18.6, pgAdmin 4 |

---

## 1. Mental Model

A type is a **label on a box**. It decides three things:

1. **Validation:** wrong data is rejected.
2. **Operations:** what you can do with the value (`+` on numbers, date differences on dates).
3. **Storage:** how much space the database needs.

---

## 2. The 7 Core Types

| Type | Stores | Example | Use for |
|---|---|---|---|
| `INTEGER` | Whole numbers (4 bytes, about ±2.1 billion) | `21`, `-5` | counts, IDs |
| `NUMERIC(p, s)` | **Exact** decimals | `8.75` | CGPA, money, fees |
| `TEXT` | Text of any length | `'Prashant'` | names, addresses, notes |
| `VARCHAR(n)` | Text up to `n` characters | `'CSE'` | when a real length rule exists |
| `BOOLEAN` | `TRUE` / `FALSE` / `NULL` | `TRUE` | yes/no flags |
| `DATE` | Date only | `'2004-05-17'` | DOB, admission date |
| `TIMESTAMP` | Date + time | `'2026-10-27 13:38:00'` | when something happened |

---

## 3. NUMERIC(precision, scale): the part I got wrong

- **precision (p)** = total number of digits
- **scale (s)** = digits after the decimal point
- **digits before the decimal = p − s**

| Type | Max value |
|---|---|
| `NUMERIC(2,1)` | 9.9 |
| `NUMERIC(3,1)` | 99.9 |
| `NUMERIC(4,2)` | 99.99 |
| `NUMERIC(5,2)` | 999.99 |
| `NUMERIC(6,2)` | 9999.99 |

```sql
SELECT 9999.99::NUMERIC(6,2);    -- works
SELECT 10000.00::NUMERIC(6,2);   -- ERROR: numeric field overflow
```

**Mistakes I made:**
- Read `NUMERIC(2,1)` as "2 digits before, 1 after". Wrong: it means 2 digits total.
- Said the max of `NUMERIC(6,2)` is "6". Wrong: 6 is the digit count, the max is 9999.99.

**Lesson:** before choosing a type, ask "what is the largest valid value?"

**Note:** a type limits **size**, not **range**. `NUMERIC(4,2)` for CGPA still accepts 15.00. Range checks need a `CHECK` constraint (coming later).

---

## 4. Key Facts

- `NUMERIC` is exact. `FLOAT` is approximate (`0.1 + 0.2` gives `0.30000000000000004`). Use `NUMERIC` for money and marks.
- In PostgreSQL, `TEXT` and `VARCHAR(n)` have **the same performance**. `VARCHAR(n)` only adds a length rule.
- `TIMESTAMP` has no timezone. Real apps often use `TIMESTAMPTZ` (later topic).
- Don't store `age`, it goes stale. Store `date_of_birth` and calculate age.
- Phone numbers are **not** `INTEGER` (leading zeros are lost, and you never do arithmetic on them).
- Text uses **single quotes** `'...'`. Double quotes are for identifiers (column/table names).
- `CREATE TABLE`: no comma after the last column, and end the statement with `;`.
- Type is the first line of defense against garbage data, but not the only one.

---

## 5. Practice Answers (reviewed)

| Question | My answer | Verdict |
|---|---|---|
| Email | TEXT | Right type. Real reason: variable-length text, no arithmetic. `VARCHAR(254)` is also fine. |
| Fees (45,000.50) | NUMERIC | Right type. Reason: has paise, needs exact decimals. |
| Lives in hostel? | BOOLEAN | Correct |
| Trailing comma bug | Comma after last column | Correct |
| `NUMERIC(2,1)` max | 99.9 | Wrong, it is 9.9 |
| CGPA 0.00 to 10.00 | `NUMERIC(4,2)` | Correct |
| `NUMERIC(6,2)` max | 6 | Wrong, it is 9999.99 |

**Self-check pending:** max value of `NUMERIC(8,3)`?

---

## 6. Task: `students` table (to complete)

Rules: 6 columns, at least 5 different types, one-line reason per column based on the nature of the data.

| # | Column name | Type | Why this type |
|---|---|---|---|
| 1 | Name | VARCHAR | 	Stores names as variable-length character strings |
| 2 | RollNo | NUMERIC | 	Stores roll numbers that may contain numeric values |
| 3 | Course | TEXT | 	Stores course names/descriptions with variable-length text |
| 4 | Date | DATE |	Stores calendar dates in a proper date format |
| 5 | Enrolled | BOOLEAN | Stores a true/false value indicating enrollment status |
| 6 | Id | INTEGER | 	Stores a whole-number identifier for each record |

```sql
-- CREATE TABLE students (
--     ...
-- );
```

After running, verify with:

```
\d students
```

---

## 7. Checkpoint Questions

1. Difference between `NUMERIC` and float, and which is right for money?
2. Why not store a phone number as `INTEGER`?
3. What should be stored instead of age, and why?
4. Real difference between `TEXT` and `VARCHAR(50)` in PostgreSQL?

---

## 8. Next

Day 4: `INSERT INTO` (adding data to the `students` table).
