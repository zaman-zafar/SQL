/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT [chequenum], 
       t2.NAME, 
       t7.text, 
       t7.ledgeraccount, 
       t7.generaljournalentry, 
       t4.displayvalue, 
       t3.journalnumber, 
       t5.storenumber, 
       t6.NAME, 
       [chequestatus], 
       t1.[accountid], 
       t9.NAME, 
       [amountcur], 
       t1.[currencycode], 
       t1.[bankneginstrecipientname], 
       [recipientaccountnum], 
       t1.[transdate], 
       t1.[voucher], 
       [recipienttype], 
       [recipientcompany], 
       t1.[reasonrefrecid], 
       [recipienttransvoucher], 
       t1.[remittanceaddress], 
       t1.[bankcurrency], 
       t1.[bankcurrencyamount], 
       [processedbypositivepay], 
       [reversalrecid], 
       [reversaltableid], 
       [sourcerecid], 
       [sourcetableid], 
       t1.[modifieddatetime], 
       t1.[modifiedby], 
       t1.[createddatetime], 
       t1.[createdby], 
       t1.[dataareaid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid], 
       t21.journalnum, 
       t21.banktranstype 
--use this code to use voucher number and then get the financial dimension 
FROM   [MITAX_live].[dbo].[bankchequetable] AS t1 
       LEFT JOIN bankaccounttable AS t2 
              ON t1.accountid = t2.accountid 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN generaljournalentry AS t3 
              ON t1.voucher = t3.subledgervoucher 
                 AND t1.dataareaid = t3.subledgervoucherdataareaid 
       LEFT JOIN generaljournalaccountentry AS t7 
              ON t3.recid = t7.generaljournalentry 
                 AND t7.postingtype = '41' 
       LEFT JOIN dimensionattributevaluecombination AS t4 
              ON t7.ledgerdimension = t4.recid 
       LEFT JOIN retailchanneltable AS t5 
              ON Substring(t4.displayvalue, 8, 4) = t5.eftstorenumber 
       LEFT JOIN mainaccount AS t6 
              ON Substring(t4.displayvalue, 1, 6) = t6.mainaccountid 
                 AND t6.ledgerchartofaccounts = '5637145326' 
       LEFT JOIN vendtable AS t8 
              ON t1.recipientaccountnum = t8.accountnum 
                 AND t1.dataareaid = t8.dataareaid 
       LEFT JOIN dirpartytable AS t9 
              ON t8.party = t9.recid 
       LEFT JOIN ledgerjournaltrans AS t21 
              ON t1.voucher = t21.voucher 
                 AND t1.dataareaid = t21.dataareaid 
WHERE  t1.dataareaid IN( 'company1', 'company2' ) 
       AND chequestatus = '4' 
       AND t21.banktranstype <> 'PDC' 
       AND journalnumber <> '' 
       AND t1.[transdate] > '2018-12-31' 