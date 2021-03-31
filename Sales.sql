SELECT T1.[currency], 
       T1.[transactionid], 
       T1.[linenum], 
       T2.tendertype, 
       t1.discamount, 
       t1.price, 
       t1.staff, 
       T1.[receiptid], 
       T1.[barcode], 
       T1.[itemid], 
       t3.batchid, 
       T1.[qty], 
       T1.[transactionstatus], 
       T1.[costamount], 
       T1.[transdate], 
       T1.[shift], 
       T1.[netamount], 
       t1.[taxamount], 
       T1.[statementid], 
       T1.[custaccount], 
       t6.accountnum, 
       T1.[section], 
       T1.[shelf], 
       T1.[statementcode], 
       T1.[discgroupid], 
       T1.[store], 
       T1.[itemidscanned], 
       T1.[keyboarditementry], 
       T1.[priceinbarcode], 
       T1.[pricechange], 
       T1.[staffid], 
       T1.[periodicdiscgroup], 
       T1.[inventtransid], 
       T1.[inventdimid], 
       T1.[inventstatussales], 
       t5.itembuyergroupid, 
       t1.itemidscanned, 
       T2.cardtypeid, 
       t3.invoiceid, 
       t7.displaystring AS infoCode 
FROM   retailtransactionsalestrans AS T1 
       LEFT JOIN retailtransactionpaymenttrans AS t2 
              ON t1.transactionid = t2.transactionid 
                 AND t1.receiptid = t2.receiptid 
                 AND t1.dataareaid = t2.dataareaid 
                 AND t2.linenum = 1 
       LEFT JOIN retailtransactiontable AS T3 
              ON T1.dataareaid = t3.dataareaid 
                 AND T1.receiptid = t3.receiptid 
                 AND t1.transactionid = t3.transactionid 
       JOIN inventtable AS T5 
         ON T1.itemid = t5.itemid 
            AND T1.dataareaid = t5.dataareaid 
       LEFT JOIN whscusttable AS t6 
              ON t1.custaccount = t6.accountnum 
                 AND t1.dataareaid = t6.dataareaid 
       LEFT JOIN retailtransactioninfocodetrans AS t7 
              ON t1.transactionid = t7.transactionid 
                 AND t1.dataareaid = t7.dataareaid 
                 AND t7.infocodeid = '009' 
                 AND t1.netamount = t7.amount *- 1 
                 AND t1.linenum = t7.linenum 
WHERE  T1.dataareaid = 'company name' 
       AND t1.transactionstatus <> 1 
       AND t1.receiptid <> '' 
       AND T1.[transdate] > '2018-12-31' 
ORDER  BY T1.transdate 