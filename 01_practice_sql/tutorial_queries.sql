-- Resources: https://selectstarsql.com/ ; https://www.thoughtspot.com/sql-tutorial/introduction-to-sql

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

COUNT -- commonly used aggregate function to count things
-- Usage: SELECT COUNT(col_name) FROM table_name; (*) as col_name counts all rows with > 0 non-nulls
-- Counts non NULL : doesn't mean empty or 0 (means TRUE)

CASE -- acts as a big if-else statement
-- Usage: WHEN clause THEN result; ELSE result; END
-- a bit archaic but works well

WHERE -- filters dataset based on clause before aggregation occurs
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

-- Nesting: multiple queries within each other; allow for more complex values such as percentages