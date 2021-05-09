/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

Answer1: SELECT name FROM `Facilities` WHERE membercost != 0;


/* Q2: How many facilities do not charge a fee to members? */

Answer2: SELECT name FROM `Facilities` WHERE membercost = 0;



/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

Answer3: SELECT facid, name, membercost, monthlymaintenance FROM `Facilities` WHERE membercost != 0 and membercost < 0.2*monthlymaintenance;




/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

Answer4: SELECT * FROM `Facilities` WHERE facid in (1, 5);



/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

Answer5: SELECT name, case when monthlymaintenance < 100 then 'Cheap' else 'Expensive' end, monthlymaintenance FROM `Facilities`;



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

Answer6: SELECT firstname, surname, max(joindate) FROM `Members`;


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

Answer7: select distinct member_name, court_name from 
(
SELECT concat(m.firstname, ' ', m.surname) as member_name, f.name as court_name  FROM `Members` m
left join `Bookings` b on m.memid = b.memid 
left join `Facilities` f on b.facid = f.facid
WHERE f.name like ('Tennis %') 
) q WHERE 1
order by member_name;



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

Answer8: SELECT member_name, court_name, total_if_member, guest_total from 
(SELECT concat(m.firstname, ' ', m.surname) as member_name, f.name as court_name,
sum(membercost) total_if_member, sum(guestcost) guest_total FROM `Bookings` b
left join `Members` m on m.memid = b.memid 
left join `Facilities` f on b.facid = f.facid
WHERE date(b.starttime) = '2012-09-14'
group by member_name
order by guestcost, membercost desc) q
where total_if_member > 30 or guest_total > 30;



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

Answer9: SELECT member_name, court_name, total_if_member, guest_total from 
(SELECT concat(m.firstname, ' ', m.surname) as member_name, f.name as court_name,
sum(membercost) total_if_member, sum(guestcost) guest_total FROM `Bookings` b
left join `Members` m on m.memid = b.memid 
left join `Facilities` f on b.facid = f.facid
WHERE date(b.starttime) = '2012-09-14'
group by member_name
order by guestcost, membercost desc) q
where total_if_member > 30 or guest_total > 30;




/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
Answer10: select facility_name, (totalmembercost+totalguestcost) total_revenue from
(
    SELECT f.name as facility_name, sum(f.membercost) totalmembercost, sum(f.guestcost) totalguestcost 
FROM `Bookings` b
left join `Facilities` f
on b.facid = f.facid
group by b.facid ) q
group by facility_name
having total_revenue > 1000
order by total_revenue;

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */

Answer12:select facility_name, totalmembercost total_revenue from
(
    SELECT f.name as facility_name, sum(f.membercost) totalmembercost 
FROM `Bookings` b
left join `Facilities` f
on b.facid = f.facid
group by b.facid ) q
group by facility_name
having total_revenue !=0
order by total_revenue;

/* Q13: Find the facilities usage by month, but not guests */

