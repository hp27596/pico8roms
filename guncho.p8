pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--guncho
--@spoike
-- original game by
-- arnold rauers and
-- terri vellman for
-- 7drl 2022

dirx,diry={-1,1,0,0,-1,-1,1,1},{0,0,-1,1,-1,1,-1,1}
debug={}
blink=false
sand_y=-1
shake=0
enter_calls=split"rode to bandit camp,entered bandit camp,whoa there!,howdy!,want to talk about this?,gringos sighted!"
exit_calls=split"yippee ki yay!,yee-haw!,whoopee!,yippee!,huzzah!,hog-killin time!,gosh darn!"
cries=split"oh no!,argh!,auugh!,yikes!,doh!,oops!,nooooooo!,ugh!,wah!,oomf!,ghaa!,eek!,gargle!"
kabooms=split"kaboom!,boom!,ka-blowie!,blammo!,asplode!,explosion!,bssboom!"
punches=split"kapow!,ker-pow!,pow!,thud!,falcon punch!,bam!,bam-bam!,wham!,humph!"
bullet_hail_phrases=split"it's high noon!,bang-bang-bang!,rat-tat-tah!"

function _init()
 pal(15,143,1)
 pal(12,140,1)
 pal(11,15,1)
 pal(9,142,1)
 palt(0,false)
 palt(14,true)
 
 anims,particles={},{}
 hail_particles={}
 for i=0,25 do
  add(hail_particles, {x=rnd(9)+1,y=rnd(128)})
  add(hail_particles, {x=rnd(9)+1,y=rnd(128),reverse=true})
 end
 start_intro()
 -- test game
 --start_game(1)
 -- test travel
 --start_travel(2)
 --start_game_over(false)
 --start_game_over(true)
end

function _update()
 blink = t() % 1 >= 0.5
 shake = max(0, shake-1)
 for anim in all(anims) do
  if costatus(anim) != "dead" then
   coresume(anim)
  else
   del(anims,anim)
  end
 end

 if _upd then _upd() end
  
 for p in all(particles) do
  p:update()
 end
end

function add_anim(cb)
 return add(anims, cocreate(cb))
end

function _draw()
 cls(15)

 if shake>0 then
  camera(flr(rnd(4)-2),flr(rnd(4)-2))
 end
 if shake==1 then
  camera(0,0)
 end
  
 _drw()
 
 for idx,d in pairs(debug) do
  print(d,0,(idx-1)*8,7)
 end
 
 -- sand overlay transition
 fillp()
 rectfill(0,-1,128,sand_y-40,15)
 fillp(▒)
 rectfill(0,-1,128,sand_y,15)
 fillp()
end



-->8
-- intro

function add_cutscene_particles(amount,hstart,hend)
 amount=amount or 30
 hstart=hstart or 30
 hend=hend or 52
 for i=0,amount do
  add(particles,{
   t=rnd(),
   x=rnd(128)+100,
   c=rnd({2,4,5,8}),
   sy=rnd(20)-10,
   h=rnd(hend)+hstart,
   update=function (self)
    self.t+=0.005
    if self.t >= 1 then
     self.t=0
    end
   end,
   draw=function (self)
    local r,y,x=
     mid(0,1.9,sin(self.t)*3),
     lerp(self.sy,self.h,self.t) + (sin(self.t*3.2+self.h)*self.h/20),
     lerp(self.x,self.x-128,self.t)
    
    if self.t > 0.001 then
     circfill(x,y,r,self.c)
    end
   end
  })
 end
end

function start_intro()
 logo_bounce=5
 logo_yoff=30
 _drw=draw_intro
 _upd=update_intro
 particles={}
 add_cutscene_particles()
 sfx(26)
 music(0, 100)
end

function update_intro()
 logo_bounce=max(0,logo_bounce-0.08)
 logo_yoff=max(0,logo_yoff-4)
 
 if #anims > 0 then return end
 
 if btnp() > 0 then
  sfx(27)
  music(-1,100)
  intro_out()
 end
end

function intro_out()
 add_anim(function ()
  for y=0,16 do
   camera(0,-y*y)
   yield()
  end
  start_game()
 end)
end

function draw_intro()
 local posterx,postery=40,36
  --40,36,
 -- wanted poster
 sspr(104,0,24,32-14,
  posterx,postery,
  48,64-28)
  
 for i=18,31 do
  local xosc=
   (max(0,
    sin((i-18)/50+(t()/3))*6
   )
    +(max(-0.2,sin(t()*1.3+0.66))*2.5))
   *(i-18)
   /31
   
  sspr(
   104,i,
   24,1,
   posterx-xosc,postery+(i*2),
   24*2,2
  )
 end

 for p in all(particles) do
  p:draw()
 end

 -- el guncho
 --sspr(96,88,32,40,28,(logo_yoff*3)+5,100,124)

 -- logo
 for i=1,8 do
  draw_title(21+dirx[i],10+diry[i]-logo_yoff,0,logo_bounce)
  draw_title(21+dirx[i]-1,10+diry[i]+2-logo_yoff,0,logo_bounce)
 end
 draw_title(21,10-logo_yoff,8,logo_bounce)
 
 -- subtitle
 print_c("a wild west roguelike", 46, 7, 1)

 if logo_bounce==0 and blink then
  print_c("press any button to start",111,4)
 end
 
end

function draw_title(x,y,col,yb)
 pal(8,col or 8)
 spr(32,x+0, (sin(t())*yb)+y+5,2,3)
 spr(34,x+15,(sin(t()+0.25)*yb)+y+9,2,3)
 spr(36,x+30,(sin(t()+0.40)*yb)+y+4,2,3)
 spr(38,x+46,(sin(t()+0.5)*yb)+y,2,3)
 spr(40,x+60,(sin(t()+0.25)*yb)+y+7,2,3)
 spr(42,x+75,(sin(t()+0.75)*yb)+y+11,2,3)
end

-->8
-- game
modes=split"move,revolver,sprint,punch,bullet hail,wait,sprint"
modes_desc=split"moves one tile,select a target to fire at or\nreload empty chamber,moves two tiles,punches item or bandit,use all bullets and then reload\nall bullets,skips a turn,take second step"
modes_instr=split"  go,  fire,  go,  punch,unleash,  wait,  go"
modes_uses_arrows={true,false,true,true,false,false,true}
mode_rotates_gun={true,true,true,false,false,false,true}
mode_shows_target={false,true,false,false,"all",false,true}
-- 1: axe guy 
-- 2: dynamite guy
-- 3: trapper guy
-- 4: gun guy
-- 5: boss guy (should always spawn on last level)
level_data={
  --"2", -- test
  "1,1,4,3",
  "1,1,3,2,4",
  "1,1,2,3,4,4",
  "1,2,2,3,4,4,4",
  "1,2,2,3,3,4,4"
}
level_data_objects={3,4}
level_data_walls={4,5}
current_level,bandits_killed=0,0

function start_game(level)
 _drw,_upd=draw_game,update_game
 current_level,sand_y=level or 1,-1
 to_push={}
 hail=0
 if current_level==1 then
  bandits_killed=0
 end
 selected_mode,selected_aim,enemy_turn=1,1,false
 enemies,cells,dynamites,gun_targets={},{},{},{}
 revolver_angle,selected_idx=0,0
 draw_arrows,disable_game_buttons=false,false
 bullets={true,true,true,true,true,true}
 cooldowns={0,0,0,0,0,0,0,0}
 button_pane_y=0
 create_player()
 clear_bullet_highlights()
 anims,entities,particles={cocreate(function()
  action_override=rnd(enter_calls)
  for y=16,0,-1 do
   camera(0,y*(y/4))
   yield()
  end
  co_pause(1, function()
  end)
 end)},{},{}
 
 -- generate background objects
 bg_o={}
 local bg_o_temp={}
 for i=1,#bg_objs do
  add(bg_o_temp, i)
 end
 shuffle(bg_o_temp)
 for i=0,6 do
  for j=1,2 do
    if maybe(0.25+(0.1*current_level)) and #bg_o_temp > 0 then
      local fidx = deli(bg_o_temp, 1)
      add(bg_o, {
        fidx, -- idx
        flr(rnd(4)*-1+1), -- dx
        flr(i*10+rnd(2)+4), -- dy
        j > 1 -- flip
      })
    end
  end
 end
 board={}
 -- generate board (procgen it)
 local to_place = split(level_data[current_level])
 for i=1,rnd(level_data_objects) do
  add(to_place,flr(rnd(1)+0.5)+6) -- tnt or bear trap
 end
 while #to_place < 32 do
  add(to_place,0)
 end
 shuffle(to_place)
 -- place boss man
 if level == 5 then
  local i = flr(rnd(4)+1)
  local cell = to_place[i]
  while cell > 0 do 
    i+=1
    cell = to_place[i]
  end
  to_place[i] = 5
 end
 for row=0,6 do
  local isodd=row % 2 == 1
  local xoff=isodd and 8 or 0
  local rowarr=add(board,{})
  local col_width=isodd and 4 or 5 
  for col=0,col_width do
   -- generate fences
   local fences = {0,0,0,0}
   if col > 0 and col < col_width and row > 0 and row < 6
    and maybe(0.5 + (current_level*0.05)) then
    fences[flr(rnd(3))+2]=flr(rnd(2)+1)
   end
   -- adding cell
   local c=add(cells,add(rowarr, {
    x=xoff+(col*17),
	  y=row*11,
	  col=col+1,row=row+1,
	  isodd=isodd,marked=false,
	  hilight=false,
	  tokens={},
    fences=fences
   }))
   if #to_place > 0 then
    local placing=to_place[1]
    if placing == 6 then
     add_token(c,create_tnt())
    elseif placing == 7 then
     add_token(c,create_beartrap())
    elseif placing > 0 then
     add_token(c,create_enemy(placing))
    end
    del(to_place, placing)
   end
  end
 end
 
 --[[
 function safe_place(x,y,token)
  local another = board[x][y].tokens[1]
  if another != nil then return end
  add_token(board[x][y],token)
 end
 ]]

 --player token/sprite
 --add_token(board[7][2], player)
 add_token(board[7][flr(rnd(4)+2)], player)
 
 --test enemy tokens
 --add_token(board[7][4],create_enemy(1))
 --add_token(board[7][6],create_beartrap())
 --safe_place(4,3,create_tnt())
 --safe_place(4,5,create_enemy(1))
 --add_token(board[7][4],create_dynamite())
 --[[ testing blowing stuff up
 add_token(board[7][3],create_tnt())
 add_token(board[6][3],create_tnt())
 board[7][3].fences[1]=0
 board[7][3].fences[2]=1
 add_token(board[7][4],create_enemy(1))
 board[7][4].fences[1]=1
 add_token(board[7][5],create_enemy(1))
 ]]
 --add_token(board[3][5],create_tnt())
 --add_token(board[4][4],create_tnt())
 --add_token(board[7][4],create_tnt())
 --add_token(board[7][4],create_enemy(1))
 -- testing trapper bug
 --add_token(board[5][2],create_enemy(1))
 --add_token(board[7][5],create_enemy(3))
 --add_token(board[7][4],create_beartrap())

 update_highlights()
 rotate_selection(2)
