{{ config(materialized='table') }}

select
    kategori,
    round(avg(arama_puani), 2) as ortalama_puan,
    max(arama_puani) as en_yuksek_puan,
    min(arama_puani) as en_dusuk_puan,
    rank() over (order by avg(arama_puani) desc) as ilgi_sirasi
from {{ ref('mart_trends_haftalik') }}
group by kategori
order by ilgi_sirasi
