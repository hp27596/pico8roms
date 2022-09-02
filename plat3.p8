pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--super mario bros. (authentic)
--@matthughson
local a={}
b=mget
function mget(c,d)
c=flr(c)
d=flr(d)
if a[c] and a[c][d] then
return a[c][d].e
end
return 0
end
f=mset
function mset(c,d,g)
if not a[c] then
a[c]={}
end
if not a[c][d] then
a[c][d]={}
end
a[c][d].e=g
end
h=map
function map(i,j,k,l,m,n,o)
local p=peek(0x5f29)
p=bor(shl(p,8),peek(0x5f28))
local q=peek(0x5f2b)
q=bor(shl(q,8),peek(0x5f2a))
local r=flr(p/8)
local s=flr(q/8)
local t=r+16
local u=flr(q/8)+16
for v=r,t do
local w=a[i+v]
if w then
for x=s,u do
local y=w[j+x]
if y then
if y.e!=0 then
local z=k+(v*8)
local ba=l+(x*8)
local bb=false
if fget(y.e,7) then
bc()
bb=true
elseif y.bd!=nil then
be(bf[y.bd])
bb=true
end
spr(y.e,z,ba,1,1,y.bg,y.bh)
if(bb) bi()
end
end
end
end
end
end
bf=
{
{1,0,4,1,15,13},
{7,11,12,3},
}
bj={0,19,28}
bk={1,3,5,6}
bl=
{
{
map="07814724570063017701c97168f2e77397fb06835c01d722e70003a76c02b322e301e70747a05706a701d300d70107816720932203a31c6117216f33c763d862e961fa604fb387639c01b763c862d961ea6039f18721a701b72039f15f386dc1af26",
}
}
bm={
{
bn=446,
bo=30,
cls=12,
bj=1,
bp="ff00d2000101010201030e000101020201031b000101010201030e000101020201031b000101010201030e000101020201031b000101010201030e000101020201030e0001040c0001010102010311000101010201030800010501060107050001010302010304000105020601071000010101020103080001050106010705000101030201030400010502060107100001010102010308000105010601070500010103020103040001050206010710000101010201030800010501060107050001010302010304000105020601070e0001080100010101020103080001050106010705000101030208000105010601071000010503060107180001050106010710000105030601071800010501060107100001050306010718000105010601071000010503060107160001080100010501060107100001050306160001093900080a0300030a01090e0001090b00030a0400010a0209010a3800020b08000108d300030b08000108d200040b08000108d100050b08000108280001090300010a0109010a0109010a1500010c010d0900010c010d1200010a0109010a0e00010a0500020a0400010902000109020001090500010a0a00020a0600010b0200010b0a00020b0200010b0c00020a0109010a0c00060b080001081a00010e2300010c010d0600010f01100200010e0600010f01102700010e2500020b0200020b0400010e0300030b0200020b1a00070b0400010e0300010819000111011201130d00010e0a00010c010d0800010f01100600010f011001000111011201130500010f01100600010e1f000111011201130d00010e1500030b0200030b02000111011201130100040b0200030b0300010e0100010c010d0e00010c010d0100080b0300011101120113020001080a00010e0d0001110112011401150113060001010302010301110112011304000101010201030200010f01100800010f011001000101020201030100010f0110011101120114011501130400010f011001010302010301110112011304000101010201030f00010102020103030001110112011401150113060001010302010301110112011304000101010201030c00040b0202040b0111011201140115050b0200040b0103011101120113010f011002000101010201030900010f0110090b0200011101120114011501130100010b090001110112011304000101010201030500451602000f16030040160200891602000f160300401602004416",
bq="000000000000007b6c6d6b6b00007c0000007575008b00008c8d00007d000000767676766768777863636464696a797a818291928384939400008787a1a2a1a2a3a4a3a4008686a3a385a3a38600a386a3a3a3a385a3a3a361627172",
br="98c00598c00698c00798c00898c00998c00a98c00b98c00c98c00d98c00e98c00f98c01098c01198c01298c01398c0148050158650158c501592501598501598c0158060168660168c601692601698601698c0168070178230178670178830178c70178e301792701794301798701798c0179a30178080188240188680188840188c80188e40189440189880189a40188090198250198690198850198c90198e50199450199890199a5019",
bs="18b006650a00080c0a40080c0da00a940800109502a0129409c012940bc012990ca012970d60172d02c0180c0500180c0660180c0690180c0c20180c0c50180c0e40180c0e70180c0f80180c0fb0180c1000180c1030180c15c0180c15f0180c",
bt={
{116,18,2,4,0,0},
},
bd="0171882202f18422053186220771882208f184220b3186220d7188220ef184221141842214f184221af1842213e19112",
},
{
bn=34,
bo=30,
pal=1,
bj=2,
bp="01000301070004010102010301000301070004010102010301000301070004010102010301000e010102010301000e010102010301000401050405010102010301000e010102010301000301070404010102010301000e010102010301000301070404010102010301000301070504010102010301000301070002010106010701020103010003010700020101080109010201030d0a01080109010201030d0a0108010901020103",
bq="6464646400000000a4a3a4a3a2a1a2a1999aa9aa636364648182919283849394a1a2a1a2a3a4a3a461627172",
br="81e00081f00082000082100081e00181f00182000182100181e00281f00282000282100281e00381f00382000382100381e00481f00482000482100481e00581f00582000582100581e00681f00682000682100681e00781f00782000782100781e00881f00882000882100881e00981f00982000982100981e00a81f00a82000a82100a81e00b81f00b82000b82100b81e00c81f00c82000c82100c81e00d81f00d82000d82100d81e00e81f00e82000e82100e81e00f81f00f82000f82100f81e01081f01082001082101081e01181f01182001182101181e01281f01282001282101281e01381f01382001382101381e01481f01482001482101481e01581f01582001582101581e01681f01682001682101681e01781f01782001782101781e01881f01882001882101881e01981f01982001982101981e01a81f01a82001a82101a81e01b81f01b82001b82101b81e01c81f01c82001c82101c81e01d81f01d82001d82101d",
bs="",
bt={
{28,22,1,328,22,2},
},
},
{
bn=384,
bo=30,
pal=1,
bj=2,
bp="ff00810001010500840117000701010201031101030003013500020102000601020004010600040158000102010307010d0003013500020102000601020004010600040158000102010307010d00030128000404070002010800020103000101040002010a0006044e000102010307010d000301330002010800020103000101040002015e000102010307010d000301260001010100040101000101050002010800020103000101040002010a0006014e000102010307010d0003011c00010109000101010401010200010101040101050002010400040402010300010101040101020002010a000601370006010f00010501060102010307010d0003010900050708000108010001080d0003010200030105000401020006010300030102000201020004011d0001050106190002081c00010201030102010307010d0003011400010801000108010001080100010803000108160002012f00010501060400010201030b0002010b00030816000601010201030102010307010100010501060200010501060200010501060200030112000108010001080100010801000108010001080300010801000108140002012f0001020103040001020103040001050106050002010a000408160006010102010301020103070101000102010302000102010302000102010302000301100001080100010801000108010001080100010801000108030001080100010845000102010304000102010304000102010305000201090005081600060101020103010201030701010001020103020001020103020001020103020002015009030025090200020902000c09070008090700060901020103010201036609030025090200020902000c09070008090700060901020103010201031609",
bq="0000000064646464a1a2a1a2a3a4a3a4999aa9aa818291928384939467687778696a797a61627172",
br="",
bs="0b2004950920080c1350097305c00e9711700e7203a0109908a01094092010990980100c09b0100c1110100c12c01094014012940db012b010e0120c0cf014b00220160c0e7016b00580172d05b0172d0760172d1240172f0200180c03a0180c07c0180c0800180c0c60180c0c90180c0cc0180c0e20180c1350197311701a72",
bt={
{208,20,4,4,0,0},
{358,20,4,4,0,0},
{366,20,4,4,0,0},
{374,20,4,4,0,0},
{334,16,1,360,22,2},
},
},
{
bn=34,
bo=30,
pal=1,
bj=2,
bp="01000e010102010301000e0101020103010002010c0001020103010002010c0001020103010002010c0001020103010002010c000102010301000c0102000102010301000c010200010201030100030108040101020001020103010002010c000102010301000c0102000102010301000e01010201030100020109040301010201030d0501060107010201030d050108010901020103",
bq="6464646400000000a4a3a4a3a2a1a2a1999aa9aa616271728182919283849394a1a2a1a2a3a4a3a4",
br="81e00081f00082000082100081e00181f00182000182100181e00281f00282000282100281e00381f00382000382100381e00481f00482000482100481e00581f00582000582100581e00681f00682000682100681e00781f00782000782100781e00881f00882000882100881e00981f00982000982100981e00a81f00a82000a82100a81e00b81f00b82000b82100b81e00c81f00c82000c82100c81e00d81f00d82000d82100d81e00e81f00e82000e82100e81e00f81f00f82000f82100f81e01081f01082001082101081e01181f01182001182101181e01281f01282001282101281e01381f01382001382101381e01481f01482001482101481e01581f01582001582101581e01681f01682001682101681e01781f01782001782101781e01881f01882001882101881e01981f01982001982101981e01a81f01a82001a82101a81e01b81f01b82001b82101b81e01c81f01c82001c82101c81e01d81f01d82001d82101d",
bs="01801299",
bt={
{28,26,3,232,22,2},
},
},
{
bn=310,
bo=30,
cls=12,
bj=1,
bp="ff0049000101020201030f0002041b000101020201032c000101020201032200010505000101020201030b000106020701081d000101020201030b000106020701081d000101020201030b000106020701081d00010102020103010001090500010602070108140003040a00010a050b010c0400010602070108050004041d000204020002040106020701082c00010602070108010001091c00010a030b010c0a00050d0e00010a020b010c15000204210002041400020e080001091d00030d0800010101020103050d040002040900020d0d00010a040b010c04000101010201032d000101010201030500020e080001090b000101010201030f00030d0500010101020103010601070108050d0b000101010201030100020d0e00040d02000101010201030106010701080f00010a060b010c13000101010201030106010701080300040e08000109010101020100030f05000106010701080f00030d0500010a030b010c0100050d0b000106010701080100020d0e00040d02000106010701081300060d14000106010701080600040e080001090106010701000110011101121400010a060b010c0400030d0200050d0f00020d0700010a010b010c0400040d1800060d0500010a020b010c0200010a020b010c0c00060e080001090200010f0313010f1400060d0500030d0200050d0d0001140100020d0800010d0500040d1800060d0600020d0400020d0d00060e0800010902000211011502111400060d020001040200030d0200050d0101010201030c00020d0800010d04000101040d0d000101010201030100010a020b010c0300060d0600020d0400020d010201030b00060e01030700010902000211011602110d00010a020b010c0300060d0100010a010b010c0100030d0200050d0106010701080c00020d0800010d04000106040d0d000106010701080200020d0400060d020003040100020d0400020d010701080b00060e01080700010e020010170300020d0400060d0200010d0200030d0200050d0400010a020b010c0500010a030b010c0100010a030b010c0100010d0500040d1200020d0400060d0200010a010b010c0100020d0400020d04002a170300020d0400060d0200010d0200030d0200050d0500020d0700030d0300030d0200010d0500040d1200020d0400060d0300010d0200020d0400020d04001a17",
bq="000000000000007b6c6d6b6b00007c00999aa9aa00007575008b00008c8d00007d00000076767676b3b4c3c4b4b4c4c4b4b3c4c35d5d5d5d696a797ab5b5b7b7b7c6b7c6b7b7b7b7c6b7c6b7b6b6b7b767687778c5c5c6c6c6c6c6c661627172",
br="93000593000693000785d00893000885d00993000983d00a87f00a93000a83d00b87f00b93000b8a300c93000c8a300d93000d8df00e93000e8df00f93000f80301080501080701084f01093001084f01193001183f0128910128ef0128fb01293001283f0138910138ef0138fb0139300138010148030148050148070148090149300149300158050168cb0169300168cb01793001782b01884501882b01984501986b01a87f01a88b01a8e701a86b01b87f01b88b01b8e701b",
bs="0580060c05c0060c12f0066503c0072f0940079a0e40099a0a000a0c0dc00b2f06e00c750ff00c740a5010740b5012740760149410a0172f",
bt={
},
},
{
bn=320,
bo=30,
bj=3,
bp="ff0041009301010224010d002301080001010700010108000701130005010e000201030001030c0018010d002301080001040700010408000701130005010e00020103000103230001010d00230146000201030001032300010406000105060001040b0001040a000104060001044f0001030c000301900001030c0004018f0001030c0005011e0025010400010407000104070001042f0001060301030001030c000d0102000b010300010101040101030045010c000401030005010d070301030001030c000d01020009010108010103000301030045010c000401030005010d000301030001030c000d0102090b0103090301030945010c000401030005010d0903010300010a0c000d01020b0b01030b0301030b5d010d0b2001020b0b01030b0301030b5d010d0b1301",
bq="00000000e1e1f1f10000757576767676696a797a6768777800d3d300e2e2f2f2e1e1e1e1e3e3f3f3f1f1f1f1f3f3f3f3",
br="92600592600692600792600892600992600a92600b92600c92600d92600e92600f926010926011926012926013926014926015926016926017",
bs="125006650b10095f0d600a980dc00a980e200a9803c00c9410d00c7406300d6f07900d6f08700d6f0cb010b90fe010b91070109f0d4012980da012980e0012980e5012b90990136f0a90136f03d0156f",
bt={
},
},
}
bu=0
bv=1
bw=2
bx=3
function by(r,s,g)
if type(g)!="table"then
g={g,g+1,g+16,g+17}
end
local count=1
for x=0,1 do
for v=0,1 do
mset(r+v,s+x,g[count])
count+=1
end
end
end
function bz(ca)
for v=1,#ca.bs,8 do
local c=cb(ca.bs,v,2)
v+=3
local d=cb(ca.bs,v,2)
v+=3
local cc=cb(ca.bs,v,1)
local g=
{
[12]=cd,
[176]=ce,
[45]=cf,
[47]=cg,
[95]=ch,
[111]=ch,
[154]=ci,
[159]=cj,
[185]=ck,
[101]=cl,
[114]=cm,
[115]=cm,
[116]=cm,
[117]=cm,
[148]=cn,
[149]=cn,
[151]=cn,
[152]=cn,
[153]=cn,
}
if g[cc]!=nil then
local co=g[cc](c*8,d*8,cc)
if co then
co.c+=co:cp()
co.d+=co:cq()
co.cr=co.c
co.cs=co.d
end
end
end
local c=0
local d=0
for v=1,#ca.bp,4 do
local count=cb(ca.bp,v,1)
local bq=cb(ca.bp,v+2,1)
bq=(bq*8)+1
for x=0,count-1 do
local g={}
for ct=0,6,2 do
local cu=cb(ca.bq,bq+ct,1)
add(g,max(0,cu-1))
end
by(c,d,g)
if g[1]==102 and cv(c*8,d*8)==nil then
co=cn(c*8+8,d*8+8,152)
end
c+=2
if c>=ca.bn then
c=0
d+=2
end
end
end
for v=1,#ca.br,6 do
local cw=cb(ca.br,v,2)
local cx=cb(ca.br,v+3,2)
local c=band(cw,0x7ff)
local d=band(cx,0x7ff)
a[c][d].bg=band(cw,0x800)!=0
a[c][d].bh=band(cx,0x800)!=0
end
local bd=ca.bd
if bd then
for v=1,#bd,8 do
local cy=cb(bd,v,2)
local cz=cb(bd,v+3,1)
local da=cb(bd,v+5,0)
local db=cb(bd,v+6,0)
local dc=cb(bd,v+7,0)
for d=cz,cz+db-1 do
for c=cy,cy+da-1 do
a[c][d].bd=dc
end
end
end
end
for dd in all(ca.bt) do
local de=0
if dd[6]==1 then
de=1
elseif dd[6]==2 then
de=-1
end
df(dd,de)
end
end
function cb(dg,v,dh)
return tonum("0x"..sub(dg,v,v+dh))
end
function di(dj,dk)
local dl,dm,dn,dp=dj:dq()
local dr,ds,dt,du=dk:dq()
return dv(
dl,dm,dn,dp,
dr,ds,dt,du)
end
function dw(dj,dx,dy,dz,ea)
local dl,dm,dn,dp=dj:dq()
return dv(dl,dm,dn,dp,dx,dy,dz,ea)
end
function eb(cy,cz,dk)
local dr,ds,dt,du=dk:dq()
return ec(cy,cz,dr,ds,dt,du)
end
function ec(cy,cz,c,d,bn,bo)
if flr(cy)>=flr(c-(bn)) and flr(cy)<flr(c+(bn)) and
flr(cz)>=flr(d-(bo)) and flr(cz)<flr(d+(bo)) then
return true
else
return false
end
end
function dv(
dx,dy,
dz,ea,
ed,ee,
ef,eg)
local eh=dx-ed
local ei=dz+ef
if(abs(eh)>=ei) return false
local ej=dy-ee
local ek=ea+eg
if(abs(ej)>=ek) return false
return true
end
function el(self)
local em,en,eo,ep=self:dq()
local eq=eo
local er=0
if self.z<0 then
eq*=-1
er=8
elseif self.z==0 then
return
end
local c=(em+eq)/8
for es=-(ep)+1,(ep)-1,2 do
local d=(en+es)/8
if fget(mget(c,d),0) then
if self.et!=nil then
self:et()
else
self.z=0
self.c=(flr((c))*8)+er-eq
end
return true
elseif self.eu==-1 and self.ev and self.ew then
for dd in all(bs) do
if dd!=self and dd.ev and dd.ew and dd.ex then
if eb(c*8,d*8,dd) then
self.z*=-1
return true
end
end
end
end
end
return false
end
function ey(self)
if self.ba<0 then
return false
end
local em,en,eo,ep=self:dq()
local d=(en+ep)/8
for v=-(eo)+2,(eo)-2,2 do
local ez=nil
if fget(mget((em+v)/8,d),0) then
ez=(flr(d)*8)-(self:cq())
else
for dd in all(bs) do
if self==fa and dd.fb then
if di(self,dd) then
ez=(flr(dd.d-dd:cq()))-(self:cq())+1
break
end
end
end
end
if ez then
if self.fc!=nil then
self:fc(ez)
else
self.ba=0
self.d=ez
self.fd=true
self.fe=0
end
return true
end
end
if self.ff then
self.z*=-1
self.c+=self.z
end
return false
end
function fg(self)
if self.ba>=0 then
return
end
fh={}
local d=flr((self.d-(self:cq()))/8)
for v=-(self:cp())+2,(self:cp())-2,2 do
local c=flr((self.c+v)/8)
fi=nil
if self==fa then
fi=cv(c*8,d*8)
end
local fj=mget(c,d)
if fget(fj,0) or fi!=nil then
add(fh,{fj,c,d,fi})
end
end
if#fh>0 then
self.ba=0
self.d=flr(d)*8+8+(self:cq())
self.fk=0
local fi=fh[flr(#fh/2)+1]
if self==fa then
if fi[4]!=nil then
fi[4]:fl(self)
else
fj=fi[1]
c=fi[2]
d=fi[3]
if(fget(fj,1)) fm(c,d,104)
if(fget(fj,2)) then
if fa.fn then
fm(c,d,0)
else
fm(c,d)
end
end
end
end
else
return nil
end
end
function fo(c,d)
local dd=
{
c=c,
d=d,
fp=function(self)
return sqrt(self.c^2+self.d^2)
end,
fq=function(self)
local dh=self:fp()
return fo(self.c/dh,self.d/dh),dh;
end,
}
return dd
end
function fr(c,d)
function fs(dj)
return(dj%2==0) and dj or dj-1
end
return fs(c),fs(d)
end
function cv(c,d)
for dd in all(bs) do
if dd.ft==true and eb(c,d,dd) then
return dd
end
end
return nil
end
function fm(c,d,e)
local r,s=fr(c,d)
for dd in all(bs) do
if dd.fu!=nil and dw(dd,r*8+8,s*8+8-16,8,8) then
dd:fu({c=r*8+8,d=s*8+8})
end
end
if fget(mget(r,s-1),7) then
local fv,fw=fr(flr(r),flr(s-1))
by(fv,fw,{0,0,0,0})
fa:fx()
fy(fv*8+8,fw*8+8)
end
if e==0 then
for v=0,1 do
for x=0,1 do
fz(
(r+v)*8+4,
(s+x)*8+4,
-1+(v*2),((1-x+1)*-3),mget(r+v,s+x))
end
end
by(r,s,{0,0,0,0})
sfx(55)
return
end
if e==nil then
e={}
for d=0,1 do
for c=0,1 do
add(e,mget(r+c,s+d))
end
end
end
ga(r*8+8,s*8+8,e)
sfx(52)
by(r,s,{127,127,127,127})
end
function gb(dg,gc,
gd,ge,
gf)
for d=-1,1 do
for c=-1,1 do
print(dg,gc+c,gd+d,gf)
end
end
print(dg,gc,gd,ge)
end
function gg(
dg,c,d,
ge,gf,
gh)
local gi=(#dg*4)+(gh*3)
local gc=c-(gi/2)
local gd=d-2
gb(dg,gc,gd,ge,gf)
end
function gj(c,d)
local co=
{
c=c,
d=d,
z=0,
ba=0,
bn=16,
bo=16,
gk=0,
cp=function(self)
return self.bn*0.5
end,
cq=function(self)
return self.bo*0.5
end,
dq=function(self)
if self.gl and self.gm then
return
self.c,
self.d+self:cq()-self.gl/2,
self.gm/2,self.gl/2
else
return self.c,self.d,self.bn/2,self.bo/2
end
end,
gn=1,
go=9999,
gp=9999,
gq=0,
bg=false,
bh=false,
ev=true,
gr=false,
o=1,
gs=
{
["idle"]=
{
gt={26},
},
},
gu="idle",
gv=1,
gw=0,
gx=function(self,gy)
if(gy==self.gu) return
self.gw=self.gs[gy].gz or 0
self.gu=gy
self.gv=1
end,
ha=function(self)
self.gw-=1
if self.gw<=0 then
self.gv+=1
local dj=self.gs[self.gu]
self.gw=dj.gz or 0
if self.gv>#dj.gt then
if self.hb!=nil then
self:hb()
end
self.gv=1
end
end
end,
hc=function(self)
self.gk+=1
self.z=mid(-self.go,self.z,self.go)
self.c+=self.z
if self.ev then
local hd=self.z
if el(self) then
self.z=-hd
end
end
self.ba+=self.gq
self.ba=mid(-self.gp,self.ba,self.gp)
self.d+=self.ba
if self.he!=nil then
local hf=self.gk/60
if self.he.hg==true then
self.c=self.cr+((sin(hf/self.he.hh)+1)*0.5)*self.he.hi
else
self.d=self.cs+((sin(hf/self.he.hh)+1)*0.5)*self.he.hi
end
end
if self.ev then
ey(self)
fg(self)
end
self:ha()
end,
hj=function(self)
local dj=self.gs[self.gu]
local hk=dj.gt[self.gv]
if(self.pal) be(self.pal)
if type(hk)=="table"then
local r=self.c-(self:cp())
local s=self.d-(self:cq())
local count=1
local hl=flr(self.bo/8)
local hm=flr(self.bn/8)
local hn=8
local ho=8
if self.bg then
r=r+((hm-1)*8)
hn=-8
end
if self.bh then
s=s+((hl-1)*8)
ho=-8
end
local d=s
for hp=1,hl do
local c=r
for hq=1,hm do
local hr=hk[count]
local bg=self.bg
local bh=self.bh
if hr!=nil and hr!=0 then
if hr<0 then
hr=abs(hr)
bg=not bg
end
if hr>=256 then
hr-=256
bh=not bh
end
sspr((hr*8)%128,flr((hr/16))*8,8,8,
c,d,8,8,
bg,bh)
end
count+=1
c+=hn
end
d+=ho
end
else
local bg=self.bg
local bh=self.bh
if hk<0 then
bg=not bg
hk=abs(hk)
end
if hk>=256 then
hk-=256
bh=true
end
sspr((hk*8)%128,flr((hk/16))*8,self.bn,self.bo,
self.c-(self:cp()),self.d+(self:cq())-(self.bo/self.gn),
self.bn,self.bo/self.gn,bg,bh)
end
if(self.pal) bi()
end,
hs=function(self,g)
for ct,dd in pairs(g) do
self[ct]=dd
end
return self
end,
}
add(ht,co)
return co
end
function hu(c,d)
local hv=gj(c,d):hs(
{
go=2,
gp=4,
hw=9999,
hx=9999,
hy=-4,
hz=0.1,
ia=0.8,
ib=1,
gq=0.3,
ic=id(5),
ie=id(4),
fk=0,
ig=5,
ih=20,
fd=false,
fe=0,
gs=
{
["idle"]=
{
gt={10},
},
["run"]=
{
gz=2,
gt={6,4,2},
},
["jump"]=
{
gt={0},
},
["slide"]=
{
gt={8},
},
["dead"]=
{
gt={93},
},
["fire"]=
{
gz=15,
gt={
ii("06075d5e6d6e3637")
},
},
},
ij=3,
ik=0,
il=0,
fn=false,
im=false,
io=function(self,ip)
for ct,dd in pairs(self.gs) do
for iq,ir in pairs(dd.gt) do
if type(ir)=="table"then
for is,it in pairs(ir) do
self.gs[ct].gt[iq][is]+=ip
end
else
self.gs[ct].gt[iq]+=ip
end
end
end
end,
iu=function(self)
if self.fn==false then
self:io(32)
self.bo=32
self.d-=8
self.fn=true
self.iv=60
elseif self.im==false then
self.im=true
self.iv=60
end
sfx(58)
end,
iw=function(self,ix)
if self.fn==true then
self:io(-32)
self.bo=16
self.d+=8
self.fn=false
self.im=false
if not ix then
self.iv=60
sfx(56)
end
end
end,
iy=function(self)
self.iz=0
self:iw(true)
self:ja(nil)
end,
ja=function(self,jb)
if self.iz<=0 then
if self.fn then
self:iw()
self.iz=120
else
self.jc=true
self.z=0
self.ba=-10
self.bh=false
self.fd=false
self.cz=self.d
self.eu=0
self.bn=16
self.jd=0
self:gx("dead")
music(24)
end
end
end,
je=function(self,cy,cz)
self.c=cy
self.d=cz-self:cq()
self.z=0
self.ba=0
self.iz=0
self.iv=0
self.jf=0
self.jg=0
self.jh=nil
self.jc=false
self.ji=false
self.jd=0
self:gx("idle")
end,
jj=function(self)
self.z=0
self.ba=0
self.ji=true
self.il=0
music(-1)
end,
jk=function(self)
self.jd=900
music(23)
end,
fx=function(self)
self.ik+=1
if self.ik>=100 then
self.ij+=1
self.ik=self.ik%100
sfx(59)
else
sfx(61)
end
end,
})
hv:je(0,0)
hv.jl=hv.hc
hv.hc=function(self)
if self.jd>0 then
self.jd-=1
if self.jd==0 then
music(bj[bm[jm].bj])
end
end
self.iz=max(0,self.iz-1)
if self.jc then
self.eu+=1
if self.eu<30 then
return
end
local gi=120
local jn=(self.eu-30)/gi
if jn>0.5 then
self.d+=self.ba
if(self.d>jo.jp.d+256) and self.eu>200 then
self.ij-=1
if self.ij<=0 then
jq(bx)
else
jq(bv)
end
end
return
end
jr=(sin(jn)*80)+self.cz
if(jn>=0.5) then
self.ba=jr-self.d
end
self.d=jr
return
end
if self.jh!=nil then
self.jf-=1
if self.jf==0 then
self.jh:js()
self.jh=nil
self.jg=0
else
self.d+=1*self.jg
end
return
end
if self.ji then
if self.il==60 then
music(30)
end
self.il+=1
if self.il>60 then
self.d+=1
if ey(self) then
if(self.il>400) then
jt+=1
if jt>#bk then
stop("to be continued...",32,64,7)
end
jm=bk[jt]
jq(bv)
end
elseif gz%4==0 then
fa:fx()
fy(self.c+rnd(16)-8,self.d-rnd(8))
end
end
return
end
if(self.d>jo.jp.d+64) then
self:iy()
end
if self.iv>0 then
self.iv-=1
return
end
local ju=btn(0) and not self.jc
local jv=btn(1) and not self.jc
if ju==true then
self.z-=self.hz
jv=false
elseif jv==true then
self.z+=self.hz
else
if self.fd then
self.z*=self.ia
else
self.z*=self.ib
end
end
local jw=self.go*0.5
if btn(4) then
self.hw=0
else
self.hw=min(999,self.hw+1)
end
if self.hw<15 then
jw=self.go
end
self.z=mid(-jw,self.z,jw)
self.c+=self.z
el(self)
local jx,jy=jo:jz()
if self.c-self:cp()<jx then
self.z=0
self.c=jx+self:cp()
elseif self.c+self:cp()>jx+128 then
self.z=0
self.c=jx+128-self:cp()
end
self.ic:hc()
if self.ic.ka and not self.jc then
local kb=(self.fd or self.fe<5)
local kc=self.ic.kd<10
if self.fk>0 or(kb and kc) then
if(self.fk==0) sfx(63)
self.fk+=1
if self.fk<self.ih then
self.ba=self.hy
end
end
else
self.fk=0
end
self.ba+=self.gq
self.ba=mid(-self.gp,self.ba,self.gp)
self.d+=self.ba
if not self.jc and not ey(self) then
self:gx("jump")
self.fd=false
self.fe+=1
end
if self.fd==true and btn(3) then
for dd in all(bs) do
if dd.ke!=nil then
if eb(self.c,self.d,dd) then
self.jh=dd
self.jf=60
self.jg=1
sfx(56)
music(-1)
return
end
end
end
end
for x=-1,1 do
for v=-1,1 do
local c=(self.c-(v*self:cp()))/8
local d=(self.d-(x*self:cq()))/8
if fget(mget(c,d),3) then
local r,s=fr(flr(c),flr(d))
by(r,s,{0,0,0,0})
self:fx()
end
end
end
if(not self.jc) fg(self)
if self.hx<5 then
self:gx("fire")
elseif self.fd then
if(jv and self.z<0) or(ju and self.z>0) then
self:gx("slide")
elseif ju or jv then
self:gx("run")
self.gs["run"].gz=((self.go-abs(self.z))+1)*3
else
self:gx("idle")
end
end
if self.fd then
if(jv) self.bg=false
if(ju) self.bg=true
end
self.ie:hc()
if self.ie.kf and self.im and#kg<2 then
local de=1
if(self.bg) de=-1
kh(self.c,self.d,de)
self:gx("fire")
self.hx=0
else
self.hx=min(9999,self.hx+1)
end
self:ha()
end
hv.ki=hv.hj
hv.hj=function(self)
if self.iz%2==0 then
if self.jd>0 then
local kj={{9,7,5,9},{8,1,5,4,9,15},{8,3,5,9,9,7}}
local kk=self.jd<120 and 8 or 2
local v=(flr(gz/kk)%4)
self.pal=kj[v]
elseif self.im then
self.pal={8,15,5,8}
else
self.pal=nil
end
self.gn=1
if self.iv%20>10 then
if self.fn then
self.gn=2
else
self.gn=0.5
end
end
self:ki()
end
end
return hv
end
function kl(c,d)
local co=gj(c,d)
co.ev=false
co.hb=function(self)
del(bs,self)
end
return co
end
function km(c,d)
local co=kl(c,d)
co.gs=
{
["idle"]=
{
gz=5,
gt={
ii("0087ff790187fe79",4),
ii("0088ff780188fe78",4),
ii("0089ff770189fe77",4)
}
}
}
end
function fy(c,d)
kl(c,d):hs(
{
bn=8,
ba=-6,
gq=0.3,
}).gs["idle"]=
{
gz=5,
gt={
{252,508},
{253,509},
{254,510},
{255,511},
{252,508},
{253,509},
{254,510},
{255,511},
}
}
end
function kh(c,d,kn)
sfx(53)
local ko=2
local co=gj(c,d):hs(
{
bn=8,
bo=8,
gq=0.2,
z=kn*ko*2,
ba=ko,
fc=function(self,d)
self.ba=-ko
self.d=d
end,
et=function(self)
km(self.c,self.d)
del(kg,self)
end,
kp=function(self)
for dd in all(bs) do
if dd.ex and dd.eu==-1 and not dd.kq and di(self,dd) then
self:et()
dd:fu(self)
break
end
end
end,
})
co.gs["idle"]=
{
gz=5,
gt=ii("005f006ffea1fe91",4)
}
co.kr=co.hc
co.hc=function(self)
self:kr()
self:kp()
local jx,jy=jo:jz()
if self.c+self.bn<jx or self.c-self.bn>jx+128 or self.d-self.bo>jy+128 then
del(kg,self)
end
end
del(ht,co)
add(kg,co)
end
function df(dd,ks)
gj(dd[1]*8,dd[2]*8):hs({
bn=10,
bo=32,
ke=dd[3],
kt=dd[4]*8,
ku=dd[5]*8,
ks=ks,
hj=function() end,
js=function(self)
kv(self.kt,self.ku,self.ke,self.ks)
end
})
end
function cm(c,d,g)
local co=gj(c,d):hs({
bn=48,
bo=8,
fb=true,
})
co.gs["idle"].gt={
ii("727272727272")
}
co.kw=co.hc
if g==114 then co.ba=0.5 end
if g==115 then co.ba=-0.5 end
if g==116 then co.he={hh=5,hi=56,hg=true} end
if g==117 then co.he={hh=10,hi=112,hg=false} end
co.hc=function(self)
local kx=di(self,fa)
local ky=self.c
local kz=self.d
self:kw()
if kx then
fa.c+=self.c-ky
fa.d+=self.d-kz
end
if self.he==nil then
self.d=(self.d+(jo.jp.d+64))%(jo.jp.d+64)
end
end
co.la=co.hj
co.hj=function(self)
local kz=self.d
local ky=self.c
lb(self)
self:la()
self.c=ky
self.d=kz
end
return co
end
function cn(c,d,g)
local co=gj(c,d)
co.g=g
co.lc=-1
co.ft=true
co.fl=function(self)
if self.g==148 or self.g==149 then
local co=ld(self.c,self.d)
if self.g==149 then
co.pal={4,3}
co.le=true
elseif fa.fn then
co.lf=true
co.gs["idle"]=
{
gt={
ii("0096ff6a00a6ff5a",4)
},
}
co.z=0
end
elseif self.g==151 then
lg(self.c,self.d)
elseif self.g==152 or self.g==153 then
fy(self.c,self.d)
fa:fx()
if self.lc==-1 then
self.lc=60*4
end
end
local c,d=fr(self.c/8,self.d/8)
if self.g!=153 or self.lc<=0 then
fm(c,d,104)
del(bs,self)
else
fm(c,d)
end
end
co.hc=function(self)
if self.lc>0 then
self.lc-=1
end
end
co.hj=function(self) end
return co
end
function lh(c,d)
local co=gj(c,d)
co.ev=false
co.lf=false
co.pal={}
co.fu=function(self,li)
self.z=sgn(self.c-li.c)*abs(self.z)
self.ba=-2
end
co.lj=co.hc
co.hc=function(self)
if di(self,fa) then
if self.lk then
self:lk()
end
del(bs,self)
end
if self.gk==32 then
self.o=1
self.ev=true
elseif self.gk<32 then
self.d-=0.5
self.gk+=1
return
end
self:lj()
end
co.ll=co.hj
co.hj=function(self)
if self.lf then
local kj={{7,15,9,4,4,2},{7,9,9,3},{4,3}}
local v=(flr(gz/2)%4)
self.pal=kj[v]
end
self:ll()
end
co.o=0
return co
end
function lm(g)
pal()
if g then
for v=1,#g,2 do
pal(g[v],g[v+1])
end
end
end
function be(ln)
add(lo,ln)
lm(ln)
end
function bi()
del(lo,lo[#lo])
lm(lo[#lo])
end
function bc()
local kj={{9,4},{},{9,10},{}}
local v=(flr(gz/10)%4)+1
if kj[v]!=nil then
be(kj[v])
end
end
function ld(c,d)
sfx(57)
local co=lh(c,d):hs({
z=0.75,
gq=0.1
})
co.gs["idle"]=
{
gt={148},
}
co.lk=function(self)
if co.le then
fa.ij+=1
sfx(59)
else
fa:iu()
end
del(bs,self)
end
return co
end
function lg(c,d)
sfx(57)
local co=lh(c,d):hs(
{
z=0.75,
ba=-3,
gq=0.1,
lf=true,
fc=function(self,ez)
self.ba=-3
self.d=ez
end,
lk=function(self)
fa:jk(self)
end,
})
co.gs["idle"]=
{
gt={
ii("0097ff6900a7ff59",4)
}
}
end
function ga(c,d,lp)
local co=gj(c,d)
co.g=0
co.cz=d
co.lq=lp
co.gs["idle"].gt={lp}
if bm[jm].pal!=nil then
co.pal=bf[bm[jm].pal]
end
co.hc=function(self)
self.g+=1
local jn=self.g/30
jr=(sin(self.g/30)*4)+self.cz
self.d=jr
if(self.d>=self.cz) then
del(bs,self)
by((self.c-8)/8,(self.cz-8)/8,self.lq)
end
end
end
function lr(c,d)
local co=gj(c,d):hs({
z=-0.5,
gq=0.1,
eu=-1,
ex=true,
ew=true,
gl=10,
gm=10,
lt=1,
fu=function(self,li)
self.lt-=1
if self.eu==-1 and self.lt==0 then
self.eu=240
self.z=sgn(self.c-li.c)*0.5
self.ba=-3
self.ev=false
self.bh=true
self.he=nil
self.gq=0.1
sfx(54)
end
end
})
co.gs["idle"]=
{
gz=5,
gt={12,-12},
}
co.lu=function(self)
end
co.lv=function(self,lw)
if lw.ja then
lw:ja(self)
end
end
co.ja=co.fu
co.lx=co.hc
co.hc=function(self)
self:lx()
if self.z<0 then
self.bg=true
elseif self.z>0 then
self.bg=false
end
if self.eu>=0 then
self.eu-=1
if self.eu<=0 then
del(bs,self)
end
return
end
if self.eu==-1 and not fa.jc and fa.jh==nil then
if di(fa,self) then
if fa.jd>0 then
self:fu(fa)
else
local ly,lz=fa.c,fa.d+(fa:cq())
local ma,mb,mc,md=self:dq()
if mb>lz then
if fa.ba>=0 then
self:lu()
end
else
self:lv(fa)
end
end
end
end
end
co.me=co.hj
co.hj=function(self)
local kz=self.d
local ky=self.c
if self.eu==-1 then
lb(self)
end
self:me()
self.c=ky
self.d=kz
end
return co
end
function lb(self)
local jx,jy=jo:jz()
local mf=10
if self.d>=jy+128 then
local ez=jy+128
circfill(self.c,ez,mf+1,1)
circfill(self.c,ez,mf,7)
self.d=ez
elseif self.d<=jy then
local ez=jy
circfill(self.c,ez,mf+1,1)
circfill(self.c,ez,mf,7)
self.d=ez
end
end
function cd(c,d)
local co=lr(c,d):hs(
{
lu=function(self)
self.gn=4
self.eu=60
self.z=0
self.ba=0
fa.ba=fa.gp*-1
sfx(54)
end,
})
if bm[jm].pal==1 then
co.pal={4,13,15,12}
end
return co
end
function ce(c,d)
local co=lr(c,d):hs(
{
bo=24,
z=0,
ev=false,
gq=0,
o=0,
fu=function(self,li)
del(bs,self)
sfx(54)
end,
})
co.gs["idle"]=
{
gz=15,
gt=
{
ii("00b0ff5000c0ff4000d0ff30",4),
ii("00b1ff4f00c1ff3f00d1ff2f",4)
},
}
co.mg=co.hc
co.hc=function(self)
if abs(self.c-fa.c)>32 or self.d!=self.cs then
self.d=mid(self.cs,self.cs-self:cq()+cos(self.gk*0.003)*36,self.cs-self.bo)
end
self:mg()
end
return co
end
function cf(c,d)
local co=lr(c,d):hs({
bo=24,
gl=12,
gm=8,
lu=function(self)
mh(self.c,self.d+4).pal=self.pal
del(bs,self)
fa.ba=fa.gp*-1
sfx(54)
end
})
co.gs["idle"]=
{
gz=5,
gt={44,46},
}
return co
end
function cg(c,d)
local co=cf(c,d):hs(
{
pal={3,8},
ff=true,
})
return co
end
function ci(c,d)
local co=cg(c,d):hs(
{
he={hh=7,hi=96,hg=false},
ff=false,
z=0,
ba=0,
gq=0,
cs=d,
bg=true,
})
co.gs["idle"]=
{
gz=15,
gt={
ii("9a2daa3d4c4d"),
ii("9b2fab3f4e4f"),
},
}
return co
end
function ii(dg,cu)
local g={}
if(not cu) cu=2
for v=1,#dg,cu do
add(g,cb(dg,v,cu-1))
end
return g
end
function ck(c,d)
local co=lr(c,d):hs(
{
z=-1,
bn=24,
bo=8,
ew=false,
ev=false,
gq=0,
kq=true
})
co.gs["idle"]=
{
gz=5,
gt=
{
185,
441
}
}
return co
end
function cj(c,d)
local co=lr(c,d):hs({
bn=32,
bo=32,
gl=30,
gm=16,
gq=0.025,
lt=6,
he={hh=30,hi=128,hg=true}
})
co.gs["idle"]=
{
gz=5,
gt=
{
ii("00009e9facadaeafbcbdbe00cccd0000"),
ii("00009e9facadaeafbcbdbe00cecf0000"),
}
}
co.mi=co.hc
co.hc=function(self)
self:mi()
self.bg=true
if self.eu==-1 then
if gz%180<20 then
self.ba=-1
self.fd=false
end
if gz%240==0 then
ck(self.c-8,self.d)
end
end
end
co.lu=function(self)
self:lv(fa)
end
return co
end
function mj(c,d,eq,de)
local co=lr(c,d):hs(
{
bn=8,
bo=8,
gq=0,
z=0,
cr=c,
cs=d,
kq=true,
de=de,
ev=false,
eq=eq
})
co.gs["idle"]=
{
gz=5,
gt=ii("005f006ffea1ff91",4)
}
co.mk=co.hc
co.hc=function(self)
self.c=self.cr+(sin(self.gk*de/240))*self.eq
self.d=self.cs+(cos(self.gk*de/240))*self.eq
self:mk()
end
return co
end
function ch(c,d,g)
for v=1,6 do
mj(c,d,v*8-8,g==95 and 1 or-1)
end
end
function mh(c,d)
local co=lr(c,d):hs(
{
z=0,
ba=0,
gl=12,
gm=8,
iz=0,
ml=function(self,mm)
self.z=sgn(self.c-mm.c)*2.5
self.iz=15
self.ew=false
sfx(52)
end,
lu=function(self)
if self.z==0 then
self:ml(fa)
elseif self.iz<=0 then
self.z=0
self.ew=true
fa.ba=fa.gp*-1
end
sfx(54)
end,
lv=function(self,lw)
if self.z!=0 and self.iz<=0 then
lw:ja(self)
else
self:ml(lw)
end
end,
})
co.gs["idle"]=
{
gt={
ii("000efff2001effe2",4)
}}
co.mn=co.hc
co.hc=function(self)
self:mn()
self.iz=max(0,self.iz-1)
for dd in all(bs) do
if dd!=self and dd.ev and dd.ex then
if self.z!=0 and di(self,dd) then
dd:fu(self)
end
end
end
end
return co
end
function cl(c,d)
local co=gj(c,d)
co.mo=false
co.gs["idle"]=
{
gt={
ii("64650064")
},
}
co.hc=function(self)
if self.mo then
self.d=fa.d
elseif fa.c>self.c then
fa:jj(self)
self.mo=true
end
end
return co
end
function id(cc)
local dk=
{
hc=function(self)
self.kf=false
if btn(cc) then
if not self.ka then
self.kf=true
end
self.ka=true
self.kd+=1
else
self.ka=false
self.kf=false
self.kd=0
end
end,
kf=false,
ka=false,
kd=0,
}
return dk
end
function mp(lw)
local kj=
{
mq=lw,
mr=fo(lw.c+lw:cp(),lw.d+lw:cq()),
ms=16,
mt=fo(max(64,lw.c+16),78),
jp=fo(3504,152),
hc=function(self)
if self:mu()<self.mq.c then
self.mr.c+=self.mq.c-self:mu()
end
if self:mv()>self.mq.c then
self.mr.c+=self.mq.c-self:mv()
end
if self:mw()<self.mq.d+(self.mq:cq()) then
self.mr.d+=self.mq.d+self.mq:cq()-self:mw()
end
if self:mx()>self.mq.d+(self.mq:cq()) then
self.mr.d+=self.mq.d+self.mq:cq()-self:mx()
end
self.mr.c=mid(self.mt.c,self.mr.c,self.jp.c)
self.mr.d=mid(self.mt.d,self.mr.d,self.jp.d)
self:my()
self:mz()
end,
jz=function(self)
return self.mr.c-64,self.mr.d-64
end,
mu=function(self)
return self.mr.c-16
end,
mv=function(self)
return self.mr.c-16
end,
mw=function(self)
return self.mr.d+self.ms
end,
mx=function(self)
return self.mr.d-self.ms
end,
my=function(self)
self.mt.c=max(self.mt.c,fa.c-128)
for dd in all(bs) do
if dd.c+dd.bn<self.mt.c-64 or dd.d-dd.bo>self.jp.d+64 then
del(bs,dd)
end
end
end,
mz=function(self)
for dd in all(ht) do
if dd.c<=(flr(self:jz()/256)+1)*256+128+dd.bn then
add(bs,dd)
del(ht,dd)
end
end
end,
}
return kj
end
function fz(na,nb,nc,nd,ne)
local co=gj(na,nb):hs(
{
z=nc,
ba=nd,
bn=8,
bo=8,
gq=0.3,
ev=false,
gs=
{
["idle"]=
{
gt={ne},
}
},
})
return co
end
function nf()
ng=0
gz=0
bs={}
ht={}
kg={}
lo={}
menuitem(1,
"[cheat] next level",
function() jt+=1
jm=bk[jt]
jq(bv) end)
end
function jq(nh)
if ng==bu then
fa=hu(0,0)
fa:gx("idle")
jt=1
end
ng=nh
gz=0
if ng==bv then
jm=bk[jt]
ni(40,96,jm)
elseif ng==bx then
music(26)
end
end
function kv(cy,cz,nj,jg)
nk={cy,cz,nj,jg}
end
function ni(cy,cz,nl,jg)
bs={}
ht={}
kg={}
a={}
lo={}
fa:je(cy,cz)
if jg!=nil and jg!=0 then
fa.jh={js=function() end,}
fa.jf=60
fa.jg=-1
fa.d+=60
end
jo=mp(fa)
jm=nl
local nj=bm[jm]
jo.jp=fo((nj.bn*8)-64-8,(nj.bo*8)-64-24),
bz(nj)
music(bj[nj.bj])
end
function _init()
nf()
end
function _update60()
gz+=1
if ng==bu then
if btnp(4) or btnp(5) then
jq(bv)
end
elseif ng==bv then
if gz>=120 then
jq(bw)
end
elseif ng==bw then
if btnp(2,1) then
fa:iu()
end
if not fa.jc and fa.iv==0 then
for co in all(bs) do
co:hc()
end
for co in all(kg) do
co:hc()
end
end
fa:hc()
jo:hc()
if nk!=nil then
ni(nk[1],nk[2],nk[3],nk[4])
nk=nil
end
elseif ng==bx then
if btnp(4) or btnp(5) then
jq(bu)
end
end
end
local nm=15
local nn="00000000000000011111110000000022222211100000033333311100000044422222110000055555111110000066dddd55551110076666ddd5551100888822222200000999444444550000aa9994445555000bbb333333300000ccccc3311111100ddd555511111000eeed44222221100ff6ddd555551100"
function no(v)
for kj=0,15 do
if flr(v+1)>=nm then
pal(kj,0,1)
else
local np=kj*nm+v+1
pal(kj,cb(nn,np,0),1)
end
end
end
function _draw()
if ng==bu then
cls(0)
gg("super mario bros.",64,64,7,1,0)
elseif ng==bv then
cls(0)
camera(0,0)
spr(10,32,56,2,2)
gg("   x   "..fa.ij,64,64,7,1,0)
if gz<=nm then
no(nm-gz)
elseif gz>=100-nm then
local jn=gz-(100-nm)
jn/=nm
no(flr((jn)*nm))
end
elseif ng==bw then
if bm[jm].cls then
cls(bm[jm].cls)
else
cls(0)
end
camera(jo:jz())
if fa.jh!=nil then
fa:hj()
end
if(bm[jm].pal!=nil) be(bf[bm[jm].pal])
for co in all(bs) do
if co.o==0 then
co:hj()
end
end
map(0,0,0,0,32,446)
for co in all(bs) do
if co.o==1 then
co:hj()
end
end
if(bm[jm].pal!=nil) bi()
for co in all(kg) do
co:hj()
end
if fa.jh==nil then
fa:hj()
end
camera(0,0)
bc()
sspr(64,72,16,16,54,0,8,8)
bi()
gb("x "..fa.ik,64,2,7,1)
elseif ng==bx then
cls(0)
gg("game over",64,64,7,1,0)
end
end
__gfx__
00000000000009990000008888800000000000888880000000000000000000000000008888800000000008888800000000000044440000000000000000000000
00000088888009990000088888888800000008888888880000000008888800000000588888888000000088888888800000000444444000000000000000000000
00000888888888990000055599590000000005559959000000000088888888800005555559590000000055599590000000004444444400000000093333900000
00000555995905550000595999599900000059599959990000000055599590000099599599999900000595999599900000044444444440000000339999330000
00005959995995550000595599959990000059559995999000000595999599900099599559955990000595599959990000411444444114000003393333933000
0000595599959995000055999955550000005599995555000000059559995999000995999999550000055999955550000444f144441f44400003933333393000
0000559999555550000000999999900000000099999990000000055999955550000088855589900000000999999900000444f111111f44400039333333339300
0000009999999500000555588550000000000558555000000000000999999900000889995885550000005585550000004444f1f44f1f44440093933333393900
0055555855585000099555588855599900005555885500000000005555850900000859995555550000055585585550004444fff44fff44440933393333933390
05555555855580050999055898885599000055588988900000000955555599900008889955555500005555888855550044444444444444440333339999333330
99555555888880050990088888880050000055558888800000009985555599000000888885555000009958988985990004444ffffff444407773393333933777
9990885889889855000088888888855000008559998880000000558888888000000085558888000000999888888999000000ffffffff00007777933333397777
0905888888888855000888888888855000000859988800000000588888888000000005555888000000998888888899000011ffffffff00000007733333377000
005558888888885500558880008885500000008885550000000558880888000000505885558000000000888008880000011111fffff110000000773333770000
0555888888800000005550000000000000000055555550000005000055500000005555580000000000055500005550000111111fff1110000000077777700000
05008888000000000005550000000000000000555500000000000000555500000005555000000000005555000055550000111110011100000000007777000000
00000000000099900000008888800000000000000000000000000000000000000000008888888000000000888880000000000000000000000000000000070000
00000000000995990000888888900000000008888800000000000000000000000055888888899000000088888890000000000000000070000000000000777000
00000088888995590008888889900000000888888900000000000008888800000555888888890000000888888990000000000000000777000000000000777900
00008888888999990008888888888800008888889900000000000888888900000995599588888800000888888888880000000000009777000000000009773900
00088888888555550005559959990000008888888888800000008888889900009999599599599880000555995999000000000000099773900000000009773990
00088888888888550059959955999900005559959990000000008888888888809999599599559000005995995599990000000000099773900000000009773990
00055599599955550059955999999990059959955999900000005559959990009959899959999990005995599999999000000000099773900000000009777990
00599599599999550559955999599990059955999999990000059959955999909595889999959999055995599959999000000000099777900000000009979939
00599559999999950559999955555500559955999599990000059955999999999958855995555999055999995555550000000000099979990000000009999999
00599559995999950555999995555500559999955555500000559955999599990008555999955550055599999555550000000000099999390003333309900999
05599999555555500005599999999000055999995555500000559999955555500088555559999900000559999999900000033333009999990039333937900099
05555999955559500000055599000000005599999999000000055999995555500085599955888550000089999950000000393339309909990033939337990000
00055999999995500000888855800090000888899000000000000599999999000085999998885550000058555585000003339393309900990377393333799000
00008888558555500005555885580999005855885500000000005888999000000085999995585550000558555585500003773933337990990373939333799990
05555558858555000055555588585999058555588500000000058555850000000000999995555555005558555585550003739393337990900939333939799900
55555555855855000555555588558999058555588550000000058555585000000088895995555555055558555585555009393339397990000393333393779000
55555555885850000555555588558595058555588850000000558555558899000088889955555555055588555588555003933333937799000939333939379000
55995555885580000555555888558550058555559950000000588555555599990088888885555555555588555588555509393339393790000333939333979000
59999558888590005555558889859500058555599990000000588855555599990008888888555555555588888888555503339393339790000333393333370000
99999588898880005555888888888000088555599998000000088855555559990000555888885550555589888898555503333933333700007773939333770000
99999888888880009999988888888000088855599998800000088885555559990000055555888880999988888888999977739393337700000977733977790000
90998888888880059999988888888005088885599988800000088888855580000055555555888880999988888888999900777339777990000999777779990000
09988888888880559999888888888055088888855888800000088888888880000059999555588800099988888888999009997777799999000999000099900000
00088888888855550999888888855555008888855588000000088888888850000059999995580000099888888888899099990000009999900099900999000000
00058888888855550008588888855555000888555555000055558888888588000000888899500000008888888888880044444444000000000000000000888800
55585588888855550058858888855555000885555550000055558888855888005008888888000000088888800888888044445444000000888880000008899880
555888558888555555588855888555550000885555000000555588885888800055005888800000000888880000888880444454440009988888889900889f9980
55588888008855555555888800055555000058885550000055558880088880005555555880000000088888000088888044445444099959599595999989f99880
55588888000000005555580000000000000055550550000055550000055550000555555500000000005555000055550044454444099559599595599989988800
55588880000000000555000000000000000555550000000055000000055550000055555500000000005555000055550044454444099555999955599988980008
55000000000000000555000000000000000555555500000050000000055555500005555000000000555555000055555544454444000555599555550008880800
50000000000000000055500000000000000005555500000000000000055555500000555000000000555555000055555544444444000059555595500000888080
4ffffffff14ffff4ffffffff44444441777777777777777714444444444444411444444444444441777777770000001111000000000059999995500000888800
f444444441f444414444444144444441077777777333337749999999999999914222222222222221777777770000017777100000000888999988880008899880
f444444441f44441444444414444444100777777337373374919999999999191421222222222212177777777000117777771000000558855558855508899f988
f444444441f444411111111111111111000777773773773749999444449999914222222222222221777777770017777777710100005558855885555088889f98
f444444441f144414441444444414444000077773733373749994411144999914222222222222221777777770017777777771710005558988985555080089998
f444444441411114444144444441444400000777333733374999441994419991422222222222222177777777001777777c777771005558888885555008088988
f444444441fffff144414444444144440000007733333337499944199441999142222222222222217777777701777cc777c77771000558888885550080008880
f444444441f444411111111111111111000000077733377749999119444199914222222222222221777777771777c77777777771000000000000000000800000
f444444441f44441777777770000001111000000b000000049999994411199914222222222222221000001111001000077777100000599559999999900000000
f444444441f4444188888888000001b333100000b000000049999994419999914222222222222221000017771017100077777710005599559995999900000000
114444441f4444419900009900001b3333310000b000000049999999119999914222222222222221000177777177100077777771005599999555555000000000
ff1144441f4444419000008900001b3333310000b000000049999994499999914222222222222221000777777777101077777770000559999955999900000000
f4ff1111f4444441900000890000133333310000b000000049999994419999914222222222222221011777777777717177777110000005995559999000000000
f444fff1f4444441998888990000133333310000b000000049199999119991914212222222222121177777777777777117711000000058855555990000000000
f4444441f4444411999999990000013333100000b000000049999999999999914222222222222221177777777777777101100000000588555555900000000000
41111114f1111114888888880000001111000000b000000011111111111111111111111111111111017777777777771000000000000585555550000000000000
1111111111111111111111111111111133333133000000010000000000000000000000000008008800177c77777777777c777777000585555585000000000000
1bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb1333311130000001300000000000000000000800008008888000177c77c777777c7777777000585555885000000000000
133333bbbbbb333333333333333333313333111300000133000000000000000000000808008888890000177cccc777cccc7777c7000088558885500000000000
1bbb33bbbbbb3bb3333333333b3b3bb13333111300001333000000000000000000008888808898980000177777cccccc7ccccc77000088888888500000000000
1bbb33bbbbbb3bb33333333333b3bbb1311311130001333300000000000000800080898900898999000001117777cc7777ccc777000088888988800000000000
1bbb33bbbbbb3bb3333333333b3b3bb131133133001333330000011100008088000889f908889f9f000000001777777177777777000888888888800000000000
1bbb33bbbbbb3bb33333333333b3bbb131133333013333330011133300000889000899ff88989fff000000000117771011777711000888888888800000000000
1bbb33bbbbbb3bb3333333333b3b3bb131133333133333331133333300008899008889ff88899fff000000000001110000111100000888888888800000000000
1bbb33bbbbbb3bb33333333333b3bbb1000000999900000000007777000000090000000000000000000000000000000000000000000000000777000000000000
1bbb33bbbbbb3bb3333333333b3b3bb1000009999440000000777777000000090000000000000000077000000000000000000000000000000097773300000000
1bbb33bbbbbb3bb33333333333b3bbb1000099994444000007779999000000990000099991100000777700000000000000000000000000000099773330000000
1bbb33bbbbbb3bb3333333333b3b3bb1000999994444400077999444000000990000999999110000777770000000000000000000000000000039933337700000
1bbb33bbbbbb3bb33333333333b3bbb1009999999444990077999444000009990000994499110000077777000000000000000000000000000033333337730090
1bbb33bbbbbb3bb3333333333b3b3bb1099444999999999007779999099999990009949919911000007797700000000000000000000000000333333337733909
11111111111111111111111111111111094444499999999000777777099999490009949919911000077779700000777000000000000000000333339333777999
00111111111111111111111111111100994444499999449900007777009999490009949919911000077779770007797700000000000000000333399933379999
001bbb33bbbbb3bb33333333b3bbb100994444499999444900000003000999490009949919911000007777970077779700000000000733377333393799339997
001bbb33bbbbb3bb333333333b3bb100999444999999944933300003000099990009949919911000070777970777779700000000039773377333393339999070
001bbb33bbbbb3bb33333333b3bbb100999999999999999903330003000099990009949919911000077777970777777700000777399777377333397337377070
001bbb33bbbbb3bb333333333b3bb100094447777774449003333003000999990009949919911000007779737777777300000977339973377733399300070000
001bbb33bbbbb3bb33333333b3bbb100000077777777000000333303000999990009949919911000033377737773773300073993333333337773399700000000
001bbb33bbbbb3bb333333333b3bb100000077777797000000333303000999900000991199110000033393937733939300073333333333333777339900000000
001bbb33bbbbb3bb33333333b3bbb100000077777797000000033333009990000000999999110000093933390939333900033333777333333777339997000000
001bbb33bbbbb3bb333333333b3bb100000007777970000000000033009900000000099991100000039333330393333300777333977337777773300990000000
00000030000000000033333333333333ffff0000ffff444144444441000000000000000000000080088088800880000000977333993377999330000000000000
0000037000300000033bbbbbbbbbbbbb444f0000444f444144444441000000000000000000008888880888888888000000993333333779990700999000000000
000033300377700003bbbbbbbbbbbbbb444f0000444f444144444441000000000000000008888999888888888888800007333333333739970999079900000000
000073300337000033bbbbbbbbbbbbbb444f0000444f11111111111100000000000000008f999999999999988880000079333777333733009999009900000000
00033370073377003bbbbbbbbbbbbbbb444f0000444f444444414444000000000000000088ffff99999888888888888800333977337733799999907900000000
00033330333770003bbbbbbbbbbbbbbb444f0000444f444444414444000000000000000088999988999988998888800007733993337733339999900900000000
00737330733337703bbbbbbbbbbbbbbb444f0000444f444444414444000000000000000000088888888888888880000077733333337733339999907000000000
00333330337337003bbbbbbbbbbbbbbb111fffff111fffff11111111000000000000000000000800888888000000000009937733337333330999700000000000
00333730333330003bbbbbbbbbbbbbbb444441111111111100000000000000000000000000000000000000000000000003933933377333330393393337733333
00373330373333703bbbbbbbbbbbbbbb444111111111111100000000000000000000000000000000000000000000000003333337773333300333333377333330
00333370333373703bbbbbbbbbbbbbbb441111111111111100000000000000000000000000000000000000000000000003333777733333000333377773333300
00373330073333303bbbbbbbbbbbbbbb111111111111111100000000000000000000000000000000000000000000000077777773333339007777777333333000
00033730033733303bbbbbbbbbbbbbbb411111111111111100000000000000000000000000000000000000000000000077777999933997707777799993399000
00033330003333703bbbbbb1bbbbbbb1411111111111111100000000000000000000000000000000000000000000000007799999999997770779779977999900
000073700003733301bbbb101bbbbb10111111111111111100000000000000000000000000000000000000000000000000999977997700009999777977799770
00000030000003730011110001111100111111111111111100000000000000000000000000000000000000000000000009999977797770000000009999999777
99000009990000090000006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93990009939900090000060500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09399009093990090000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09939909099399090006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00993909009939090005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999399009993990650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099999000999996050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099000000995500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77507777077707770000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66507666077707770007870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66507666077707770078870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66507666077707777788870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66507666055505558888887700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66507666855585558788888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55505555855585557878888700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000855585558878877800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777750855585558888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76666650855585558888888800000000000000000000000000000000000000000000000000000000000000000000000000094000000990000007400000009000
76666650855585558888888800000000000000000000000000000000000000000000000000000000000000000000000000094000009999000007400000009000
76666650055505558888888800000000000000000000000000000000000000000000000000000000000000000000000000944400099999900077740000009000
76666650088808888888888800000000000000000000000000000000000000000000000000000000000000000000000000944400099749900077740000009000
76666650088808888888888800000000000000000000000000000000000000000000000000000000000000000000000000944400997994990077740000009000
55555550088808888888888800000000000000000000000000000000000000000000000000000000000000000000000000944400997994990077740000009000
00000000000000008888888800000000000000000000000000000000000000000000000000000000000000000000000000744400997994990077740000007000
__label__
ccccccccccccccccccccccccccc4999999441119991ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4999999441999991ccccccccccccc9991ccc11111ccc11111cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4999999911999991cccccccccccc94991ccc17171ccc17771cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4999999449999991cccccccccccc94991ccc17171ccc17171cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4999999441999991cccccccccccc94991ccc11711ccc17171cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4919999911999191cccccccccccc94991ccc17171ccc17171cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc4999999999999991ccccccccccccc9191ccc17171ccc17771cccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc1111111111111111ccccccccccccc991cccc11111ccc11111cccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccc9999ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccc999944cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccc99994444ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc9999944444cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccc999999944499ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc99444999999999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc94444499999999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc9944444999994499ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc9944444999994449ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc9994449999999449ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc9999999999999999ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc94447777774449cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccc77777797ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccc77777797ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccc777797cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
fffffffffff1444444444444441ffffffffffffffff1444444444444441ffffffffffffffffccccccccccccccccccccccccccccccccccccccccccccccccccccc
441444444414222222222222221444444414444444149999999999999914444444144444441ccccccccccccccccccccccccccccccccccccccccccccccccccccc
441444444414212222222222121444444414444444149199999999991914444444144444441ccccccccccccccccccccccccccccccccccccccccccccccccccccc
111111111114222222222222221111111111111111149999444449999911111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444222222222222221444144444441444449994411144999914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444222222222222221444144444441444449994419944199914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444222222222222221444144444441444449994419944199914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
111111111114222222222222221111111111111111149999119444199911111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccccccc
441444444414222222222222221444444414444444149999994411199914444444144444441ccccccccccccccccccccccccccccccccccccccccccccccccccccc
441444444414222222222222221444444414444444149999994419999914444444144444441ccccccccccccccccccccccccccccccccccccccccccccccccccccc
441444444414222222222222221444444414444444149999999119999914444444144444441ccccccccccccccccccccccccccccccccccccccccccccccccccccc
111111111114222222222222221111111111111111149999994499999911111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444222222222222221444144444441444449999994419999914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444212222222222121444144444441444449199999119991914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
444444144444222222222222221444144444441444449999999999999914441444444414444ccccccccccccccccccccccccccccccccccccccccccccccccccccc
111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccc999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc88888cc999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc88888888899cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc5559959c555cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc595999599555cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc595599959995cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc55999955555ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc99999995cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc55555855585ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc555555585558cc5cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccc9955555588888cc5ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc11111
cccccccccccccccccccccccccccccccccccccccc999c885889889855ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbb
ccccccccccccccccccccccccccccccccccccccccc9c5888888888855ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc13333
cccccccccccccccccccccccccccccccccccccccccc55588888888855ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccc5558888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccc5cc8888ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc11111
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1111cccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbb1ccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc11bbbbbb1cccccccccccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbb1c1cccccccccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbb1b1ccccccccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbb3bbbbb1cccccccccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb33bbb3bbbb1cccccccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbb3bbbbbbbbbb1cccccccccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc111bbbbbbbbbbbbbbbb1cc1cccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbbbbbbbbbbbb1c1b1ccccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbbbbbbbbbbbbbb1bb1ccccccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbb1c1ccccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccc11bbbbbbbbbbbbbbbbbbbbbbbbbb1b1cccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb1cccccccccccccccccccccccccccccccccccccccccc1bb
ccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb1cccccccccccccccccccccccccccccccccccccccccc1bb
cccccccccccccccccccccccccccccccccccccccccccccccccccc1bbbbbbbbbbbbbbbbbbbbbbbbbbbb1ccccccccccccccccccccccccccccccccccccccccccc1bb
ffff14ffff44ffffffff14ffff44ffffffff14ffff44ffffffff14ffff44ffffffff14ffff44ffffffff14ffff44ffffffff14ffff44ffffffff14ffff44ffff
44441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f4444
44441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f4444
44441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f4444
44441f14441f444444441f14441f444444441f14441f444444441f14441f444444441f14441f444444441f14441f444444441f14441f444444441f14441f4444
44441411114f444444441411114f444444441411114f444444441411114f444444441411114f444444441411114f444444441411114f444444441411114f4444
44441fffff1f444444441fffff1f444444441fffff1f444444441fffff1f444444441fffff1f444444441fffff1f444444441fffff1f444444441fffff1f4444
44441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f444444441f44441f4444

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002010101010101010101010000000000000000000000000000000000000000000101050500008383010100000000000001010500000083830101000000000001
0101010100000000000000000000000001010101000000008888000000000000010100010000000088880000000000000000010100000000000000000000000000000101000000000000000000000000000000000000000000000000000000000101000000000000000000000000000001010000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000969700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000969700000000000000009697000096970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011200200a135161450713513145081351414507100071000710013100131000a1000a13516145071351314508135141450810008100141001410014100141001f3001f3001f3000030000300003000030000300
01120020031350f145001350c145011350d1450f1000f10000100001000010000100031350f145001350c145011350d14501100011000d1000d1050d1450c1350b1451f3001f3000030000300003000030000300
010e00000e1000e0050e1000e005021050e1050e1000e00500100001000e1000e0050e1000e005001000010013100131051310500100001000010000100001000710007100071050010000100001000010000100
010a00003c6153c0053c6053c005186103c0053c6153c0053c0053c005186103c0053c6153c0053c0053c0053c6153c0053c0053c0053c0053c0053c0053c0053c6153c0053c6153c0053c615000053c61500005
011300002433500000000001f33500000000001c33500000000002133523305233350000022335213350c0231f33528335283052b3352d33500000293352b335000002833500000243352633523335000000c023
011300001c325000000000018325000000000013325000000000018325000001a3250000019325183250c0030c0231f32500000233253c6150000021325233250c0031f325000001c3253c6151a325000000c003
01130000131353f2150c000101353c6153f2150c1350c0000c023111353f215131353c61512135111353f21510135181353f2151c1351d135180001a1351c1350c023181353f215151351713513135071043f215
010c0000243301a015243301a015243301a0151a015243301a015243301a0151a015243301a015243301a01523330180352333018015233301803518015233301801523330180151803523330180352333018035
01130000000002b3052b3352a33529335273353f215283350c0232033521335243353c61521335243352633500000000002b3352a335293352733528305283350000030335070003033530335000000000000000
001300000c0233f205283252732526325233053f205243050c0031c3051d3251f3253c605183251c3251d3250000000000283252732526325233052430524325000002b325003002b3253c615000000000000000
01130000001353f21500000071353c615233250c13524325051351c3253f2150c1350c1353f215051353f215001353f2153f215041353c61523325071350c1350c023293253f21529325293253f215071353f215
01130000000002b3052b3352a335293352733500000283350c0232033521335243353c6152133524335263350000000000273352a30529305263352830528305243353030507000283053c615000000000000000
001300000000000000283052732526325233053f215243050c0031c3051d3251f3253c605183251c3251d32500000000002032527305263051d32524305243051c3352b305003002b3053c6053f2050000000000
01130000001353f21528325071353c615233250c13524325051351c3253f2150c1350c1353f215051353f215001353f215081353f2153c6150a1353f2150c1050c1350c1053f21507135071353f215001353f215
011300002433524335000002433500000243352633500000283352433500000213351f335000003f2150000024335243350000024335000002433526335283350c023000003f2050c023000003f6153f6153f615
011300000c0232030500000203253c6052032522325000001f3251c305000001c32518325000003f205000000c0232030500000203250000020325223251f3250c003000003f2050c003000003f6053f6053f605
0113000008135203253f2150f1353c6153f2151413500000131351c325000000c1353c6153f615071353f6150813520325336150f135306153f215141351f3251313500000000000c13500000000000713500000
0110000013334183341c3341f33424334283342b3342b3302b33014334183341b3342033424334273342c3342c3302c330163301a3341d3342233426334293342e3342e330163002e3352e3352e3353033030330
0113000008135203253f2150f1353c615203251413500000131350c023000000c1353f6153f605071353f6150e1350e1353f6150e135000000e1350e135000001313500000000000c023071353f6153f6153f615
011300002433524335000002433500000243352633500000283352433500000213351f335000003f2150000028335283350000028335000002433528335000002b3350000000000000001f335000000000000000
011300000c0232030500000203253c6052030522325000001f3251c325000001c32518325000003f205000000c0231e325000001e325000001e3251e325000002332500000000000000013325000000000000000
011300002833524335000001f3353f6150000020335000002133529335000002933521335000003f21500000233352d335000002d3352d3352b3350000029335283352433524305213351f335000003f21500000
011300002432521325000001c3253f605000001d325000001d3252432500000243250c135000003f205000001f3252932500000293253f6152832500000263252432521305000001d3053f615000003f20500000
01130000001353f2153f21506135071350c1050c1353f215051353f215051353f2153f6150c1350513505105021353f2150000005135071353f2150b1353f2150713521325071351d3250c1350c1350713500000
01130000001353f2153f21506135071350c1050c1353f215051353f215051353f2150c1350c135051353f215071353f215000000713507135091353f2150b1350c1353f215071353f215001350c1053f21500000
011300002833524335000001f3353f61500000203350000021335293350000029335213350000000000000002333529335000002933529335283350000026335243351c335243051c33518335000000000000000
011300002432521325000001c3253f605000001d325000001d3252432500000243253f6150000000000000001f3252632500000263253f6152432500000233251f32521305000001d3053f615000000000000000
010c00000e0301d3151d330150303c6101d3151d3151a0300c0331d3301d015150303c6101a3301a0300c0330c0301c3151c330130303c6101c3151c315180300c0331c3301c015130303c6101c015180300c033
0114002028335283352830028335280052433528335280052b3352b3052b305003001f3350030000300003002b3052b3052b305003002b3050030000300003001f3001f3001f3050030000300003000030000300
011400201e3251e3251e3001e3251e0051e3251e325003002332523305230050000013325000000000000000233052330523005000001f3050000000000000001330013300130050000000000000000000000000
011400200e1350e1353c6050e1353c6050e1350e13500100131351310513105001000713500100001000010013105131051310500100131050010000100001000710007100071050010000100001000010000100
010a00003c6053c0053c6053c005186003c0053c6053c0053c0053c005186003c0053c6053c0053c0053c0053c6053c0053c0053c0053c0053c6053c6053c6053c6053c0053c6053c0053c605000053c60500005
011200200a325163250732513325083251432507100071000710013100131000a1000a32516325073251332508325143250810008100141001410014100141001f3001f3001f3000030000300003000030000300
01120020033250f325003250c325013250d3250f1050f10500105001050010500105033250f325003250c325013250d32501105011050d1050d3050d3250c3250b3251f3051f3050030500305003050030500305
010d00000a1450a725001050d1400d725001050c1400c725001050614006725001050514005725001050b1400b725001050a135101450f1350e145141351314512135001000d1450010009145001000814507305
010d00000a3200a7050a0050d3200d100003000c32000300003000632000300003000532000300003000b32000300003000a320103200f3200e320143201332012320003000d3200030009320003000832000305
010e00200714500105061450d10500105001050c10500105001050610500105001050510500105001050b10500105001050a305103050f3050e305143051330512305000000d3050000009305000000830507305
010e00200732000305063200d10500105001050c10500105001050610500105001050510500105001050b10500105001050a305103050f3050e305143051330512305000000d3050000009305000000830507305
01120000030300303003030030300303003030030300303002030020300203002030060300603006030060300503005030050300503005030050300503005030040300403004030040300a0300a0300a0300a030
010900000903009030090300903009030090300903009030040300403004030040300403004030040300403003030030300303003030030300303003030030300403004030040300403004030040300403004030
011200001f317223171f317213171f317203171f317213171f317223171f317233171f317223171f317213171e317213171e317203171e317213171e317223171e317213171e317223171e317213171e31720317
010900002231726317223172731722317263172231725317223172631722317253172231724317223172531722317263172231727317223172631722317253172231726317223172531722317243172231725317
0108000023330233202933029310130151301529330293252933029325293002833028325283002633026325263002433024325243000030000300003000030000300183130c3310030000300003000030000300
0108000013030130251f313133312631312331130301302513030130251d00015030150251c00017030170251a0001f3130a3311c3131333113030130201c313103310c0300c0200c00000000000000000000000
01100000000001032013320183201c3201f320243202432024320283000f32014320183201b320203202432024320243202030011320163201a3201d320223202632026320223001a3251a3251a3251c3201c320
010a00002433424330000000000000000000001f3341f330000000000000000000001c3341c3301c3301c33021334213302132023334233302332021334213302132020334203302032020320223342233022320
010f000022320203342033020320203201f3341f3301f3301f3301f3301f3321f3351f3001f300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001c3341c33000000000000000000000183341833000000000000000000000133341333013330133301d3341d3301d3301d3301d3301d3301d3301d3301d3301d3341d3301d3301d3301d3301d3301d330
010b00201033020337230172033520330203301133021330213102133524017213171233022330223102233522330223301f030130101f036130361f036130361f036130361f0361300700000000000000000000
010a00001303013030000000000000000000001003010030000000000000000000000c0300c0300c0300c0301103011030110301103011030110301103011030110300d0300d0300d0300d0300d0300d0300d030
011000000d0300d0300d0300d0320d0320c0300c0300c0300c0220c0220c0120c0150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00201c33026330263102633526330263301d33027330273102733527330273301e33028330283102833528330283302933029310293262332629326233262932623326293262330000000000000000000000
01040000103500c3510e3501035010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000133551f3552b3553735537305003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000000
010200002406025051270412f0002b0512c0512d0412e0312f0212f0052f00032000030000000037000370002f0002f0002f0002f000000003300004000000000000000000000000000000000000000000000000
01020000346500513000605396500a130006053365004130006053865009130006053265003130006053765008130006053165002130006053365004130006000060000600006000060000600006000060000600
01030000343502d350343502d35028350213501c35015350103500a35004350343502d350343502d35028350213501c35015350103500a35004350343502d350343502d35028350213501c35015350103500a350
01050000183401f340203401934020340213401a34021340223401b3402234023340003000030000300003000030000300003001a30021300223001b300223002330000300003000030000300003000030000000
01040000244401f44024440284402b440304402b4402044024440274402c440274402c440304403344038440334402244026440294402e440294402e44032440354403a440354400040000400004000040000400
01100000373553c35534c703c3553e35537c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104000015320163201732018320193201a3201b3201c3201d3201e3201f320203202132022320233202432025320263202732028320293202a3202c3202d3202f32030320323203332035320363203832039320
010400002f3502f3502f3503435034350343503434034340343403434034340343303433034320343203432034310343103431500300003000030000300003000030000300003000030000300003000030000300
010200001f3601f3602233022330214312133023360233601f450214512130021300233012330023300233001f4001f4001f4001f405214002130523300233051f4002040122401233001f400000000000000000
0103000021360213602135021350213502135022340233302432025320263202732028320293202a3202b3102c3102d3100000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 1c1d1e03
01 04060547
00 04060547
00 080a0947
00 0b0d0c47
00 08090a47
00 0b0c0d47
00 0e100f51
00 13121451
00 04050647
00 04050647
00 1517165b
00 19181a5b
00 1517165b
00 19181a5b
00 0e100f51
00 13121451
00 1516175b
02 191a185b
01 00204302
00 01214302
00 22234344
02 24254342
03 071b6869
00 3e6d6a67
04 2a2b6c67
00 2d316f67
04 2e327067
01 26285167
02 27296c67
00 3c7b7167
04 112c7044
04 33304344