end

function add_token(cell, token)
 token.current=cell
 return add(entities, add(cell.tokens, token))
end

function update_game()
 --debug[1]=#anims
 --debug[1]=selected_mode.." c:"..cooldowns[selected_mode]
 if #anims>0 then return end
 if player.killed then
  sfx(30)
  action_override=rnd(cries)
  co_game_fade_out(function()
   start_game_over(false)
  end)
  return
 end

 if enemy_turn and (#enemies > 0 or #dynamites > 0) then
  perform_enemy_turn()
  for i=1,5 do
   cooldowns[i]=max(0,cooldowns[i]-1) 
  end
  enemy_turn=false
  return
 else
  enemy_turn=false
 end

 action_override=nil
 if #enemies<1 and #dynamites<1 then
  action_override=rnd(exit_calls)
  sfx(28)
  co_game_fade_out(function()
   if current_level<5 then 
    start_travel(current_level+1)
   else
    start_game_over(true)
   end
  end)
  return
 end
 if btnp(4) then
  handle_player_action()
  return
 end
 if btnp(0) then
  player.flipped=true
  rotate_selection(1)
  sfx(13)
 elseif btnp(1) then
  player.flipped=false
  rotate_selection(-1)
  sfx(13)
 elseif btnp(2) and not disable_game_buttons then
  mode_select(-1)
 elseif btnp(3) and not disable_game_buttons then
  mode_select(1)
 end
 update_highlights()
 if btnp(5) then
  -- open_game_button_selection
  if disable_game_buttons then return end
  add_anim(function ()
   for t=0,3 do
    button_pane_y=flr(lerp(0,30,t/3))
    yield()
   end
   sfx(14)
   _upd=update_game_buttons
  end)
 end
end

function handle_player_action()
 --enemies[1]:kill()
 --move to target
 --debug[1]=selected_mode
 function can_use(idx)
  return selected_mode == idx and cooldowns[idx] == 0
 end

 if can_use(1) or can_use(7) then -- move, sprint
  handle_player_move("moving", function ()
   enemy_turn=true
   if selected_mode==7 then
    selected_mode=1
    cooldowns[3]=3
    disable_game_buttons=false
   end
  end)
 elseif can_use(2) then -- revolver, shoot/reload
  local target = r_state[selected_aim] 
  sfx(22)
  if not bullets[selected_aim] then -- reload
   action_override="reloading"
   co_pause(0.1, function()
    bullets[selected_aim] = true
   end)
   enemy_turn=true
  elseif type(target) == "table" then -- shoot
   action_override="shooting"
   add_anim(function ()
    bullets[selected_aim]=false
    clear_bullet_highlights()
    fire_gun(player, target)
    if selected_aim > 2 and selected_aim < 6 then
     add_anim(rotate_ccw)
    else
     add_anim(rotate_cw)
    end
   end)
   enemy_turn=true
   update_highlights()
  end
 elseif can_use(3) then -- sprint
  handle_player_move("sprinting", function()
   disable_game_buttons=true
   selected_mode=7
  end)
 elseif can_use(4) then -- punch, aka. "push"
  action_override=rnd(punches)
  local target=get_neighbors(player.current)[selected_idx]
  if type(target)=="table" and #target.tokens > 0 then
   local ttoken = target.tokens[1]
   player.target_direction=selected_idx
   player:bounce(function()
    local a = push_object(ttoken, selected_idx)
    if ttoken.enemy_idx then
     -- 2 but effectively 1 turn
     ttoken.stun = 2 
    end
   end)
   enemy_turn=true
   cooldowns[4]=3
   selected_mode=1
  else
    player_nope("can't punch there")
  end
 elseif can_use(5) then -- bullet hail
  local has_any_bullets=false
  for b in all(bullets) do
   has_any_bullets=has_any_bullets or b
  end
  if has_any_bullets then
   add_anim(function()
    sfx(29)
    for i=0,25 do
     hail=lerp(0,1,i/25)
     yield()
    end
    action_override=rnd(bullet_hail_phrases)
    local angles=shuffle({1,2,3,4,5,6})
    for angle in all(angles) do
     if bullets[angle] then
      bullets[angle]=false
      player:flip_to(angle)
      local targetcell=r_state[angle]
      local anim=fire_gun(player, targetcell)
      while costatus(anim)!="dead" do yield() end
     end
     if player.killed then return end
    end
    clear_bullet_highlights()
    for i=0,4 do
     hail=lerp(1,0,i/4)
     yield()
    end
    for i=1,6 do
     bullets[1]=true
     local a = add_anim(rotate_cw)
     while costatus(a) != "dead" do yield() end
     sfx(22)
     --local pause=t()+0.05
     --while pause>t() do yield() end
    end
    cooldowns[5]=5
    selected_mode=2
    enemy_turn=true
    update_highlights()
   end)
  end
 elseif can_use(6) then -- sleep
  enemy_turn=true
 else
  player_nope("action available in "..cooldowns[selected_mode].." turns")
 end
end

function handle_player_move(label, on_done)
 local target=get_neighbors(player.current)[selected_idx]
 if type(target) == "table" and #target.tokens == 0 then
  player:move(target)
  action_override=label
  if selected_idx > 2 and selected_idx < 6 then
   add_anim(rotate_ccw)
  else
   add_anim(rotate_cw)
  end
  selected_aim=selected_idx
  on_done()
 else 
  player_nope("can't move there")
 end
end

function player_nope(message)
 action_override=message
 sfx(20)
 add_anim(function()
  --shake player
  for i=0,12 do
   player.ox=sin(i/6)*3
   yield()
  end
  player.ox=0
  for i=0,24 do yield() end
  action_override=nil 
 end)
end

function fire_gun(from, target)
 return add_anim(function ()
  gunsmoke(from)
  sfx(10)
  if type(target)=="table" then
    for i=0,2 do yield() end
    local wait=t()+0.4
    if type(target.kill) == "function" then
     wait=nil
     local anim=target:kill()
     while costatus(anim)!="dead" do yield() end
    elseif target.target_is_fence then
     local anim=destroy_fence(target, target.has_target, false)
    elseif target.tokens and #target.tokens > 0 then
     wait=nil
     local anim=(target.tokens[1]):kill()
     while costatus(anim)!="dead" do yield() end
    end
    if wait then
     while wait > t() do yield() end
    end
    update_highlights()
  else
   local wait=t()+0.5
   while wait > t() do yield() end
  end
 end)
end

function can_drop_trap(from)
 return can_aim_player(from)
  and type(from.trap_target) == "table"
  and #from.trap_target.tokens == 0
end

function can_push_trap(from)
 if not can_aim_player(from) then return false end
 from.trap = nil
 local n = get_neighbor(from.current, from.target_direction)
 if type(n) != "table" then return false end

 local trap = n.tokens[1]
 if type(trap) == "table" and trap.is_beartrap then
  from.trap = trap
  return true
 end
 return false
end

function co_pause(seconds, callback)
 add_anim(function()
  local pause=t()+seconds
  while pause > t() do yield() end
  if type(callback) == "function" then callback() end
 end)
end

function co_wait(callback)
 while #anims>1 do
  yield()
 end
 add_anim(callback)
end

function co_game_fade_out(cb)
 add_anim(function()
  -- music outro
  local pause=t()+1
  while pause > t() do yield() end
  sfx(19)
  for y=0,10 do
    sand_y=y 
  end
  for y=0,24,1 do
    camera(0,-y*(y/4))
    sand_y=y*(y/2)
    yield()
  end
  cb()
 end)
end

function update_game_buttons() 
 if #anims > 0 then return end
 if btnp(0) or btnp(2) then
  mode_select(-1)
 elseif btnp(1) or btnp(3) then
  mode_select(1)
 end
 if btnp(5) or btnp(4) then
  add_anim(function()
   for t=0,3 do
    button_pane_y=flr(lerp(30,0,t/3))
    yield()
   end
   _upd=update_game
   sfx(15)
  end)
 end
end

function mode_select(diff)
 selected_mode+=diff
 if selected_mode > 6 then
  selected_mode = 1
 elseif selected_mode < 1 then
  selected_mode = 6
 end
 sfx(31)
end

function rotate_selection(dir)
 local from, ns = player.current, get_neighbors(player.current)
 local i,stop,curr = 1,7,selected_idx
 if selected_mode==2 then
  curr=selected_aim+dir
  if curr>6 then curr=1 elseif curr<1 then curr=6 end
  selected_aim=curr
  selected_idx=curr
  player:flip_to(curr)
 elseif selected_mode==1 or selected_mode==3 or selected_mode==4 or selected_mode==7 then
  while i<stop do
   i+=1
   curr+=dir
   if curr>6 then curr=1 elseif curr<0 then curr=6 end
   local n=ns[curr]
   if type(n)=="table" and not is_blocking(curr,from,n) then
    selected_idx=curr
    selected_aim=curr
    player:flip_to(curr)
    return
   end
  end
 end
end

function rotate_cw()
 for i=1,6 do
  revolver_angle-=1/32
  yield()
 end
 revolver_angle=0
 add(bullets,deli(bullets,1))
end
function rotate_ccw()
 for i=1,6 do
  revolver_angle+=1/32
  yield()
 end
 revolver_angle=0
 add(bullets,deli(bullets,6),1)
end

function draw_game()
 draw_board()
 for p in all(particles) do
  p:draw()
 end

 -- bottom pane
 -- da horns
 map(0,0,0,86,16,2)
 
 local cooldown=cooldowns[selected_mode]
 if #anims==0 then
  if cooldown==0 then
    local show_select=selected_mode != 5 
    local s_text=show_select and "⬅️➡️ select\n" or ""
    local action_label=modes_instr[selected_mode]
    if selected_mode==2 and not bullets[selected_aim] then
     action_label="  reload"
    end
    print(s_text.."🅾️ "..action_label,2,
    show_select and 115 or 121,
    4)
  end
  if not disable_game_buttons then
   print("actions ❎",87,121,4)
  end
  -- draw rotation
  if mode_rotates_gun[selected_mode] then
   local is_right=selected_aim <= 2 or selected_aim == 6
   spr(11,is_right and 76 or 44,99,1,1,not is_right)
  end
 end

 draw_revolver(revolver_angle,48,97)

 -- draw action middle of revolver
 circfill(63,112,5,1)
 circfill(64,112,5,1)
 draw_action_icon(selected_mode,60,108)

 -- da buttons
 if button_pane_y > 0 then
	 rectfill(0,128-button_pane_y,128,128,2)
	 for i=0,5 do
     local x,y=i*21+2,129-button_pane_y
    
     local on_cooldown=draw_action_icon(i+1,x,y)
     -- selection arrow
	   if i+1==selected_mode then
	    spr(156,x+10,y)
	   end
     -- cooldown notice
     if on_cooldown then
      print(cooldowns[i+1], x+3, y+8, 7)
     end
	 end
	 print(modes_desc[selected_mode],2,145-button_pane_y,11)
 end
 local selected_label = action_override
 if selected_label==nil then
  selected_label=modes[selected_mode]
  if cooldown > 0 then
   selected_label=selected_label.." (in "..cooldown.." turns)"
  end
 end
 print_c(selected_label,91,7,2)

 if #anims == 0 then
  for tg in all(gun_targets) do
   local x,y,i=unpack(tg)
   local show=mode_shows_target[selected_mode]
   if (show != false and selected_aim==i or show == "all") and bullets[i] then
    spr(182,x,y-abs(sin(t())*4))
   end
  end
 end

 -- draw bullet hail effects!
 -- hail=abs(sin(t()/4)) --test
 if hail>0 then
  local w=lerp(-1,2.5,hail)
  rectfill(-1,0,w,128,8)
  rectfill(129-w,0,129,128,8)
  w=lerp(-1,8.5,hail)
  fillp(▒)
  rectfill(-1,0,w,128,8)
  rectfill(129-w,0,129,128,8)
  w=w*2
  fillp(░)
  rectfill(-1,0,w,128,8)
  rectfill(129-w,0,129,128,8)
  for h in all(hail_particles) do
   fillp()
   local x=h.reverse and 128-(h.x*hail) or h.x*hail
   for i=1,6 do
    circfill(x,h.y+(i*3),max(2,5-i)*hail,8)
   end
   --fillp(▒)
   --circfill(x,h.y,2*hail,2)
   --circfill(x,h.y+2,1*hail,2)
   h.y-=(10-h.x)*2
   if h.y <-5 then h.y=130 end
  end
  fillp()
 end
end

fence_render_order={2,3,1,4}
bg_objs={
  split"32,96,8,10",
  split"40,96,8,6",
  split"40,102,8,9",
  split"32,106,8,12",
  split"40,111,8,5",
  split"32,118,7,10",
  split"40,116,8,8",
  split"39,124,7,4",
  split"48,96,7,8",
  split"48,104,9,14",
  split"57,96,9,11",
  split"48,118,8,6",
  split"57,107,8,5"
}
function draw_board()
 spr(80,0,0,6,1)
 spr(80,128-(6*8),0,6,1,true)
 
 for idx=1,4 do
  spr(76,0,(idx-1)*16+8,2,2)
  spr(76,112,(idx-1)*16+8,2,2,true)
 end
 for idx=1,3 do
  spr(201,0,(idx-1)*22+20+(idx%2-1),3,2)
  spr(201,128-24,(idx-1)*22+20+(idx%2-1),3,2,true)
 end
 spr(108,0,78,2,1)
 spr(108,112,78,2,1,true)

 for o in all(bg_o) do
  local i,dx,dy,flip=unpack(o)
  local sx,sy,sw,sh=unpack(bg_objs[i])
  if flip then dx=128-sw-dx end
  sspr(sx,sy,sw,sh,dx,dy,sw,sh,flip)
 end

 -- actual board 
 local xoff,yoff=14,8
 for rowidx,row in pairs(board) do 
  for col in all(row) do
   local ox,oy=
   	xoff+col.x,yoff+col.y

   if col.hilight then
    pal(11,9)
   end
	  spr(3,ox,oy,2,2)
	  if modes_uses_arrows[selected_mode] and
	   col.marked and #anims == 0 then
	   spr(5,ox,oy,2,2)
	   spr(85+col.marked,ox+3,oy+3)
	  end
	  pal(11,11)
	  --print(col.col,ox,oy,7)
	  
    for idx in all(fence_render_order) do
     local fence=col.fences[idx]
	   if fence>0 then
	    local is_wooden=fence <= 1
		   if idx==1 then --e
		    spr(is_wooden and 98 or 101,
		     ox+14,oy,1,2)
		   elseif idx==2 then --ne
		    spr(is_wooden and 97 or 100,
		     ox+8,oy-6,1,2)
		   elseif idx==3 then --nw
		    spr(is_wooden and 96 or 99,
		     ox-1,oy-6,1,2)
		   else --w
		    spr(is_wooden and 98 or 101,
		     ox-3,oy,1,2)
		   end
	   end
    end

	 end
   for col in all(row) do
    local ox,oy=
      xoff+col.x,yoff+col.y
    for token in all(col.tokens) do
      if token.current != col and not token.moving then
        --fix: tokens losing track of their situation
        token.current = col
        --debug[2]="token lost its current place"
        --debug[3]=token.enemy_idx or token.kill == kaboom
      end
      token:draw(ox,oy)
    end
    if col.debug then
      print(col.debug,ox,oy,1)
    end
   end
 end
end

function draw_action_icon(selected_action,x,y)
 selected_action = selected_action == 7 and 3 or selected_action
 local on_cooldown=cooldowns[selected_action] > 0
 local s = on_cooldown and 167+selected_action or 127+selected_action
 spr(s,x,y)
 return on_cooldown
end

function draw_revolver(r,sx,sy)
 -- sprite sheet pointer
 -- 0x5f54, addr:0x00
 -- screen pointer
 -- 0x5f55, addr:0x60 
 local xoff,yoff=15,111
 local cx,cy=camera()
 
 poke(0x5f55, 0x00)
 clip(0,96,32,127)
 rectfill(0,0,127,127,14)
 circfill(15,96+15,15,13)
 circfill(16,96+15,15,13)
 local p=1/6
 for i=0,5 do
  local a=i*p+r
  local x,y=
   flr(cos(a)*10+0.5),
   flr(sin(a)*10+0.5)
  if bullets[i+1] then
    local targetcell = r_state[i+1]
	  spr((targetcell and r==0 and not targetcell.target_is_fence) and 44 or 60,
	  xoff+x-3,
	  yoff+y-3)
	  --print(i+1,14+x,109+y,7)
	 else
	  spr(28,xoff+x-3,yoff+y-3)
  end
  if selected_mode==2 and selected_aim==i+1 and #anims == 0 then
	 spr(12,xoff+x-3,yoff+y-3)
  end
  -- mask
  x,y=
   flr(cos(p/2+a)*16+0.5),
   flr(sin(p/2+a)*16+0.5)
  circfill(xoff+x,yoff+y,3,14)
  circfill(xoff+x+1,yoff+y,3,14)
 end

 clip()
 poke(0x5f55, 0x60)
 camera(cx,cy)
 
 spr(192,sx,sy,4,4)
end

function clear_highlights()
 for cell in all(cells) do
  cell.hilight=false
  cell.marked=false
  cell.has_target=false
 end
end

function update_highlights()
 clear_highlights()
 for cell in all(cells) do
  for token in all(cell.tokens) do
   if token.highlight then
    token:highlight(cell)
   end
  end
 end
end

function gunsmoke(token)
 local cell=token.current
 local xoff,yoff=cell.x+8,cell.y+4
 xoff+=not token.flipped and 26 or 0
 for i=1,10 do
  add(particles, {
   x=xoff+rnd(4)-2,
   y=yoff+rnd(2),
   l=30,
   draw=function(self)
    circfill(self.x,self.y,self.l/10,self.l > 20 and 2 or 5)
   end,
   update=function(self)
    self.y-=0.15+rnd(1)
    self.x+=rnd(2)-1
    self.l-=1
    if self.l < 0 then
     del(particles, self)
    end
   end
  })
 end
 add(particles, {
  l=4,
  draw=function(self)
   circfill(xoff,yoff+3,3+self.l,self.l>1 and 10 or 9) 
  end,
  update=function(self)
   self.l-=1
   if self.l<0 then
    del(particles, self)
   end
  end
 })
end
-->8
-- tokens

function create_player()
	player={
		draw=draw_human_token,
		move=move_token,
    bounce=bounce_token,
    flip_to=flip_to,
    flip_to_target=flip_to_target,
		kill=kill_token,
		ox=0,oy=0,stun=0,
		flipped=true,
		head=23,
		hat=7,
		weapon=2,
		colour=12,
    highlight=highlight_player
	}
end

function highlight_player(self, cell)
 clear_bullet_highlights()
 for i=1,6 do
  local previous=cell
  local c=get_neighbors(previous)[i]
  while type(c)=="table" and not is_blocking(i,previous,c) do
    --c.marked=true
    --c.debug=i
   local next=get_neighbors(c)[i]
   if can_target(c) then
    r_state[i]=c
    add(gun_targets, {c.x+18,c.y-4,i})
    c.has_target=i
    c.target_is_fence=false
    c=0
   elseif has_fence(i,c,next) then
    r_state[i]=c
    c.has_target=i
    c.target_is_fence=true
    c=0
   else
    previous=c
    c=next
   end
  end
 end
 local selected = get_neighbors(self.current)[selected_idx]
 if type(selected)=="table" then
  selected.marked=selected_idx
 end
end

function clear_bullet_highlights()
 r_state={false,false,false,false,false,false}
 gun_targets={}
end

function can_target(cell)
 return
  type(cell)=="table" and
  #cell.tokens>0 and
  type(cell.tokens[1].kill)=="function" and
  not cell.tokens[1].killed and
  not cell.tokens[1].bullets_pass
end

function can_move_to(direction_idx, from_cell, to_cell)
 -- TODO: fence logic
 return type(to_cell) == "table"
  and #to_cell.tokens == 0
  and (not is_blocking(direction_idx, from_cell, to_cell))
end

bounce_dir_x={2,1,-1,-2,-1,1}
bounce_dir_y={0,-1,-1,0,1,1}
function bounce_token(self, on_mid_bounce)
 if self.flip_to_target then self:flip_to_target() end
 local dir = self.target_direction or 1
 local ex,ey=bounce_dir_x[dir]*3,bounce_dir_y[dir]*3
 return add_anim(function()
  for i=0,4 do
   self.ox=lerp(0,ex,i/4)
   self.oy=lerp(0,ey,i/4)
   yield()
  end
  if on_mid_bounce then on_mid_bounce() end
  for i=0,4 do
   self.ox=lerp(ex,0,i/4)
   self.oy=lerp(ey,0,i/4)
   yield()
  end
  self.ox,self.oy=0,0
 end)
end

function push_object(self, dir, push_distance)
 if self.killed or self.moving or self.pushed then
  return cocreate(function() end)
 end
 push_distance = push_distance or 99
 self.target_direction = dir
 sfx(21)
 self.pushed = true

 -- determine push target location
 local prev=self.current
 local target = get_neighbor(self.current, dir)
 while push_distance > 0 and can_move_to(dir, prev, target) do
   prev=target
   target=get_neighbor(target, dir)
   push_distance -= 1
 end
 local actual_move_target=prev
 local target_token=nil
 if type(target) == "table" and
   not is_blocking(dir, prev, target) then 
  --debug[1]=#target.tokens
  if #target.tokens >= 1 then
   local token = target.tokens[1]
   if token.is_beartrap or
     self.is_beartrap then
    actual_move_target=target
    target_token=token 
   else
    --debug[1]="DONT"
    target_token=nil
   end
  end
 end

 local a = move_token(self, actual_move_target)

 return add_anim(function()
  -- move the token to end target
  if a != nil then
   while costatus(a) != "dead" do
    yield()
   end
  end

  if target_token!=nil then
    -- trap is at target
    target_token:kill()
    self:kill()
    --debug[1]="KILL"
  else
    self.target_direction=dir
    a = bounce_token(self, function()
      return destroy_fence(actual_move_target, dir, false)
    end)
    if a != nil then
     while costatus(a)!="dead" do
      yield()
     end
    end
  end
  self.pushed=false
 end)
end

function destroy_all_fences(cell, destroy_brick)
 for i=1,6 do
  destroy_fence(cell, i, destroy_brick)
 end
end

fence_splash_x={0,4,5,15}
fence_splash_y={12,6,6,12}
function destroy_fence(cell, dir, destroy_brick)
 if type(cell) != "table" then return end
 local actual_cell,actual_dir=cell,dir
 if dir > 4 then
  actual_cell=get_neighbor(cell, dir)
  actual_dir=opposite_f[dir]
 end
 if type(actual_cell) == "table" then 
  local fence = actual_cell.fences[actual_dir]
  local is_brick = fence > 1
  if fence>0 and (is_brick and destroy_brick or not is_brick) then
    actual_cell.fences[actual_dir] = 0
  end
    add_splash(
     actual_cell.x+fence_splash_x[actual_dir]+14,
     actual_cell.y+fence_splash_y[actual_dir]+8
    )
 end
end

function place_object(self, target)
  add(target.tokens, del(self.current.tokens, self))
  self.current = target
end

function move_token(self, target)
 if self.flip_to_target or self.moving then self:flip_to_target() end
 if self.killed or self.moving or type(target)!="table" or self.current == target then
  return nil 
 end
 self.moving=true
 -- reserve a space to move to
 local blocker={
  draw=function() end,
  current=target
 }
 add(target.tokens, blocker)
 local previous=self.current
 local dx,dy=
   previous.x-target.x,
   previous.y-target.y
 local dist=sqrt((dx*dx)+(dy*dy))
 local move_t=flr(dist/3)
 local has_placed=false
 local sx,sy,ex,ey=dx,dy,0,0
 if dy<0 then
  place_object(self, target)
  has_placed=true
 else
  sx,sy,ex,ey=0,0,-dx,-dy
 end

 return add_anim(function()
  sfx(self.enemy_idx == nil and 11 or 12)
 
	for i=0,move_t do
	 local t=i/move_t
	 self.ox=lerp(sx,ex,t)
	 self.oy=lerp(sy,ey,t)
	 yield()
	end
	self.ox,self.oy=0,0
  self.moving=false
  if not has_placed then
	 place_object(self, target)
  end
  del(target.tokens, blocker)
  if self == player then
   player:flip_to(selected_aim)
  end
 end) 
end

function draw_human_token(self,xoff,yoff)
 xoff=xoff+self.ox
 yoff=yoff+self.oy
 self.drawx=xoff
 self.drawy=yoff
 if self.colour then
  pal(13,self.colour)
 end
 if self.kill_frame and self.kill_frame>0 then
  local kf=self.kill_frame
  spr(133+mid(0,9,kf),xoff+4,yoff+2,1,1,self.flipped)
  spr(self.hat,
   (3*sin(kf*0.1+0.5))+xoff+4,
   (mid(0,2,2-(kf*0.5))*abs(cos(kf*0.1)))+(kf*0.5)+yoff-10,
   1,1,self.flipped
  )
 else
	 spr(1,xoff+4,yoff+2,1,1)
	 if self and self.flipped then
	  spr(16,xoff-2,yoff+2,1,1,true)
	  spr(self.weapon,xoff-5,yoff-2,1,1,true)
	 else
	  spr(16,xoff+9,yoff+2,1,1)
	  spr(self.weapon,xoff+12,yoff-2,1,1)
	 end
	 spr(self.hat,xoff+4,yoff-7)
	 spr(self.head,xoff+(self.flipped and 3 or 4),yoff,1,1,self.flipped)
   if self.stun > 0 then
    local x,y=3+xoff+4,yoff-4
    circfill(sin(t()-0.075)*3.5+x,sin(t()*2-0.075)*2+y,0,1)
    circfill(sin(t())*3.5+x,sin(t()*2)*2+y,0,7)
    --circfill(sin(t()+0.3)*3+3+xoff+4,cos(t()*2+0.3)+yoff-2,0,7)
   end
 end
 pal(13,13)
end

enemy_hats=split"7,9,8,7,10"
enemy_heads=split"24,24,24,24,25"
enemy_weapons=split"18,26,27,2,2"

function create_enemy(enemy_idx)
 return add(enemies,{
  draw=draw_human_token,
  enemy_idx=enemy_idx,
	move=move_token,
  bounce=bounce_token,
  kill=kill_token,
  flip_to=flip_to,
  flip_to_target=flip_to_target,
  flipped=rnd(1)>0.5,
	ox=0,oy=0,stun=0,
  targets={},
	head=enemy_heads[enemy_idx],
	hat=enemy_hats[enemy_idx],
  weapon=enemy_weapons[enemy_idx],
  colour=8,
  highlight=highlight_enemy,
  actions=enemy_idx==5 and 2 or 1
 })
end

function flip_to(self, dir)
 self.flipped = dir > 2 and dir < 6
end

function flip_to_target(self)
 if type(self.target_direction) == "number" then
  self:flip_to(self.target_direction)
 end
end

function add_splash(sx, sy)
 for i=1,5 do
  add(particles, {
   x=sx,
   y=sy-rnd(2),
   dx=rnd(1)-0.5,
   dy=rnd(2)+4*-1,
   c=rnd({0,2,4,5}),
   l=2,
   draw=function(self)
    circfill(self.x,self.y,0.5,self.c)
   end,
   update=function(self)
    self.dy+=0.5
    if self.y > sy+4 then 
     self.dy=self.dy*-0.81
     self.l-=1
    end
    self.x+=self.dx
    self.y+=self.dy
    if self.l < 0 then
     del(particles, self)
    end
   end
  })
 end
end

-- pretty much kill enemy
function kill_token(self)
 if self.killed then return end
 if type(self.enemy_idx)=="number" then
  bandits_killed+=1
 end
 self.killed=true
 add_splash(self.drawx+6, self.drawy+4)
 return add_anim(function()
  for i=1,5 do
   --debug[1]=i
   self.kill_frame=i
   yield()
   yield()
  end
  add_anim(function()
   for i=6,20 do
    self.kill_frame=i
    yield()
    yield()
   end
   local pause=t()+0.25
   while pause > t() do
    yield()
   end
   del(enemies, self)
   del(self.current.tokens, self)
  end)
 end)
end

opposite_f={4,5,6,1,2,3}
function is_blocking(idx,fromcell,tocell)
 if type(fromcell) != "table" or type(tocell) != "table" then return true end
 return has_fence(idx,fromcell,tocell)
end

function has_fence(idx,fromcell,tocell,is_brick)
 if type(fromcell) != "table" or type(tocell) != "table" then return false end
 local to_check=0
 if is_brick then
  to_check=1
 end
 local oidx=opposite_f[idx]
 return 
  (idx <= 4 and fromcell.fences[idx] > to_check) or
  (oidx <= 4 and tocell.fences[oidx] > to_check)
end

function highlight_enemy(self,cell)
 self.targets={}
 if self.kill_frame != nil then return end
 if self.weapon == 18 then
  -- close quarters (axe)
  local n = get_neighbors(cell)
  for idx,c in pairs(n) do
   if c!=0 and not is_blocking(idx,cell,c) then
    c.hilight=true
    add(self.targets, c)
   end
  end
 elseif self.weapon==2 then
  -- gun
  local start = get_neighbors(cell)
  for idx=1,6 do
   local previous=cell
   local c = start[idx]
   while c!=0 and not is_blocking(idx,previous,c) do
    c.hilight=true
    add(self.targets, c)
    previous=c
    c=get_neighbors(c)[idx]
   end
  end
 end
end

kaboom_push={{1},{2,1},{3,4},{4},{4,5},{6,1}}
function add_to_push(token, dir, moves)
  if token==nil then return end
  for entry in all(to_push) do
   if entry[1]==token then
    return
   end
  end
  add(to_push, {token, dir, moves})
end

function flush_to_push()
 add_anim(function() 
  yield()
  while #to_push > 0 do
   local entry = deli(to_push)
   push_object(unpack(entry))
  end
 end)
end

function kaboom(self)
  if self.killed then return end
  self.killed=true

  -- resolve kills from blast radius
  local ns=get_neighbors(self.current)
  local tokens_to_kill={}
  for dir,cell in pairs(ns) do
   if type(cell)=="table" then
    --cell.debug="boom"
    local has_brick_wall=has_fence(dir,self.current,cell,true)
    --debug[dir]=has_brick_wall
    local token = cell.tokens[1]

    if not has_brick_wall then
     -- resolve to kill
     if type(token)=="table" and token.kill then
      add(tokens_to_kill, token)
     end
     -- resolve to push (when flushed after all this)
     local push_dirs = kaboom_push[dir]
     for push_dir in all(kaboom_push[dir]) do
      local next_cell=get_neighbor(cell, push_dir)
      if type(next_cell)=="table" and not has_fence(dir,cell,next_cell) then
       local tokens = next_cell.tokens
       if #tokens > 0 then
        local token = tokens[1]
        if not (token.killed or token.moving) then
         --push_object(tokens[1], dir, 1)
         add_to_push(tokens[1], dir, 1)
        end
       end
       --next_cell.debug=dir
      end
     end
    end
   end
  end
  destroy_all_fences(self.current,true)
  for token in all(tokens_to_kill) do
   token:kill()
  end
  flush_to_push()

  -- explode tnt
  return add_anim(function()
  --debug[1]="kablam!"
   action_override=rnd(kabooms)
   local splode=0
   sfx(18)
   add(particles,{
    x=self.current.x+14+8,
    y=self.current.y+8+3,
    update=function(self)
      if splode<6 then return end
      del(particles, self) 
    end,
    draw=function(self)
      circfill(self.x,self.y-2,splode+12,9)
      circfill(self.x,self.y,splode+5,10)
    end
   })
   shake+=8
   while splode<10 do
    splode+=1
    yield()
   end
   del(self.current.tokens, self)
   action_override=nil
  end)
end

function create_tnt()
 return {
  is_tnt=true,
  ox=0,oy=0,
  kill=kaboom,
  draw=function(self,xoff,yoff)
   if self.killed then
    spr(126,xoff+2+self.ox,yoff+8+self.oy,2,1)
   else
    spr(78,xoff+2+self.ox,yoff-5+self.oy,2,2)
   end
  end
 }
end

function create_beartrap(is_hidden)
 return {
  is_beartrap=true,
  ox=0,oy=0,
  bullets_pass=true,
  -- TODO: animate beartrap?
  kill=function (self)
   sfx(24)
   del(self.current.tokens, self)
  end,
  is_hidden=is_hidden,
  draw=function(self,xoff,yoff)
   if self.is_hidden then return end
   spr(110,xoff+self.ox,yoff+3+self.oy,2,1)
  end
 }
end

function create_dynamite(is_hidden)
  local particles = {}
  for i=1,10 do
   add(particles, {dx=rnd(1)-0.5,offs=rnd(2),h=2+rnd(2),x=0,c=rnd({7,9,10})})
  end
  return add(dynamites,{
    ox=0,oy=0,
    bullets_pass=true,
    turn=0,
    kill=function (self)
     del(dynamites, self) 
     return kaboom(self)
    end,
    is_hidden=is_hidden,
    particles=particles,
    draw=function(self,xoff,yoff)
     if self.is_hidden then return end
     local x,y=xoff+4+self.ox,yoff+3+self.oy
     spr(152+self.turn,x,y)
     if self.turn >= 2 then
      for p in all(particles) do
       local px,py=x+5,y+5
       local sy=sin(t()+p.offs)*p.h
       if sy <= 0 then
        p.x=p.x+p.dx
        circfill(px+p.x,py+sy,0,p.c)
       else
        p.x=0
       end
      end
     end
    end
  })
end

function update_move_field(enemy)
 local prefer_horizontal = enemy.enemy_idx >= 3
  -- prefer going sideways for trapper, gun and boss guys
 local visited=0
 for cell in all(cells) do
  --cell.debug=nil
  --cell.move_target=nil
  cell.move_weight=999
 end
 player.current.move_weight=0
 local queued={}
 function get_n(cell)
  local inc = prefer_horizontal and 0.25 or 1
  local level=cell.move_weight+inc
  for d,n in pairs(get_neighbors(cell)) do
   if can_move_to(d,cell,n)
    and n.move_weight==999 then
    n.move_weight=level
    --n.move_target=cell
    --n.debug=level
    if #n.tokens<1 then
     add(queued,n)
    end
   end
  end
 end
 get_n(player.current)
 while #queued>0 do
  local next=deli(queued,1)
  get_n(next)
  visited+=1
 end
 if enemy.enemy_idx==2 or enemy.enemy_idx==3 then
   -- dynamite guy and trapper needs to be away from player
   for cell in all(get_neighbors(player.current)) do
    if type(cell)=="table" then
     cell.move_weight=999
     --cell.debug=999
    end
   end
 end
end

function perform_enemy_turn()
  add_anim(function()
    for d in all(dynamites) do
     if player.killed then return end
     d.turn+=1
     if d.turn>2 then
      local a = d:kill()
      while costatus(a) != "dead" do yield() end
     end
    end
    for enemy in all(enemies) do
     enemy.stun = max(0, enemy.stun - 1)
    end
    for i,enemy in pairs(enemies) do
      action_override="bandits turn"
      enemy.actions_left = enemy.actions
      while enemy.actions_left > 0 do
       if player.killed or enemy.killed then return end
       update_move_field(enemy)

       if enemy.stun > 0 then
        -- pass
       elseif enemy.enemy_idx==1 and next_to_player(enemy) then
       -- axeman kills
        enemy:bounce(function ()
         sfx(25)
         player:kill()
        end)
       elseif (enemy.enemy_idx==2) and can_drop_dynamite(enemy) then
       -- tnt bandit drops dynamite
        local d = add_token(enemy.candidates[1], create_dynamite(true))
        enemy:bounce(function ()
         d.is_hidden=false
        end)
       elseif (enemy.enemy_idx==3) and can_drop_trap(enemy) then
       -- trapper drop trap
        local t = add_token(enemy.trap_target, create_beartrap(true))
        enemy:bounce(function()
         sfx(23)
         t.is_hidden=false
        end)
       elseif enemy.enemy_idx==3 and can_push_trap(enemy) then
       -- trapper push trap
        enemy:bounce(function()
         sfx(23)
         push_object(enemy.trap, enemy.target_direction)
        end)
       elseif (enemy.enemy_idx==4 or enemy.enemy_idx==5) and can_aim_player(enemy, true) then
       -- check if bandit (pistols) should attack
        fire_gun(enemy, enemy.target)
       else
        move_enemy(enemy)
       end
       enemy.actions_left -= 1
      end
    end
  end)
end

function move_enemy(enemy)
  -- check movement
  local cmp = function(a,b)
    if
      #dynamites > 0 or
      (enemy.enemy_idx==3 and next_to_player(enemy)) -- trapper needs to be one tile away from player
    then
      -- flee
      return b > a
    end
    return b < a
  end

  -- first check passable cells
  local targets = get_neighbors(enemy.current)
  local valid = {}
  for dir,next in pairs(targets) do
    if can_move_to(dir, enemy.current, next) then add(valid,{dir,next}) end
  end
  shuffle(valid)
  
  -- get the cell with least movement cost towards player
  local target = nil
  for tc in all(valid) do 
    local dir,next = tc[1],tc[2]
    if target == nil or cmp(target.move_weight, next.move_weight) then
    enemy.target_direction=dir
    target = next
    end 
  end
  --debug[i]=type(target)
  if target!=nil then
    local movement = enemy:move(target)
    while costatus(movement)!= "dead" do
    yield()
    end
  end
end

function next_to_player(enemy)
 local cell=enemy.current
 local ns = get_neighbors(cell)
 enemy.target_direction=nil
 for dir,enemy_n in pairs(ns) do
  if (not is_blocking(dir,cell,enemy_n)) and enemy_n.tokens[1] == player then
    enemy.target_direction=dir
    return true
  end
 end
 return false
end

function can_drop_dynamite(enemy)
  local candidates = {}
  local ns = get_neighbors(enemy.current)
  local pns = get_neighbors(player.current)
  for dir,enemy_n in pairs(ns) do
   if type(enemy_n) == "table" and #enemy_n.tokens == 0 and not is_blocking(dir,enemy.current,enemy_n) then
    for player_n in all(pns) do
     if enemy_n==player_n then
      add(candidates, enemy_n)
     end
    end
   end
  end
  enemy.candidates=candidates
  return #candidates>0
end

function can_aim_player(enemy, check_tnt)
 enemy.target_direction=nil
 enemy.trap_target=nil
 enemy.target=nil
 for i=1,6 do
  local prev= enemy.current
  local c=get_neighbor(enemy.current, i)
  while not is_blocking(i, prev, c) do
   prev = c
   local target_token=c.tokens[1]
   if player==target_token then
    enemy.target_direction=i
    enemy.trap_target=get_neighbor(enemy.current, i)
    enemy.target=player
    return i
   elseif check_tnt and target_token and target_token.is_tnt then
    local tnt_n=get_neighbors(c)
    for n in all(tnt_n) do
     if type(n) == "table" and n.tokens and #n.tokens>0 then
      if n.tokens[1] == player then
       enemy.target=target_token
       enemy.target_direction=i
       return i
      end
     end
    end
   end
   if c!=enemy.current and #c.tokens>0 and not c.tokens[1].bullets_pass then
    c=0
   else
    c=get_neighbor(c,i)
   end
  end
 end
 return false
end

-->8
-- utils

function maybe(success_rate)
 return rnd() <= (success_rate or 0.5)
end

function print_c(str, y, c, bgc)
 if bgc != nil then
  print_o(str, 64-flr(#str*2-0.5), y, c, bgc)

 else
  print(str, 64-flr(#str*2-0.5), y, c)
 end
end

function print_o(str, x, y, fgc, bgc)
 for i=1,8 do
  print(str,x+dirx[i],y+diry[i],bgc)
 end
 print(str,x,y,fgc)
end

function lerp(a,b,t)
 return (1-t)*a+t*b
end

function lerp2d(p1,p2,t)
 return lerp(p1.x,p2.x,t),
  lerp(p1.y,p2.y,t)
end

function shuffle(t)
 -- fisher-yates
 for i=#t,1,-1 do
  local j=flr(rnd(i)) + 1
  t[i],t[j] = t[j],t[i]
 end
 return t
end


function safe_get(row,col)
 local r=board[row]
 if r==nil then return 0 end
 return r[col] or 0
end

function get_neighbor(cell,dir)
 if type(cell) != "table" then return 0 end
 local srow,scol=cell.row,cell.col
 local col_correction=0
 if not cell.isodd then
  col_correction=-1
 end
 if dir==1 then
  return safe_get(srow,scol+1)
 elseif dir==2 then
  return safe_get(srow-1,scol+1+col_correction)
 elseif dir==3 then
  return safe_get(srow-1,scol+col_correction)
 elseif dir==4 then
  return safe_get(srow,scol-1)
 elseif dir==5 then
  return safe_get(srow+1,scol+col_correction)
 end
 return safe_get(srow+1,scol+1+col_correction)
end

function get_neighbors(cell)
 local n={}
 for dir=1,6 do
  add(n, get_neighbor(cell, dir))
 end
 return n
end
-->8
-- cutscenes

function start_travel(next_level)
 _drw,_upd=draw_travel,nil
 local start_y=90-((next_level-2)*17)
 player_y=start_y
 sand_y=-1
 
 anims={cocreate(function()
  for y=16,0,-1 do
   camera(0,y*(y/4))
   yield()
  end
  local wait=t()+0.25
  while wait > t() do
   yield()
  end
  sfx(27)
  wait=t()+0.25
  while wait > t() do
   yield()
  end
  for t=0,15 do
   player_y=lerp(0,-17,t/15)+start_y
   yield()
  end
  local wait=t()+1
  while wait > t() do
   yield()
  end
  sfx(19)
  for y=0,24,1 do
   camera(0,-y*(y/4))
   yield()
  end
  start_game(next_level)
 end)}
end

function draw_travel()
 --bad boss
 spr(10,72,23)
 spr(25,72,30)
 --player
 spr(7,50,player_y)
 spr(23,50,player_y+7)
 
 line(64,30,64,98,2)
 for i=0,4 do
  circfill(64,30+(i*17),2,2)
 end
end

function print_row(left,right,y,col)
 local s,middle=left,30-#left-#right
 for i=1,middle do 
  s=s.." "
 end
 s=s..right
 print_c(s, y, col)
end

function start_game_over(is_victory)
 anims,particles,sand_y={},{},-1
 add_cutscene_particles(10,5,30)
 camera(0,0)
 local go_offset=0
 if is_victory then
  current_level=6
  music(7)
 end

 function draw_money_bag(toff,centerx,yend)
  local w,h,y
  if toff<5 then
    local t=toff/5
    w,h,y=12,20+yend,lerp(-20,12,t)
  else 
    local t=min(1,(toff-5)/5)
    w,h,y=flr(lerp(24,15,t)),lerp(10,16,t),lerp(20+yend,12+yend,t)
  end
  sspr(48,72,16,16,centerx-(w/2),y,w,h)
 end

 _drw=function()
  --da horns (again)
  map(0,0,0,42,16,2)
  
  if is_victory then
    draw_money_bag(go_offset-12,70,-4)
    draw_money_bag(go_offset-6,58,-3)
    draw_money_bag(go_offset,64,1)
  else
    spr(144,64-16,5,4,3)
    local toff=mid(0,1,(go_offset-10)/4)
    spr(148,lerp(80,64,toff),lerp(-25,5,toff),2,3)
  end

  for p in all(particles) do
   p:draw()
  end

  print_c(is_victory and "victory" or "defeat",34,2,11)

  if go_offset>30 then
    local toff=mid(0,1,(go_offset-30)/20)
    print_row("bandits defeated", flr(lerp(0,bandits_killed,toff)).." / 30", 60, 2)
    print_row("camps cleared ",flr(lerp(0,current_level-1,toff)).." /  5", 70, 2)
  end

  if go_offset>50 and blink then print_c("press any button to continue", 111, 4) end
 end

 _upd=function()
  go_offset=min(200,go_offset+1)
  if not is_victory and go_offset==14 then
    shake+=7
    sfx(16)
  end
  if is_victory then
    if go_offset==3 then
     sfx(17)
    elseif go_offset==6 then
     shake+=7
    end
  end
  if go_offset>10 and btn()>0 then
    start_intro()
    sfx(14)
  end
 end
end
__gfx__
00000000edddddeeeefeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffeee944eeeeeee8888eeee111111111111111111111e
00000000dddddddeef0ffffeeeeee44444eeeeeeeeeee88888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeef888feeee94eeeee88ee88ee1716777777777777777771e
00700700dddddddee05555feeee44fbfbf44eeeeeee888888888eeeeefffffeeeeeeeeeeeeeeeeeeef888feeeee94eee88eeee8817716777777777777777771e
00077000dddddddee70000fee44bbbbbbbbb44eee8888eeeee8888eeef4f4feeeefffeeeeefffeeeff888ffeeeee94ee8eeeeee811116571171611611716771e
000770001ddddd1ee07ffffe4bfbfbfbfbfbfb4e888eeeeeeeee888eff444ffeef555ffeef666fee8f888f8eeeeee2ee8eeeeee816616156571171716711771e
00700700e11111eee07feeee4bbbbbbbbbbbbb4e88eeeeeeeeeee88e4400044ee555550fef000fee8200028eeee4e9e488eeee8817711161166171711711771e
00000000ee0e0eeeefffeeee4fbfbfbfbfbfbf4e88eeeeeeeeeee88e4444444ee0000055e66666ee8888888eeee94949e88ee88e11777777777777777777771e
00000000e44e44eeeeeeeeee4bbbbbbbbbbbbb4e88eeeeeeeeeee88e2222222ee1111100e11111ee2222222eeeee929eee8888eee1777777777777777777761e
ddd1eeeeedddddd1efffffee4bfbfbfbfbfbfb4e88eeeeeeeeeee88ee07070eee07070eee07070eeff0feeeeeefffeeeee555eee16777777777777777777771e
ddd1eeeeddddddd1ef055fee4bbbbbbbbbbbbb4e888eeeeeeeee888ee00000eee88888eee00000eef0ffeeeeeff0ffeee50005ee17771111111111111117771e
ddd1eeeedddddd11ef055feee44fbfbfbfbf44eee8888eeeee8888eee00077eee08880ee0077700eff0ffeeeef0f0fee5001015e17771777771117777717771e
dd1eeeeeddddd11ee70fffeeeee44bbbbb44eeeeeee888888888eeeee00000eeee080eee0000000eff88feeeef050fee5000015e17771777716661777717771e
d1eeeeeedddd00eee70feeeeeeeee44444eeeeeeeeeee88888eeeeeeee000eeeeee0eeeee00000eee778feeee7750fee6001016e17771777716661777717761e
eeeeeeee1110e0eeef0feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeee778feeee77f0feee60106ee16771777116661177717771e
eeeeeeeeee4ee44eef0feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeff88feeeef0f0feeee666eeee1771771616661617717771e
eeeeeeeeee4eeeeeefffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffeeeeef0feeeeeeeeeeee1771771650005617717771e
eee88888888eeeee88888eee88888eee8888eeeeeeeeeeeeeee8888888eeeeee88888eee8888eeeeeee88888888eeeeeeeffffeee1771771666666617717771e
ee8888888888eeee88888eee88888eee8888eeeeeeeeeeeeee888888888eeeee88888eee88888eeeee8888888888eeeeef9999fe16771771507070517717771e
e888888888888eee88888eee88888eee88888eeeee8888eee88888888888eeee88888eee88888eeee888888888888eeef994499f1777177100000001771771ee
8888888888888eee88888eee88888eee88888eeeee8888ee888888888888eeee88888eee88888eee8888888888888eee9949949917771777007770077717771e
88888eee88888eee88888eee88888eee888888eeee8888ee88888ee88888eeee88888eee88888eee88888eee88888eee9949949911771771000000017717771e
88888eee88888eee88888eee88888eee888888eeee8888ee88888ee88888eeee88888eee88888eee88888eee88888eee4994499417771716600000661717771e
88888eee88888eee88888eee88888eee8888888eee8888ee88888ee88888eeee88888eee88888eee88888eee88888eeee499994e17771716660006661717771e
88888eeeeeeeeeee88888eee88888eee8888888eee8888ee88888eeeeeeeeeee88888eee88888eee88888eee88888eeeee4444ee17771716666666661717771e
88888eeeeeeeeeee88888eee88888eee88888888ee8888ee88888eeeeeeeeeee8888888888888eee88888eee88888eeeee6666ee17771111111111111117771e
88888eeeeeeeeeee88888eee88888eee88888888ee8888ee88888eeeeeeeeeee8888888888888eee88888eee88888eeee6dddd6e16777677777777777777771e
88888e88888eeeee88888eee88888eee888888888e8888ee88888eeeeeeeeeee8888888888888eee88888eee88888eee6dd55dd6e1771117177177177177771e
88888e888888eeee88888eee88888eee8888e8888e8888ee88888eeeeeeeeeee8888888888888eee88888eee88888eeedd5dd5ddee171577171755715717711e
88888e8888888eee88888eee88888eee8888e888888888ee88888eeeeeeeeeee88888eee88888eee88888eee88888eeedd5dd5dde1677517171715715717771e
88888e8888888eee88888eee88888eee8888ee88888888ee88888eeeeeeeeeee88888eee88888eee88888eee88888eee5dd55dd5ee171117177177177177771e
88888eee88888eee8888888888888eee8888ee88888888ee88888eeeeeeeeeee88888eee88888eee88888eee88888eeee5dddd5eee177677777777777777761e
88888eee88888eee8888888888888eee8888eee8888888ee88888ee88888eeee88888eee88888eee88888eee88888eeeee5555eeee11111111111111111111ee
8888888888888eee8888888888888eee8888eee8888888ee88888ee88888eeee88888eee88888eee8888888888888eeeffff442242eeeeeeeeeeeeeeeeeeeeee
e888888888888eeee88888888888eeee8888eeee888888ee88888ee88888eeee88888eee88888eee888888888888eeee999fff4224eeeeeeeefffffffeeeeeee
ee88888888888eeeee888888888eeeee8888eeee888888ee888888888888eeee88888eee88888eeee8888888888eeeeefffff9f4224eeeeeef4444444feeeeee
eee8888888888eeeeee8888888eeeeee8888eeeee88888eee88888888888eeee88888eee88888eeeee88888888eeeeee99999ff442eeeeeef442222244feeeee
eeeeeeeee8888eeeeeeeeeeeeeeeeeeeeeeeeeeee88888eeee888888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffff44eeeeee42244444424feeee
eeeeeeeeee888eeeeeeeeeeeeeeeeeeeeeeeeeeeee8888eeeee8888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeef999999f444eeeee25222222258feeee
eeeeeeeeeee88eeeeeeeeeeeeeeeeeeeeeeeeeeeee8888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffff24444eeee22888888888feeee
eeeeeeeeeeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99999f2224444eee20002820028eeeee
222222222222222222222422222222222222222244444444eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffff22222444eee22080008088eeeee
224422222222222222222222422222222222222224444444eeee8eeeeee8888ee8888eeeeee8eeeeeeeee8eeee8eeeee999f922422244eee22080208088eeeee
222244222242222224222222242222222222242222444444eeee88eeeee0888ee8880eeeee88eeeeeeee888ee888eeeeffff22224222eeee55888888855eeeee
22224442222422222242222224422222222224422224444ee888888eeee8888ee8888eeee888888ee8e8880ee0888e8e999f422224eeeeeee255555554eeeeee
f422222222244422222222222244222222222244222224eee888888eee88808ee80888eee888888ee88880eeee08888efffff422224eeeeee224444444eeeeee
f999424242224442222222222244422222222222222eeeeee000880ee8880e0ee0e0888ee088000ee8880eeeeee0888e9ff992422244eeeeeee22222eeeeeeee
ffffff24444224444222222222444eeeeee22222eeeeeeeeeeee80eee080eeeeeeee080eee08eeeee8888eeeeee8888efff942422444eeeeeeeeeeeeeeeeeeee
99999f222224e244eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eeeee0eeeeeeeeee0eeeee0eeeee0000eeeeee0000e9994422424eeeeeeeeeeeeeeeeeeeeee
eeeeeffeeffeeeeeeffeeeeeeeeeff7777ffeeeeeffeeeeee4eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4eff2224224eeeeeeeeeeeeefefefeeeee
eeeef24ee24feeeee44eeeeeeeff77766677ffeee67eeeeee449eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee944ef22224444eeeeeeeeeeeff5f5f5feeee
eeef424ee244feeee22eeeeeff777666556677ffe67eeeeee4b449eeeeeeeeeeee444eeeeee444eeeeeeeeeeee944b4e22222244eeeeeeeeeeeff000000ffeee
fff4424ee2424fffe24eeeee7776667756556677e67eeeeee4bbb449eeeeeeeee4bbb444444bbb4eeeeeeeee944bbb4e22222224eeeeeeeeeeff0ff66ff0feee
2424424ee2222424effeeeee5566776755565566e66eeeeee4bbbbb4444444442bebebbbbbbebeb2444444444bbbbb4e2222222eee2eeeeeee5005f060f50eee
2422424ee2222224e44eeeee5577676665555655e55eeeeee4bbbbbbbbbbbbbb1bee99999999eeb1bbbbbbbbbbbbbb4e22222ee2eeeeeeeeeeee50505050eeee
2422224ee2222224e22eeeee0567667655655555e05eeeeeee4bebbbbbbbbbbb2e9949999994ee92bbbbbbbbbbbeb49e222eeeeeeeeeeeeeeeeee000000eeeee
2422e24ee22e2224e24eeeee5566766600556555e00eeeeeee4beebebebebebe1999499999949991ebebebebebeeb4eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
242eeeeeeeeee224e22eeeee057666eeee005565e56eeeeeeee4beeeeeeeeeee2999499ee9949992eeeeeeeeeeeb4eeeeeeeeeee42424242eeee5eeee5eeeeee
24eeeeeeeeeeee24e24eeeee0566eeeeeeee0055e05eeeeeeee949eeeeeeeeee929949eeee949929eeeeeeeeee949eeeeeeeeeee22222222e25505555225eeee
22eeeeeeeeeeee22e22eeeee00eeeeeeeeeeee00e00eeeeeeeeee449eeeeeeeee49e94eeee49e94eeeeeeeee944eeeeeeeeeeeee22222222552050505050eeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4ee99ee99ee4eeeeeeeeeeeeeeeeee4444444411111111e20005050005eeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebbbbbbbbeeeeeeeee2200000002eeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99999999eeeeeeeeeee2222222eeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99999999eeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99999999eeeeeeeeeeeeeeeeeeeeeeee
00000eee00000050eee0000ee000000eee0000eeeeeeeeeeeddddddeeeddddeeeeddddeeeeddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000
04440eee0666660e0000440e06757770e095590e7777eeeedddddd1deddddddeeddddddeeddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000
02240eee055555500440240e05507066055555501171eeeeddddd111dddd001eddd0004eddd0004eeeddd4eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000
02240eee00000240024024000675756609555590e71e6777dddd100eddd00014dd00004edd00004eed00004eeeddddeeeeeeeeeeeeeeeeeeeeeeeeee00000000
022440eeee05024402400240005005660555555077771171dd10110edd00004ed00001eed00001eedd00001eedd00014eeeeeeeeeeeeeeeeeeeeeeee00000000
0222440eeee002440224099005760575209559021111e71e11101e44dd1001eed10001eed10001eed100041edd000004ed1141d4eeeeeeeeeeeeeeee00000000
02222440eeee022209990000e0505550e200002eeeee7777e141eeeeed14eeeee11144eee11144eed110411ed000401ed1004014eddd4dd4edd14d1400000000
00000000eeee000000000eeeee00000eee2222eeeeee1111ee4eeeeeeeee4eeeeeeeeeeeeeeeeeeed11111eed000411ed1000000d1004004dd10400400000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebbeeeef8feeeeef8feeeeef8feeeeeeeeeeeeeeee81eeeeeeeeeeeeeeeeee2beeeeeee
eee2eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee992beee288feeee288feeee288feeeee0e55e0eee881eeeeeeeeeeeeeeeee299beeeeee
ee4242eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2494beeee288feeee288feeee288feee55000eeee8881eeeeeeeeeeeeeeeeee29eeeeeee
ee4224eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee42249eeeeee282eeeee282eeeee288eeeeee5e0ee88888881eeeeeeeeeeeeeee24eeeeeee
e2242eee42222eeeeeeeeeeeeeeeeeeeeeeeeeeeeebbeeeeeeeeebb9944bbeeeeee200eeeee200eeeee2a9ee05eeeee018881111eeeeeeeeeeee444444444eee
e44e22422bbbb2eeeeeeeeeeeeeeeeeeeeeeeeeee244bbeeeeebb99999bbbbeeeeee2e0eeeee2e0eeeee2e9eeeee05eee1881eeeeeeeeeeeeee49999999994ee
eee4222bbffffb2eeeeeeeeeeeeeeeeeeeeeeeeee22444bbeeb999494999bbbe9a0eee0eeeeeee0eeeeeeeeeee5eeeeeee181eeeeeeeeeeeee4f999999999b4e
ee422bbffff24f2eeeeeeeeeeeeeeeeeeeeeeeeeeee2444beb999222999bbbbeeee000eeeeee9aeeeeeeeeeeeeeeeeeeeee11eeeeeeeeeeee249999999999b4e
e42bb99994f2f2b2eeeeeeeeeeeeeeeeeeeeeeeeee24422ee999299949999bbb00000eee00000050eee2222ee222222eee2222eeeeeeeeeee24f229929229b4e
42299429f2f42ff2eeeeeeeeeeeeeeeeeeeeeeeeee244eeeb9999229999bbbbb04440eee0666660e2222ff2e29f4fff2e2f44f2e7777eeeee249492949492b4e
24299292924f2fff2eeeeeeeeeeeeeeeeeeeeeeee244eeee49949992999999bb02240eee055555502ff29f2e2442f299244444421171eeeee24f429f49424b4e
22429242992fffff2eeeeeeeeeeeeeeeeeeeeeeee244eeee499922249999bbbb02240eee0000024029f29f2229f4f4992f4444f2e71e6777e249492949499b4e
242299292ffffffff2eeeeeeeeeeeeeeeeeeeeee244eeeee4999494999999999022440eeee05024429f229f2224224992444444277771171e24fffff9f999b4e
e24229499999fffff2eeeeeeeeeeeeeeeeeeeeee244eeeee2449999999999b420222440eeee00244299f299224f924f4e2f44f2e1111e71ee249999999999b4e
e224299999ffffffff2eeeeeeeeeeeeeeeeeeee244eeeeeee22449999999922e02222440eeee022229992222e2424442ee2222eeeeee7777e24ffffffff9fb4e
ee22429999999fffff2eeeeeeeeeeeeeeeeeeee244eeeeeeeee2222222222eee00000000eeee000022222eeeee22222eeeeeeeeeeeee1111e22222222222222e
ee242299999ffffffff2eeeeeeeeeeeeeee2bb244eeeeeeefffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eee24229999999fffff2eeeeeeeeeeeeee2fffbb4eeeeeee8888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eee224299999ffffffff2eeeeeeeeeeeee2f99ffbeeeeeee2888882eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eeee22429999999fffff2eeeeeeeeeeee2f99999fbeeeeeef28882feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eeee242299999ffffffff2eeeeeeeeeee2fff999fbeeeeeeef282feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eeeee22229999999fffff2eeeeeeeeee2f99999fbeeeeeeeeef2feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
eeeee222229999ffffffff2eeeeeeeee2ffff99fbeeeeeeeeeefeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee65eeeee
e2e22222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee655eeee
33333333333333333333333333333333eeeffeeeefeeeefeeefffeeeeeeeefeeeeeeeeeeffffffff44444eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee655eeee
3bb33bbb3b3b33b33b33b3b3bbb3bb33eef42ffef2ffff2fef444feeeeeef2fffeeeeeee9999f9999922444eeeeeeeeeeeeeee44444ee44eeeeeeeeee655eeee
3b3b3b333b3b3b3b3b33b3b3b333b3b3eef42f4ff224442ff44442feeeef2222feeeeeeefffffffffffff24444ffeeeeeeee444444444444eeeeeeeee655eeee
3bb33bb33b3b3b3b3b33b3b3bb33bb33eff42f2feff244fef24222feeff22222feeeeeee9999999f99999f24444ffeeeeee44441111114444444444ee655eeee
3b3b3b333b3b3b3b3b33b3b3b333b3b3f4f4222feef2244ff42222fee4222ffffeeeeeeefffffffffffffff24444feeeeee444111144444422222244e655eeee
3b3b3bbb3bb333b33bb3bb33bbb3b3b3f2f42ffeeeee222ff44222fee4242fef4feeeeee9f99f999f99999944442feeeeee441114444442222222222e655eeee
33333333333333333333333333333333ef222feeeeeffeeef24222fee2224ff42feeeeeefffffffffffffff24444ffeeeee411144442200002222222e655eeee
33333333333333333333333333333333eef42feeeff44feeee222eeee222244f2feeeeeef999999f9999222244444feeeee11144420000000022222ee655eeee
33333333333333333333333333333333eef42feef44444feeeeffeeeefff2fff2feeeeeefffffffffff4422224444feeeee1144207770000770222eee650eeee
3bb33bbb3b3b33b33b33b3b3bbb3bb33eef42feef244444feff44feeeeef2fef2feeeeee9f999999f22444222244ffeeeee444007077700707722eeee670077e
3b3b3b333b3b3b3b3b33b3b3b333b3b3eeeefeeef224422ff44444feeeef2fefffeeeeeefffffff22224444222ffffeeee442000707770070770eeeee675005e
3bb33bb33b3b3b3b3b33b3b3bb33bb33eeef4feef222222ff244444feeefffffeeeeeeeef9999f2222224444ffffffeeee422000077770007700eeeee6507777
3b3b3b333b3b3b3b3b33b3b3b333b3b3ffff2ffff222222ff4244444fef44444feeeeeeefffff2242222444fffffffeee42220000000000000000eeee7007666
3b3b3bbb3bb333b33bb3bb33bbb3b3b3f422222fee22222ef4224422fe4fffff4feeeeee9999222442222fffffffffeee22200007700000000070eeee7007776
33333333333333333333333333333333ef42222feee22eeef442222feefef442feeeeeeefffff222442fffffffffffeee222000077077707770700eee7706666
33333333333333333333333333333333eeff2ffeefeefeeef424222feeeeefffeeeeeeeeeeeeeee244ffffffffffffeee222000007077707770700eec7700006
33333333333333333333333333333333ef42222ff4ff2ffef424222feeeeeeee00000000000000000000000000000000eeee000000077707770000ecc7770006
3bb33bbb3b3b33b33b33b3b3bbb3bb33eef4222fef2fff4ff444222feeeeeeee00000000000000000000000000000000eeeed00000007707700000ccc7770006
3b3b3b333b3b3b3b3b33b3b3b333b3b3eeef2ffeeefef2fef444222feeeeeeee00000000000000000000000000000000eeedc00000000000000000cccc770000
3bb33bb33b3b3b3b3b33b3b3bb33bb33eeef2feeeeeeefeef444222feeeeeeee00000000000000000000000000000000eedccc000000000000000ccccc10000e
3b3b3b333b3b3b3b3b33b3b3b333b3b3eeef2feeeeeeffffef44222feeeeeeee00000000000000000000000000000000edcccccc0000000000000ccccc16661d
3b3b3bbb3bb333b33bb3bb33bbb3b3b3eeef2feeffff222feef422feeeeeeeee00000000000000000000000000000000eccccccccc00000000001ccccc16611d
33333333333333333333333333333333eefffeeef222ff2feeeeefeeeeeeeeee00000000000000000000000000000000eccccccccccc000000001ccccc161111
33333333333333333333333333333333eff4ffeef2ff222feeeef4feeeeeeeee00000000000000000000000000000000ecccccccccccc000000ccccccc111111
33333333333333333333333333333333ef422feef222ff2fefef442feeeeeeee00000000000000000000000000000000ecccccccccccccc0000cccccccc11111
3bb33bbb3b3b33b33b33b3b3bbb3bb33eff2ffeef2ffef2ff4ff422feeeeeeee00000000000000000000000000000000ecccccccccccccccccccccccccc11111
3b3b3b333b3b3b3b3b33b3b3b333b3b3ff422ffef2feef2feffff22feeeeeeee00000000000000000000000000000000eccccccccccccccccccccccccccc1111
3bb33bb33b3b3b3b3b33b3b3bb33bb33f42222fef2feeeeeeef2fffeeeeeeeee00000000000000000000000000000000ecccccccccccccccccccccccccccc111
3b3b3b333b3b3b3b3b33b3b3b333b3b3f42222fefffffeeeeeeeeeeeeeeeeeee00000000000000000000000000000000eccccccccccccccccccccccccccccc11
3b3b3bbb3bb333b33bb3bb33bbb3b3b3f42222fef4f4feeeeeeeeeeeeeeeeeee00000000000000000000000000000000eccccccccccccccccccccccccccccc11
33333333333333333333333333333333f42222fef222feeeeeeeeeeeeeeeeeee00000000000000000000000000000000eeccccccccccccccccccccccccccccc1
33333333333333333333333333333333f422eeef44444feeeeeeeeeeeeeeeeee00000000000000000000000000000000eecccccccccccccccccccccccccccccc
__label__
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv4vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv4vvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv000000000vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv8vvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv00888888800vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv0088888888800v2vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv00888888888880vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv000000vvvvvvvvvv08888888888880vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvv0000000000vvvvvvvvvvvvvvvvv088880vvvvvvvvv008888800888880vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv008888888800vvvvvvvvvvvvvvv00888800vvv00000008888800888880vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvv00888888888800vvvvvvvvvvvvvv00888880vvv088880088888008888800000000v000000vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvv008888888888880vvvvvvvvvvvvvv008888800v0088880088888000000000888880v0888800vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvv0888888888888800000000v000000008888880v008888008888800000000088888000888880vvvvvvvvvvvvvvvvvvv4vvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv00888880008888800888880v0888880088888800008888008888800000000088888000888880vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv008888800088888008888800088888008888888000888800888880vvvvvv0088888000888880vvv0000000000vvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv008888800088888008888800088888008888888000888800888880vvvvvv0088888000888880vv008888888800vvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv008888800000000008888800088888008888888800888800888880vvvvvv0088888000888880v00888888888800vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv008888800000000008888800088888008888888800888800888880vvvvvv0088888000888880008888888888880vvvvvvvvvvvvvvv8vv
vvvvvvvvvvvvvvvvvvv0088888000000000088888000888880088888888808888008888800000000088888000888880088888888888880vvvvvvvvvvvvvv888v
vvvvvvvvvvvvvvvvvvv0088888088888000088888000888880088880888808888008888800888880088888888888880088888000888880vvvvvvvvvvvvvvv8vv
vvvvvvvvvvvvvvvvvvv0088888088888800088888000888880088880888888888008888800888880088888888888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0088888088888880088888000888880088880088888888008888800888880088888888888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0088888088888880088888000888880088880088888888008888888888880088888888888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0088888000888880088888000888880088880008888888000888888888880088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0088888000888880088888000888880088880008888888000088888888800088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0088888888888880088888000888880088880000888888000008888888000088888000888880088888000888880vvvvvvvvvvvvvvvv2v
vvvvvvvvvvvvvvvvvvv0008888888888880088888000888880088880000888888000000000000000088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv00008888888888800888888888888800888800000888880v00000000000v0088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvv0000088888888880088888888888880000000v000888880vv000000000vv0088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv5vvvv00000000008888008888888888888000000vv000088880vvvvvvvvvvvvv0088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvv555vvvv00000000008880008888888888800000001110008888041111111111110088888000888880088888000888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv5vvvvvv0000000000880000888888888001111111110000000044111111111110000000000000000088888888888880vvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvv4vvv0000080000088888880006777777777000000747777777777770000000v00000000088888888888800vv8vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvv444vvv000000000000000000066777777777000000777777777777770000000v0000000000888888888800vv888vvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvv4vvvvv0000vv00000000000166777777777777777777777777777777777711vvvvvvvv000088888888000vvv8vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv000vvv0000000001166777777777777777777777777777777777711vvvvvvvv00000000000000vvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111111166557711117711661111661111771166777711vvvvvvvvv000000000000vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111111166557711117711661111661111771166777711vvvvvvvvvv0000000000vvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166661166115566557711117711771166771111777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv11111vvv111111111111111111661111111111111111117711111111111111111111111v1111111111111vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv17771vvv171717771711177111111717177711771777117717771177117717171777171v1777171717771vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv17171vvv171711711711171711111717171117111171117717171717171117171711171v1171171717111vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv17771vvv171711711711171717771717177117771171777717711717171117171771171vv17117711771vvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv17171vvv17771171171117171777177717111117117177771717171717171717171117111171171717111vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv17171vvv17771777177717771777177717771771117177771717177117771177177717771777171717771vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvv11111vvv11111111111111111777111111111111711177771111111111111111111111111111111111111vvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777777777777777777777777777777777777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv8vvvvvvvvvvvvvvvvvvvvvvvv1166777777777777777777777777777777777777777751vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvv888vvvvvvvvvvvvvvvvvvvvvvv1177777711111111111111111111111111111177777555vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv8vvvvvvvvvvvvvvvvvvvvvvvv1177777711111111111111111111111111111177777751vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177787711777777777711111177777777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177858711777777777711111177777777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177787711777777771166666611777777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711777777771166666611777777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711777777771166666611777777771177776611vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711777777771166666611777777771177776611vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777711777777111166666611117777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777711777777111166666611117777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711661166666611661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711661166666611661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711665500000055661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711665500000055661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711666666666666661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711777711666666666666661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777711777711550077007700551177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777711777711550077007700551177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777777117777115500000000005511777711777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777777117777115500000000005511777711777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711777777110077777700117777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711777777110077777700117777771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111777711777711660000000000661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111777711777711660000000000661177771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666600000066666611771177777411vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666600000066666611771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666666666666666611771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666666666666666611771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666666666666666611771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711771166666666666666666611771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711111111111111111111111111111177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1177777711111111111111111111111111111177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777777667777777777777777777777777777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1166777777667777777777777777777777777777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711111177117777117777117777117777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11777711111177117777117777117777117777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117711557777117711775555771155771177771111vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117711557777117711775555771155771177771111vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11667777551177117711771155771155771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv11667777551177117711771155771155771177777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117711111177117777117777117777117777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117711111177117777117777117777117777777711vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117777667777777777777777777777777777776611vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv117777667777777777777777777777777777776611vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111111111111111111111111111111111111111vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv1111111111111111111111111111111111111111vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

__map__
6667676767687c7c7c7c696a6a6a6a6b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7600000000780000000079000000007b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300000017400177007750c70000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500000e663306730547518771010401f041181311f1211811000015000000020009130126301373111525002000020000200051300c6300d7210a525002000020000200021300761009711065150020000000
010400001275113751167511d7561d700227000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
010200001d751157510c7500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400001a5330e555005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503
01060000110511a1511d1550010400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004
010600001d7510e751117550070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0005000031670176311b2110060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
01040000057210f7212f62500701057210f7212f62500000000000000000000057210f7212f625007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701
a906000013773146221f7732c6111f7732c6712067120671146511464108631086210020000200002000020000200002000020000200002000020000200002000020000200002000020000200000000000000000
9d0a00002464418333006230031500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
510700003545300000054720545500400054720543500400004000040000400004000040000400004000040000400004000040000400004000040000000004000040000400004000040000400000000000000000
010800000c6540c100131411315500100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
590200000467400133026311e37500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000000
03050000086540e430066550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050000333550d6500e7550000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105000026656111510d1311f131181311f1311810018500222000020009100126001350011500002000020000200051000c6000d5000a5000020000200002000210007600095000650000200002000020000200
010400000c1540c53118521185250c500267502675226755007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000000000000
5107000000464196550045419655004540c645000001960000464196450046419645004640c635000000060000434196350043419635004340c625000000060000414196250041419625004140c6150060000600
01070000211702115526170261552610021170211552617026160261622615226152261522613226120261251f1001d1001c1001a1001810117101111011310111101101010e1010c1010a1000a1000a10500000
010700000677006770067600676007751087510a7410d7410e1411174113141167411a1311f731261250070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0108000011550115521154211542115321153211525005000f5500f5520f5420f5420f5320f5320f5250050011550115521154211542115321153211525005000c5500c5420c5320c5320c5220c5220c51500500
4d0400001c5441c034113250c60000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000188650c85500855008050c865008550c85500805188650c8550c855008050c865008550c85500805188650c85500855008050c865008550c85500805188650c85500855000000c865008550c85500000
011000001085000800008000000000000000001885000000188500000018800008000c8000080000800008001885000800008000000000000000001885000000188500080018850008000c800008000080000800
01100000000000000004155041550315500155040001b100000000015507155181050715516105071550f10516100161000a1550a155071550715500000000000f10004155051550f100051550f1000515500000
01100000001551f105001551d100001551b1001b1001b10007155181050715516105071550f10516100161000a155131000a155111000a155111000f1000f100051550f100051550f100051550c1000c1000b100
01100000001551f105001551d100001551b1001b1001b10007155181050715516105071550f10516100161000a155131000a155111000a155111000f1000f100051550f100051550f10005150051550415500000
011000000015500155041551d100071551b1001b1001b100071551810509155161050c1550f10516100161000a155131000a155111000a155111000f1000f100051550f100051550f10005150051550415500000
011000000c1450c1350c125000000000000000000000c1350e1350c1250c125161001610000000151000c1350c1450c1350c1200c1250e10000000000000e1350c1250c1450c1300c1350010000100151000c135
910e00000243500400024350243502435004000243502435024350040002435024350243502435024350243502435004000243502435024350040002435024350243500400024350243502435024350243502435
010e00000e265002000e2650e2650e265002000e265002000e2650e2650e2650e2650e265002000e2650020013260132601326013265172601726017260172601726500200002000020000200002000020000200
010e00000e2650e1000e2650e2650e265002000e265002000e2650e2650e2650e2650e2600e2600e265182000e265002000e2650e265102601026512260122651326013260132601326013262132621326213265
010e00000713007135131000010002130021350010000100071300713513100001000213002135001000010007130071351310000100021300213500100001000713007135131000010002130021350010000100
010e00000913009135131000010002130021350010000100091300913513100001000213002135001000010009130091351310000100021300213502130021350713007135131000010002130021350010000100
010e00000e0700e0700e0700e0700e0600e0600e0500e05526024260302603026030260302604026040260450000000000000001306013060130601306013065180601806018060180651c0601c0601c0601c060
010e000013265002001326513265132650020013265002001326513265132651326513265002001326500200182601826018260182651c2601c2601c2601c2601c26500200002000020000200002000020000200
010e000013265002001326513265132650020013265002001326513265132651326513265002001326500200182601826018260182651c2601c2601c2601c2601c26500200002000020000200002000020000200
010e0000132650e100132651326513265002001326500200132651326513265132651326013260132651820013265002001326513265152601526517260172651826018260182601826018262182621826218265
910e00000743500400074350743507435004000743507435074350040007435074350743507435074350743507435004000743507435074350040007435074350743500400074350743507435074350743507435
010e00000013000135131000010007130071350010000100001300013513100001000713007135001000010000130001351310000100071300713500100001000013000135131000010007130071350010000100
010e00000213002135131000010007130071350010000100021300213513100001000713007135001000010002130021351310000100071300713507130071350013000135131000010007130071350010000100
010e000018260182601c2311c23013231132301323213235132301323018231182301023110230102301023510230102351323013235182301823515230152351a2301a2301a2301a2321a235000000000000000
910e00000c43500400074000740007400000000c435074000743500000000000000000000000000743500000074350000000000000000743500000074000000000000000000e435000000e435000000e43500000
010e00000c1300c135131000010007100071000c1300c1350703007035131000010007100071000703007035070300703513100001001303013035071000710000100001000e0300e0350e0300e0350e0300e035
__music__
01 29424344
01 286a4344
00 282b4344
00 282c4344
00 282d4344
02 282c4344
01 2f747244
01 2f707244
00 2f303244
00 2f313344
00 38363944
00 38373a44
02 3c3b3d44

