-- Korelasyon -1 ile 1 arasında ve boş olmamalıdır.
-- Geçersiz satırları döndürür.
select *
from {{ ref('mart_trends_satis_korelasyon') }}
where korelasyon_ayni_hafta is null
   or korelasyon_ayni_hafta not between -1 and 1
   or korelasyon_1_hafta_sonra is null
   or korelasyon_1_hafta_sonra not between -1 and 1
