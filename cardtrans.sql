/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT t3.invoiceid, 
       t3.batchid, 
       [linenum], 
       t1.[receiptid], 
       t1.[statementcode], 
       [cardoraccount], 
       [cardtypeid], 
       t1.[exchrate], 
       [tendertype], 
       [amounttendered], 
       t1.[currency], 
       [amountcur], 
       t1.[transdate], 
       t1.[store], 
       [transactionstatus], 
       t1.[statementid], 
       [amountmst], 
       t1.[businessdate], 
       t3.incomeexpenseamount 
FROM   [MITAX_live].[dbo].[retailtransactionpaymenttrans] AS t1 
       LEFT JOIN retailtransactiontable AS T3 
              ON T1.dataareaid = t3.dataareaid 
                 AND T1.receiptid = t3.receiptid 
                 AND t1.transactionid = t3.transactionid 
WHERE  t1.dataareaid = 'companyname' 
       AND transactionstatus <> 1 
       AND t1.receiptid <> '' 
       AND tendertype = '2' 
       AND t1.[transdate] > '2018-12-31' 