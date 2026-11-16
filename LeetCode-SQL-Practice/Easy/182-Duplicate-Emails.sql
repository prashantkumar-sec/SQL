-- Problem Number: 182
-- Problem Name:  Duplicate Emails
-- Platform: LeetCode
-- Difficulty: Easy
-- Language: MySQL
-- Topic: SELECT, FROM, AS, GROUP BY, HAVING, COUNT
-- Link: https://leetcode.com/problems/duplicate-emails/description/

SELECT email AS Email
FROM person
GROUP BY email 
HAVING COUNT(email)>1;
