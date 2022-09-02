pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- high stakes
-- by krystian majewski, lazy devs

-- nice to have
-- - face fading
-- - chip target highlight?
-- - touch / mouse controls
-- - tutorial?

function _init()
 ver="v3"
 --debug={}
 
 wint,fadeperc,shake,frames,bignums,fadetable=240,1,0,0,{},split2d("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0|1,1,129,129,129,129,129,129,129,129,0,0,0,0,0|2,2,2,130,130,130,130,130,128,128,128,128,128,0,0|128,128,128,128,128,128,128,128,0,0,0,0,0,0,0|129,129,129,129,129,129,129,129,129,0,0,0,0,0,0|5,5,133,133,133,133,130,130,128,128,128,128,128,0,0|6,6,134,13,13,13,141,5,5,5,133,130,128,128,0|7,6,6,6,134,134,134,134,5,5,5,133,130,128,0|8,8,136,136,136,136,132,132,132,130,128,128,128,128,0|136,136,136,136,136,132,132,132,132,130,128,128,128,128,0|130,130,130,130,130,130,130,128,128,128,128,128,128,0,0|11,139,139,139,139,3,3,3,3,129,129,129,0,0,0|12,12,12,140,140,140,140,131,131,131,1,129,129,129,0|13,13,141,141,5,5,5,133,133,130,129,129,128,128,0|14,14,14,134,134,141,141,2,2,133,130,130,128,128,0|15,143,143,134,134,134,134,5,5,5,133,133,128,128,0") 
 
 cartdata("highstakes")
 loadgame()
 --chain=2
 --unlocked={true,true,true,true}
 
 local bnumi,bnumx,bnumy,bnumw=split("0,1,2,3,4,5,6,7,8,9,h,i,g,s,t,a,k,e,r,o,u,n,d,w,l,y,p",",",false),split("15,23,29,37,45,53,61,69,77,85,15,23,29,45,53,61,69,77,15,23,31,39,47,55,65,72,80"),split("118,118,118,118,118,118,118,118,118,118,118,118,118,118,118,118,118,118,108,108,108,108,108,108,108,108,108"),split("8,6,8,8,8,8,8,8,8,8,8,4,8,8,8,8,8,6,8,8,8,8,8,10,7,8,8")

 for i=1,#bnumi do
  local bb={}
  bignums[bnumi[i]]={
   x=bnumx[i],
   y=bnumy[i],
   w=bnumw[i],
   alt=i>10,
   kern=bnumi[i]=="t" and -1 or 0
  }
 end

 cardx,cardy,chipx,chipy,circcols1,circcols2,circcols3,drects,chipspr,curpos,clout=split("41,63,85,41,63,85,41,63,85"),split("30,30,30,58,58,58,86,86,86"),split("36,58,80,99,99,99"),split("6,6,6,27,55,83"),split2d("90,9|41,2|26,10|15,3"),split2d("90,10|24,3"),{{90,15}},split("31,18,53,18,53,46,31,46"),{},{},{} 
 
 for ch in all(split("28,21,13,10|41,21,13,10|67,21,13,10|80,21,13,10|93,21,7,10|100,21,7,10|19,15,9,8|19,23,9,8|28,31,13,10|41,31,13,10","|")) do
  ch=split(ch)
  add(chipspr,{x=ch[1],y=ch[2],w=ch[3],h=ch[4]})
 end
 for ch in all(split("39,38,4,16,2,10|61,38,5,1,3,11|83,38,6,2,13,12|39,66,7,16,5,1|61,66,8,4,6,2|83,66,9,5,14,3|39,94,17,16,8,4|61,94,17,7,9,5|83,94,17,8,15,6|39,12,1,10,11,10|61,12,2,10,12,11|83,12,3,11,12,12|102,33,14,3,13,13|102,61,15,6,14,13|102,89,17,9,15,14|15,47,17,16,4,16|15,103,17,17,7,16","|")) do
  ch=split(ch)
  add(curpos,{x=ch[1],y=ch[2],dw=ch[3],lf=ch[4],rt=ch[5],up=ch[6]}) 
 end
 for s in all(split("5,4|5,13#5,2|5,9|5,16#1,3|9,3|1,15|9,15#1,3|9,3|1,15|9,15|5,9#1,3|9,3|1,9|9,9|1,15|9,15#1,3|9,3|1,9|9,9|1,15|9,15|5,6#1,3|9,3|1,9|9,9|1,15|9,15|5,6|5,12#1,1|9,1|1,6|9,6|1,11|9,11|1,16|9,16|5,4","#")) do
  add(clout,split2d(s))
 end
 
 
 --menu / vamp data
 mnutxt1,mnutxt2,vampmults,vampcost,vamptoken,helptxt,helpy,helpdy,talktxt,talktxtd=split("bafur,houkin,zver,orlok"),split("'i don't bite','rent is due','zamorit chervichka','blood is life!'"),split("1,5,10,100"),split("0,50,200,1000"),split("2,1,0,0"),split("place on a face-down card.\ncard value is equal or \nhigher than token number|place on a face-up card.\ncompares the values of\nadjecent face-down cards|stab a card if you think\nit is a vampire. bonus ML\nif you get it right.|flip all cards in this\ncolumn face-up to unlock\nthis hint token.|flip all cards in this line\nface-up to unlock this\nhint token.|highlights a 2x2 area where\nthe vampire card will be.","|"),0,0,"","" 
 
 cur,curx,cury,curshake,circcx,circcy,circcdx,circcdy,mnux,mnuy,mnudx,mnudy,mnucur=1,39,38,0,64.5,49.5,64.5,49.5,0,31,0,31,1

 makecircs() 

 --gen cards
 cls()
 rectfill(0,0,19,25,11)
 rrectfill(0,0,19,25,10)
 for val=2,14 do
	 rectfill(1,1,17,23,0)
	 mypal()
	 local mcl=clout[val-1]
	 for cspr in all(mcl) do
	  sspr(0,8,7,7,cspr[1]+1,cspr[2]+1)
	 end
	 palt()
	 if val>=10 then
	  sspr(28+(val-10)*15,0,15,21,2,2)
	 end
	 if val<10 then
	  rectfill(1,1,5,7,0)
	  print(val,2,2,val==10 and 8 or 6)
	 end 
	 local adr=0x4300+(val-2)*250
	 for i=0,24 do
	  memcpy(adr+i*10,0x6000+i*64,10)
	 end
 end
 
 --menucards
 mcards={}
 for i=1,4 do
  add(mcards,{
   x=64+(i-1)*39,
   y=100,
   z=1,
   zbase=1,
   val=9+i,
   hidden=false,
   rot=0,
   chips={}
  })
 end
 
 _upd,_drw=update_credits,draw_credits
 music(0)
end

function _update60()
 frames+=1
 if frames<0 then frames=0 end
 _upd()
end

function _draw()
 doshake()
 _drw()

 --cursor(1,1)
 --color(12)
 --for d in all(debug) do
 -- print(d)
 --end
 
 fadeperc=max(fadeperc-0.04,0)
 dofade()
end

function genbacks()
 for x=0,6 do
  for y=0,9 do
   local c=rnd(1)<0.4 and 9 or 2
   sset(111+x,28+y,c)
   sset(123-x,28+y,c)
   sset(111+x,46-y,c)
   sset(123-x,46-y,c)
  end
 end
end

function makecircs()
 circs={}
 for i=9,0,-1 do
  add(circs,{x=64,y=49,r=i*9,c=2,t=1,carr=circcols1})
 end
end
-->8
--draw

function draw_credits()
 cls(9)
 for _i,_t in pairs(split("made by,krystian majewski,@lazydevsacademy,,music by,grubermusic,@grubermusic,,based on a design by,tyler anderson,@tandyq")) do
  cprint(_t,63,20+_i*6,10)
 end
end

function draw_start()
 cls()
 drawcircs()
 mypal()
 circcdx,circcdy=64.5+cos(time()/3)*3,49.5+cos(time()/4)*3
 sspr(93,90,35,38,circcdx-14,circcdy-19)
 palt()
 drawstartmnu()
 cprint(chaintxt(),63,93,14)
end

function draw_menu()
 cls()
 drawcircs() 
 mypal()
 if circtme>0 then
  sspr(93,90,35,38,circcdx-14,mnuy-69.5-(100-circtme)/5 )
 end
 palt()
 print("⬅️",circcx-26,mnuy+2,9)
 print("➡️",circcx+21,mnuy+2,9)
 for c in all(mcards) do
  drawcard(c)
 end
 --7579
 local _flashtxt=sin(time()*3)<0 and 15 or 7
 local _mnutxtc,_mnutxty,_mnutxt={8,9,_flashtxt,_flashtxt},{24,32,43,49},{"???","payout "..vampmults[mnucur].."x","buy-in: "..vampcost[mnucur].."ML","❎ unlock"}

 if scoremode then
  _mnutxt,_mnutxtc[3],_mnutxty[3]={mnutxt1[mnucur],"high score:"..high[mnucur],"","❎ deal me in"},9,38 
 elseif unlocked[mnucur] then
		_mnutxt,_mnutxtc[3],_mnutxty[3]={mnutxt1[mnucur],mnutxt2[mnucur],"payout "..vampmults[mnucur].."x","❎ deal me in"},9,38
 end
 for i=1,4 do
  cprint(_mnutxt[i],64,mnuy+_mnutxty[i],_mnutxtc[i])
 end 

 if circtme==0 then
  rectfill(0,89,128,128,8)
  drawblood(89)
  if not scoremode then
	  print(chaintxt(),1,115,9)
	  print("game:"..tries,1,121,9)
  end
 else
  drawstartmnu()
  
  local bldy=circtme/100
  bldy=1-(bldy*bldy)
   
  for i=0,64 do
   local wang=i-(bldy*120-64)
   wang=(cos(mid(0.5,wang/128,0))+1)*19.5
   
   line(63-i,128-wang,63-i,128,8)
   line(64+i,128-wang,64+i,128,8)
  end 
  
  drawblood(128-39*bldy)
 end
end

function draw_score()
 local btxt=result!="pass" and "round "..result or "pass"
 
 draw_game()
 if #linet==0 then
  clip(11,winsashy,106,14)
  local perc=wint/100
  perc=1-perc*perc

  for x=0,105 do
   local wav=sin(time()+x*0.01)+1
   wav=wav*6-12+perc*30
   if wav>-1 then
    line(x+11,winsashy+13-wav,x+11,winsashy+13,8)
   end
  end
  local tperc=mid(0,(wint/50)-0.5,1)
  tperc=tperc*tperc*tperc
  bignumc(btxt,63,winsashy+2+14*tperc,0)
  clip()
 else
  if winsashy<104 then
   clip(11,0,106,104)
   rectfill(11,winsashy,116,winsashy>=90 and 103 or winsashy+13,8)
   bignumc(btxt,63,winsashy+2,0)
   clip()
  end
 end
 if winsashy<90 then
  rectfill(11,winsashy+14,116,103,9)
  clip(11,winsashy,105,105-winsashy)
  if #linet>0 then
   local nxty=winsashy+11
   for i=1,#linet do
    local nxtc,nxtx=2,21
    nxty+=6
    if linev[i]=="❎" then
     nxty+=3
     nxtx,nxtc=43,sin(time())<0.5 and 10 or 2
    else
     rprint(linev[i],109,nxty,nxtc)
    end
    print(linet[i],nxtx,nxty,nxtc)    
   end
  end
  clip()
 end
end

