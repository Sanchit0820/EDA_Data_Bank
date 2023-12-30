USE CASE2;
/*
SQL Case Study 3: Data Bank

INTRODUCTION:
Neo-Banks are a recent development in the financial sector; they are new banks that solely operate online.
I believed that there should be some kind of connection between the digital world, these new age institutions, and cryptocurrencies.
So I made the decision to start a new project called Data Bank! 
Customers of Data Bank receive cloud data storage allotments that are directly related to the balances in their accounts. The Data Bank team needs your assistance since this business model comes with some intriguing drawbacks.
This case study focuses on metrics calculations, business growth, and smart data analysis to assist the company more accurately estimate and plan for the future.


SCHEMA USED : 

   REGION TABLE
........................
|REGION_ID   | INT     |
|REGION_NAME | VARCHAR |
........................
		   .
           .
           .
           .         .........................  CUSTOMER_TRANSACTIONS TABLE
		   .         .                          ...........................
           .         .                          | CUSTOMER_ID | INT       |
           .         .                          | TXN_DATE    | DATE      |
           .         .                          | TXN_TYPE    | VARCHAR   |
           .         .                          | TXN_AMOUNT  | INT       |
           .         .                          ...........................
           .         .
   CUSTOMER_NODES TABLE
.........................
| CUSTOMER_ID | INT     |
| REGION_ID   | INT     |
| NODE_ID     | INT     |
| START_DATE  | DATE    |
| END_DATE    | DATE    |
.........................



CASE STUDY QUESTIONS /*

/*1.How many different nodes make up the Data Bank network?/*

SELECT COUNT(DISTINCT NODE_ID) AS UNIQUE_NODES
FROM CUSTOMER_NODES ;

/*2.How many nodes are there in each region?/*

SELECT R.REGION_NAME,
COUNT(C.NODE_ID) AS NO_OF_NODES
FROM REGIONS R
LEFT JOIN CUSTOMER_NODES C
ON R.REGION_ID = C.REGION_ID
GROUP BY R.REGION_NAME ;

/*3.How many customers are divided among the regions?/*

SELECT R.REGION_NAME,
COUNT(C.CUSTOMER_ID) AS CUSTOMER_COUNT
FROM REGIONS R
LEFT JOIN CUSTOMER_NODES C
ON R.REGION_ID = C.REGION_ID
GROUP BY R.REGION_NAME ;


/*4.Determine the total amount of transactions for each region name./*

SELECT R.REGION_NAME, SUM(T.TXN_AMOUNT) AS TOTAL_TRANSACTION_AMOUNT
FROM CUSTOMER_NODES C 
LEFT JOIN CUSTOMER_TRANSACTIONS T
ON C.CUSTOMER_ID = T.CUSTOMER_ID
RIGHT JOIN REGIONS R
ON C.REGION_ID = R.REGION_ID
GROUP BY R.REGION_NAME ;


/*5.How long does it take on an average to move clients to a new node?/*

SELECT ROUND(AVG(DATEDIFF(END_DATE, START_DATE)),2) AS AVG_DAYS
FROM CUSTOMER_NODES
WHERE END_DATE!= '9999-12-31' ;

/*6.What is the unique count and total amount for each transaction type?/*

SELECT TXN_TYPE, COUNT(TXN_TYPE) AS UNIQUE_COUNT, SUM(TXN_AMOUNT) AS TOTAL_AMOUNT
FROM CUSTOMER_TRANSACTIONS
GROUP BY TXN_TYPE ;


/*7.What is the average number and size of past deposits across all customers?/*

SELECT ROUND(COUNT(CUSTOMER_ID)
/(SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMER_TRANSACTIONS)) AS AVERAGE_DEPOSIT
FROM CUSTOMER_TRANSACTIONS
WHERE TXN_TYPE = 'DEPOSIT' ;


/*8.For each month - how many Data Bank customers make more than 1 deposit and at least either 1 purchase or 1 withdrawal in a single month?/*

WITH CTE AS (
SELECT CUSTOMER_ID, 
MONTH(TXN_DATE) AS TXN_MONTH,
SUM(IF(TXN_TYPE = 'DEPOSIT', 1,0)) AS DEPOSIT_COUNT,
SUM(IF(TXN_TYPE = 'WITHDRAWAL', 1,0)) AS WITHDRAWAL_COUNT,
SUM(IF(TXN_TYPE = 'PURCHASE', 1,0)) AS PURCHASE_COUNT
FROM CUSTOMER_TRANSACTIONS
GROUP BY CUSTOMER_ID, TXN_MONTH
)

SELECT TXN_MONTH, 
COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT
FROM CTE
WHERE DEPOSIT_COUNT>1 AND
WITHDRAWAL_COUNT = 1 OR PURCHASE_COUNT = 1
GROUP BY TXN_MONTH ;