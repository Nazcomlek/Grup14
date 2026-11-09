{{ config(materialized='table') }}

-- Google Trends (haftalık, hafta pazar günü başlar) ile kozmetik satışlarını
-- aynı hafta tanımıyla karşılaştırır.
--
-- Eşleştirme:
--   Şampuan  -> Şampuan ürünü
--   Parfüm   -> Parfüm ürünü
--   Makyaj   -> Makyaj Paleti ürünü
--   Kozmetik -> tüm kozmetik ürünleri (genel terim)
--
-- Satış verisi 2024-01-01 .. 2024-12-31 aralığındadır. Trends haftaları
-- 2023-12-31 (pazar) başlar. İlk hafta (2023-12-31) ve son hafta (2024-12-29)
-- satış verisinde eksik gün içerdiği için tam_hafta = false işaretlenir.

with satis as (
    select
        cast(siparis_tarihi - (dayofweek(siparis_tarihi) * interval 1 day) as date) as hafta_baslangic,
        case
            when urun = 'Şampuan' then 'Şampuan'
            when urun = 'Parfüm' then 'Parfüm'
            when urun = 'Makyaj Paleti' then 'Makyaj'
        end as kategori,
        miktar,
        miktar * birim_fiyat * (1 - indirim_orani) as net_tutar
    from {{ ref('stg_perakende_satis') }}
    where kategori = 'Kozmetik'
),

satis_urun as (
    select
        hafta_baslangic,
        kategori,
        sum(miktar) as satis_adedi,
        sum(net_tutar) as net_satis_tutari
    from satis
    where kategori is not null
    group by hafta_baslangic, kategori
),

satis_genel as (
    select
        hafta_baslangic,
        'Kozmetik' as kategori,
        sum(miktar) as satis_adedi,
        sum(net_tutar) as net_satis_tutari
    from satis
    group by hafta_baslangic
),

satis_hafta as (
    select * from satis_urun
    union all
    select * from satis_genel
)

select
    t.tarih as hafta_baslangic,
    t.kategori,
    t.arama_puani,
    coalesce(s.satis_adedi, 0) as satis_adedi,
    round(coalesce(s.net_satis_tutari, 0), 2) as net_satis_tutari,
    (t.tarih >= date '2024-01-07' and t.tarih <= date '2024-12-22') as tam_hafta
from {{ ref('mart_trends_haftalik') }} as t
left join satis_hafta as s
    on s.hafta_baslangic = t.tarih
   and s.kategori = t.kategori
order by t.kategori, t.tarih
