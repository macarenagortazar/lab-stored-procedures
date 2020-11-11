  Use sakila;

  -- Convert the query into a simple stored procedure. 
drop procedure simple_action; 
DELIMITER //
create procedure simple_action(out customers varchar(50))
begin
    select concat(first_name," ",last_name) as customers, email as email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by concat(first_name," ",last_name);
 END //
 DELIMITER ;
 
 call simple_action(@x);

 
 
  -- Convert the query into a simple stored procedure. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
  
Drop procedure categories;
  delimiter //
create procedure categories(in param1 varchar(50))
begin
  select concat(first_name," ",last_name) as full_name, email, cat.name as category from customer as c
  join rental as r 
  on c.customer_id = r.customer_id
  join inventory as i 
  on r.inventory_id = i.inventory_id
  join film as f
  on f.film_id = i.film_id
  join film_category as fc 
  on fc.film_id = f.film_id
  join category as cat
  on cat.category_id = cat.category_id
   group by concat(first_name," ",last_name), email
having cat.name COLLATE utf8mb4_general_ci = param1;
END //
delimiter ;

call categories("Action");

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

Drop procedure year_count;
  delimiter //
create procedure year_count(in param1 int)
begin
select cat.name as category, count(*) as number_movies, release_year from film as f
join film_category as fc 
on fc.film_id=f.film_id
join category as cat
on cat.category_id = fc.category_id
group by cat.name
having release_year COLLATE utf8mb4_general_ci > param1;
END //
delimiter ;

call year_count(2004);

Drop procedure movie_count;
  delimiter //
create procedure  movie_count(in param1 int)
begin
select cat.name as category, count(*) as number_movies, release_year from film as f
join film_category as fc 
on fc.film_id=f.film_id
join category as cat
on cat.category_id = fc.category_id
group by cat.name
having number_movies COLLATE utf8mb4_general_ci > param1;
END //
delimiter ;

call  movie_count(61);


