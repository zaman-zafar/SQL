With TESTING AS 
(
   SELECT
      [ITEMID] 		
,
      t2.INVENTSITEID,
      [DATEPHYSICAL],
      [QTY],
      [COSTAMOUNTPOSTED],
      [INVOICEID],
      [VOUCHER],
      [DATEEXPECTED],
      [DATEFINANCIAL],
      [COSTAMOUNTPHYSICAL],
      [STATUSRECEIPT],
      [PACKINGSLIPRETURNED],
      [INVOICERETURNED],
      [PACKINGSLIPID],
      [VOUCHERPHYSICAL],
      [COSTAMOUNTADJUSTMENT],
      [SHIPPINGDATEREQUESTED],
      [SHIPPINGDATECONFIRMED],
      [VALUEOPEN],
      [DATESTATUS],
      [COSTAMOUNTSTD],
      [DATECLOSED],
      [PICKINGROUTEID],
      [COSTAMOUNTOPERATIONS],
      [RETURNINVENTTRANSORIGIN],
      t1.[INVENTDIMID],
      [MARKINGREFINVENTTRANSORIGIN],
      [INVENTDIMFIXED],
      [DATEINVENT],
      [INVENTTRANSORIGIN],
      [NONFINANCIALTRANSFERINVENTCLOSING],
      t1.[MODIFIEDDATETIME],
      t1.[DATAAREAID],
      t1.[RECVERSION],
      t1.[PARTITION],
      t1.[RECID] 
   FROM
      [MITAX_live].[dbo].[INVENTTRANS] as t1 
      left join
         INVENTDIM as t2 
         on t1.INVENTDIMID = t2.INVENTDIMID 
         and t1.DATAAREAID = t2.DATAAREAID 			-- here limiting physical date is important as this query will subtract stock from date after this date as well. like stock of 1/1/20 will also included in Feb data.
   where
      t1.DATAAREAID = 'companyname' 
      and DATEPHYSICAL <> '' 
      and DATEPHYSICAL <= '2019-12-31' 
)
,
cteRn As 
(
   Select
      ITEMID,
      INVENTSITEID,
      DATEPHYSICAL,
      QTY,
      Row_Number() Over (PARTITION BY INVENTSITEID, ITEMID 
   Order By
      DATEPHYSICAL) As rn 
   From
      testing
)
,
cte As 
(
   Select
      ITEMID,
      INVENTSITEID,
      DATEPHYSICAL,
      QTY,
      Sum(
      Case
         When
            QTY < 0 
         Then
            - 1 * QTY 
         Else
            0 
      End
) Over(PARTITION BY INVENTSITEID, ITEMID) As QTYRemoved, Sum(
      Case
         When
            QTY > 0 
         Then
            QTY 
         Else
            0 
      End
) Over( PARTITION BY INVENTSITEID, ITEMID 
   Order By
      rn) As QTYRecieved 
   From
      cteRn
)
, AF as 
(
   Select
      ITEMID,
      INVENTSITEID,
      DATEPHYSICAL,
      QTY,
      Case
         When
            QTY > 0 
            And QTYRecieved <= QTYRemoved 
         Then
            0 
         When
            QTY > 0 
            And QTY + QTYRemoved > QTYRecieved 
         Then
            QTYRecieved - QTYRemoved 
         When
            QTY > 0 
         Then
            QTY 
         Else
            Null 
      End
      As RemainingQty 
   From
      cte
)
select
   ITEMID,
   INVENTSITEID,
   DATEPHYSICAL,
   QTY,
   RemainingQty 
from
   AF 
where
   RemainingQty <> 0