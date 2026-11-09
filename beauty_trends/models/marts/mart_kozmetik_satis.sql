{{ config(materialized='table') }}

select
    urun,
    sum(miktar) as toplam_satis_adedi,
    count(distinct siparis_id) as siparis_sayisi,
    sum(miktar * birim_fiyat) as brut_satis_tutari,
    sum(miktar * birim_fiyat * (1 - indirim_orani / 100)) as net_satis_tutari

from {{ ref('stg_perakende_satis') }}

where kategori = 'Kozmetik'

group by urun
order by net_satis_tutari desc
