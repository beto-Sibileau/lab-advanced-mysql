
-- Challenge 1 (step 1 and 2 together plus step 3 from a derived table)
-- We need the derived table for step 3 in order not to sum the advances per book more than once
select `Author ID`,
sum(`Royalty Sum`) + sum(`Advance`) as `Profit`
from (select t.title_id as `Title ID`, au_id as `Author ID`,
royaltyper / 100 * advance as `Advance`,
sum(royaltyper / 100 * royalty / 100 * price * qty) as `Royalty Sum`
from
titles t join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id
group by `Title ID`, `Author ID`) agg1
group by `Author ID` order by `Profit` desc limit 3;

-- Challenge 2 is about repeating the process but with a temporary table
CREATE TEMPORARY TABLE agg1
select t.title_id as `Title ID`, au_id as `Author ID`,
royaltyper / 100 * advance as `Advance`,
sum(royaltyper / 100 * royalty / 100 * price * qty) as `Royalty Sum`
from
titles t join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id
group by `Title ID`, `Author ID`;

-- now i query on the temporary table
select `Author ID`,
sum(`Royalty Sum`) + sum(`Advance`) as `Profit`
from agg1
group by `Author ID` order by `Profit` desc;

-- Challenge 3 is about creating a permanent table `most_profiting_authors` with the results
create table `most_profiting_authors`
as
select `Author ID`,
sum(`Royalty Sum`) + sum(`Advance`) as `Profit`
from agg1
group by `Author ID` order by `Profit` desc;

-- show tables for reference
/* 
select * from titles order by title_id;
select * from titleauthor order by title_id;
select * from sales;
*/

-- do a series of joins each of them as a derived table
/*
select `Title ID`,`Author ID`,
getTitAut.autRoy / 100 * getTitAut.titRoy / 100 * getTitAut.titPric * sales.qty as `Royalty`,
getTitAut.autRoy * getTitAut.titAdv / 100 as `Advance`
from (select titles.title_id as `Title ID`, titleauthor.au_id as `Author ID`, titles.royalty as titRoy,
titles.price as titPric, titles.advance as titAdv, titleauthor.royaltyper as autRoy
from titles
inner join titleauthor on titles.title_id = titleauthor.title_id) getTitAut
inner join sales on getTitAut.`Title ID` = sales.title_id;
*/

-- same creation of derived tables but using WHERE instead of JOIN
/*
select `Title ID`,`Author ID`,
getTA.autRoy / 100 * getTA.titRoy / 100 * getTA.titPric * s.qty as `Royalty`,
getTA.autRoy * getTA.titAdv / 100 as `Advance`
from (select t.title_id as `Title ID`, ta.au_id as `Author ID`, t.royalty as titRoy,
t.price as titPric, t.advance as titAdv, ta.royaltyper as autRoy
from titles t, titleauthor ta where t.title_id = ta.title_id) getTA, sales s
where getTA.`Title ID` = s.title_id;
*/

-- no need to create derived tables if just a series of joins is needed
/*
select titleauthor.title_id as `Title ID`, au_id as `Author ID`,
royaltyper / 100 * royalty / 100 * price * qty as `Royalty`,
royaltyper * advance / 100 as `Advance`
from titles join titleauthor on titles.title_id = titleauthor.title_id
join sales on titleauthor.title_id = sales.title_id;
*/

-- no need to create derived tables if just a series of joins is needed
/*
select t.title_id as `Title ID`, au_id as `Author ID`,
royaltyper / 100 * advance as `Advance`,
royaltyper / 100 * royalty / 100 * price * qty as `Royalty`
from
titles t join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id
order by `Title ID`, `Author ID`;
*/

-- no need to create derived tables if just a series of joins is needed
/*
select t.title_id as `Title ID`, au_id as `Author ID`,
royaltyper / 100 * advance as `Advance`,
sum(royaltyper / 100 * royalty / 100 * price * qty) as `Royalty Sum`
from
titles t join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id
group by `Title ID`, `Author ID`;
*/

-- the is the solution without a derived table (it sums the advances wrongly,
-- that is, more that once per title and author!)
/*
select au_id as `Author ID`,
sum(royaltyper / 100 * advance) + sum(royaltyper / 100 * royalty / 100 * price * qty) as `Profit`
from
titles t join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id
group by `Author ID` order by `Profit` desc;
*/