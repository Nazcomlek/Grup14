-- Karşılaştırma tablosu Trends ve satış verisinin ortak aralığında kalmalı
-- (2024-01-01 .. 2024-12-31) ve her kategori aynı sayıda tam haftaya sahip olmalı.
-- Sorunlu satırları döndürür.
select 'aralik_disi_tam_hafta' as sorun, kategori, hafta_baslangic
from {{ ref('mart_trends_satis_haftalik') }}
where tam_hafta
  and (hafta_baslangic < date '2024-01-01' or hafta_baslangic > date '2024-12-31')

union all

select 'kategori_hafta_sayisi_farkli' as sorun, kategori, null as hafta_baslangic
from {{ ref('mart_trends_satis_haftalik') }}
where tam_hafta
group by kategori
having count(*) <> (
    select count(distinct hafta_baslangic)
    from {{ ref('mart_trends_satis_haftalik') }}
    where tam_hafta
)
