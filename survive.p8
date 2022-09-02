pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- vampire survivors style game
-- made by hp

function _init()
 p={ x=60, y=60, t=0, anim=6, i=1, state='idle' } -- ship table
 bul={} -- bullet table
 t=0 -- time before shoot (attack speed)
 bt={} -- bullet type table
 anim={
  idle={6,7,8,9},
  fly={7,10,8},
 }
end

-- draw the bullet on screen
function buldraw(o)
 spr(o.spr,o.x,o.y)
end

-- update the bullet location on screen
function bulupdate(b)
 b.x += b.dx
 b.y += b.dy
 b.time -= 1
 return b.time > 0
end

-- add a new bullet object to table
function newbul(spr,x,y,dx,dy)
 local b = {
  x=x, y=y, dx=dx, dy=dy,
  time=120,
  update=bulupdate,
  spr=spr,draw=buldraw
 }
 add(bul,b)
 return b
end

function aspd(i)
 t+=1
 if t==i then
  bool=true
  t=0
 else
  bool=false
 end
 return bool
end

function animate(state)
 p.t+=1
 if p.t==5 then
  p.i+=1
  p.anim=anim[state][p.i]
  p.t=0
  if(p.i==#anim[state]) p.i=0
 end
 -- p.anim=anim.fly[2]
end

function _update()
 -- Set default ship behavior
 p.ax=0
 p.ay=0
 p.spr=2
 p.state='idle'
 -- p.anim=anim.fly[1]

 -- moving the ship
 if(btn(0)) p.ax-=3 p.spr=1 p.state='fly'
 if(btn(1)) p.ax+=3 p.spr=3 p.state='fly'
 if(btn(2)) p.ay=-3 p.state='fly'
 if(btn(3)) p.ay=3 p.state='fly'
 -- update player location
 p.x+=p.ax
 p.y+=p.ay
 animate(p.state)
 -- create a new bullet on button click
 if(btnp(5)) newbul(17,p.x,p.y-3,0,-2) sfx(0)
 -- if(btnp(4)) newbul(16,p.x,p.y-3,0,-2) sfx(0)

 -- Auto shoot every x seconds
 -- t+=1
 -- if(t==60) newbul(17,p.x,p.y-3,0,-2) sfx(0) t=0

 -- shoot bullet type every t seconds
 bt[1] = {}
 bt[1].t=60
 bt[1].sfx=0
 if(aspd(bt[1].t)) newbul(17,p.x,p.y-3,0,-2) sfx(bt[1].sfx)


 -- update bullet table
 local i,j=1,1
 while(bul[i]) do
  if bul[i]:update() then
   if(i!=j) bul[j]=bul[i] bul[i]=nil
   j+=1
  else bul[i]=nil end
  i+=1
 end

 -- limit ship on screen
 if(p.x>120) p.x=120
 if(p.x<0) p.x=0
 if(p.y>120) p.y=120
 if(p.y<0) p.y=0
end

function _draw()
 cls(3)
 spr(p.spr,p.x,p.y)
 spr(p.anim,p.x,p.y+8)
 for o in all(bul) do o:draw() end
end


-- code ends here
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002882000028820000288200000000000000000000077000000770000007700000c77c00000770000000000000000000000000000000000000000000
007007000028820000288200002882000000000000000000007777000007700000c77c000cc77cc0000770000000000000000000000000000000000000000000
0007700000288e2002e88e2002e88200000000000000000000c77c00000cc00000cccc0000cccc00000cc0000000000000000000000000000000000000000000
00077000027c88202e87c8e202887c200000000000000000000cc000000cc000000cc0000000000000cccc000000000000000000000000000000000000000000
00700700021188202881188202881120000000000000000000000000000cc000000000000000000000cccc000000000000000000000000000000000000000000
00000000025582200285582002285520000000000000000000000000000000000000000000000000000cc0000000000000000000000000000000000000000000
00000000002aa200002aa200002aa200000000000000000000000000000000000000000000000000000cc0000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa77aa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000990009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000990009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa77aa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01dccd10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1dc7ecd1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1cc11cc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01c55c10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001aa100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003d050390503605033050300502c050290502705022050200501d0501b0501805015050110500f0500f0500e0500d0500b050080500805006050050500305003050020500205001050000500005023000
000100003a050310502905024050200501c05018050150500c0500505000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
