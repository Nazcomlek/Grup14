{{ config(materialized='table') }}

select tarih, 'Şampuan' as kategori, sampuan_arama_puani as arama_puani
from {{ ref('stg_google_trends') }}

union all

select tarih, 'Parfüm' as kategori, parfum_arama_puani as arama_puani
from {{ ref('stg_google_trends') }}

union all

select tarih, 'Makyaj' as kategori, makyaj_arama_puani as arama_puani
from {{ ref('stg_google_trends') }}

union all

select tarih, 'Kozmetik' as kategori, kozmetik_arama_puani as arama_puani
from {{ ref('stg_google_trends') }}

order by tarih, kategori
