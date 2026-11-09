{{ config(materialized='table') }}

select
    round(avg(sampuan_arama_puani), 2) as ortalama_sampuan,
    round(avg(parfum_arama_puani), 2) as ortalama_parfum,
    round(avg(makyaj_arama_puani), 2) as ortalama_makyaj,
    round(avg(kozmetik_arama_puani), 2) as ortalama_kozmetik

from {{ ref('stg_google_trends') }}