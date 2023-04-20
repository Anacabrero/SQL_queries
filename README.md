# SQL: Window functions and nested queries


SQL is an easy to learn yet powerful language when it comes to Data Analysis.
There are however, some functionalities that usually take longer to understand and therefore put into practice.

One of them are the window functions. 

A window function performs a calculation across a set of table rows that have some relationship with the current row.
They fall into three different categories:

-	Aggregate Window functions: Can be compared with aggregate functions, but unlike those that reduce the number of rows to match the categories in the aggregation, windows functions do not cause rows to become grouped into a single output row, so the number of rows is not modified.
Use case example: Comparing each category sales’ percentage over the total sales.

-	Ranking Window functions: Assign numbers to rows on a defined order. These window functions are especially useful since there is not any other functionality to achieve an equivalent output in an easy way.
Use case example: Creating counters, displaying the numbers of the rows that have been previously sorted.

-	Value Window functions: assign to rows values from other rows. Use case example: Comparing current sales performance with sales in previous unit of time.
 

# Bonus!

I am taking advantage of this opportunity to introduce the concept of nested queries vs temporary tables.
Temporary tables, as their name implies, exist only temporarily on the database server. As soon as the session in which it has been created is closed, the temporary table will be dropped automatically by SQL Server.
However, most of the times temporary tables can be bypassed by nested tables. This means, you do not need to save a provisional table and then use it, but nest it in the same query and do it all at once.


I have prepared some examples to illustrate both windows functions and nested tables using a single table so that you can understand it. You can also download the code and play around with it. Hope you enjoy it!
