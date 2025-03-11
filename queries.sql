-- ------------------------------------------------------
-- NOTE: DO NOT REMOVE OR ALTER ANY LINE FROM THIS SCRIPT
-- ------------------------------------------------------

-- select 'Query 00' as '';
-- Show execution context
-- select current_date(), current_time(), user(), database();
-- Conform to standard group by constructs
-- set session sql_mode = 'ONLY_FULL_GROUP_BY';

-- Write the SQL queries that return the information below:
-- Ecrire les requêtes SQL retournant les informations ci-dessous:

-- select 'Query 01' as '';
-- The countries of residence the supplier had to ship products to in 2014
-- Les pays de résidence où le fournisseur a dû envoyer des produits en 2014
select distinct c.residence from customers c join orders o on c.cid=o.cid where year(o.odate)=2014;

-- select 'Query 02' as '';
-- For each known country of origin, its name, the number of products from that country, their lowest price, their highest price
-- Pour chaque pays d'orgine connu, son nom, le nombre de produits de ce pays, leur plus bas prix, leur plus haut prix
select origin, count(*) as nb_of_product, min(price) as min_price, max(price) as max_price from products group by origin;

-- select 'Query 03' as '';
-- The customers who ordered in 2014 all the products (at least) that the customers named 'Smith' ordered in 2013
-- Les clients ayant commandé en 2014 tous les produits (au moins) commandés par les clients nommés 'Smith' en 2013
select distinct c.cname from customers c join orders o on c.cid=o.cid where year(o.odate)=2014 group by c.cname having count(distinct o.pid) >= (select count(distinct o2.pid) from orders o2 join customers c2 on c2.cid=o2.cid where c2.cname="SMITH" and year(o2.odate)=2013);