function draw_game()
 cls()
 
 if dangrect then
  drectsani-=drectsani/60
  if drectsani<1 then
   drectsani=0
  end
  fillp(0b1010010110100101.1)
  local dr=flr(dangrect+drectsani)%4
  dr=dr*2+1
  if ldrect!=dr then
   ldrect=dr
   sfx(57)
  end
  rect(drects[dr],drects[dr+1],drects[dr]+44,drects[dr+1]+56,9)
  fillp()
 end
 for c=1,6 do
  sspr(54,21,13,10,chipx[c],chipy[c])
 end
 
 --gchips
 for i=1,6 do
  drawchip(gchips[i])
 end
 
 for c in all(cards) do
  drawcardshadow(c)
 end
 
 --shadows
 for c in all(cards) do
  drawcardshadow(c)
 end
 
 --cards
 for c in all(cards) do
  drawcard(c)
 end
 
 --chips
 for c in all(chips) do
  drawchip(c)
 end
 
 stabx+=(stabdx-stabx)/10
 staby+=(stabdy-staby)/4
 if not curstab then
  if cur==16 then
   pal(split("14,14,14,14,14,14,14,14,14,14,14,14,14,14,14"))
   for offs in all({{-1,0},{1,0},{0,-1},{0,1}}) do
    spr(32,14+stabx+offs[1],30+staby+offs[2],1,7)
   end
   pal()
  end
  spr(32,14+stabx,30+staby,1,7)
 end
 local bontxt=tostr(calcstabonus())
 local bonw=#bontxt*4+12
 local bonx,bonc=17-bonw/2+stabx,2
 if cur==16 or curstab then
  bonc=14
 end
 rrectfill(bonx,18,bonw+1,9,10)
 rectfill(bonx+1,19,bonx+bonw-1,25,0)
 
 cprint(bontxt.."ML",18+stabx,20,bonc)
 
 sepline(105)
 
 if not bonusmode and _upd==update_game then
  clip(8,98,21,8)
  rrectfill(8,98,21,10,2)
  rectfill(9,99,27,105,0)
  print("pass",11,100,cur==17 and 14 or 2)
	 clip()
  if cur==17 then
   cprint(passcost().."ML",19,92,8)
  end
 end
 
 bignumc(stakes_txt,64,108,8,true)
 
 rprint(plusminus(wining_txt)..abs(wining_txt).."ML",121,114,9)
 
 print("stakes",52,120,10)
 rprint(wining_desc,121,120,10)
 print(bonusmode and "bonus" or "round "..round,9,120,10)
 for i=1,5 do
  print(wins[i],9+(i-1)*4,114,i==round and 8 or 9)
 end
 
 mypal() 
 
 if pflockdest>0 then
  local pfspd=4
  if pflockdest!=pflocky and abs(staby-stabdy)<1 then
	  if abs(pflockdest-pflocky)<=pfspd then
	   pflockdest,shake=pflocky,10
	   sfx(56)
    for ch in all(chips) do
     ch.zd=1.5
     ch.dx+=rnd(20)-10
     ch.dy+=rnd(20)-10
    end
	  else
	   pflocky+=pfspd
	  end
  end
  clip(pflockx,0,8,pflockdest+20)
  sspr(8,25,8,28,pflockx,pflocky)
  clip()
 end

 if showcur then
	 local _curx,_cury=curx+0.5,cury+0.5
	 if curshake>0 then
	  curshake-=1
	  _curx+=sin(time()*10)
	 end
	 if curchip then
	  local cspr=chipspr[curchip.s]
		 sspr(cspr.x,cspr.y,cspr.w,cspr.h,_curx-3,_cury-6)
		 if curchip.s==1 then
		  cprint(curchip.cap,_curx+4,_cury-4,8)
		 end  
	 end
	 if curstab then
	  local stabplus=cur<=9 and 7 or 0
 	 sspr(16,31,12,13,_curx+3,_cury-stabplus)
 	else
 	 sspr(10,15,9,10,_curx,_cury)
 	end
 end
 pal()
 helpdy=talktxtd!="" and 104 or 130
 drawtxt(helpy)
end

function draw_wining() 
 cls()
 drawcircs()
 
 clip(0,52,128,40)
 for i=1,2 do
  if drplned[i]>0 then
   if dropup then
    line(62+i,89-max(drplnet[i],0),62+i,89-max(drplned[i],0),8)
   else
    line(62+i,51+max(drplnet[i],0),62+i,51+max(drplned[i],0),8)
   end
  end
 end
 if drph>0 then
  local mydrph=sin(time())+1
  mydrph=(mydrph/2+1)*drph
  if dropup then
   sspr(9,109,6,7,61,90-7*mydrph,6,7*mydrph,false,true)
  else
   sspr(9,109,6,7,61,52,6,7*mydrph)
  end
 end
 clip()
 
 sepline(51)
 clip(0,32,128,18)
 if wintxth>0.5 then
  cprint(wining_desc,64,50-wintxth,9)
  bignumc(wining_txt,64,57-wintxth,8,true)
 end
 if govertxth>0.5 then
  cprint(goverprint2,64,50-govertxth,9)
  bignumc(goverprint1,64,57-govertxth,8)
 end
 clip()
 if dropup or drpwh==0 then
  rectfill(0,89,128,128,8)
 else
	 for x=0,63 do  
	  local _myh=sin(-time()*2.5+x/10)
	  _myh=_myh*(1-min(x,1+40*drpwh)/(1+40*drpwh))
	  _myh=_myh*1.5*drpwh
	  line(63-x,89+_myh,63-x,128,8)
	  line(64+x,89+_myh,64+x,128,8)
	 end
	end
 drawblood()
end

function draw_intro()
 cls()
 
 --drawtxt(41) 
 drawtxt(helpy) 
 bignumc(blood_txt,64,113,8,true)
 
 if #talkqueue<=1 then
  if txtpicperc>0 then
   fadepal(txtpicperc,0)
  end
  sspr(100,50,28,40,50,55)
  pal()
 end
end

function draw_ask()
 cls()
 cprint("winnings",64,16,9)
 bignumc(wining_txt,64,23,8,true)
 
 drawtxt(helpy)
 
 drawbutt("yes",43,76,cur==1 and 9 or 2)
 drawbutt("no",72,76,cur==2 and 9 or 2)
 mypal()
 sspr(10,15,9,10,curx+0.5,cury+0.5)
 pal()
end

function drawtxt(y)
 local x,w=6,116
 rectfill(5,y-1,122,y+25,0)
 if txtcard then
  drawcard(txtcard)
  txtcard.y,x,w=y+12.5,26,96
 end
 
 rrectfill(x,y,w,25,10)
 rectfill(x+1,y+1,x+w-2,y+23,0)
 print(talktxt,x+4,y+4,2)
 if txtbuttx then
  rectfill(109,y+22,117,y+28,0)
  print("❎",110,flr(y)+22.5+abs(sin(time()/2)),10)
 end
end

function circt(x,y,r,c,t)
 if t==1 then
  circ(x,y,r,c)
 else
  circfill(x,y,r,c)
  circfill(x,y,r-t,0)
 end
end

function drawchip(c)
 if not c then return end
 local cspr=chipspr[c.s]
 mypal()
 sspr(cspr.x,cspr.y,cspr.w,cspr.h,c.x,c.y-c.z)
 if c.s==1 then
  cprint(c.cap,c.x+7,c.y-c.z+2,8)
 end
 palt()
end

function drawcard(c)
 local cx,cy=c.x,c.y
 if not c.hidden then
  loadcard(c.val==10 and vampval or c.val)
 end
 mypal()
 if c.rot<-0.3 and c.rot>-0.5 then
  pal(0,1)
  pal(2,9)
  pal(6,7)
 end
 local sy=c.hidden and 25 or 0
 if c.rot==0 then
  sspr(108,sy,19,25,cx-9+0.5,cy-12+0.5-c.z)
 else
	 local ang=0.25+c.rot/4
	 local angx,angy=-sin(ang),cos(ang)
	 local wid=19*angx
	 
	 for x=0,18 do
	  local row,rx,ry=flr((x-9)/angx+9),cx-8+x,cy-11
	  if angx==0 then
	   row=-100
	  end
	  if row>=0 and row<=18 then
	   local h=(x-9)/-9
    h=10*h*angy
    local top=ry+h/2-c.z

	   sspr(108+row,sy,1,25,rx,top,1,25)
	  end
	 end
 end
 pal()
end

function drawcardshadow(c)
 local w=19*cos(abs(c.rot)*0.25)
 rrectfill(c.x-(w/2)+1.5,c.y-12+1.5,w,25,4)
end

function rrectfill(x,y,w,h,c)
 w=flr(w)
 if w==2 then
  rectfill(x,y,x+1,y+h-1,c)
 elseif w<=1 then
  line(x,y,x,y+h-1,c)
 else
  rectfill(x+1,y,x+w-2,y+h-1,c)
  rectfill(x,y+1,x+w-1,y+h-2,c)
 end
end

function loadcard(val)
 for i=0,24 do
  memcpy(54+i*64,0x4300+i*10+(val-2)*250,10)
 end
end

function drawblood(bldy)
 if scoremode then return end
 local bldy=bldy or 89
 palt(0,false)
 palt(8,true) 
 pal(2,0) 

 sspr(0,109,9,19,55,bldy+3)
 sspr(0,109,9,19,64,bldy+3,9,19,true)
 
 --local perc=(sin(time()/10)+1)/2
 local pxperc=1652*(blood_txt/5000)
 if pxperc>=212 then
  pxperc-=212
  pxperc=10-flr(pxperc/144)
 else
  --local lookup={4,12,48,112,212}
  local lookup,i=split("0,8,30,80,162,212"),0
  repeat
   i+=1
  until pxperc<=lookup[i]
  pxperc=i-1
  pxperc=15-pxperc
 end

 rectfill(55,bldy+2,72,bldy+2+pxperc,8)

 palt(2,true)
 pal(2,8)

 sspr(0,109,9,19,55,bldy+3)
 sspr(0,109,9,19,64,bldy+3,9,19,true)
 
 pal()
 bignumc(blood_txt,64,bldy+24,0,true)

end 

function drawcircs()
 for c in all(circs) do
  circt(c.x,c.y,c.r,c.c,c.t)
 end
end

function doshake()
	local xview,yview=rnd(shake)-shake/2,rnd(shake)-shake/2
 
 shake=max(shake-1,0)	
	if shake > 10 then
 	shake*=0.9
 end
 camera(xview,yview)
end

function drawbutt(txt,x,y,c)
 rrectfill(x,y,17,9,c)
 rectfill(x+1,y+1,x+15,y+7,0)
 cprint(txt,x+9,y+2,c)
end

function mypal()
 palt(11,true)
 palt(0,false)
end

function drawstartmnu()
 rectfill(0,99,128,128,8)
 bignum(15,103,"high stakes",0)
 
 clip(40,117,47,10)
 local fcol=sin(time()*3)<0 and 15 or 7
 for x=1,#stmnu do
  print(stmnu[x],44+(x-1)*50-stmnux,118,fcol) 
 end
 clip()
 if stcur>1 then
  print("⬅️",30.5-sin(time()*2),118,fcol)
 end
 if stcur<#stmnu then
  print("➡️",90.5+sin(time()*2),118,fcol)
 end
 
 print(ver,2,122,9)
end

function draw_end()
 cls(0)

 clip(0,32,128,18)
 cprint(goverprint2,64,50-govertxth,9)
 bignumc(goverprint1,64,57-govertxth,8)
 clip()
 if goverprint2=="exsanguination" then
  sspr(7,69,86,39,20,58)
 else
  sspr(16,44,84,25,22,58)
 end
end

function chaintxt()
 if chain==nil or chain==0 then return "" end

 local chn="streak:"..chain
 if chain==bchain then
  chn=chn.."!"
 end
 return chn
end
-->8
--update

function update_credits()
 wint-=1
 if wint<=0 or btnp(5) or btnp(4) then 
  fadeout()
  gotostart()
 end
end

function update_start()
 mnuy,nmudy=100,31
 docircs(circcols1)
 if btnp(0) and stcur>1 then
  stcur-=1
  sfx(63)
 elseif btnp(1) and stcur<#stmnu then
  stcur+=1
  sfx(63)
 end
 stmnux+=(((stcur-1)*50)-stmnux)/5
 
 if btnp(5) then
  sfx(53)
  blood_txt=blood
  if stmnu[stcur]==" new game" then
   if blood<5000 then
    chain=0
   end
   newgame()
   setuptxtcard(10)
   blood_txt,blood,helpy,helpdy,_upd,_drw,talkqueue,txtpicperc,txtbuttx=5000,5000,-30,15.5,update_intro,draw_intro,split("an average human body\ncontains about 5000ML\nof blood|heheheh...|oh no! where did all\nthe blood go?!\nheheheh...|don't take it too hard\nyou were living on\nborrowed time anyway|here, the last shot is\non me. it will take\nthe edge off|or maybe you can win\nit all back? how about\nit? one last game...","|"),1,true   nexttalk()
   fadeout()
  else
   scoremode=stmnu[stcur]=="score mode"
   _upd,_drw,circtme=update_menu,draw_menu,100
   
  end
  
 end
