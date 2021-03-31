SELECT t1.[transactionid], 
       t1.[linenum], 
       [receiptid], 
       [incomeexepenseaccount], 
       t1.[store], 
       t2.namealias, 
       t2.NAME, 
       t2.messageline1, 
       t1.[transactionstatus], 
       t1.[amount], 
       t1.[accounttype], 
       t1.[statementid], 
       t1.[transdate], 
       t1.[businessdate], 
       t1.[dataareaid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid], 
       t3.information 
FROM   [MITAX_live].[dbo].[retailtransactionincomeexpensetrans] AS t1 
       JOIN retailincomeexpenseaccounttable AS t2 
         ON t1.incomeexepenseaccount = t2.accountnum 
            AND T2.dataareaid = 'comapany name' 
            AND storeid = 'KWSL' 
       LEFT JOIN retailtransactioninfocodetrans AS t3 
              ON t1.transactionid = t3.transactionid 
WHERE  t1.dataareaid = 'comapany name' 
       AND receiptid <> '' 
       AND t1.transactionstatus <> 1 
       AND t1.[transdate] > '2018-12-31' 