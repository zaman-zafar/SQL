SELECT t1.[purchid], 
       t1.[itemid], 
       [invoicedate], 
       [qty], 
       [lineamount], 
       [purchprice], 
       t1.[dataareaid], 
       invoiceid, 
       t1.taxgroup, 
       t1.taxitemgroup, 
       t2.[storenumber], 
       t4.inventsiteid, 
       t11.inventlocationid  AS warehouse, 
       t4.[itembuyergroupid] AS BuyerGroupHeader, 
       t5.itembuyergroupid   AS BuyerGroupLine 
FROM   vendinvoicetrans AS T1 
       JOIN retailchanneltable AS T2 
         ON t1.defaultdimension = t2.defaultdimension 
            AND t1.dataareaid = t2.inventlocationdataareaid 
       JOIN purchtable AS T4 
         ON t1.purchid = t4.purchid 
            AND t1.dataareaid = t4.dataareaid 
       JOIN inventtable AS T5 
         ON t1.itemid = t5.itemid 
            AND t1.dataareaid = t5.dataareaid 
       LEFT JOIN inventdim AS t11 
              ON t1.inventdimid = t11.inventdimid 
                 AND t1.dataareaid = t11.dataareaid 
WHERE  t1.dataareaid = 'company name' 
       AND t1. invoicedate > '2018-12-31' 
UNION ALL 
SELECT t1.[purchid], 
       t1.[itemid], 
       t9.[deliverydate] 
       --,t1.[PURCHSTATUS] 
       --,[QTYORDERED]  
       , 
       [remainpurchfinancial], 
       [lineamount], 
       [purchprice] 
       --,[REMAININVENTFINANCIAL]                                                            
       , 
       t1.[dataareaid], 
       t9.packingslipid, 
       t1.taxgroup, 
       t1.taxitemgroup, 
       t2.[storenumber], 
       t4.inventsiteid, 
       t11.inventlocationid  AS warehouse, 
       t4.[itembuyergroupid] AS BuyerGroupHeader, 
       t5.itembuyergroupid   AS BuyerGroupLine 
FROM   purchline AS T1 
       JOIN retailchanneltable AS T2 
         ON t1.defaultdimension = t2.defaultdimension 
            AND t1.dataareaid = t2.inventlocationdataareaid 
       JOIN purchtable AS T4 
         ON t1.purchid = t4.purchid 
            AND t1.dataareaid = t4.dataareaid 
       JOIN inventtable AS T5 
         ON t1.itemid = t5.itemid 
            AND t1.dataareaid = t5.dataareaid 
       JOIN vendpackingsliptrans AS t9 
         ON t1.dataareaid = t9.dataareaid 
            AND t1.purchid = t9.origpurchid 
            AND t1.itemid = t9.itemid 
            AND t1.linenumber = t9.purchaselinelinenumber 
       LEFT JOIN inventdim AS t11 
              ON t1.inventdimid = t11.inventdimid 
                 AND t1.dataareaid = t11.dataareaid 
WHERE  t1.dataareaid = 'company name' 
       AND t1.purchstatus IN ( 1, 2, 3 ) 
       AND t9.[deliverydate] > '2018-12-31' 