-- Kanal yalnızca 'Online' veya 'Mağaza' olabilir, bölge boş olamaz.
-- Geçersiz satırları döndürür.
select *
from {{ ref('mart_kozmetik_kanal_bolge') }}
where kanal not in ('Online', 'Mağaza')
   or kanal is null
   or bolge is null
