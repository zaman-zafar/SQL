/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT t1.[assetid], 
       [lowvaluepooltype_au], 
       [txt], 
       [transdate], 
       [transtype], 
       t6.enumitemlabel, 
       [voucher], 
       [amountcur], 
       t1.[currencycode], 
       [amountmst], 
       t1.[lvptransferid_au], 
       t1.[postingprofile], 
       t1.[assetgroup], 
       t1.[bookid], 
       [consumptionqty], 
       [revaluationdone], 
       [revaluationtrans], 
       [revaluationamount], 
       [revaluedtransid], 
       [reservetransferdone], 
       [reservetransid], 
       [reclassification], 
       [reasonrefrecid], 
       t1.[defaultdimension], 
       [approver], 
       [isprioryear], 
       [documentnum_w], 
       [documentdate_w], 
       [cashdiscbaseamountmst], 
       [cashdiscbasetransid], 
       t1.[modifieddatetime], 
       t1.[dataareaid], 
       t1.[recversion], 
       t1.[partition], 
       t1.[recid], 
       t2.assetgroup, 
       t2.NAME, 
       t3.purchid, 
       t4.students, 
       t3.vendaccount, 
       t5.depreciation, 
       t5.lifetime, 
       t5.depreciationstartdate, 
       t5.lastdepreciationdate, 
       t5.acquisitionprice, 
       t5.acquisitiondate 
FROM   [MITAX_live].[dbo].[assettrans] AS t1 
       LEFT JOIN assettable AS t2 
              ON t1.assetid = t2.assetid 
                 AND t1.dataareaid = t2.dataareaid 
       LEFT JOIN purchline AS t3 
              ON t2.purchlinerecid = t3.recid 
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
FROM   dimensionattributevaluesetitem ST2) AS t4 
ON t1.defaultdimension = t4.dimensionattributevalueset 
LEFT JOIN assetbook AS t5 
ON t1.bookid = t5.bookid 
AND t1.assetid = t5.assetid 
AND t1.dataareaid = t5.dataareaid 
LEFT JOIN srsanalysisenums AS t6 
ON t1.transtype = t6.enumitemvalue 
AND t6.enumname = 'AssetTransType' 
WHERE  t1.dataareaid = 'required company' 