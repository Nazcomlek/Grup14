{{ config(materialized='view') }}

select
    cast(SiparisID as varchar) as siparis_id,
    cast(Tarih as date) as siparis_tarihi,
    Musteri_ID as musteri_id,
    Sehir as sehir,
    Bolge as bolge,
    Kanal as kanal,
    Kategori as kategori,
    Urun as urun,
    cast(Miktar as integer) as miktar,
    cast(BirimFiyat as decimal(12,2)) as birim_fiyat,
    cast(Maliyet as decimal(12,2)) as maliyet,
    cast(IndirimOrani as decimal(5,2)) as indirim_orani

from {{ ref('perakende_satis') }}