-- Arama puanı 0-100 aralığı dışında olan satırları döndürür.
-- Satır dönerse test başarısız olur.
select *
from {{ ref('stg_google_trends') }}
where sampuan_arama_puani not between 0 and 100
   or parfum_arama_puani  not between 0 and 100
   or makyaj_arama_puani  not between 0 and 100
   or kozmetik_arama_puani not between 0 and 100
