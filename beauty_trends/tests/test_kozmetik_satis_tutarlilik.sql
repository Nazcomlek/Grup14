-- Kozmetik satış martında tutarsız satırları döndürür.
-- Satış adedi 0 veya negatif olamaz, net tutar brüt tutardan büyük olamaz.
select *
from {{ ref('mart_kozmetik_satis') }}
where toplam_satis_adedi <= 0
   or net_satis_tutari > brut_satis_tutari
