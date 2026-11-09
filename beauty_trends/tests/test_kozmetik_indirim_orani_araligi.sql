-- indirim_orani kolonu 0-1 arası bir orandır (0.2 = %20).
-- Bu aralığın dışındaki satırları döndürür.
select *
from {{ ref('stg_perakende_satis') }}
where kategori = 'Kozmetik'
  and indirim_orani not between 0 and 1
