-- Problem Number: 196
-- Problem Name: Delete Duplicate Emails
-- Platform: LeetCode
-- Difficulty: Easy
-- Language: MySQL
-- Topic: DELETE, FROM, ALIAS
-- Link: https://leetcode.com/problems/delete-duplicate-emails/description/

DELETE p1
FROM person p1, person p2
WHERE p1.email = p2.email AND p1.id > p2.id;
