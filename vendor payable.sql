SELECT [accountnum], 
       t2.purchid, 
       t3.inventsiteid, 
       t3.itembuyergroupid, 
       t9.students, 
       [transdate], 
       [voucher], 
       [invoice], 
       [txt], 
       [amountcur], 
       [settleamountcur], 
       [amountmst], 
       [settleamountmst], 
       t1.[currencycode], 
       t1.[duedate], 
       [lastsettlevoucher], 
       [lastsettledate], 
       [closed], 
       [transtype], 
       [approved], 
       t1.[paymid], 
       [exchadjustment], 
       t1.[documentnum], 
       t1.[documentdate], 
       [arrival], 
       [lastexchadj], 
       [correct], 
       [lastexchadjvoucher], 
       [lastexchadjrate], 
       t1.[postingprofile], 
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
       t1.[cashdisccode], 
       t1.[prepayment], 
       t1.[paymspec], 
       [vendexchadjustmentrealized], 
       [vendexchadjustmentunrealized], 
       [approveddate], 
       [promissorynoteid], 
       [promissorynotestatus], 
       [promissorynoteseqnum], 
       [bankremittancefileid], 
       t1.[fixedexchrate], 
       t1.[bankcentralbankpurposetext], 
       t1.[bankcentralbankpurposecode], 
       [tax1099state], 
       [tax1099stateamount], 
       [settletax1099amount], 
       [settletax1099stateamount], 
       t1.[defaultdimension], 
       [exchratesecond], 
       t1.[exchrate], 
       [lastsettleaccountnum], 
       [lastsettlecompany], 
       [invoiceproject], 
       [reasonrefrecid], 
       [releasedatecomment], 
       [invoicereleasedate], 
       [invoicereleasedatetzid], 
       t1.[vendpaymentgroup], 
       [remittancelocation], 
       t1.[remittanceaddress], 
       [tax1099fields], 
       t1.[banklcimportline], 
       [accountingevent], 
       [approver], 
       [reportingcurrencyamount], 
       [reportingexchadjustmentrealized], 
       [reportingexchadjustmentunrealized], 
       [lastexchadjratereporting], 
       [reportingcurrencycrossrate], 
       [exchadjustmentreporting], 
       [settleamountreporting], 
       t1.[taxinvoicepurchid], 
       [tax1099recid], 
       [consessionsettlementid], 
       [rbovendtrans], 
       t1.[modifieddatetime], 
       [del_modifiedtime], 
       [modifiedby], 
       [modifiedtransactionid], 
       t1.[createddatetime], 
       [del_createdtime], 
       t1.[createdby], 
       [createdtransactionid], 
       t1.[dataareaid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid] 
FROM   [MITAX_live].[dbo].[vendtrans] AS t1 
       LEFT JOIN vendinvoicejour AS t2 
              ON t1.invoice = t2.invoiceid 
                 AND t1.voucher = t2.ledgervoucher 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN purchtable AS t3 
              ON t2.purchid = t3.purchid 
                 AND t2.dataareaid = t3.dataareaid 
       LEFT JOIN (SELECT DISTINCT ST2.dimensionattributevalueset, 
                                  Substring( 
                                  (SELECT '-' + ST1.displayvalue AS 
                                          [text()] 
                                   FROM 
                                  dimensionattributevaluesetitem ST1 
                                             WHERE 
                                  ST1.dimensionattributevalueset = 
ST2.dimensionattributevalueset 
ORDER  BY ST1.dimensionattributevalueset 
FOR xml path ('')), 2, 1000) [Students] 
FROM   dimensionattributevaluesetitem ST2) AS t9 
ON t1.defaultdimension = t9.dimensionattributevalueset 
WHERE  t1.dataareaid = 'company name' 
       AND accountnum = 'KJ-00001' 
       AND settleamountmst <> amountcur 
       AND invoice <> '' 
ORDER  BY transdate 