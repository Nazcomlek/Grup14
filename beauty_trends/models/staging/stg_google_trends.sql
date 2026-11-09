{{ config(materialized='view') }}

select
    cast("Time" as date) as tarih,
    cast("şampuan" as integer) as sampuan_arama_puani,
    cast("parfüm" as integer) as parfum_arama_puani,
    cast("makyaj" as integer) as makyaj_arama_puani,
    cast("kozmetik" as integer) as kozmetik_arama_puani

from {{ ref('time_series_TR_20240101-0300_20261104-2056') }}