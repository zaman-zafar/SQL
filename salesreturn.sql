/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT T1.[transactionid], 
       T1.[receiptid], 
       t2.receiptid                                AS ActualReceipt, 
       T1.[barcode], 
       T1.[itemid], 
       T1.[price], 
       T1.[qty], 
       T1.[taxgroup], 
       T1.[transactionstatus], 
       T1.[discamount], 
       T1.[costamount], 
       T1.[transdate], 
       t2.transdate                                AS ActualSalesDate, 
       Datediff(day, t2.transdate, T1.[transdate]) AS diff, 
       T1.[netamount], 
       T1.[taxamount], 
       T1.[statementid], 
       T1.[custaccount], 
       T1.[store], 
       T1.[itemidscanned], 
       T1.[keyboarditementry], 
       T1.[returntransactionid], 
       t7.displaystring                            AS infoCode 
FROM   [MITAX_live].[dbo].[retailtransactionsalestrans] AS t1 
       LEFT JOIN (SELECT DISTINCT( transactionid ), 
                                 dataareaid, 
                                 transdate, 
                                 receiptid 
                  FROM   retailtransactionsalestrans) AS t2 
              ON t1.returntransactionid = t2.transactionid 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN retailtransactioninfocodetrans AS t7 
              ON t1.transactionid = t7.transactionid 
                 AND t1.dataareaid = t7.dataareaid 
                 AND t7.infocodeid = '009' 
                 AND t1.linenum = t7.parentlinenum 
WHERE  T1.dataareaid = 'comapany name' 
       AND T1.qty > 0 
       AND T1.transdate > '2018-12-31' 
       AND T1.receiptid <> '' 
       AND T1.transactionstatus <> 1 
       AND T1.returntransactionid <> '' 
--  and t2.RECEIPTID = 'KAAF1401191006936' 
--  order by TRANSDATE 
--and DATEDIFF(day,t2.TRANSDATE,T1.[TRANSDATE]) >'15' 
--- some shops are returning without receipt 