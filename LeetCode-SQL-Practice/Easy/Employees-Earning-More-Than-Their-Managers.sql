-- Problem Number: 181
-- Problem Name: Employees Earning More Than Their Managers
-- Platform: LeetCode
-- Difficulty: Easy
-- Language: MySQL
-- Topic: SELECT, WHERE, JOIN, ON, FROM
-- Link: https://leetcode.com/problems/big-countries/description/

SELECT E1.name AS Employee
FROM Employee E1
JOIN Employee E2
ON E1.managerId = E2.id
WHERE E1.salary > E2.salary;