--select 'Query 04' as '';
-- For each customer and each product, the customer's name, the product's name, the total amount ordered by the customer for that product,
-- sorted by customer name (alphabetical order), then by total amount ordered (highest value first), then by product id (ascending order)
-- Par client et par produit, le nom du client, le nom du produit, le montant total de ce produit commandé par le client, 
-- trié par nom de client (ordre alphabétique), puis par montant total commandé (plus grance valeur d'abord), puis par id de produit (croissant)
select c.cname, p.pname, p.price, SUM(p.price * o.quantity) as total_price from customers c join orders o on o.cid=c.cid join products p on o.pid=p.pid group by c.cname, p.pname, p.pid order by c.cname asc, total_price desc, p.pid asc;

--select 'Query 05' as '';
-- The customers who only ordered products originating from their country
-- Les clients n'ayant commandé que des produits provenant de leur pays
select distinct c.cname from customers c join orders o on c.cid=o.cid join products p on o.pid=p.pid where p.origin is not null and c.residence is not null group by c.cname having count(distinct case when p.origin!=c.residence then p.pid end)=0;

--select 'Query 06' as '';
-- The customers who ordered only products originating from foreign countries 
-- Les clients n'ayant commandé que des produits provenant de pays étrangers
select distinct c.cname from customers c join orders o on c.cid=o.cid join products p on o.pid=p.pid where p.origin is not null and c.residence is not null group by c.cname having count(distinct case when p.origin=c.residence then p.pid end)=0;


-- select 'Query 07' as '';
-- The difference between 'USA' residents' per-order average quantity and 'France' residents' (USA - France)
-- La différence entre quantité moyenne par commande des clients résidant aux 'USA' et celle des clients résidant en 'France' (USA - France)
select (select avg(o.quantity) from customers c join orders o on c.cid=o.cid where c.residence="USA") - (select avg(o.quantity) from customers c join orders o on c.cid=o.cid where c.residence="France") as difference;

--select 'Query 08' as '';
-- The products ordered throughout 2014, i.e. ordered each month of that year
-- Les produits commandés tout au long de 2014, i.e. commandés chaque mois de cette année
select distinct p.pid, p.pname from products p join orders o on o.pid=p.pid where year(o.odate)=2014;

--select 'Query 09' as '';
-- The customers who ordered all the products that cost less than $5
-- Les clients ayant commandé tous les produits de moins de $5
select distinct c.cname from customers c join orders o on o.cid=c.cid join products p on p.pid=o.pid group by c.cname having count(distinct case when p.price<=5 then p.pid end)=(select count(distinct pid) from products where price <=5);

--select 'Query 10' as '';
-- The customers who ordered the greatest number of common products. Display 3 columns: cname1, cname2, number of common products, with cname1 < cname2
-- Les clients ayant commandé le plus grand nombre de produits commums. Afficher 3 colonnes : cname1, cname2, nombre de produits communs, avec cname1 < cname2
with customer_products as (select c.cname, o.pid from customers c join orders o on c.cid=o.cid) select cname1, cname2, nb_p from (select cp1.cname as cname1, cp2.cname as cname2, count(*) as nb_p from customer_products cp1 join customer_products cp2 on cp1.pid=cp2.pid and cp1.cname<cp2.cname group by cp1.cname, cp2.cname) as pair order by nb_p desc limit 1;

--select 'Query 11' as '';
-- The customers who ordered the largest number of products
-- Les clients ayant commandé le plus grand nombre de produits
select c.cname, sum(o.quantity) as quantity from customers c join orders o on o.cid=c.cid group by c.cid order by quantity desc;

--select 'Query 12' as '';
-- The products ordered by all the customers living in 'France'
-- Les produits commandés par tous les clients vivant en 'France'
select p.pname from products p join orders o on p.pid=o.pid join customers c on c.cid=o.cid group by p.pid having count(distinct case when c.residence="France" then c.cid end)=(select count(distinct cid) from customers where residence="France");

--select 'Query 13' as '';
-- The customers who live in the same country customers named 'Smith' live in (customers 'Smith' not shown in the result)
-- Les clients résidant dans les mêmes pays que les clients nommés 'Smith' (en excluant les Smith de la liste affichée)
select distinct c.cname from customers c where c.residence in (select distinct residence from customers where cname="Smith") and c.cname!="Smith";

--select 'Query 14' as '';
-- The customers who ordered the largest total amount in 2014
-- Les clients ayant commandé pour le plus grand montant total sur 2014 
select c.cname from customers c join orders o on o.cid=c.cid join products p on p.pid=o.pid group by c.cid order by SUM(o.quantity * p.price) desc;

--select 'Query 15' as '';
-- The products with the largest per-order average amount 
-- Les produits dont le montant moyen par commande est le plus élevé
select p.pname from products p join orders o on p.pid=o.pid group by p.pid order by  sum(o.quantity) desc;

--select 'Query 16' as '';
-- The products ordered by the customers living in 'USA'
-- Les produits commandés par les clients résidant aux 'USA'
select p.pname, p.origin from products p join orders o on p.pid=o.pid join customers c on c.cid=o.cid where c.residence="USA" group by p.pid;

--select 'Query 17' as '';
-- The pairs of customers who ordered the same product en 2014, and that product. Display 3 columns: cname1, cname2, pname, with cname1 < cname2
-- Les paires de client ayant commandé le même produit en 2014, et ce produit. Afficher 3 colonnes : cname1, cname2, pname, avec cname1 < cname2
with customer_products as (select c.cname, c.cid, p.pname, p.pid from customers c join orders o on o.cid=c.cid join products p on p.pid=o.pid where year(o.odate)=2014) select cname1, cname2, pname from (select cp1.cname as cname1, cp2.cname as cname2, cp1.pname as pname from customer_products cp1 join customer_products cp2 on cp1.pid=cp2.pid and cp1.cname<cp2.cname group by cp1.cname, cp2.cname, cp1.pid) as pair order by cname1 asc, cname2 asc, pname asc;

--select 'Query 18' as '';
-- The products whose price is greater than all products from 'India'
-- Les produits plus chers que tous les produits d'origine 'India'
select pname from products where price > (select max(price) from products where origin="India");

--select 'Query 19' as '';
-- The products ordered by the smallest number of customers (products never ordered are excluded)
-- Les produits commandés par le plus petit nombre de clients (les produits jamais commandés sont exclus)
select p.pname from products p join origin o on p.pid=o.pid group by p.pid order by count(o.cid) asc;

--select 'Query 20' as '';
-- For all countries listed in tables products or customers, including unknown countries: the name of the country, the number of customers living in this country, the number of products originating from that country
-- Pour chaque pays listé dans les tables products ou customers, y compris les pays inconnus : le nom du pays, le nombre de clients résidant dans ce pays, le nombre de produits provenant de ce pays 
select country, sum(nb_customers), sum(nb_product) from (select c.residence as country, count(distinct c.cid) as nb_customers, 0 as nb_product from customers c group by c.residence union all select p.origin as country, 0 as nb_customers, count(distinct p.pid) as nb_products from products p group by p.origin) as full_join group by country order by country;


