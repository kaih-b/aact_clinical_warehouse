-- Resources: https://www.thoughtspot.com/sql-tutorial/sql-window-functions; https://www.postgresql.org/docs/9.1/tutorial-window.html 

-- Purpose: perform a calculations across a set of rows that are somehow positionally related to the current row
-- e.g. comparing a selected month to the month previous; creating a running total
-- Utility: rows retain seperate identities (i.e. are not aggregated)
-- the window function accesses a new virtual table view
-- most window functions operate on the *window frame*, which is a set of rows around each row

SELECT table_name
    SUM(col_1) OVER (ORDER BY col_2) AS total
FROM dataset

-- this is an aggregation without actually aggregating (e.g. using GROUP BY)
-- you can narrow the window via PARTITION BY col_3, e.g. if many rows have 3 possibles in col_3, you can partition
-- the partition is the ordered subset over which calculations are performed

-- SUM, COUNT, and AVERAGE are the most common
-- ROW_NUMBER gives the row number; RANK works by row number and assigns duplicates the same value with skips; DENSE_RANK no skips
-- NTILE distinguishes percentiles 
-- LAG pulls from previous rows; LEAD pulls from subsequent rows (key in this application, see 06)
