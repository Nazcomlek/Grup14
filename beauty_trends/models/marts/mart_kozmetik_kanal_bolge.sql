{{ config(materialized='table') }}

select
    kanal,
    bolge,
    count(distinct siparis_id) as siparis_sayisi,
    sum(miktar) as toplam_satis_adedi,
    round(
        sum(miktar * birim_fiyat * (1 - indirim_orani)),
        2
    ) as net_satis_tutari
from {{ ref('stg_perakende_satis') }}
where kategori = 'Kozmetik'
group by
    kanal,
    bolge
order by net_satis_tutari desc
