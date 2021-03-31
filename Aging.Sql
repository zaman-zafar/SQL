WITH testing 
     AS (SELECT [itemid], 
                t2.inventsiteid, 
                [datephysical], 
                [qty], 
                [costamountposted], 
                [invoiceid], 
                [voucher], 
                [dateexpected], 
                [datefinancial], 
                [costamountphysical], 
                [statusreceipt], 
                [packingslipreturned], 
                [invoicereturned], 
                [packingslipid], 
                [voucherphysical], 
                [costamountadjustment], 
                [shippingdaterequested], 
                [shippingdateconfirmed], 
                [valueopen], 
                [datestatus], 
                [costamountstd], 
                [dateclosed], 
                [pickingrouteid], 
                [costamountoperations], 
                [returninventtransorigin], 
                t1.[inventdimid], 
                [markingrefinventtransorigin], 
                [inventdimfixed], 
                [dateinvent], 
                [inventtransorigin], 
                [nonfinancialtransferinventclosing], 
                t1.[modifieddatetime], 
                t1.[dataareaid], 
                t1.[recversion], 
                t1.[partition], 
                t1.[recid] 
         FROM   [MITAX_live].[dbo].[inventtrans] AS t1 
                LEFT JOIN inventdim AS t2 
                       ON t1.inventdimid = t2.inventdimid 
                          AND t1.dataareaid = t2.dataareaid 
         -- here limiting physical date is important as this query will subtract stock from date after this date as well. like stock of 1/1/20 will also included in Feb data.
         WHERE  t1.dataareaid = 'companyname' 
                AND datephysical <> '' 
                AND datephysical <= '2019-12-31'), 
     ctern 
     AS (SELECT itemid, 
                inventsiteid, 
                datephysical, 
                qty, 
                Row_number() 
                  OVER ( 
                    partition BY inventsiteid, itemid 
                    ORDER BY datephysical) AS rn 
         FROM   testing), 
     cte 
     AS (SELECT itemid, 
                inventsiteid, 
                datephysical, 
                qty, 
                Sum(CASE 
                      WHEN qty < 0 THEN -1 * qty 
                      ELSE 0 
                    END) 
                  OVER( 
                    partition BY inventsiteid, itemid) AS QTYRemoved, 
                Sum(CASE 
                      WHEN qty > 0 THEN qty 
                      ELSE 0 
                    END) 
                  OVER( 
                    partition BY inventsiteid, itemid 
                    ORDER BY rn)                       AS QTYRecieved 
         FROM   ctern), 
     af 
     AS (SELECT itemid, 
                inventsiteid, 
                datephysical, 
                qty, 
                CASE 
                  WHEN qty > 0 
                       AND qtyrecieved <= qtyremoved THEN 0 
                  WHEN qty > 0 
                       AND qty + qtyremoved > qtyrecieved THEN 
                  qtyrecieved - qtyremoved 
                  WHEN qty > 0 THEN qty 
                  ELSE NULL 
                END AS RemainingQty 
         FROM   cte) 
SELECT itemid, 
       inventsiteid, 
       datephysical, 
       qty, 
       remainingqty 
FROM   af 
WHERE  remainingqty <> 0 