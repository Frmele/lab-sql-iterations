#Lab | SQL Iterations
#In this lab, we will continue working on the Sakila database of movie rentals.

#Instructions
#Write queries to answer the following questions:

#Write a query to find what is the total business done by each store.
use sakila;


select s.store_id, sum(p.amount)
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id;

-------------------------------

drop procedure if exists store_payments;
delimiter //
create procedure store_payments ()
begin    
select s.store_id, sum(p.amount)
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id;    
end
//
delimiter ;

call store_payments();




#Convert the previous query into a stored procedure.


#Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists store_payments;
delimiter //
create procedure store_payments (in id int)
begin    
select s.store_id, sum(p.amount)
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id
having store_id=id;    
end
//
delimiter ;

call store_payments(2);

-------------------------------
#Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total 
#sales amount for the store). Call the stored procedure and print the results.

drop procedure if exists store_payments;
delimiter //
create procedure store_payments (in id int, out total_sales_value float)
begin
#declare total_sales_value float default 0.0;
select sum(p.amount) into total_sales_value    
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id
having store_id=id;   
#set total_sales_value = 0.0; 
end;
//
delimiter ;

call store_payments(2,@x);
select @x as storerevenue;





# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag,
# otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for
# that store and flag value.
drop procedure if exists store_flag;
delimiter //
create procedure store_flag(in store_input integer, out total_sales_value float, out flag varchar(20))
begin
#declare total_sales_value float default 0.0;
#declare flag varchar(20) default "";
select sum(p.amount) into total_sales_value
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
where s.store_id = store_input
group by s.store_id;
case
	when total_sales_value > 30000 then
		set flag = 'green';
	else
		set flag = 'red';
  end case;  
  select flag into flag;
#select flag;    
end;
//
delimiter ;
call store_flag(2, @y,@x);
#we can change the placehold to 33500 if we wish to differentiate the results among the 2 stores 
select round(@y,2) as revenue,@x as flag;