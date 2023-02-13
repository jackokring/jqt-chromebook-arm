
NB. ~$ echo -n "message digest" | md5sum
NB. f96b697d7cb7938d525a2f31aaf161d0
NB.
NB. q)md5 "c" $ til 256
NB. 0xe2c865db4162bed963bfaa9ef6ac18f0
NB.
NB. ~$ echo -n "message digest" | sha1sum
NB. c12252ceda8be8994d5fa0290a47231c1d16aae3
NB.
NB. this should fail with unknown hash type:
NB. gethash_jqtide_ 'dummy';T

T=: 'message digest'
W=: 'abc'

NB. =========================================================
NB. http://www.di-mgt.com.au/sha_testvectors.html
NB. SHA-1		a9993e36 4706816a ba3e2571 7850c26c 9cd0d89d
NB. SHA-224	23097d22 3405d822 8642a477 bda255b3 2aadbce4 bda0b3f7 e36c9da7
NB. SHA-256	ba7816bf 8f01cfea 414140de 5dae2223 b00361a3 96177a9c b410ff61 f20015ad
NB. SHA-384	cb00753f45a35e8b b5a03d699ac65007 272c32ab0eded163 1a8b605a43ff5bed 8086072ba1e7cc23 58baeca134c825a7
NB. SHA-512	ddaf35a193617aba cc417349ae204131 12e6fa4e89a97ea2 0a9eeee64b55d39a 2192992a274fc1a8 36ba3c23a3feebbd 454d4423643ce80e 2a9ac94fa54ca49f
NB. SHA-3-224	c30411768506ebe1 c2871b1ee2e87d38 df342317300a9b97 a95ec6a8
NB. SHA-3-256	4e03657aea45a94f c7d47ba826c8d667 c0d1e6e33a64a036 ec44f58fa12d6c45
NB. SHA-3-384	f7df1165f033337b e098e7d288ad6a2f 74409d7a60b49c36 642218de161b1f99 f8c681e4afaf31a3 4db29fb763e3c28e
NB. SHA-3-512	18587dc2ea106b9a 1563e32b3312421c a164c7f1f07bc922 a9c83d77cea3a1e5 d0c6991073902537 2dc14ac964262937 9540c17e2a65b19d 77aa511a9d00bb96

tests=: 3 : 0
v=. wd 'version'
if53=. 53 <: 10 #. 2 {. 0 ". (1+v i.'/') }. v rplc '. '
r=. ''
r=. r,'f96b697d7cb7938d525a2f31aaf161d0' -: gethash_jqtide_ 'md5';T
r=. r,'e2c865db4162bed963bfaa9ef6ac18f0' -: gethash_jqtide_ 'md5';a.
r=. r,'c12252ceda8be8994d5fa0290a47231c1d16aae3' -: getsha1_jqtide_ T
r=. r,'a9993e364706816aba3e25717850c26c9cd0d89d' -: getsha1_jqtide_ W
if. if53 do.
  f=. gethash_jqtide_ @ (;&W)
  r=. r,'23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7' -: f 'sha224'
  r=. r,'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad' -: f 'sha256'
  r=. r,'cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7' -: f 'sha384'
  r=. r,'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e 2a9ac94fa54ca49f' -: f 'sha512'
  r=. r,'c30411768506ebe1c2871b1ee2e87d38df342317300a9b97a95ec6a8' -: f 'sha3_224'
  r=. r,'4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45' -: f 'sha3_256'
  r=. r,'f7df1165f033337be098e7d288ad6a2f74409d7a60b49c36642218de161b1f99f8c681e4afaf31a34db29fb763e3c28e' -: f 'sha3-384'
  r=. r,'18587dc2ea106b9a1563e32b3312421ca164c7f1f07bc922a9c83d77cea3a1e5d0c69910739025372dc14ac9642629379540c17e2a65b19d77aa511a9d00bb96' -: f 'sha3-512'
end.
)

smoutput tests''
