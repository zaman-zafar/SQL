SELECT [transactioncurrencyamount], 
       [accountingcurrencyamount], 
       [reportingcurrencyamount], 
       [quantity], 
       [allocationlevel], 
       [iscorrection], 
       [iscredit], 
       [transactioncurrencycode], 
       [paymentreference], 
       [postingtype], 
       [ledgerdimension], 
       [generaljournalentry], 
       [text], 
       [reasonref], 
       [projid_sa], 
       [projtabledataareaid], 
       [historicalexchangeratedate], 
       [ledgeraccount], 
       [mainaccount], 
       t1.[createdtransactionid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid], 
       t2.journalcategory, 
       t2.documentnumber, 
       t2.subledgervoucherdataareaid, 
       t2.journalnumber, 
       t3.purchid AS POINvoice, 
       t4.purchid AS PODelivery, 
       t5.storenumber, 
       t2.accountingdate 
FROM   [MITAX_live].[dbo].[generaljournalaccountentry] AS t1 
       LEFT JOIN generaljournalentry AS t2 
              ON t1.generaljournalentry = t2.recid 
       LEFT JOIN vendinvoicejour AS t3 
              ON t2.documentnumber = t3.invoiceid 
                 AND t2.subledgervoucherdataareaid = t3.dataareaid 
                 AND t2.subledgervoucher = t3.ledgervoucher 
       LEFT JOIN (SELECT DISTINCT packingslipid, 
                                  dataareaid, 
                                  purchid 
                  FROM   vendpackingslipjour) AS t4 
              ON t2.documentnumber = t4.packingslipid 
                 AND t2.subledgervoucherdataareaid = t4.dataareaid 
       --the problem with above line is that some purchase order have same product receipt no so that is why it extra line exist
       -- Example is of JournalNumber KRJI-069373,   KRJI-069379,   KRJI-070365 
       LEFT JOIN retailchanneltable AS t5 
              ON Substring(ledgeraccount, 8, 4) = t5.eftstorenumber 
WHERE  t2.journalcategory = '3' 
       AND t2.subledgervoucherdataareaid = 'company name' 
       AND t2.accountingdate > '2018-12-31' 
ORDER  BY t3.purchid DESC 