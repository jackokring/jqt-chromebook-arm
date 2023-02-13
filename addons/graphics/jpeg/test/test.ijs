
USEQTJPEG_jjpeg_=: USEJAJPEG_jjpeg_=: USEJNJPEG_jjpeg_=: USEPPJPEG_jjpeg_=: 0

load 'graphics/jpeg bmp'     NB. require toucan.bmp for testing

test=: 3 : 0

NB. write
dat=. 200 300 3 $ 0 0 255
dat writejpeg jpath '~temp/blue.jpg'
dat=. 200 300 3 $ 255 0 0
dat writejpeg jpath '~temp/red.jpg'

dat=. readjpeg jpath '~Addons/graphics/jpeg/test/lena.jpg'
dat writejpeg jpath '~temp/lena.jpg'
dat writejpeg 90;~ jpath '~temp/lena-hihg.jpg'
dat writejpeg 10;~ jpath '~temp/lena-low.jpg'
dat writejpeg (75;2 2);~ jpath '~temp/lena-sub.jpg'
smoutput 'finisih'
)

test''
