/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT t1.[accountnum], 
       t3.NAME, 
       t4.enumitemname, 
       t1.[transdate], 
       t1.[voucher], 
       t1.[invoice], 
       t1.[txt], 
       t1.[amountcur], 
       t1.[settleamountcur], 
       t1.[amountmst], 
       t1.[settleamountmst], 
       t1.[currencycode], 
       t1.[duedate], 
       t1.[lastsettlevoucher], 
       t1.[lastsettledate], 
       t1.[closed], 
       t1.[transtype], 
       t1.[approved], 
       t1.[paymid], 
       [exchadjustment], 
       [documentnum], 
       [documentdate], 
       [arrival], 
       [lastexchadj], 
       [correct], 
       [lastexchadjvoucher], 
       [lastexchadjrate], 
       [postingprofile], 
       [settlement], 
       [cancel], 
       [postingprofileclose], 
       [postingprofileapprove], 
       [postingprofilecancel], 
       [postingprofilereopen], 
       [thirdpartybankaccountid], 
       [companybankaccountid], 
       [paymreference], 
       t1.[paymmode], 
       [tax1099date], 
       [tax1099amount], 
       [tax1099num], 
       [offsetrecid], 
       [journalnum], 
       [eurotriangulation], 
       [cashdisccode], 
       [prepayment], 
       t1.[paymspec], 
       [vendexchadjustmentrealized], 
       [vendexchadjustmentunrealized], 
       [approveddate], 
       [promissorynoteid], 
       [promissorynotestatus], 
       [promissorynoteseqnum], 
       [bankremittancefileid], 
       [fixedexchrate], 
       t1.[bankcentralbankpurposetext], 
       t1.[bankcentralbankpurposecode], 
       [tax1099state], 
       [tax1099stateamount], 
       [settletax1099amount], 
       [settletax1099stateamount], 
       t1.[defaultdimension], 
       [exchratesecond], 
       [exchrate], 
       [lastsettleaccountnum], 
       [lastsettlecompany], 
       [invoiceproject], 
       [reasonrefrecid], 
       [releasedatecomment], 
       [invoicereleasedate], 
       [invoicereleasedatetzid], 
       [vendpaymentgroup], 
       [remittancelocation], 
       [remittanceaddress], 
       t1.[tax1099fields], 
       [banklcimportline], 
       [accountingevent], 
       [approver], 
       [reportingcurrencyamount], 
       [reportingexchadjustmentrealized], 
       [reportingexchadjustmentunrealized], 
       [lastexchadjratereporting], 
       [reportingcurrencycrossrate], 
       [exchadjustmentreporting], 
       [settleamountreporting], 
       [taxinvoicepurchid], 
       [tax1099recid], 
       [consessionsettlementid], 
       [rbovendtrans], 
       t1.[modifieddatetime], 
       t1.[del_modifiedtime], 
       t1.[modifiedby], 
       t1.[modifiedtransactionid], 
       t1.[createddatetime], 
       t1.[del_createdtime], 
       t1.[createdby], 
       [createdtransactionid], 
       t1.[dataareaid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid] 
FROM   [MITAX_live].[dbo].[vendtrans] AS t1 
       LEFT JOIN vendtable AS t2 
              ON t1.accountnum = t2.accountnum 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN dirpartytable AS t3 
              ON t2.party = t3.recid 
       LEFT JOIN srsanalysisenums AS t4 
              ON t1.transtype = t4.enumitemvalue 
                 AND t4.enumname = 'LedgerTransType' 
                 AND t4.languageid = 'en-us' 
WHERE  t1.dataareaid = 'myla' 
       AND t2.vendgroup IN ( 'Domes', 'Purchase' ) 
       AND NAME = 'name of vendor' 