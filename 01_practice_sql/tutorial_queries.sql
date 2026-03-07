-- Resource 1: https://selectstarsql.com/

SELECT -- specifies which columns are outputted; arguments seperated by a comma

FROM --  specifies which table recieves the query; always comes after SELECT
-- no need to use when we aren't doing anything from table

-- side note: not case sensitive, but this is standard practice

WHERE -- filters table for rows with conditions; always comes after FROM
-- argument is a boolean
-- String Operators:
LIKE -- '%dam' will match 'dam', 'adam', 'beaverdam'; not 'dammit'
LIKE -- '_dam' will match 'adam', 'edam', not 'dam', 'beaverdam', 'dammit'
-- all strings are denotes by single quotes
-- comparisons: NOT > AND > OR; or just use parenthesis
-- = for equals, not ==

LIMIT -- limits output based on argument

COUNT -- commonly used aggregate function to count things
-- Usage: SELECT COUNT(col_name) FROM table_name; (*) as col_name counts all rows with > 0 non-nulls
-- Counts non NULL : doesn't mean empty or 0 (means TRUE)

CASE -- acts as a big if-else statement
-- Usage: WHEN clause THEN result; ELSE result; END
-- a bit archaic but works well

WHEN -- used mostly in CASE blocks

LENGTH -- analagous to len in Python
MAX
MIN

-- NOTE: this is technically for SQLite which is a common dialect for SQL databases

GROUP BY -- splits dataset and applies aggregate functions within each group
-- follows the WHERE block
-- basic form: GROUP BY column
AS -- aliasing; expression AS alias gives an alias that we can refer to in the query

SELECT -- used to find a single value or group of values e.g. to find the longest in a group (comparing)

HAVING -- filters results of a GROUP BY based on aggregate functions (AFTER aggregation)
-- folows the WHERE block; precedes the ORDER BY block (to present data)
-- ORDER BY: DESC, ASC

-- Nesting: multiple queries within each other; allow for more complex values such as percentages
-- allows for the use the output of an inner (nested) query in an outer one

JOIN -- allows for simultaneous analysis of two or more tables
-- creates a combined table which is then used by the FROM block (but it comes after the FROM block)
-- defaults to inner join (unmatched rows dropped)
-- other options: LEFT JOIN preserves left table rows & empty parts evaluate to NULL, RIGHT JOIN for right table, OUTER JOIN for both
-- ON clause: works the same as WHERE clause

/* ex: 
FROM table1
JOIN table2
    ON table1.col1 = table2.col1
*/

WITH -- used to define a temporary, named result that can then be referred to later in the query

-- EXAMPLE CHALLENGE PROBLEM: most networked center by each state

/* 
WITH mutual_counts AS ( # counts total mutual cosponsorships for each senator
  SELECT
    senator, state, COUNT(*) AS mutual_count  # count distinct mutual relationships for this senator
  FROM (
    SELECT DISTINCT # subquery: find all instances of mutual cosponsorships
      c1.sponsor_name AS senator, 
      c1.sponsor_state AS state, 
      c2.sponsor_name AS senator2 
    FROM cosponsors c1 
    # join table to match; catch vice-versas
    JOIN cosponsors c2
      ON c1.sponsor_name = c2.cosponsor_name
      AND c2.sponsor_name = c1.cosponsor_name
    )
  GROUP BY senator, state # group results by senator (get total count)
),

# find max connections by each state
state_max AS (
  SELECT
    state,
    MAX(mutual_count) AS max_mutual_count
  FROM mutual_counts
  GROUP BY state
)

# filter original state to only show max
SELECT
  mutual_counts.state,
  mutual_counts.senator,
  mutual_counts.mutual_count
FROM mutual_counts
JOIN state_max
  ON mutual_counts.state = state_max.state
  AND mutual_counts.mutual_count = state_max.max_mutual_count
*/

-- Resource 2: https://www.thoughtspot.com/sql-tutorial/introduction-to-sql

BETWEEN -- rows within a certain range
DISTINCT -- only unique values
