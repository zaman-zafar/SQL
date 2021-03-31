/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT DISTINCT( [voucher] ), 
               t4.displayvalue, 
               t5.storenumber, 
               t6.NAME          AS bankGL, 
               t12.NAME         AS FullbankName, 
               t13.displayvalue AS bankAccount, 
               t3.recid, 
               [paymreference], 
               [linenum], 
               [accounttype], 
               offsetaccounttype, 
               [txt], 
               [amountcurdebit], 
               [amountcurcredit], 
               [transdate], 
               [transactiontype], 
               t15.settleid 
FROM   [MITAX_live].[dbo].[ledgerjournaltrans] AS t1 
       LEFT JOIN generaljournalentry AS t3 
              ON t1.voucher = t3.subledgervoucher 
                 AND t1.dataareaid = t3.subledgervoucherdataareaid 
       LEFT JOIN(SELECT DISTINCT generaljournalentry, 
                                 postingtype, 
                                 ledgerdimension, 
                                 recid 
                 FROM   generaljournalaccountentry) AS t7 
              ON t3.recid = t7.generaljournalentry 
                 AND t7.postingtype = '20' 
       --if i don't use ledgerDimension in above line then code give unique values as in some transaction 2 banks used
       LEFT JOIN dimensionattributevaluecombination AS t13 
              ON t1.ledgerdimension = t13.recid 
       --the above area is used to get bank account number as GL name of Bank is different 
       LEFT JOIN dimensionattributevaluecombination AS t4 
              ON t7.ledgerdimension = t4.recid 
       LEFT JOIN retailchanneltable AS t5 
              ON Substring(t4.displayvalue, 8, 4) = t5.eftstorenumber 
       LEFT JOIN mainaccount AS t6 
              ON Substring(t4.displayvalue, 1, 6) = t6.mainaccountid 
                 AND t6.ledgerchartofaccounts = '5637145326' 
       LEFT JOIN bankaccounttable AS t12 
              ON t13.displayvalue = t12.accountid 
                 AND t12.dataareaid IN( 'krji', 'myla' ) 
       --this part is also used to get full bank account number 
       LEFT JOIN ledgertranssettlement AS t15 
              ON t7.recid = t15.transrecid 
--Settlement should be done on bank side or GL Code of transaction.the above area is used to remove cancled cheques General journal. I couldn't find anything on Settleid. Just don't add column T7.RECID
WHERE  t1.dataareaid IN ( 'krji', 'myla' ) 
       AND transactiontype = '36' 
       AND t3.recid IS NOT NULL 
       AND Concat(accounttype, offsetaccounttype) IN ( '60', '66' ) 
       AND Isnull(settleid, '1') = '1' 
       AND t1.transdate > '2018-12-31' 
-- for bank        --36 is type General Journal   take credit - debit as in some cases reversal.     the problem is that sometime bank comes on debit side and sometime on credit side of AX so 6 is for bank and 0 for ledger i have to create the code
--2 time as bank name will not come otherwise 
--5637217750;5637221008;5637313883;5637314102;5637329636;5637329962;5637330077;5637332166;5637391495;5637411168;5637411169;5637459891;5637460133 are duplicating as in same transaction 2 banks used
--from General Journal   Normal 