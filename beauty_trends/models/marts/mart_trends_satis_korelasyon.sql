{{ config(materialized='table') }}

-- Kategori bazında Google Trends arama puanı ile haftalık satış adedi
-- arasındaki Pearson korelasyonu. Yalnızca tam haftalar kullanılır.
--   korelasyon_ayni_hafta : arama puanı (t) ile satış adedi (t)
--   korelasyon_1_hafta_sonra : arama puanı (t) ile satış adedi (t+1)

with hafta as (
    select
        kategori,
        hafta_baslangic,
        arama_puani,
        satis_adedi,
        lead(satis_adedi) over (partition by kategori order by hafta_baslangic) as sonraki_hafta_satis
    from {{ ref('mart_trends_satis_haftalik') }}
    where tam_hafta
)

select
    kategori,
    count(*) as hafta_sayisi,
    round(corr(arama_puani, satis_adedi), 3) as korelasyon_ayni_hafta,
    round(corr(arama_puani, sonraki_hafta_satis), 3) as korelasyon_1_hafta_sonra,
    round(avg(arama_puani), 2) as ortalama_arama_puani,
    round(avg(satis_adedi), 2) as ortalama_haftalik_satis_adedi
from hafta
group by kategori
order by kategori
