
NB. init.ijs

NB. supports JPEG files
NB.
NB. These are .jpg files in 24-bit true color format.
NB.
NB. readjpeg and writejpeg use RGB values (single numbers).
NB.
NB. writejpeg also accepts RGB triples
NB.
NB. main functions:
NB.
NB.   readjpeg      read JPEG file, returning RGB data
NB.   writejpeg     write JPEG file from RGB data

coclass 'jjpeg'

IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
3 : 0''
if. (IFJNET +. IFIOS +. UNAME-:'Android') do. USEQTJPEG=: USEPPJPEG=: 0 end.
if. 0~: 4!:0<'USEQTJPEG' do.
  USEQTJPEG=: IFQT
end.
if. 0~: 4!:0<'USEJAJPEG' do.
  USEJAJPEG=: IFJA
end.
if. 0~: 4!:0<'USEJNJPEG' do.
  USEJNJPEG=: IFJNET
end.
if. (0~: 4!:0<'USEPPJPEG') > IFIOS +. UNAME-:'Android' do.
  USEPPJPEG=: (0 < #1!:0 jpath '~addons/graphics/pplatimg/pplatimg.ijs')
  require^:USEPPJPEG 'graphics/pplatimg'
  if. USEPPJPEG *. UNAME-:'Linux' do.
    USEPPJPEG=: (LIBGDKPIX_pplatimg_,' dummyfunction + n')&cd :: (2={.@cder) ''
  end.
end.
require^:USEPPJPEG 'graphics/pplatimg'
EMPTY
)

tagAPP0=: 16be0  NB. 224
tagAPP1=: 16be1  NB. 225
tagCOM=: 16bfe   NB. 254
tagDHT=: 16bc4   NB. 196
tagDQT=: 16bdb   NB. 219
tagDRI=: 16bdd   NB. 221
tagEOI=: 16bd9   NB. 217
tagRST0=: 16bd0  NB. 208
tagSOF0=: 16bc0  NB. 192
tagSOI=: 16bd8   NB. 216
tagSOS=: 16bda   NB. 218
