-- Sipariş sayısı, satış adedi ve net satış tutarı pozitif olmalıdır.
-- Ayrıca kanal-bölge toplamı staging'deki kozmetik satış adedine eşit olmalıdır.
select 'pozitif_olmayan_deger' as sorun, kanal, bolge
from {{ ref('mart_kozmetik_kanal_bolge') }}
where siparis_sayisi <= 0
   or toplam_satis_adedi <= 0
   or net_satis_tutari <= 0

union all

select 'adet_toplami_uyusmuyor' as sorun, null as kanal, null as bolge
where (select sum(toplam_satis_adedi) from {{ ref('mart_kozmetik_kanal_bolge') }})
   <> (select sum(miktar) from {{ ref('stg_perakende_satis') }} where kategori = 'Kozmetik')
