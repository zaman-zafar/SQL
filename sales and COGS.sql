/****** Script for SelectTopNRows command from SSMS  ******/ 
-- the main problem in this code is that 2 sales line with different receipt can have same Inventtransid but on cost side there will have 1 InventtransID so we have to group sales by InventtransID
SELECT T1.[itemid], 
       t3.batchid, 
       Sum(T1.[qty])        AS QTY, 
       T1.[transactionstatus], 
       Sum(T1.[costamount]) AS COSTAMOUNT, 
       T1.[transdate], 
       T1.[shift], 
       Sum(T1.[netamount])  AS NETAMOUNT, 
       T1.[statementid], 
       T1.[custaccount], 
       T1.[section], 
       T1.[shelf], 
       T1.[statementcode], 
       T1.[discgroupid], 
       T1.[store], 
       T1.[staffid], 
       T1.[inventtransid], 
       T1.[inventdimid], 
       T1.[inventstatussales], 
       t5.itembuyergroupid, 
       t3.invoiceid, 
       t7.costamountposted, 
       t7.costamountadjustment 
FROM   retailtransactionsalestrans AS T1 
       JOIN retailtransactionpaymenttrans AS t2 
         ON t1.transactionid = t2.transactionid 
            AND t1.receiptid = t2.receiptid 
            AND t1.dataareaid = t2.dataareaid 
            AND t2.linenum = 1 
       JOIN retailtransactiontable AS T3 
         ON T1.dataareaid = t3.dataareaid 
            AND T1.receiptid = t3.receiptid 
            AND t1.transactionid = t3.transactionid 
       JOIN inventtable AS T5 
         ON T1.itemid = t5.itemid 
            AND T1.dataareaid = t5.dataareaid 
       --the Above are relates to sales and below area relates to COGS. Inventtrans has COGS but can't be directly linked to sales but through InventTransOrigin you can link Retail Transaction and Inventtrans
       LEFT JOIN inventtransorigin AS t6 
              ON t1.inventtransid = t6.inventtransid 
                 AND t1.dataareaid = t6.dataareaid 
       LEFT JOIN (SELECT [itemid], 
                         Sum([qty])                  AS QTY, 
                         Sum([costamountposted])     AS COSTAMOUNTPOSTED, 
                         [inventtransorigin], 
                         dataareaid, 
                         Sum([costamountadjustment]) AS COSTAMOUNTADJUSTMENT 
                  FROM   inventtrans 
                  GROUP  BY itemid, 
                            inventtransorigin, 
                            dataareaid) AS t7 
              ON t6.recid = t7.inventtransorigin 
                 AND t6.dataareaid = t7.dataareaid 
                 AND t6.itemid = t7.itemid 
--THe reason of not selecting complete Inventtrans table is that same RECEIPT CAN HAVE 2 INVENTTRANSORIGIN ID
WHERE  T1.dataareaid = 'companyname' 
       AND t1.transactionstatus <> 1 
       AND t1.receiptid <> '' 
       AND t1.transdate > '2018-12-31' 
GROUP  BY 
--IN GROUP BY I HAD TO REMOVE A LOT OF COLUMNS LIKE RECEIPT ID, SCANNING, EVEN BARCODE SO THAT ALL TRANSACTION WITH SIMILLAR INVENTTRANSid CAN ADD 
T1.[itemid], 
t3.batchid, 
T1.[transactionstatus], 
T1.[transdate], 
T1.[shift], 
T1.[statementid], 
T1.[custaccount], 
T1.[section], 
T1.[shelf], 
T1.[statementcode], 
T1.[discgroupid], 
T1.[store], 
T1.[staffid], 
T1.[inventtransid], 
T1.[inventdimid], 
T1.[inventstatussales], 
t5.itembuyergroupid, 
t3.invoiceid, 
t7.costamountposted, 
t7.costamountadjustment 
ORDER  BY T1.transdate 