end

function update_menu()
 update_gtxt()
 circtme,vampval=max(circtme-2.5,0),10
 local circfirst=true
 for i=1,#circs do
  if i/#circs>(circtme)/100 then 
   if circfirst and circtme>0 then
    circfirst,circs[i].carr=false,circcols3
   else
    circs[i].carr=circcols2
   end
  end
 end

 docircs(circcols2)
 
 if btnp(0) then
  mnucur-=1
  sfx(63)
 elseif btnp(1) then
  mnucur+=1
  sfx(63)
 end
 mnucur=mid(mnucur,1,4)
 mnudx=50*(mnucur-1)
 mnux+=(mnudx-mnux)/10
 mnuy+=(mnudy-mnuy)/20

 for i=1,4 do
  local randx,randy=cos((time()+i*0.79)/2)*1.7,cos((time()+i*0.79)/3)*1.7
  mcards[i].x=64-mnux+(i-1)*50+randx
  mcards[i].y=mnuy+cos((mcards[i].x-64)/160)*5+randy
 end
 circcdx,circcdy=mcards[mnucur].x,mnuy+2
 
 if btnp(5) then
  if unlocked[mnucur] or scoremode then
	  sfx(53)
	  fadeout()
   vampval,mult,dropboxes,droptoken,blood_txt,_upd,_drw=9+mnucur,vampmults[mnucur],mnucur>1,vamptoken[mnucur],blood,update_game,draw_game
   startmatch()
	 else
	  if blood>vampcost[mnucur] then
	   sfx(53)
    mult,ticksfx,blood,unlocked[mnucur]=vampmults[mnucur],54,blood-vampcost[mnucur],true
	   savegame()
	  else
	   sfx(61)
	  end
	 end
 end
end

function update_game()
 update_gtxt()
 dotxt()
 if wining_txt==wining and ticksfx and not bonusmode then
  ticksfx=nil
 end
 local noani,canact=true,true
 for c in all(cards) do
  if c.delay>0 then
   c.delay-=1
  else
   c.x+=(c.dx-c.x)/5
   c.y+=(c.dy-c.y)/5
   c.z+=c.zd
   c.zd-=0.15
   if c.z<=c.zbase then
    c.z,c.zd=c.zbase,0
   end
   if abs(c.x-c.dx)<0.3 then
    c.x=c.dx
   end
   if abs(c.y-c.dy)<0.3 then
    c.y=c.dy   
   end
   
  end
  if c.ani then
   canact,noani=canact and c.ani(c),false
  end
  if c.x!=c.dx or c.y!=c.dy then
   canact=false
  end
 end
 if canact and autoflip then
  autoflip.hidden,canact=false,false
  dodroptoken()
  autoflip.hidden=true
  flipbegin(autoflip)
  autoflip=nil
 end
 
 dochips()
 
 if pflockdest>0 then
  canact,showcur=false,false
  if pflockdest==pflocky and pflockard then
   if pflockard==vcard then
    pflockard=nil
    endgame("stab")
   else
    flipbegin(vcard)
    vcard.badstab,pflockard=true,nil
   end
  end
 end
 
 if result!="" then
  if noani and pflockdest==pflocky then
   --∧
   wait(20,false,true)
   if result=="won" then
    sfx(41,3)
   end
   wait(50,false,true)
		 winsashy,winsashdy,wint,wintstep,_upd,_drw=90,90,100,60,update_score,draw_score
  end
  return 
 end

 local oldcur=cur
 if showcur then
	 if btnp(0) then
	  cur=curpos[cur].lf
	 elseif btnp(1) then
	  cur=curpos[cur].rt
	 elseif btnp(2) then
	  cur=curpos[cur].up 
	 elseif btnp(3) then
	  cur=curpos[cur].dw
	 end
 end
 if stabonus<=0 and cur==16 then
  cur=oldcur
 end
 if curchip and cur>=16 then
  cur=oldcur
 end
 if bonusmode and cur>=16 then
  cur=oldcur
 end
 if curstab and (cur>16 or (cur>9 and cur<16)) then
  cur=oldcur
 end
 if oldcur!=cur then
  sfx(63)
  for c in all(cards) do
   c.zbase=0
   for c2 in all(c.chips) do
    c2.zbase=0
   end
  end
  for c in all(gchips) do
   c.zbase=0
  end
  if curchip==nil then
	  if cur<=9 and cards[cur].hidden then
	   cards[cur].zbase=1
	   for c2 in all(cards[cur].chips) do
	    c2.zbase=1
	   end
	  elseif cur<=16 then   
	   local c=gchips[cur-9]
	   if c and (c.s==1 or c.s==3 or c.s==10) then
	    c.zbase=1
	   end
	  end
  end
 end
 if canact and result=="" then
  showcur=showcur or canact
  dobutts()
 end
 
 local chipbst=0
 if cur<=9 and curchip then
  chipbst=7
 end
 curx+=(curpos[cur].x-curx)/1.5
 cury+=(curpos[cur].y-chipbst-cury)/1.5
 
 --♥
 local helpi=0
 if canact and showcur then
		if curchip or (cur>=10 and cur<=15) then
		 gch=curchip
		 if gch==nil then 
		  gch=gchips[cur-9]
		 end
		 if gch then
		  chs=gch.s
		  if chs==1 then
		   helpi=1
		  elseif chs==3 then
		   helpi=2
		  elseif chs==9 then
		   helpi=6
		  elseif chs!=9 then
		   if cur<=12 then
		    helpi=4
		   else
		    helpi=5
		   end
		  end
		 end
		elseif cur==16 or curstab then
		 helpi=3
		end
 end
 talktxt=helpi==0 and "" or helptxt[helpi]
 talktxtd=talktxt
end

function dobutts()
 if btnp(5) then
  if cur<=9 then
   local c=cards[cur]
   if curchip then
    if curchip.s==1 then
     if c.hidden and not c.had1 then
      dropchip1(curchip,c)
      del(gchips,curchip)
      curchip=nil
      sfx(60)
     else
      sfx(61)
      curshake=10
     end
    elseif curchip.s==3 then
     if not c.hidden and not c.had3 and hasouts(cur) then
      dropchip3(curchip,c)     
      del(gchips,curchip)
      curchip=nil
      sfx(60)
     else
      sfx(61)
      curshake=10
     end
    end
   elseif curstab then
    if c.hidden then
     --stab
     stabcard(c)
     pflockard=c
    else
     sfx(61)
     curshake=10    
    end
   else
    --normal flip
	   if c.hidden then
	    flipbegin(c)
	   else
	    if c.ani==nil then
	     if c.zd==0 then
	      c.zd=0.8
	     else
	      c.zd=-c.zd/2
	     end
	    end
	   end
	  end
  elseif cur<16 then
   if curchip then
    returnchip()
   elseif curstab then
    curstab=false
    sfx(59)  
   else
	   local c=gchips[cur-9]
	   if c then
	    if c.s==1 or c.s==3 then
		    --trigger
      curchip,curchipi,gchips[cur-9]=c,cur-9,nil
		    sfx(60)
	    elseif c.s==9 then
	     dropchip9()
	     gchips[cur-9]=nil
	     sfx(60)
	    end
	   end
	  end
  elseif cur==16 then
   if curchip then
    returnchip()
   elseif curstab then
    curstab=false
    sfx(59)   
   else
    curstab=true
    sfx(60)
   end
  elseif cur==17 then  
   if curchip then
    returnchip()
   elseif curstab then
    curstab=false
    sfx(59)    
   else
    -- stake
    endgame("pass")
    sfx(51)
   end  
  end
 elseif btnp(4) then
  if curchip then
   returnchip()
  elseif curstab then
   curstab=false
   sfx(59)
  end
 end
end

function update_score()
 ticksfx=55
 update_gtxt()
 wint-=1
 winsashy+=(winsashdy-winsashy)/10
 dochips()
 if wint<=0 then
  if #linet_next>0 then
   local nt,nv=linet_next[1],linev_next[1]
   add(linet,nt)
   add(linev,nv)
   del(linet_next,nt)
   del(linev_next,nv)
   winsashdy-=6
   if nv=="❎" then
    winsashdy-=2
    tempsave()
   end
   if #linet==1 then
    winsashdy-=5
   end
   if #linet>1 and nv!="❎" then
    stakes+=tonum(sub(nv,1,-3))
   end
   wint=wintstep
  end
 end
 
 if btnp(5) or btnp(4) then
  wintstep,wint=5,0
  if #linet_next==0 then
   winstakes()
   --★
   if round>=5 then
    if bonusmode and result=="won" then wbin=1 end
    repeat
     flip()
     frames+=1
     update_gtxt()
     winsashdy=105
     winsashy+=(winsashdy-winsashy)/5
     _draw()
    until stakes_txt==stakes
    local _mywins=0
    for w in all(wins) do
     if w=="w" then _mywins+=1 end
    end
    if _mywins>=3 and not bonusmode then
     gotoask()
    else
     gotowin()
    end
   else
    dealround()
    _upd,_drw=update_game,draw_game
   end
  end
 end
end

function update_wining()
 ticksfx,showcur,circcdy,circcdx=54,false,40,64
 update_gtxt()
 docircs(circcols2)
 wint-=1
 wintxth+=(wintxtdh-wintxth)/10
 if winphase==0 then
  wintxtdh=18
	 if wint<=0 then
	  if not scoremode then
 	  blood=mid(blood+wining,0,5000)
 	 end
   savegame()
   if scoremode then
    winphase=4
	  elseif wining==0 then
	   winphase=3
	  else
 	  wining,winphase=0,1
	   drplned[1]=-rnd(90)
	  end
	 end 
 elseif winphase==1 then
  for i=1,2 do
   drplnedd[i]+=0.05
  end
  drph+=(1-drph)/50
  if wining_txt==0 then
   winphase,drplnet[2]=2,-rnd(90)
  end
 elseif winphase==2 then
  for i=1,2 do
   drplnedd[i]+=0.05
   drplnetd[i]+=0.05
  end
  drph+=-drph/10
  if drplnet[1]>90 and drplnet[2]>90 then
   winphase=3
  end
 elseif winphase==3 then
  if blood<=0 then
   winphase,wint,goverprint2,goverprint1,chain=5,1000,"exsanguination","you died",0
   music(9)
  elseif blood>=5000 then
   winphase,wint,goverprint2,goverprint1=5,1000,"congratulations","you won"
   chain+=1
   bchain=max(chain,bchain)
   music(10)
  else
   winphase,wint=4,200
  end
 elseif winphase==4 then
  if wint<=0 then
   wintxtdh=0
  end
  if wintxth<0.5 then
   wintxth,mnuy,mnudy,_upd,_drw=0,-60,31,update_menu,draw_menu
   music(0)
   _upd()  
  end
 elseif winphase==5 then
  wintxtdh,govertxtdh=0,18
  if wintxth<0.9 then
   wintxth=0
   _draw()
   fadeout()
   _upd,_drw=update_end,draw_end
  end
 end
 
 if winphase>=1 then
  local raisewav,lowerwav=false,false
  for i=1,2 do
   drplned[i]+=drplnedd[i]
   drplnet[i]+=drplnetd[i]
   if drplned[i]>=89 then
    raisewav=true
   end
   if drplnet[i]>0 then
    lowerwav=true
   end
  end 
  if lowerwav then
   drpwh=max(0,drpwh-0.02)
  elseif raisewav then
   drpwh=min(1,drpwh+0.01)
  end
 end
 if btnp(5) or btnp(4) then
  wint,wintxth,govertxth,blood_txt,wining_txt=0,wintxtdh,govertxtdh,blood,wining  
 end
end

function update_intro()
 txtpicperc=max(0,txtpicperc-0.03)
 update_gtxt()
 dotxt()
 if btnp(5) then
  if #talkqueue>0 then
   nexttalk()
   if #talkqueue==4 then
    blood,mult,ticksfx=0,187,54
   elseif #talkqueue==1 then
    txtpicperc,blood,blood_txt,mult=1,20,0,1
   end
  else
   sfx(51)
   fadeout()
   _upd,_drw,circtme=update_menu,draw_menu,0
  end
 end
