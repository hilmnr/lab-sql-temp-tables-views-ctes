-- 1. First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
create view customer_rental_summary as(
select c.customer_id, c.first_name, c.email, count(r.rental_id) as rental_count
from rental r
left join customer c on r.customer_id = c.customer_id
group by c.customer_id, c.first_name,  c.email);



-- 2. Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
--  The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
create temporary table temp_total_payments as(
select crs.customer_id, crs.first_name, crs.email, sum(p.amount) AS total_paid
from customer_rental_summary crs
left join rental r on crs.customer_id = r.customer_id
left join payment p on r.rental_id = p.rental_id
group by crs.customer_id, crs.first_name, crs.email);


-- 3. Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
with customersummarycte as (
select
crs.customer_id,
crs.first_name,
crs.email,
crs.rental_count,
tps.total_paid
from customer_rental_summary crs
inner join temp_total_payments tps on crs.customer_id = tps.customer_id
)

select
customer_id,
first_name,
email,
rental_count,
total_paid
from
customersummarycte;

-- 4. Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
with customersummarycte as (
select
crs.customer_id,
crs.first_name,
crs.email,
crs.rental_count,
tps.total_paid
from customer_rental_summary crs
inner join temp_total_payments tps on crs.customer_id = tps.customer_id
)

select
    first_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
from
    customersummarycte;