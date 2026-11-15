-- Problem Number: 595
-- Problem Name: Big Countries
-- Platform: LeetCode
-- Difficulty: Easy
-- Language: MySQL
-- Topic: SELECT, WHERE, OR
-- Link: https://leetcode.com/problems/big-countries/description/

SELECT name, population, area
FROM World
WHERE area >= 3000000
   OR population >= 25000000;