end

function update_ask()
 helpdy=41
 dotxt()
  
 if btnp(0) then
  cur=1
  sfx(63)
 elseif btnp(1) then
  cur=2
  sfx(63)
 end
 local curdx=cur==1 and 48 or 77

 curx+=(curdx-curx)/1.5
 cury=83
 
 if btnp(5) then
  --sfx
  sfx(51)
  if cur==2 then
   gotowin()
  else
   fadeout()
   dealround()
   _upd,_drw,bonusmode,stakes,stabdx=update_game,draw_game,true,wining,-30
   musiclvl(3)
  end
 end
end

function dotxt()
 helpy+=(helpdy-helpy)/4
 if frames%2==0 then
	 if #talktxt!=#talktxtd then
	  talktxt=sub(talktxtd,1,#talktxt+1)
	  sfx(52)
	 end
 end
end

function nexttalk()
 local t=talkqueue[1]
 talktxtd,talktxt=t,""
 del(talkqueue,t)
end

function docircs(colarr)
 circcx+=msgn(circcdx-circcx)*0.5
 circcy+=msgn(circcdy-circcy)*0.5
 if abs(circcdy-circcy)<0.5 then
  circcy=circcdy
 end
 if abs(circcdx-circcx)<0.5 then
  circcx=circcdx
 end
 
 for c in all(circs) do
  c.r+=0.26
  if c.r>=90 then 
   c.r,c.t,c.carr=0,1,colarr
   del(circs,c)
   add(circs,c)
  end
  local myage=c.r/90
  c.x,c.y=64.5*myage+circcx*(1-myage),49.5*myage+circcy*(1-myage)

  for cc in all(c.carr) do
   if c.r<cc[1] then
    c.c=cc[2]
   end
  end
  
  if c.r>71 then
   c.t=4
  elseif c.r>55 then
   c.t=3
  elseif c.r>40 then
   c.t=2
  end
 end
end

function update_gtxt()
 if frames%5==0 then
		if stakes_txt!=stakes then
		 if abs(stakes-stakes_txt)<mult then
		  stakes_txt=stakes
		 else
 		 stakes_txt+=sgn(stakes-stakes_txt)*mult
 		end
 	 if ticksfx then
	 	 sfx(ticksfx)
		 end
		end
		if wining_txt!=wining then
		 if abs(wining-wining_txt)<mult then
		  wining_txt=wining
		 else
 		 wining_txt+=sgn(wining-wining_txt)*mult
		 end
 	 if wining_desc=="winnings" and wining_txt<0 then
	   wining_desc="losses"
	  end
		 if wining_desc=="losses" and wining_txt>0 then
 	  wining_desc="winnings"
	  end
		end
		if blood_txt!=blood then
		 if abs(blood-blood_txt)<mult then
		  blood_txt=blood
		 else
 		 blood_txt+=sgn(blood-blood_txt)*mult
 		end
		 if ticksfx then
 		 sfx(ticksfx)
 		end
		end

	end
end

function ani_flip(crd)
 crd.rot+=0.1
 if crd.rot>=1 then
  crd.hidden,crd.rot=false,-1
  cardflip(crd)
 elseif crd.rot>=0 and not crd.hidden then
  crd.rot,crd.ani=0,nil
 end
 return crd.rot<=0
end

function dochips()
 for c in all(gchips) do
  dochip(c)
 end
 for c in all(chips) do
  dochip(c)
 end
end

function dochip(c)
 if c.delay>0 then
  c.delay-=1
 else
  if c.dx and abs(c.dx-c.x)>=1 then
   c.x+=sgn(c.dx-c.x)*1
  end
  if c.dy and abs(c.dy-c.y)>=1 then
   c.y+=sgn(c.dy-c.y)*1
  end

  c.z+=c.zd
  c.zd-=0.25
  if c.z<=c.zbase then
   c.z=c.zbase
   if abs(c.zd)>1.5 then
    c.zd=-c.zd*0.3
    sfx(58)
   else
    c.zd=0
   end
  end
  if c.delme and c.y-c.z<=-10 or c.x<=-14 then
   del(chips,c)
   del(gchips,c)
  end
 end
end

function update_end()
 govertxth+=(govertxtdh-govertxth)/10
 wint-=1
 if wint<=0 or btnp(5) then
  fadeout(0.01)
  savegame() 
  gotostart()
  makecircs()
  wait(120,true)
  music(0,2000) 
 end
end
-->8
--gameplay
function gotostart()
 _upd,_drw=update_start,draw_start
 stmnu,stmnux,stcur=split(" continue, new game,score mode"),0,1
 if blood<=0 or blood>=5000 then
  del(stmnu," continue")
 end
 --bchain=1
 if bchain==0 then
  del(stmnu,"score mode")
 end

end

function gotowin()
 fadeout()
 music(-1,4000)
 high[mnucur]=max(high[mnucur],wining)
 wint,winphase,drplnet,drplned,drplnetd,drplnedd,drph,drpwh,wintxth,wintxtdh,govertxth,govertxtdh,dropup,_upd,_drw=200,0,{0,0},{0,0},{0,0},{0,0},0,0,0,0,0,0,wining<0,update_wining,draw_wining
end

function gotoask()
 setuptxtcard(10)
 fadeout()
 talktxt,talktxtd,cur,txtbuttx,helpy,helpdy,_upd,_drw="","how about a final\nbonus round? double\nwinnings or nothing?",1,false,-30,41,update_ask,draw_ask
end

function setuptxtcard(val)
 txtcard={
  x=15,
  y=54,
  z=1,
  zbase=1,
  val=val,
  hidden=false,
  rot=0,
  chips={}
 }
end

function startmatch()
 genbacks()
 musiclvl(0)
 music(1) 
 round,wining,wining_txt,wining_desc,wins,stakes_txt,stabx,staby=0,0,0,"winnings",split(".,.,.,.,."),0,-20,0
 dealround()
end

function dealround()
 talktxtd,txtcard,helpy,txtbuttx,bonusmode,stabdx,stabdy,stabonus,pflockx,pflocky,pflockdest,pflockard,curchip,curstab,showcur,cards,dangrect="",nil,130,false,false,0,0,7,0,-28,-28,nil,nil,false,false,{},nil
 if staby!=0 then
  stabx,staby=-20,0
 end
 musiclvl(0)
 
 local cardvals={2,3,4,5,6,7,8,9,10}
 for i=1,9 do
  local thisval=rnd(cardvals)
  del(cardvals,thisval)
  add(cards,{
   pos=i,
   dx=cardx[i]+0.5,
   dy=cardy[i]+0.5,
   x=54,
   y=-70,
   z=10,
   zd=0,
   zbase=0,
   val=thisval,
   delay=10*i,
   hidden=true,
   rot=0,
   chips={},
   hint=0,
   row=flr((i-1)/3)
  })
  if thisval==10 then
   vcard=cards[#cards]
  end
 end
  
 repeat
  autoflip=rnd(cards)
 until autoflip.val!=10
 autoflip.hidden,cur=false,autoflip.pos
 
 local cps={9,8,7,6,5,4,3,2}
 if vampval==13 then
  --asshole mode
  vcard.hint=autoflip.val
  del(cps,autoflip.val) 
 end
 
 for h in all(cps) do
  local targs={}
  for i=1,#cards do
   local crd=cards[i]
   if crd.hidden and crd.val>=h and crd.hint==0 then
    add(targs,crd)
   end
  end
  
  if #targs>0 then
   rnd(targs).hint=h
  end  
 end 

 autoflip.hidden,gchips,chips=true,{},{}

 for i=1,6 do
  add(gchips,{
   x=chipx[i],
   y=chipy[i],
   z=0,
   zd=0,
   zbase=0,
   s=rnd({2,4}),
   delay=0,
   cap="+"
  })
 end
 if dropboxes then
  if vampval==13 then
   --asshole mode
   local cands,vcands={},{}
   for c in all(gchips) do
    add(cands,c)
   end
   add(vcands,gchips[(vcard.pos-1)%3+1])
   add(vcands,gchips[vcard.row+4])
   for c in all(vcands) do
    del(cands,c)
   end
   rnd(rnd(5)<3 and vcands or cands).s=10
  else
   rnd(gchips).s=10
  end
 end
  
 result,stakes="",0
 round+=1
end

function flipbegin(crd)
 swipechips(crd)
 crd.ani,crd.zd=ani_flip,1.4
 sfx(62)
end

function cardflip(crd)
 if crd.badstab then
  endgame("badstab")
  return
 elseif not bonusmode then
	 st_raise(1)
	 stabonus-=1
	 if stabonus<=0 then
	  stabdx=-30
	 end
 end
 local hcount=hidcount()
 for chii,chi in pairs(split2d("1,4,7|2,5,8|3,6,9|1,2,3|4,5,6|7,8,9")) do
  local chic=0
  for chj in all(chi) do
   if cards[chj].hidden==false then
    chic+=1
   end
  end
  if chic==3 then
   local mychip=gchips[chii]
   if mychip and (mychip.s==2 or mychip.s==2 or mychip.s==4 or gchips[chii].s==10) then
    mychip.zd=1.5
    mychip.s-=1
   end
  end
 end 
 if crd.val==10 then
  endgame("lose")
 elseif hcount==1 then
  endgame("win")
 else
  --0x3100
  if not bonusmode then
	  if hcount<=3 then
	   musiclvl(3)
	  elseif hcount<=5 then
	   musiclvl(2)
	  elseif hcount<=7 then
	   musiclvl(1)
	  end
  end
 end
end

function stabcard(c)
 swipechips(c)
 stabdy,pflockdest,pflockx=-128,c.y-17,c.x-2
end

function st_raise(v)
 stakes+=mult*v
end

function hidcount()
 local ret=0
 for c in all(cards) do
  if c.hidden or c.badstab then
   ret+=1
  end
 end
 return ret
end

function winstakes()
 if result=="lost" then
  stakes=-stakes
 end
 wining+=stakes
 stakes=0
end

function hasouts(ci)
 local dsts={cards[ci-1],cards[ci+1],cards[ci-3],cards[ci+3]}
 for i=1,4 do
  if dsts[i] and dsts[i].hidden and(i>2 or dsts[i].row==cards[ci].row) then
   return true
  end
 end
 return false
end

function dodroptoken()
 local cand={}
 for i=1,9 do
  if cards[i].hidden then
   add(cand,i)
  end
 end
 
 for i=1,droptoken do
  local drp=rnd(cand)
  local chp={
   x=0,
   y=0,
   zbase=0,
   s=1,
   delay=(i-1)*10
  }
  dropchip1(chp,cards[drp])
  chp.z=chp.y+12
  chp.zd=0
  del(cand,drp)
 end
end


function dropchip1(chip,card)
 add(chips,chip)
 chip.x,chip.y,chip.zd,chip.cap,card.had1=card.x-5,card.y-3,2,card.hint.."+",true
 chip.dx,chip.dy=chip.x,chip.y

 add(card.chips,chip)
end

function dropchip3(chip,card)
 card.had3=true
 local pos=card.pos
 local _newx,_newy,_news,_newb,_newdst=split("-8,14,2,2"),split("0,0,-14,14"),split("5,6,7,8"),split("6,5,8,7"),{cards[pos-1],cards[pos+1],cards[pos-3],cards[pos+3]}
 for i=1,4 do
  if _newdst[i] and _newdst[i].hidden and (i>2 or _newdst[i].row==card.row) then
   local _newc={
    x=card.x-5,
    y=card.y-3,
    zd=2,
    z=0,
    zbase=0,
    s=_newdst[i].val<card.val and _news[i] or _newb[i],
    delay=0
   }
   _newc.dx,_newc.dy=_newc.x+_newx[i],_newc.y+_newy[i]
   
   add(chips,_newc)
   add(card.chips,_newc)
   add(_newdst[i].chips,_newc)
  end
 end
end

function dropchip9()
 local bxs,bestc,best=split2d("1,2,4,5|2,3,5,6|5,6,8,9|4,5,7,8"),-1,-1
 for i=1,4 do
  local ten,hid=false,0
  for j in all(bxs[i]) do
   ten=ten or cards[j].val==10
   if cards[j].hidden then
    hid+=1
   end
  end
  if ten then
   if hid+rnd()>best then
    best,bestc=hid+rnd(),i
   end
  end
 end
 dangrect,drectsani,ldrect=bestc-1,20,5
end

function calcstabonus()
 local ret=stabonus+hidcount()-1 
 return ret*mult
end

function swipechips(c)
 if c.chips then
	 for cc in all(c.chips) do
	  cc.zd,cc.delme=8,true
	  sfx(58)
	 end
 end
end

function scoreline(cap,val)
 add(linet_next,cap)
 add(linev_next,val)
end

function endgame(how)
 tempsave()
 musiclvl(0)
 result,wins[round],showcur,linet_next,linev_next,linet,linev="won","w",false,{},{},{},{}
	     
 local crds=9-hidcount()
 if not bonusmode then
  scoreline("flipped "..crds.." cards",crds*mult.."ML")
 end

 if how=="win" then 
  stabcard(vcard)
  if bonusmode then
   scoreline("winnings doubled","")
  else
   scoreline("vampire evaded",2*mult.."ML")
  end 
 elseif how=="lose" then
  result,wins[round],shake="lost","l",2
  sfx(40,3)
  if bonusmode then
   scoreline("winnings lost","")
  end 

 elseif how=="pass" then
	 result,wins[round]="pass","p"
  scoreline("pass penalty",passcost().."ML")
  	 
 elseif how=="stab" then	
  scoreline("vampire evaded",2*mult.."ML")
  scoreline("stab bonus",calcstabonus().."ML")
   
 elseif how=="badstab" then
	 result,wins[round]="lost","l"
	 scoreline("stab penalty",calcstabonus().."ML")
	 sfx(40,3)
 end
 
 scoreline("❎ continue","❎")
end

function returnchip()
 gchips[curchipi],curchip.zd=curchip,0.8
 curchip=nil
 sfx(59)
end

function passcost()
 local cst=scoremode and -2 or -2-chain
 return cst*mult
end
-->8
--tools

function plusminus(v)
 if v<0 then
  return "-"
 elseif v>0 then
  return "+"
 end
 return ""
end

function dofade()
 fadeperc=min(fadeperc,1)
 fadepal(fadeperc,1)
end

function fadepal(perc,plt)
 for c=0,15 do
  pal(c,fadetable[c+1][flr(perc*16+1)],plt)
 end
end

function wait(_wait,_skipdraw,_dochips)
 repeat
  _wait-=1
  if not _skipdraw then
   if _dochips then
    dochips()
   end
   _draw()
  end
  flip()
 until _wait<0
end

function fadeout(spd,_wait)
 local spd,_wait=spd or 0.04,_wait or 0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 wait(_wait)
end

function split2d(s)
 local arr=split(s,"|")
 for i=1,#arr do
  arr[i]=split(arr[i])
 end
 return arr
end

function bignumc(num,tx,ty,c,ml)
 local stklen=bignumlen(num)
 bignum(tx-stklen/2,ty,num,c)
 if ml then
  print("ML",tx+stklen/2+2,ty+5,c)
 end
end

function bignumlen(num)
 local snum,w=tostr(num),0
 for i=1,#snum do
  local cs=sub(snum,i,i)
  local bb=bignums[cs]
  if bb then
   w+=bb.w+bb.kern*2+2
  else
   w+=6
  end
 end
 return w-2
end

function bignum(x,y,num,col)
 local snum,px,shrt,w,col=tostr(num),x,6,8,col or 7
 
 pal(7,col)
  
 for i=1,#snum do
  local cs=sub(snum,i,i)
  local bb=bignums[cs]
  
  if bb then
   local alt=bb.alt
	  if alt then
	   pal(5,col)
	   palt(6,true)
	   shrt=4
	  else
	   palt(5,true)
	   pal(6,col)
	  end
	  w=bb.w+bb.kern*2
   sspr(bb.x,bb.y,bb.w,10,px+bb.kern,y)
  elseif cs=="-" then
   rectfill(px,y+4,px+3,y+5,col)
   w=4
  else
   w=4
  end
  px+=w+2
 end
 pal()
end

function sepline(y)
	line(8,y,119,y,2)
	sspr(0,108,6,1,8,y)
 sspr(0,108,6,1,114,y,6,1,true)
end

function rprint(txt,x,y,c)
 local rx=x-#tostr(txt)*4
 print(txt,rx,y,c)
end

function cprint(txt,x,y,c)
 local rx=x-#tostr(txt)*2
 print(txt,rx,y,c)
end

function msgn(v)
 return v==0 and 0 or sgn(v)
end
-->8
--music
function musiclvl(lvl)
 for i=1,8 do
  for j=1,3 do
   if j<lvl+1 then
    --0 play
    poke(0x3100+4*i+j,peek(0x3100+4*i+j)&0b10111111)
   else
    --1 no play
    poke(0x3100+4*i+j,peek(0x3100+4*i+j)|0b01000000)
   end
  end
 end

end
-->8
--cdata
function newgame()
 tries+=1
 blood,unlocked=20,{true,false,false,false}
 savegame()
end

function tempsave()
 if scoremode then return end
 local tblood=blood
 blood=mid(blood+wining,0,5000)
 savegame()
 blood=tblood
end

function savegame()
 dset(0,1)
 dset(1,blood)
 dset(2,tries)
 dset(6,chain)
 dset(7,bchain)
 dset(12,wbin)
 for i=2,4 do
  dset(i+1,unlocked[i] and 1 or 0)
 end
 for i=1,4 do
  dset(i+7,high[i])
 end
 dogpio()
end

function loadgame()
 unlocked,high={true},{}
 if dget(0)==1 then
  blood,tries,chain,bchain,wbin=dget(1),dget(2),dget(6),dget(7),dget(12)
  for i=2,4 do
   unlocked[i]=dget(i+1)==1
  end
  for i=1,4 do
   high[i]=dget(i+7)
  end
  dogpio() 
 else
  blood,tries,chain,bchain,high,wbin=0,0,0,0,split("0,0,0,0"),0
  savegame()
 end
end

function dogpio()
 poke(0x5f95,bchain)
 poke(0x5f96,unlocked[2] and 1 or 0)
 poke(0x5f97,unlocked[3] and 1 or 0)
 poke(0x5f98,unlocked[4] and 1 or 0)
 poke(0x5f99,wbin)
end
__gfx__
001122330070000070000000000080800000000000080800000000000080800005500000080800000000000080800005500055500000baaaaaaaaaaaaaaaaab0
00112233077000007700000000008080600555dd50080800000005050080800555dd5000080800d66d00000080800555dd5000500000a00000000000000000a0
44556677777000007770000000008080666677667d08080000567755008080d66666dd0008080777775500008080d66666dd00500000a06000000000000000a0
44556677077000007700000000008880667777765dd8880556777765008880d667666d50088807777d5500008880d667666d50500000a06000000000000000a0
8899aabb0070000070000000000008007777777765508006677777650008006667777650008000775000500008006667777650500000a06660000000000000a0
8899aabb00000000000000000000000d7777777765000076777777dd00000dd6777776d00000006705000500000dd6777776d0500000a06060220002202200a0
ccddeeff00000000000000000000076d77777777d5000d667777776000005dd7777777600550d67605655000505dd777777760500000a06660220002222200a0
ccddeeff0000000000000000000006d67777777750000d77777776d000005d67777777d00055777d05777000505d67777777d0500000a00000200000222000a0
b00b00bbbb0bbbbbb0bbbbb000bb0d5d67777776000000d77765670000005d677777776000007777dd5d7500505d6777777760500000a00002000000020000a0
0220220bb020bbbb0d0bbb0ddd0b0dd005777650000000077750d65560000d666776ddd00000677650005d00500d666776ddd0500000a00000000000000000a0
0222220b02220bb0ddd0bb0ddd0b056d00d760005000000d76005dd760000d005d7d50500500d56765005d00500d005d7d5050000000a00000000000000000a0
b02220b02222200ddddd0000d000007600075005500000006d0056d750000d00067600550500d57767506500500d0006760055000000a00220220002202200a0
bb020bbb02220b0dd0dd00ddddd00067056d65d650000500665566770000056dd677557d0500dd070705700050056dd677557d000000a00222220002222200a0
bbb0bbbbb020bbb00d00b0dd0dd000d7777dd76d00005006776600650000057667775d600000d70d0d06d00050057667775d60000000a00022200000222000a0
bbbbbbbbbb0bbbbbb0bbbb00b00b000576675dd00000005d667d56000500005567765000050007d00006055050005567765000500000a00002000000020000a0
0000000000bbb1bbbbbb1111111b00006d5d06d0000000d757d05600000000000700d00000000d6000dd000050d0000700d0d0500000a00000000000000000a0
0999999000bb171bbbb1888888810000665057d00000000d0d00660000000055000000000000007d00d5050050d055000000d0500000a00000000000000000a0
9999999900bb171bbbb1888f8881000067d5665000000500000675000000005d50000000000000777d50000050d05d500000d0500000a00220220002202200a0
2999999200bb171111b188f8f8810000d77765000000005ddd7750000000000ddd005000000000577750000050d00ddd0050d0500000a00222220002222200a0
2222222200b1171717118f888f81000005d65000000000005d50000000000000d6dd00000000000055000000500000d6dd0000500000a00022200000222000a0
22992992001717777711888888810000000500000000000000000000000000000d60000000000000575000005555500d600555500000a00002000000020000a0
2299229200177777771199999991b11111111111bb22222222222b0aaaaaaaaaaa0b11111b11111bb22222b22222bb11111bb11111b0a00000000000000000a0
a292299200b17777771b1111111b18777777777812000000000002a00000000000a18888898888812000000000002188888118888810a00000000000000000a0
a222299200bb177771bb1111111b19777777777912000000000002a0a0a0a0a0a0a1888f898f888120002000200021888f8118f88810a00000000000000000a0
a22a299200bb111111b18888888118777777777812000002000002a00a0a0a0a00a188f88988f8812002000002002188f881188f8810baaaaaaaaaaaaaaaaab0
a22a9992bbeeeebb00018f888f8119777777777912000022200002a0a0a0a0a0a0a18f8889888f81202000000020218f88811888f810baaaaaaaaaaaaaaaaab0
a22a2992be9999eb000188f8f88118777777777812000002000002a00a0a0a0a00a188f88988f8812002000002002188f881188f8810a33333333333333333a0
aaaaaa22e999999e0001888f888119777777777912000000000002a0a0a0a0a0a0a1888f898f888120002000200021888f8118f88810a32999999999999923a0
a22a222ae299999e00018888888118777777777812000000000002a00a0a0a0a00a18888898888812000000000002188888118888810a39929292229292993a0
a22a229ae229222e00019999999112666666666212222222222222a00000000000a19999999999912444444444442199999119999910a39292929992929293a0
a29aa99aea29292e000b1111111bb11111111111bb22222222222b0aaaaaaaaaaa0b11111b11111bb22222b22222bb11111bb11111b0a39992992229929993a0
a2922992ea29292eeeebbbbbbbbbb11111111111bb22222222222b000000000000000000000000000000000000000000000000000000a39929299999292993a0
a22a2292ea2929aeeaaebbbbbbbb1ddddddddddd12000000000002000000000000000000000000000000000000000000000000000000a39929292929292993a0
a22a229aea29a9aeeaaaebbbbbbb1ddd66666ddd12000222220002000000000000000000000000000000000000000000000000000000a39292999299929293a0
a2222292ea2a22aebeaa9ebbbbbb1ddd6ddd6ddd12000200020002000000000000000000000000000000000000000000000000000000a39999292929299993a0
a222a22aea22a2aebea992ebbbbb1ddd6ddd6ddd12000200020002000000000000000000000000000000000000000000000000000000a39299229292299293a0
aa2aa222eaa2a2aebbea229ebbbb1ddd6ddd6ddd12000200020002000000000000000000000000000000000000000000000000000000a39922992929922993a0
aa22a29aeaa2222ebbbe9922ebbb1ddd66666ddd12000222220002000000000000000000000000000000000000000000000000000000a39299229992299293a0
aaaaa292eaaaa22ebbbbe2999ebb1ddddddddddd12000000000002000000000000000000000000000000000000000000000000000000a39922992929922993a0
aa222292eaa2222ebbbbea2299eb15555555555512222222222222000000000000000000000000000000000000000000000000000000a39299229292299293a0
aa222222eaa299aebbbbbea9999eb11111111111bb22222222222b000000000000000000000000000000000000000000000000000000a39999292929299993a0
aa2aa292eaaa2aaebbbbbbe9999e00000000000000000000000000000000000000000000000000000000000000000000000000000000a39292999999929293a0
aaaaa292eaa222aebbbbbbbe99eb00000000000000000000000000000000000000000000000000000000000000000000000000000000a39929292229292993a0
aaaaa299eaaa22aebbbbbbbbeebb00000000000000000000000000000000000000000000000000000000000000000000000000000000a39929299999292993a0
aa222222eaaaaaeb25222222222222222222222222222222222929999999292222222222222222222222222222222222222200000000a39992992229929993a0
a2229222beaaaaebd555522222222222225252525252522222222252d2d9999999292222222222222222222222222222222200000000a39292929992929293a0
aa22992abeaaaaeb552525555555555552252225222222222222222229d9d9d929999992922292222222292929292929229200000000a39929292229292993a0
aa2299aabeaaaaeb222225222522520000522552525252522222222222929d9deeedee9e999e99999999929292929292292200000000a32999999999999923a0
aaa222aabeaaaaeb2222222222222000000552222525252d5d522222ddddddef6e6efefeefeeeeeeede9d92929222222222200000000a33333333333333333a0
aaaa2aaabbeaaebbd2d2d2d2229220000002212222222225ddddddddddddd2ddeeeeeeeeefff6f66ee6eeedd252222225d2500000000baaaaaaaaaaaaaaaaab0
aaaa22aabbeaaebb66666666666660000009ded9d99929299222d2d222229d99eeefffff6fe6f6f676f666ee922221122dd60000005555555555555ddd500000
aa2222aabbeaebbb2ddd2dddddddd000000676f7f766e6eeeeee9e9e9e99eeeeeffeffffffffffffff6f6ff6e6eed9292999005dd5500000000000000d676500
aa2222aabbbebbbb2222222222222000000e6ee666f666666e6ef6fffff7feff9e9feeeeefeffeffff7777ffffffff7feeef0dd5550000000000000000066760
0a2a22aa00000000e99d99999e9d9e0000eeeeeeeeefefefefefeeeeeeeeeee9e9eeeeeeeeefeffff777777ffffeefeeffefddd00000000000000000000066d5
0aaa22a000000000efeee7effefef000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffeefff777777ffefeefeeeeeed766d500000000000000000665d6
0aa22aa000000000fefefefeeefe00000000fffffffefeeeeeeeefeeeeeeeeeeeeeeefeffffffffff777777fffffffffffff57677d5500000000055dddd666dd
0aaaaaa000000000efeffefffff00000000000fffffffffffffffef6fefefeeeeeeeee6eeeffeffff777777ffffffeffffff5767655555d555dddd6666766ddd
0aaaaaa000000000ffffffeffe0000000000000eeeeeeeeeeeeeeee8eeeeeeeeeeeeeeeeeeeeefefff7777ffeeeefeeeeeef07776500000000000000055ddd65
0aaaaaa000000000fefeeefeef0000000000000eeeeeee9e8e9989eeee9e9eee9eedeee9eeeeefefffffffffffffeeeefefe0777500000000000000000000d60
0aaaaaa000000000fefeffeef0000000000000009ee9e8eee8eeeee9eefefedeeeeeeeeeee9eeefefffefffffeeeffeeefef0d77500000000000000000000660
0aaaaaa000000000eeeeeeefe000000000000000eeeeede9eee22222229eeeeffeeeefefffffefefffffffeefeefefeffefe0555500000000000000000000dd0
0aaaaaa000000000eeeeeeeee000000000000000eeed23111d2111313131129929eee9e9ee9eeeeeeeffffeefeeeffeeeeee05dd500099999999999900000dd0
00aaaa0000000000eeeeeeeee000000000000000ed233141134111111113131151222222222229229deeefeeefeeeeeeeeee05d6d0992222aaaaaaaa99900d50
00aaaa0000000000eeeeeeeee0000000000000001131111111111311111111111133111121221311322122d9d92e9e2e99d905d66922aaaaaaaaaaaa22299d50
00aaaa000000000099eeeded200000000000000001113133331331311111111111111111313133333133333111112211221200d662aaaaaaaaaaaaaaa2229d00
00aaaa000000000011113333000000000000000001111111113211111311131123111332333331333333333131313011413300d6692aaa2a222aa22222229d00
00aaa0000000000011121311100300000000010001335511351151111111111333133131333133333313333311133335133500dd699222aaaaaa222222a99d00
00aaa00000000000131133121001000000000300033333111311143331331133333333333333033333333333333333303030005667999999922222229999dd00
000aa00000000000313333330003000000000000033330330303303033333333333333330133333333333333333330330333005687999999999999999999dd00
000a000000000000000000000000000000056d55550000000000000005555d76000000000000000000000000000000000000005687799999999999999992dd00
000a000000000000000000000000000000577755555555000000555555556667600000000000000000000000000000000000000687999998999999999992d000
00000000000000000000000000000000006766500000057650567d5555000d67750000000000000000000000000000000000000d87999999989989888886d000
0000000000000000000000000000000005766d000000056760d77d0000005566760000000000000000000000000000000000000dd7999999999999999886d000
00000000000000000000000000000000067665000000007770677505000005d6675000000000000000000000000000000000000dd9799999999999888887d000
000000000000000000000000000000005776d05000000067756765000000005667d000000000000000000000000000000000000dd9999999999888999987d000
0000000000000000000000000000000067665000000000d77d77600000aaaaad677000000000000000000000000000000000000dd22999999899999999975000
0000000000000000000000000000000067660000aaaaaad776776aaaaaa2222d6675000000000000000000000000000000000005ddaa99999999992222665000
000000000000000000000000000000056665aaaaaa2222d777776999992222226675000000000000000000000000000000000005d22aaaa2222aaaaaaa265000
0000000000000000000000000000000566629999922229d67777699929292929d6755dddd5000000000000000000000000000005dd2aaaaaaaaaaaaaa9675000
0000000000000000000000000000000566d99999992229d77667698992922229d6666766676d5555000000000000000000000000d66d2aaaaaaaaaaa22770000
00000000000000000000000000000005ddd98899999229667d776d8892292299666666666666766d6d55555055050000000000006d6d28922222292229770000
00000000000000000000000000000000d65988999929a9667067669892222d676666666666666d6ddddd55555050500000000000666509899999200d67760000
000000000000000000000000000000005d55999992229dd760576dd99967776666666666666d66d66dddd5555505000000000000657d00002200000d6d760000
0000000000000000000000000000000005d559999299ad67000d6dd9976677666d666666d6d66d6dd5d555555055000000000000657d00000000000d6d660000
0000000000000000000000000000000005d9555995959d75000566552d766dddd666d6d6666dd6ddd655d5550500000000000000d56d00000000000dd5760000
000000000000000000000000000000000055d95959559dd00005665559555d6666666d6ddd665d5555d555555555000000000000d676555222225056667d0000
0000000000000000000050555d55555550005599955555000000576d55d6676666d6d66665555505050555555000000000000000dd7625255528d5dd55760000
000000000000000005555dd666777676776505885d50000000000d67677666666d6d6d65500000000000000000555000000000000d6d57750000ddddd6600000
0000000000000055555555dd6666676776760055d00000000000006666666d6d6d66d550000000000000000000000000000000000066776dd555d88877000000
000000000000500505555d5dd6666666676765d5000000000000000d7666666666555000000000000000000000000000000000000000dddddddddddd00000000
0000000000500050550555ddd66666dd667677d000000000000000005d66655550500000000000000000000000000bbbb92bbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000505050555556d6666665dd66766500000000000000000055500000000000000000000000000000000bb99992bbbbbbbbbbbbbbbbbbbbbbbbbbbb
0000000500000505050555d56d667676055d76d650000000000000000000550000000000000000000000000000000b999992bbbbbbbbbbbbbbbbbbbbbbbbbbbb
0000000005050000505005555d66666765056dd750000000000000000000500000000000000000000000000000000b9999992bbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000050505000055555d666676d5dd6750000000000000000000550000000000000000000000000000000bb9999992bbba999bbbbbbbbbbbbbbbbbbb
000000050500005000000005050505d666666d6650000000000000000000055000000000000000000000000000000bbb9929992a992299999bbbbbbbbbbbbbbb
00000000000050000000000000000005d66776d650000000000000000000055000000000000000000000000000000bbb999299209999999299bbbbbbbbbbbbbb
000000000000000000000000000000005d67766600000000000000000000005000000000000000000000000000000bbbb9922900a999999992999bbbbbbbbbbb
00000005000000000000000000000056d5d6666d00000000000000000000005000000000000000000000000000000bbbbb9990a22999999229999bbbbbbbbbbb
0000000000000000000000000000005556d5567000000000000000000000005500000000000000000000000000000bbbbb290a9929999929990009bbbbbbbbbb
000000000000000000000000000000005555055000000000000000000000000500000000000000000000000000000bbbb900a999999999999000a09bbbbbbbbb
000000000000000000000000000000000005500000000000000000000000000505000000000000000000000000000bbb992a29999992999999002009bbbbbbbb
000000000000000000000000000000000050500000000000000000000000005500500000000000000000000000000bb99292999999299999999999009bbbbbbb
000000000000000000000000000000000505500000000000000000000000055555555555000000000000000000000b999299999992999000999900909bbbbbbb
000000000000000000000000000000555550050000000000000000000000555000005550000000000000000000000b999999999999990000099900099bbbbbbb
000000000000000000000000000055555555505000000000000000000005555055550000000000000000000000000b9299999999999000a0009900009bbbbbbb
0000000000000000000000000000005555555555000000000000000005555555000000000000000000000000000009929999999999900002000900a09bbbbbbb
0000000000000000000000000000000005555555550000000000000005500000000000000000000000000000000009299999999929000a02000900a0999bbbbb
aa2a2a2200000005555555005555550550000555500005555555550550000005555000005500005555555550000009292999922929000a02009990099999bbbb
008222222888888555555555555555555000055555000555555555555000000555500000550000555555555500000299999a00009900000009299999999a9bbb
00822222208888055000055550000555500005555550055550000555500000055550000055000055550000550000022222aaaa00990000200929999999a999bb
008222222088880550000555500005555000055555550555500005555005500555500000550000555500005500000229999990000900aa00929992999a9a99bb
00822222200880055555555550000555500005555055555550000555500550055550000055500555555555550000029229929920099000092999999aa999b99b
008222222008800555555505500005555000055550055555500005555005500555500000055555505555555000000929999992aa0299999999999aa99a9bbb99
008222222008800550005555500005555000055550005555500005555055550555500000005555005500000000000999999999200029999999a9a9a999bbbbb9
008222222008800550000555500005555000055550000555500005555555555555500000000550005500000000000b99999922a0000999999bbbb99b99bbbbbb
008222222000000550000555555555555555555550000555555555505550055505555555000550005500000000000b929999922a0222999bbbbbbb9bb99bbbbb
008222222000000550000550555555005555550550000555555555000500005005555555000550005500000000000b92999922aa0099000aabbbbbbbbb9bbbbb
008222222000000576666755577000777777057666675055577707777777500677660776666775777776006666660bb92999992a099000a222bbbbbbbbbbbbbb
000822222000000776666775777007777777777666677555777757777777506777760776667777777776666666666bb9299922a0090000b229bbbbbbbbbbbbbb
800082222000000770000776776007700007777000077556666756605500067755550550055767700006666000066bbb9299992000000bbb929bbbbbbbbbbbbb
880008222000000770000770576005500066655000077576606606605500077500555550557667700006666000066bbbb929999922000bbb999bbbbbbbbbbbbb
888000822000000775555770576005500777555577775777557706667766077666675555576605777766066666666bbbbbb222999922bbbbb999bbbbbbbbbbbb
888800082000000775555770576005506775555577777675557756667766677666677555776007777766606666666bbbbbbb9222992bbbbbbb29bbbbbbbbbbbb
888880008000000770000770576005566605555000077666666770005506677555577555775007700006600000066bbbbbbbbbb99bbbbbbbbb929bbbbbbbbbbb
888888000000000770000770576005766005577000077776666776605506677555577550675507700006600000666bbbbbbbbbbbbbbbbbbbbbb99bbbbbbbbbbb
888888800000000776666777777667777777777666677555557756667766677666677550665557777776606666660bbbbbbbbbbbbbbbbbbbbbbb99bbbbbbbbbb
888888880000000576666757777666777777657666675055557700667766057666675550660555777776006666600bbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbb
__label__
0ooooo00000oooooo000000000ooooo0000000000ooooo0000000000000000000000000000000000000ooooo0000000000ooooo000000000oooooo00000ooooo
ooooo00000oooooo000000000ooooo000000000oooo0000000000000000000000000000000000000000000oooo000000000ooooo000000000oooooo00000oooo
oooo00000oooooo00000000ooooo000000000oooo00000000000000000000000000000000000000000000000oooo000000000ooooo00000000oooooo00000ooo
oooo00000ooooo00000000ooooo00000000oooo000000000000000000000000000000000000000000000000000oooo00000000ooooo00000000ooooo00000ooo
ooo00000ooooo00000000ooooo00000000oooo00000000000000000000000000000000000000000000000000000oooo00000000ooooo00000000ooooo00000oo
oo00000ooooo00000000ooooo00000000ooo0000000000000000000000ooooooooooooo0000000000000000000000ooo00000000ooooo00000000ooooo00000o
o00000ooooo00000000ooooo0000000oooo000000000000000000ooooooooooooooooooooooo000000000000000000oooo0000000ooooo00000000ooooo00000
o00000ooooo0000000ooooo0000000ooo00000000000000000oooooooo0000000000000oooooooo00000000000000000ooo0000000ooooo0000000ooooo00000
00000ooooo0000000ooooo0000000ooo000000000000000oooooo00000000000000000000000oooooo000000000000000ooo0000000ooooo0000000ooooo0000
0000ooooo00000000oooo0000000ooo00000000000000ooooo00000000000000000000000000000ooooo00000000000000ooo0000000oooo00000000ooooo000
000ooooo00000000oooo0000000ooo0000000000000ooooo000000000000000000000000000000000ooooo0000000000000ooo0000000oooo00000000ooooo00
000ooooo0000000oooo0000000oo0000000000000ooooo0000000000000000000000000000000000000ooooo0000000000000oo0000000oooo0000000ooooo00
00ooooo0000000oooo0000000oo0000000000000oooo00000000000000000000000000000000000000000oooo0000000000000oo0000000oooo0000000ooooo0
00oooo00000000ooo0000000oo0000000000000ooo000000000000000002222222222200000000000000000ooo0000000000000oo0000000ooo00000000oooo0
0ooooo0000000oooo000000ooo00000000000oooo00000000000002222200000000000222220000000000000oooo00000000000ooo000000oooo0000000ooooo
0oooo0000000oooo000000ooo00000000000ooo000000000000022000000000000000000000220000000000000ooo00000000000ooo000000oooo0000000oooo
ooooo0000000ooo000000ooo00000000000ooo00000000000222000000000000000000000000022200000000000ooo00000000000ooo000000ooo0000000oooo
oooo0000000ooo0000000oo00000000000ooo0000000000220000000000000000000000000000000220000000000ooo00000000000oo0000000ooo0000000ooo
ooo0000000oooo000000oo00000000000ooo000000000020000000000000000000000000000000000020000000000ooo00000000000oo000000oooo0000000oo
ooo0000000ooo000000ooo0000000000ooo00000000022000000000000000000000000000000000000022000000000ooo0000000000ooo000000ooo0000000oo
oo0000000oooo00000ooo0000000000ooo0000000002000000000000000000000000000000000000000002000000000ooo0000000000ooo00000oooo0000000o
oo0000000ooo000000oo0000000000ooo000000000200000000000000002222222222200000000000000002000000000ooo0000000000oo000000ooo0000000o
oo000000oooo00000ooo000000000ooo00000000020000000000000022200000000000222000000000000002000000000ooo000000000ooo00000oooo000000o
o0000000ooo000000oo0000000000oo0000000002000000000000222000000000000000002220000000000002000000000oo0000000000oo000000ooo0000000
o000000oooo00000oo0000000000oo000000000200000000000220000000000000000000000022000000000002000000000oo0000000000oo00000oooo000000
0000000ooo000000oo000000000ooo000000002000000000002000000000000000000000000000200000000000200000000ooo000000000oo000000ooo000000
000000oooo00000oo000000000ooo00000000200000000002200000000000000000000000000000220000000000200000000ooo000000000oo00000oooo00000
000000ooo000000oo000000000oo0000000020000000000200000000000000000000000000000000020000000000200000000oo000000000oo000000ooo00000
000000ooo00000oo000000000ooo0000000200000000002000000000000000000000000000000000002000000000020000000ooo000000000oo00000ooo00000
00000ooo000000oo000000000oo000000002000000000200000000o20000000000000000000000000002000000000200000000oo000000000oo000000ooo0000
00000ooo00000ooo00000000ooo0000000200000000020000000oooo2000000000000000000000000000200000000020000000ooo00000000ooo00000ooo0000
00000ooo00000oo000000000oo0000000200000000020000000ooooo2000iiiiiiiii0000000000000000200000000020000000oo000000000oo00000ooo0000
0000oooo00000oo00000000ooo0000000200000000200000000oooooo2ii000000000ii00000000000000020000000020000000ooo00000000oo00000oooo000
0000ooo00000ooo00000000oo000000020000000002000000000oooooo2000iooo00000ii0000000000000200000000020000000oo00000000ooo00000ooo000
0000ooo00000oo000000000oo0000000200000000200000000000oo2ooo2ioo22ooooo000ii00000000000020000000020000000oo000000000oo00000ooo000
0000ooo00000oo00000000oo00000000200000002000000000000ooo2oo20ooooooo2oo0000i00000000000020000000200000000oo00000000oo00000ooo000
000ooo000000oo00000000oo0000000200000000200000000000i0oo22o00ioooooooo2ooo00i0000000000020000000020000000oo00000000oo000000ooo00
000ooo00000oo000000000oo000000020000000200000000000i000ooo0i22oooooo22oooo000i000000000002000000020000000oo000000000oo00000ooo00
000ooo00000oo00000000oo000000020000000020000000000i00002o0ioo2ooooo2ooo000o000i000000000020000000020000000oo00000000oo00000ooo00
000ooo00000oo00000000oo000000020000000020000000000i000o00ioooooooooooo000i0o00i000000000020000000020000000oo00000000oo00000ooo00
000ooo00000oo00000000oo00000002000000020000000000i000oo2i2oooooo2oooooo00200o00i00000000002000000020000000oo00000000oo00000ooo00
000ooo00000oo00000000oo00000002000000020000000000i00oo2o2oooooo2ooooooooooo00o0i00000000002000000020000000oo00000000oo00000ooo00
00ooo00000oo000000000oo0000000200000002000000000i00ooo2ooooooo2ooo000oooo00o0o00i0000000002000000020000000oo000000000oo00000ooo0
00ooo00000oo00000000oo00000002000000020000000000i00oooooooooooooo00000ooo000oo00i00000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i000o2ooooooooooo000i000oo0000o000i0000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i00oo2ooooooooooo00002000o00i0o000i0000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i00o2ooooooooo2o000i02000o00i0ooo0i0000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i00o2o2oooo22o2o000i0200ooo00oooooi0000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i002oooooi0000oo0000000o2ooooooooio0000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i0022222iiii00oo0000200o2oooooooiooo000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i0022oooooo0000o00ii00o2ooo2oooioioo000000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i002o22oo2oo200oo0000o2ooooooiioooioo00000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo0000000200000002000000000i00o2oooooo2ii02oooooooooooiiooio0i0oo0000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo00000002000000020000000000i0ooooooooo20002oooooooioioiooo0i000o0000002000000020000000oo00000000oo00000ooo0
00ooo00000oo00000000oo00000000200000002000000000i00oooooo22i0000oooooo0g00oo0oo0i00000000020000000200000000oo00000000oo00000ooo0
00ooo00000oo00000000oo000000002000000020000000000i0o2ooooo22i0222ooo0gg0000o00oo000000000020000000200000000oo00000000oo00000ooo0
00ooo00000oo000000000oo00000002000000020000000000i0o2oooo22ii00oo000ii000000000o00000000002000000020000000oo000000000oo00000ooo0
000ooo00000oo00000000oo000000020000000020000000000i0o2ooooo2i0oo000i2220000000i000000000020000000020000000oo00000000oo00000ooo00
000ooo00000oo00000000oo000000020000000020000000000i0o2ooo22i00o0000022o0000000i000000000020000000020000000oo00000000oo00000ooo00
000ooo00000oo00000000oo0000000020000000200000000000i0o2oooo2000000000o2o00000i0000000000020000000200000000oo00000000oo00000ooo00
000ooo00000oo00000000oo00000000200000000200000000000i0o2ooooo22000000ooo0000i00000000000200000000200000000oo00000000oo00000ooo00
000ooo00000oo000000000oo00000000200000002000000000000i00222oooo2200000ooo00i00000000000020000000200000000oo000000000oo00000ooo00
000ooo000000oo00000000oo000000002000000002000000000000ii0o222oo200000002oii000000000000200000000200000000oo00000000oo000000ooo00
0000ooo00000oo00000000oo00000000200000000020000000000000ii00oo000000000o2o0000000000002000000000200000000oo00000000oo00000ooo000
0000ooo00000oo000000000oo000000002000000002000000000000000ii000000000ii0oo000000000000200000000200000000oo000000000oo00000ooo000
0000ooo00000ooo00000000oo00000000200000000020000000000000000iiiiiiiii0000oo00000000002000000000200000000oo00000000ooo00000ooo000
0000oooo00000oo00000000ooo000000002000000000200000000000000000000000000000o0000000002000000000200000000ooo00000000oo00000oooo000
00000ooo00000oo000000000oo00000000020000000002000000000000000000000000000000000000020000000002000000000oo000000000oo00000ooo0000
00000ooo00000ooo00000000ooo000000002000000000020000000000000000000000000000000000020000000000200000000ooo00000000ooo00000ooo0000
00000ooo000000oo000000000oo000000000200000000002000000000000000000000000000000000200000000002000000000oo000000000oo000000ooo0000
000000ooo00000oo000000000ooo0000000002000000000022000000000000000000000000000002200000000002000000000ooo000000000oo00000ooo00000
000000ooo000000oo000000000oo0000000000200000000000200000000000000000000000000020000000000020000000000oo000000000oo000000ooo00000
000000oooo00000oo000000000ooo00000000002000000000002200000000000000000000000220000000000020000000000ooo000000000oo00000oooo00000
0000000ooo000000oo000000000ooo000000000020000000000002220000000000000000022200000000000020000000000ooo000000000oo000000ooo000000
o000000oooo00000oo0000000000oo000000000002000000000000002220000000000022200000000000000200000000000oo0000000000oo00000oooo000000
o0000000ooo000000oo0000000000oo0000000000020000000000000000222222222220000000000000000200000000000oo0000000000oo000000ooo0000000
oo000000oooo00000ooo000000000ooo00000000000200000000000000000000000000000000000000000200000000000ooo000000000ooo00000oooo000000o
oo0000000ooo000000oo0000000000ooo000000000002200000000000000000000000000000000000002200000000000ooo0000000000oo000000ooo0000000o
oo0000000oooo00000ooo0000000000ooo0000000000002000000000000000000000000000000000002000000000000ooo0000000000ooo00000oooo0000000o
ooo0000000ooo000000ooo0000000000ooo00000000000022000000000000000000000000000000022000000000000ooo0000000000ooo000000ooo0000000oo
ooo0000000oooo000000oo00000000000ooo000000000000022200000000000000000000000002220000000000000ooo00000000000oo000000oooo0000000oo
oooo0000000ooo0000000oo00000000000ooo0000000000000002200000000000000000000022000000000000000ooo00000000000oo0000000ooo0000000ooo
ooooo0000000ooo000000ooo00000000000ooo00000000000000002222200000000000222220000000000000000ooo00000000000ooo000000ooo0000000oooo
0oooo0000000oooo000000ooo00000000000ooo000000000000000000002222222222200000000000000000000ooo00000000000ooo000000oooo0000000oooo
0ooooo0000000oooo000000ooo00000000000oooo00000000000000000000000000000000000000000000000oooo00000000000ooo000000oooo0000000ooooo
00oooo00000000ooo0000000oo0000000000000ooo000000000000000000000000000000000000000000000ooo0000000000000oo0000000ooo00000000oooo0
00ooooo0000000oooo0000000oo0000000000000oooo00000000000000000000000000000000000000000oooo0000000000000oo0000000oooo0000000ooooo0
000ooooo0000000oooo0000000oo0000000000000ooooo0000000000000000000000000000000000000ooooo0000000000000oo0000000oooo0000000ooooo00
000ooooo00000000oooo0000000ooo0000000000000ooooo000000000000000000000000000000000ooooo0000000000000ooo0000000oooo00000000ooooo00
0000ooooo00000000oooo0000000ooo00000000000000ooooo00000000000000000000000000000ooooo00000000000000ooo0000000oooo00000000ooooo000
00000ooooo0000000ooooo0000000ooo000000000000000oooooo00000000000000000000000oooooo000000000000000ooo0000000ooooo0000000ooooo0000
o00000ooooo0000000ooooo0000000ooo00000000000000000oooooooo0000000000000oooooooo00000000000000000ooo0000000ooooo0000000ooooo00000
o00000ooooo00000000ooooo0000000oooo000000000000000000ooooooooooooooooooooooo000000000000000000oooo0000000ooooo00000000ooooo00000
oo00000ooooo00000000ooooo00000000ooo0000000000000000000000ooooooooooooo0000000000000000000000ooo00000000ooooo00000000ooooo00000o
ooo00000ooooo00000000ooooo00000000oooo00000000000000000000000000000000000000000000000000000oooo00000000ooooo00000000ooooo00000oo
oooo00000ooooo00000000ooooo00000000oooo000000000000000000000000000000000000000000000000000oooo00000000ooooo00000000ooooo00000ooo
oooo00000oooooo00000000ooooo000000000oooo00000000000000000000000000000000000000000000000oooo000000000ooooo00000000oooooo00000ooo
ooooo00000oooooo000000000ooooo000000000oooo0000000000000000000000000000000000000000000oooo000000000ooooo000000000oooooo00000oooo
0ooooo00000oooooo000000000ooooo0000000000ooooo0000000000000000000000000000000000000ooooo0000000000ooooo000000000oooooo00000ooooo
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888800888800880000888000000888008888008888888880000008800000000888800888880088880088000000888000000888888888888888888
88888888888888800888800880000880000000088008888008888888800000000800000000888000088880088800088000000880000000088888888888888888
88888888888888800888800888008880088880088008888008888888800888800888800888880000008880088000888008888880088880088888888888888888
88888888888888800888800888008880088888888008888008888888800888888888800888800088000880080008888008888880088888888888888888888888
88888888888888800000000888008880088000088000000008888888800000008888800888800888800880000088888000008880000000888888888888888888
88888888888888800000000888008880088000088000000008888888880000000888800888800888800880000088888000008888000000088888888888888888
88888888888888800888800888008880088880088008888008888888888888800888800888800000000880000008888008888888888880088888888888888888
88888888888888800888800888008880088880088008888008888888800888800888800888800000000880088000888008888880088880088888888888888888
88888888888888800888800880000880000000088008888008888888800000000888800888800888800880088800088000000880000000088888888888888888
88888888888888800888800880000888000000888008888008888888880000008888800888800888800880088880088000000888000000888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__sfx__
010100010c17000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0108000030615186052b6051860518605186051860518605186051860518605186051860518605186051860518605186051860518605186051860518605186051860518605186051860518605186051860518605
0103000413527185271b527185272450030500245003050024500305002450030500245003050024500305000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c5000c500
01011f201833018330180701807018060180601805018050180401804018040180301803018030180201802018020180201802018020180201802018020180201802018020180201802018020180201802018020
010700021805400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
018400051851418510185211851118515005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
0103000330235313353243513505275052750513505135050c5051450526505265051450514505145051450529505295051650516505165051650527505275050c5051750517505175051f5051f5051750517505
010900101031513325183151c3251f3152432526315283252b3152832526315243251f3151c3251a3151832500305003050030500305003050030500305003050030500305003050030500305003050030500305
010e00000c0430c8550c8450c8350c0430c8550c8450c8350c0430c8550c8450c8350c0430c8550c8450c8350c0430885508845088350c0430885508845088350c0430a8550a8450a8350c0430a8550a8450a835
010e00000c0430885508845088350c0430885508845088350c0430885508845088350c0430885508845088350c0430885508845088350c0430885508845088350c0430785507845078350c043078550784507835
010e000c0ca400ca2113b1013b151bb101bb150ca400ca200ca100ca1013b1013b151bb001bb051870018700187001870013b0013b051bb001bb051870018700187002470513b0013b051bb001bb051870018700
010e0000130051373513725137250c940137351372513725130051373513725137250c940137351372513725130050f7350f7250f7250c9400f7350f7250f725130051173511725117250c940117351172511725
010e000822c4527c3524c2522c1522c4522c3527c2522c152cc052cc052cc052cc052cc052cc052cc052cc052ec052ec052ec052ec052ec052ec052ec052ec052fc052fc052fc052fc052fc052fc052fc052fc05
010e00000c00013800138001380027b2027b2513800138000c6001480026b2026b251480014800148001480029b2029b251680016800168001680027b2027b250c6001780017800178001fb201fb251780017800
010e0000130051873518725187250c940187351872518725130051873518725187250c940187351872518725130051873518725187250c940187351872518725130051673516725167250c9401a7351a7251a725
000e16200ca400ca211bb101bb1524b1024b150ca400ca200ca100ca101fb101fb150ca400ca211bb101bb1524b1024b150ca400ca200ca100ca1022c2527c3522c2516c3529c251bc3527c251bc3524c2516c35
010e00000cb0013b0013b0013b002bb202bb2513b0013b000cb0014b0029b2029b2514b0014b0014b0014b002cb202cb2516b0016b0016b0016b0024b2024b250cb0017b0017b0017b0026b2026b2517b0017b00
010e00000000000000000000000024724247112471224712247150000000000000002672426711267122671226715000000000000000277242771127712277122771500000000000000029724297112971229715
010e00000c0000c0000c0000c00037724377113771237712377150c0000c0000c0003a7243a7113a7123a7123c7243c7113c7123c7123c7150c0000c0000c0003b7243b7113b7123b7123b7150c0000c0000c000
000e00000c0000c0000c0000c00030724307113071230712307150c0000c0000c00032724327113271232712327150c0000c0000c00033724337113371233712337150c0000c0000c00035724357113571235715
010e00000c0430885508845088350c0430885508845088350c0430885508845088350c0430885508845088350c0430785507845078350c0430785507845078350c0430785507845078350c043078550784507835
010e0000130051873518725187250c940187351872518725130051873518725187250c940187351872518725130051873518725187250c940187351872518725130051773517725177250c940177351772517725
010e0000000000000000000000002b7242b7112b7122b7122b7150000000000000002e7242e7112e7122e71232724327113271232712327150000000000000003072430711307123071230715000000000000000
010e16200ca400ca211bb101bb1524b1024b150ca400ca200ca100ca101fb101fb150ca400ca211bb101bb1524b1024b150ca400ca200ca100ca1023c2526c352fc2523c3529c251ac3526c251ac351fc2526c35
010e00000cb0013b0013b0013b0027b2027b2513b0013b000cb0014b0026b2026b2514b0014b0014b0014b0024b2024b2516b0016b0016b0016b0026b2026b250cb0017b0017b0017b001fb201fb2517b0017b00
017f00200171401721017310174101731017210171101715037140372103731037410373103721037110371502714027210273102741027310272102711027150671406721067310674508734087210871108715
017f002028d2028d1127d2027d111ed201ed1120d2020d1128d2028d1127d2027d111ed201ed1120d2020d1129d2029d1128d2028d112bd202bd1129d2029d1128d2028d1127d2027d111ed201ed1120d2020d11
010e00000cb0013b0013b0013b0027b2027b2513b0013b000cb0014b0026b2026b2514b0014b0014b0014b0029b2029b2516b0016b0016b0016b0027b2027b250cb0017b0017b0017b001fb201fb2517b0017b00
01e6001120c1420c1520c1420c1520c1420c1520c1420c1520c1421c1421c1521c1421c1520c1420c1520c1420c15180001800018000180001800018000180001800018000180001800018000180001800000000
01131f20183431634314333113330f3230b3230f3130b3130fd100fd100fd210fd200fd310fd300fd410fd400fd510fd500fd610fd600fd710fd700fd610fd600fd510fd500fd410fd400fd310fd300fd210fd21
011800000000000000000000000000000000000071400711007210072100731007310074100741007400074000740007400073100730007210072000711007100071000710007120071200712007120071200715
0118000004000040000400004000040000400013d1013d1013d2113d2013d3113d3013d4113d4013d5113d5013d6113d6013d7113d7013d6113d6013d5113d5013d4113d4013d3113d3013d2113d2113d1113d15
011200000c043044200442204422044220441104410044150c0430742007422074220742207411074150c043100430b4200b4220b4220b4220b4110b4100b4150b8500b8520b8420b8420b8310b8310b8210b815
011200000442417225173151731534610286151722517315074241a2251a3151a31534610286151a2251a315285362a5262f5162a516285162a5162f5162a516275362a5262f5162a516275162a5162f5162a516
0112000028f5528f5528f6528f6528f7528f7528f6528f652bf552bf552bf652bf652bf752bf752bf652bf6534f5534f5534f6534f6534f7534f7534f6534f652ff552ff552ff652ff652ff752ff752ff652ff65
011200001f2301f2211f2111f2101f2121f2121f2152322028230282212821128210282102821028212282122a2302a2212a2112a2102a2102a2102a2122a2122f2302f2212f2112f2102f2102f2102f2122f212
016400000d8500d8520d8420d8420d8310d8210184001831018210181101810018150180001805018000180001800018000180001800018000180001800018000180001800018000180001800018000180001800
0148000028d762cd7631d662cd6628d562cd5631d462cd46017140172101731017410173101721017110171504d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d0004d00
017f000028f2028f2028f1128f1028f1228f1228f1525f0025f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f0004f00
01be000034220342113421533b0033b0033b0033b0033b0500b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b00
010700002fe612be6127e6122e511ee511ae5117e4112e4101e411833300001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001
000700001831318a7024a7018a7024a6018a6024a6018a4024a4018a4024a2018a2024a2018a1024a1018a1524a050ca0518a0500a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000000
000900001671016710167101671016710167101671016710167101671016710167101671016710167101671016710167101671016710167101671016710167101671016710167101671016710167101671016710
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000105501653016510245102b510170001a00019005355052950035500355003550501500355003550001500005000050000500005000050000500005000050000500005000050000500005000050000500
000100000412007120031200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000010550165301651024510295101d520295202e515355052950035500355003550501500355003550001500005000050000500005000050000500005000050000500005000050000500005000050000500
000100000211002110021100210002100011000610004100021000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000100003151033500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000200003e670396603066028650236401c63018620156201362012620106200f6100d6100c6100a6100a61000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002251000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100003a0103c000180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001a5101d5102052022530215301d520165100b510167000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
00010000370203c030180100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001300000542004400044000440004400044000440004400044000440004400044000440004400044000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
000100000c6100a65015610196002d600035200352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000004520085100b5100050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
__music__
03 191a1c40
01 080b0a1b
00 080b0a1b
00 080b0a10
00 080b0a18
00 090e110f
00 090e160f
00 090e130f
02 14151217
04 1d1e1f44
00 20212223
04 24252627

