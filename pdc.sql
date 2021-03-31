SELECT [maturitydate], 
       t2.journalnum, 
       t2.amountcurdebit, 
       t2.amountcurcredit, 
       t2.txt, 
       t2.paymmode, 
       t4.displayvalue, 
       t5.storenumber, 
       t6.NAME, 
       t9.NAME, 
       [checknumber], 
       [datereceived], 
       t1.dataareaid 
FROM   [MITAX_live].[dbo].[custvendpdcregister] AS t1 
       LEFT JOIN ledgerjournaltrans AS t2 
              ON t1.ledgerjournaltrans = t2.recid 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN dimensionattributevaluecombination AS t4 
              ON t2.offsetledgerdimension = t4.recid 
       LEFT JOIN retailchanneltable AS t5 
              ON Substring(t4.displayvalue, 8, 4) = t5.eftstorenumber 
       LEFT JOIN mainaccount AS t6 
              ON Substring(t4.displayvalue, 1, 6) = t6.mainaccountid 
                 AND t6.ledgerchartofaccounts = '5637145326' 
       LEFT JOIN vendtrans AS t7 
              ON t2.vendtransid = t7.recid 
                 AND t2.dataareaid = t7.dataareaid 
       LEFT JOIN vendtable AS t8 
              ON t7.accountnum = t8.accountnum 
                 AND t7.dataareaid = t8.dataareaid 
       LEFT JOIN dirpartytable AS t9 
              ON t8.party = t9.recid 
WHERE  t1.dataareaid IN( 'company1', 'company2' ) 
       AND pdcstatus = '2' 