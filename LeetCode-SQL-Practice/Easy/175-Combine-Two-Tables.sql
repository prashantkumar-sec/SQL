-- Problem Number: 175
-- Problem Name:  Combine Two Tables
-- Platform: LeetCode
-- Difficulty: Easy
-- Language: MySQL
-- Topic: SELECT, FROM, LEFT JOIN, ON
-- Link: https://leetcode.com/problems/combine-two-tables/description/

SELECT firstName, lastName, city, state
FROM person p1
LEFT JOIN Address A1
ON p1.personId =  A1.personId
