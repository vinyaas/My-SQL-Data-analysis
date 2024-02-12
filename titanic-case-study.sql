-- ----------------------------------------------------TITANIC PASSENGER CASE STUDY ------------------------------------------------------------
-- ------------------------------https://www.kaggle.com/competitions/titanic/data?select=train.csv----------------------------------------------

-- Creating a table for the dataset
CREATE TABLE Passenger (
    PassengerId INT PRIMARY KEY,
    Survived INT,
    Pclass INT,
    Name VARCHAR(255),
    Sex VARCHAR(10),
    Age FLOAT,
    SibSp INT,
    Parch INT,
    Ticket VARCHAR(20),
    Fare FLOAT,
    Cabin VARCHAR(20),
    Embarked VARCHAR(1)
);

-- Count the number of passengers in the `Passenger` table
select count(distinct(name)) from passenger;

-- Calculate the average age of passengers in the `Passenger` table.
select round(avg(age),1) from passenger;

-- Retrieve the names of passengers who survived from the `Passenger` table. ( 0 = no , 1 = yes ).
select name from passenger
where survived =  1;

-- Find the minimum fare paid by a passenger from the `Passenger` table.
select *  from passenger
having fare > 0
order by fare asc
limit 1;
-- people have paid a zero as fare which might be an error in the data . so the minimum fare paid is 4.0125

-- Calculate the total number of passengers who survived from the `Passenger` table.
select count(*) from passenger 
where survived = 1;

-- Display the count of passengers in each class (`Pclass`) from the `Passenger` table.
select pclass , count(pclass) from passenger
group by pclass;

-- List the names of passengers who paid more than $100 for their fare from the `Passenger` table.
select name , fare from passenger
having fare > 100
order by fare ;

-- Calculate the survival rate (percentage) of passengers from the `Passenger` table.
select( select count(*) from passenger 
		where Survived = 1) * 100 / count(*) as survival_rate
        from passenger;
        
-- Display the average age of passengers who survived and those who did not survive from the `Passenger` table.
select round(avg(age),1) as survived_avg_age , 
(select round(avg(age),1) from passenger where survived = 0 ) as not_survived_avg_age from passenger 
where survived = 1;

--  Count the number of passengers who are younger than 20 years old from the `Passenger` table.
select count(*) from passenger 
where age < 20;

-- Display the passenger IDs of those who were in Class 3 (`Pclass = 3`) and did not survive from the `Passenger` table.
select passengerid , pclass , Survived from passenger
where pclass = 3 and survived = 0;

-- Find the youngest passenger on board the Titanic from the `Passenger` table.
select min(age) from passenger 
where age >= 1 ;

-- Determine the percentage of passengers who survived in each class (`Pclass`) from the `Passenger` table.        
select pclass , avg(survived) * 100 as survival_rate from passenger
group by pclass
order by survival_rate desc;

-- List the names of passengers who traveled alone (without any family members) from the `Passenger` table.
select name from passenger 
where sibsp = 0 ;
        
-- Calculate the total number of families on board the Titanic (families are considered as passengers with the same last name) from the `Passenger` table.
select count(distinct(substring_index(name , ',' , 1))) as family_name from passenger;

-- Find the median fare paid by passengers from the `Passenger` table.
select round((max(fare) + min(fare)) , 1) / 2 as median_fare from passenger;

-- Display the passenger IDs of those who were in Class 2 (`Pclass = 2`) and survived from the `Passenger` table.
select passengerid , pclass from passenger 
where pclass = 3 and Survived = 1;

-- Find the passenger with the highest fare who survived from the `Passenger` table.
select name , fare  from passenger 
where survived = 1
order by fare desc
limit 1;

-- Calculate the survival rate of passengers based on both their class (`Pclass`) and gender from the `Passenger` table                
select sex , pclass,  avg(survived) * 100 as survival_rate from passenger
group by pclass , sex
order by pclass asc;

-- Determine the average age of passengers grouped by their class (`Pclass`) and gender from the `Passenger` table.
select pclass , sex , round(avg(age),1) as average_age from passenger
group by pclass , sex 
order by pclass asc ;

-- Find the passengers who paid the highest fare within each class (`Pclass`) from the `Passenger` table.
select pclass , max(fare) from passenger 
group by pclass;

-- List the names of passengers who survived and were traveling alone from the `Passenger` table.
select * from passenger 
where sibsp = 0 and parch = 0; 

-- Determine the median age of passengers who did not survive from the `Passenger` table.
select ( select (min(age) + max(age)) / 2) as median_age from passenger;
