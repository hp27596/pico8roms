pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--advanced micro platformer
--@matthughson

--if you make a game with this
--starter kit, please consider
--linking back to the bbs post
--for this cart, so that others
--can learn from it too!
--enjoy!
--@matthughson

--log
-- printh("\n\n-------\n-start-\n-------")

--config
--------------------------------

--sfx
snd=
{
	jump=0,
	throw=1,
	pullback=2,
	catch=3,
	pulltowards=4,
}

--music tracks
mus=
{

}

--math
--------------------------------

-- --point to box intersection.
-- function intersects_point_box(px,py,x,y,w,h)
-- 	if flr(px)>=flr(x) and flr(px)<flr(x+w) and
-- 				flr(py)>=flr(y) and flr(py)<flr(y+h) then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

-- --box to box intersection
-- function intersects_box_box(
-- 	x1,y1,
-- 	w1,h1,
-- 	x2,y2,
-- 	w2,h2)

-- 	local xd=x1-x2
-- 	local xs=w1*0.5+w2*0.5
-- 	if abs(xd)>=xs then return false end

-- 	local yd=y1-y2
-- 	local ys=h1*0.5+h2*0.5
-- 	if abs(yd)>=ys then return false end

-- 	return true
-- end

--check if pushing into side tile and resolve.
--requires self.dx,self.x,self.y, and
--assumes tile flag 0 == solid
--assumes sprite size of 8x8
function collide_side(self)
	local offset=self.w/3
	for i=-(self.w/3),(self.w/3),2 do
	--if self.dx>0 then
		if fget(mget((self.x+(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.x=(flr(((self.x+(offset))/8))*8)-(offset)
			return true
		end
	--elseif self.dx<0 then
		if fget(mget((self.x-(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.x=(flr((self.x-(offset))/8)*8)+8+(offset)
			return true
		end
--	end
	end
	--didn't hit a solid tile.
	return false
end

--check if pushing into floor tile and resolve.
--requires self.dx,self.x,self.y,self.grounded,self.airtime and
--assumes tile flag 0 or 1 == solid
function collide_floor(self)
	--only check for ground when falling.
	if self.dy<0 then
		return false
	end
	local landed=false
	--check for collision at multiple points along the bottom
	--of the sprite: left, center, and right.
	for i=-(self.w/3),(self.w/3),2 do
		local tile=mget((self.x+i)/8,(self.y+(self.h/2))/8)
		if fget(tile,0) or (fget(tile,1) and self.dy>=0) then
			self.dy=0
			self.y=(flr((self.y+(self.h/2))/8)*8)-(self.h/2)
			self.grounded=true
			self.airtime=0
			self.jump_in_air=false
			landed=true
		end
	end
	return landed
end

--check if pushing into roof tile and resolve.
--requires self.dy,self.x,self.y, and
--assumes tile flag 0 == solid
function collide_roof(self)
	--check for collision at multiple points along the top
	--of the sprite: left, center, and right.
	for i=-(self.w/3),(self.w/3),2 do
		if fget(mget((self.x+i)/8,(self.y-(self.h/2))/8),0) then
			self.dy=0
			self.y=flr((self.y-(self.h/2))/8)*8+8+(self.h/2)
			self.jump_hold_time=0
		end
	end
end

function h_collide_roof(self)
	local offset=self.w/3
	for i=-(self.w/3),(self.w/3),2 do
		if fget(mget((self.x+i)/8,(self.y-(self.h/2))/8),0) then
			self.dy=0
			self.dx=0
			self.y=flr((self.y-self.h/2)/8)*8+8+self.h/2-1/3
			-- unstuck
			if self.pulled_back or self.held then
				self.y=flr((self.y-self.h/2)/8)*8+8+self.h/2
			end
			return true
		end
	end
 return false
end

function h_collide_floor(self)
	for i=-(self.w/3),(self.w/3),2 do
		local tile=mget((self.x+i)/8,(self.y+(self.h/2))/8)
		if fget(tile,0) then
			self.dx=0
			self.dy=0
			self.y=(flr((self.y+(self.h/2))/8)*8)-(self.h/2)+1/3
			-- unstuck
			if self.pulled_back or self.held then
			 self.y=(flr((self.y+(self.h/2))/8)*8)-(self.h/2)-1/3
			end
			return true
		end
	end
	return false
end

function h_collide_x(self)
	local offset=self.w/3
	for i=-(self.w/3),(self.w/3),2 do
	--if self.dx>0 then
		if fget(mget((self.x+(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.dy=0
			self.x=(flr(((self.x+(offset))/8))*8)-offset
			-- unstuck
			if self.pulled_back or self.held then
			 self.x=(flr(((self.x+(offset))/8))*8)-offset-1
			end
			return true
		end
	--elseif self.dx<0 then
		if fget(mget((self.x-(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.dy=0
			self.x=(flr((self.x-(offset))/8)*8)+8+(offset)
			if self.pulled_back then
				self.x=(flr((self.x-(offset))/8)*8)+8+(offset)-7
			end
			return true
		end
--	end
	end
	--didn't hit a solid tile.
	return false
end


--make 2d vector
function m_vec(x,y)
	local v=
	{
		x=x,
		y=y,

  --get the length of the vector
		get_length=function(self)
			return sqrt(self.x^2+self.y^2)
		end,

  --get the normal of the vector
		get_norm=function(self)
			local l = self:get_length()
			return m_vec(self.x / l, self.y / l),l;
		end,
	}
	return v
end

-- --square root.
-- function sqr(a) return a*a end

-- --round to the nearest whole number.
-- function round(a) return flr(a+0.5) end


--utils
--------------------------------

--print string with outline.
function printo(str,startx,
															 starty,col,
															 col_bg)
	print(str,startx+1,starty,col_bg)
	print(str,startx-1,starty,col_bg)
	print(str,startx,starty+1,col_bg)
	print(str,startx,starty-1,col_bg)
	print(str,startx+1,starty-1,col_bg)
	print(str,startx-1,starty-1,col_bg)
	print(str,startx-1,starty+1,col_bg)
	print(str,startx+1,starty+1,col_bg)
	print(str,startx,starty,col)
end

--print string centered with
--outline.
function printc(
	str,x,y,
	col,col_bg,
	special_chars)

	local len=(#str*4)+(special_chars*3)
	local startx=x-(len/2)
	local starty=y-2
	printo(str,startx,starty,col,col_bg)
end

--objects
--------------------------------

--make the player
function m_player(x,y)

	--todo: refactor with m_vec.
	local p=
	{
		x=x,
		y=y,

		dx=0,
		dy=0,

		w=8,
		h=8,

		max_dx=2,--max x speed
		max_dy=4,--max y speed

		jump_speed=-2.5,--jump velocity
		acc=0.7,--acceleration
		dcc=0.5,--decceleration
		air_dcc=0.2,--air decceleration
		grav=0.8,

		--helper for more complex
		--button press tracking.
		--todo: generalize button index.
		jump_button=
		{
			update=function(self)
				--start with assumption
				--that not a new press.
				self.is_pressed=false
				if btn(5) then
					if not self.is_down then
						self.is_pressed=true
					end
					self.is_down=true
					self.ticks_down+=1
				else
					self.is_down=false
					self.is_pressed=false
					self.ticks_down=0
				end
			end,
			--state
			is_pressed=false,--pressed this frame
			is_down=false,--currently down
			ticks_down=0,--how long down
		},

		jump_hold_time=0,--how long jump is held
		min_jump_press=5,--min time jump can be held
		max_jump_press=5,--max time jump can be held

		jump_btn_released=true,--can we jump again?
		grounded=false,--on ground

		airtime=0,--time since grounded

		--animation definitions.
		--use with set_anim()
		anims=
		{
			["stand"]=
			{
				ticks=1,--how long is each frame shown.
				frames={2},--what frames are shown.
			},
			["walk"]=
			{
				ticks=5,
				frames={3,4,5,6},
			},
			["jump"]=
			{
				ticks=1,
				frames={1},
			},
			["slide"]=
			{
				ticks=1,
				frames={7},
			},
		},

		curanim="walk",--currently playing animation
		curframe=1,--curent frame of animation.
		animtick=0,--ticks until next frame should show.
		flipx=false,--show sprite be flipped.

		jump_cd=0,
		jump_in_air=false,
		stuck_roof=0,

		--request new animation to play.
		set_anim=function(self,anim)
			if(anim==self.curanim)return--early out.
			local a=self.anims[anim]
			self.animtick=a.ticks--ticks count down.
			self.curanim=anim
			self.curframe=1
		end,

		--call once per tick.
		update=function(self, hcx, hcy, hx, hy, pt)

			--track button presses
			local bl=btn(0) --left
			local br=btn(1) --right

			if pt then
				self.max_dx=6
				self.max_dy=6
				if(abs(hx-self.x)>4) self.dx+=1*(hx-self.x)/abs(hx-self.x)
				if(abs(hy-self.y)>4) self.dy+=1*(hy-self.y)/abs(hy-self.y)
			else
				if(self.max_dx>2) self.max_dx-=0.5
				if(self.max_dy>4) self.max_dy-=1
				self.dy+=self.grav
			--move left/right
				if bl then
					if hcx then
						self.dx=0
						self.x=hx+2
					else
						self.dx-=self.acc
						br=false--handle double press
					end
				elseif br then
					if hcx then
						self.dx=0
						self.x=hx-3
					else
						self.dx+=self.acc
					end
				else
					if self.grounded then
						self.dx*=self.dcc
					else
						self.dx*=self.air_dcc
					end
				end

			end

			--limit walk speed
			self.dx=mid(-self.max_dx,self.dx,self.max_dx)

			--move in x
			self.x+=self.dx

			--hit walls
			collide_side(self)

			--jump buttons
			self.jump_button:update()

			-- if hcy then self.stuck_roof=20 end
			if(self.stuck_roof>0) then self.stuck_roof-=1 end

			--jump is complex.
			--we allow jump if:
			--	on ground
			--	recently on ground
			--	pressed btn right before landing
			--also, jump velocity is
			--not instant. it applies over
			--multiple frames.
			if(self.jump_cd>0) self.jump_cd-=1

			if self.jump_button.is_down and not hcy then
				--is player on ground recently. and didn't press jump button
				--allow for jump right after
				--walking off ledge.
				local on_ground=((self.grounded or (self.airtime<5)) and self.dy>=0 and self.stuck_roof==0)
				--was btn presses recently?
				--allow for pressing right before
				--hitting ground.
				local new_jump_btn=self.jump_button.ticks_down<10
				--is player continuing a jump
				--or starting a new one?
				if (self.jump_hold_time>0 or (on_ground and new_jump_btn) or (not self.jump_in_air and new_jump_btn)) and self.jump_cd==0 then
					-- double jump
					if not self.jump_in_air and self.jump_button.is_pressed and self.airtime>1 then self.jump_in_air=true end

					--start new jump
					if(self.jump_hold_time==0)sfx(snd.jump)--new jump snd
					self.jump_hold_time+=1
					--keep applying jump velocity
					--until max jump time.
					if self.jump_hold_time<self.max_jump_press then
						self.dy=self.jump_speed--keep going up while held
					end
				end
			else
				self.jump_hold_time=0
			end

			--move in y
			if hcy then
				self.dy=0
				self.y=hy+4
				self.jump_cd=8
				self.stuck_roof=15
			end

			-- if pt then
			-- 	self.max_dx=10
			-- 	self.max_dy=10
			-- 	if(abs(hx-self.x)>4) self.dx+=20*(hx-self.x)/abs(hx-self.x)
			-- 	if(abs(hy-self.y)>4) self.dy+=20*(hy-self.y)/abs(hy-self.y)
			-- else
			-- 	self.max_dx=2
			-- 	self.max_dy=3
			-- 	self.dy+=self.grav
			-- end

			self.dy=mid(-self.max_dy,self.dy,self.max_dy)
			self.y+=self.dy


			--floor
			if not collide_floor(self) then
				self:set_anim("jump")
				self.grounded=false
				self.airtime+=1
			end
			-- roof
			collide_roof(self)

			--handle playing correct animation when
			--on the ground.
			if self.grounded then
				if br then
					if self.dx<0 then
						--pressing right but still moving left.
						self:set_anim("slide")
					else
						self:set_anim("walk")
					end
				elseif bl then
					if self.dx>0 then
						--pressing left but still moving right.
						self:set_anim("slide")
					else
						self:set_anim("walk")
					end
				else
					self:set_anim("stand")
				end
			end

			--flip
			if br then
				self.flipx=false
			elseif bl then
				self.flipx=true
			end

			--anim tick
			self.animtick-=1
			if self.animtick<=0 then
				self.curframe+=1
				local a=self.anims[self.curanim]
				self.animtick=a.ticks--reset timer
				if self.curframe>#a.frames then
					self.curframe=1--loop
				end
			end

			-- px=self.x
			-- py=self.y
			-- pflip=self.flipx
		end,

		--draw the player
		draw=function(self)
			local a=self.anims[self.curanim]
			local frame=a.frames[self.curframe]
			spr(frame,
				self.x-(self.w/2),
				self.y-(self.h/2),
				self.w/8,self.h/8,
				self.flipx,
				false)
		end,
	}


	return p
end

function m_hammer(x,y)
 local h=
	{
		x=x,
		y=y,

		dx=0,
		dy=0,

		w=8,
		h=8,

		max_dx=4,--max x speed
		max_dy=4,--max y speed

		jump_speed=-2.5,--jump velocity
		acc=0.5,--acceleration
		dcc=0.5,--decceleration
		air_acc=0.2,
		air_dcc=0.2,--air decceleration
		grav=0.6,

		throw_button=
		{
			update=function(self)
				--start with assumption
				--that not a new press.
				self.is_pressed=false
				if btn(4) then
					if not self.is_down then
						self.is_pressed=true
					end
					-- self.is_released=false
					self.is_down=true
					self.ticks_down+=1
				else
					-- self.is_released=true
					self.is_down=false
					self.is_pressed=false
					self.ticks_down=0
				end
			end,
			--state
			-- is_released=true
			is_pressed=false,--pressed this frame
			is_down=false,--currently down
			ticks_down=0,--how long down
		},

		throw_hold_time=0,--how long throw button is held
		min_hold_press=3,--min time throw button can be held
		max_hold_press=15,--max time throw can be held

		throw_btn_released=true,--can we jump again?

		anims=
		{
			["held"]=
			{
				ticks=1,--how long is each frame shown.
				frames={18},--what frames are shown.
			},
		 ["rev"]=
			{
				ticks=1,--how long is each frame shown.
				frames={21},--what frames are shown.
			},
		 ["angle1"]=
			{
				ticks=1,--how long is each frame shown.
				frames={22},--what frames are shown.
			},
		 ["angle2"]=
			{
				ticks=1,--how long is each frame shown.
				frames={19},--what frames are shown.
			},
		 ["angle3"]=
			{
				ticks=1,--how long is each frame shown.
				frames={23},--what frames are shown.
			},
			["charge"]=
			{
				ticks=1,
				frames={17},
			},
			["throw"]=
			{
				ticks=3,
				frames={18,19,20},
			},
			-- ["turn"]=
			-- {
			-- 	ticks=3,
			-- 	frames={17,18,19},
			-- },
		 ["airfw"]=
			{
				ticks=1,
				frames={20},
			},
		 ["airbw"]=
			{
				ticks=1,
				frames={16},
			},
		},

		curanim="held",--currently playing animation
		curframe=1,--curent frame of animation.
		animtick=0,--ticks until next frame should show.
		flipx=false,--show sprite be flipped.

		--request new animation to play.
		set_anim=function(self,anim)
			if(anim==self.curanim)return--early out.
			local a=self.anims[anim]
			self.animtick=a.ticks--ticks count down.
			self.curanim=anim
			self.curframe=1
		end,

		thrown=false,
		air=false,
		pulled_back=false,
		pulled_towards=false,
		held=true,
		btn_pressed=false,
		btn_cooldown=0,
		forward=1,
		collided=false,
		upward=0,
		h_collided_x=false,
		h_collided_y=false,
		up=0,
		down=0,
		left=0,
		right=0,

		--call once per tick.
		update=function(self,px,py,pflip)

			-- btn_cooldown=0
			if(self.btn_cooldown>0) self.btn_cooldown-=1

			if self.held then
				-- held code
				self:set_anim("held")
				self.flipx=pflip
				if pflip then
					self.x=px-3
				else
					self.x=px+3
				end
				self.y=py-4

				self.h_collided_y=false
				if not pflip then
					if(btn(1)) self.h_collided_x=false
				else
					if(btn(0)) self.h_collided_x=false
				end
				-- collision while player holding the hammer
				if(h_collide_x(self)) self.h_collided_x=true
				if(h_collide_roof(self)) self.h_collided_y=true
			else
				self.h_collided_x=false
				self.h_collided_y=false
			end

			if(self.throw_button.is_pressed) self.btn_pressed=true -- we want the game to remember press input even when we pressed it on the hammer cooldown

			if self.held and self.btn_pressed and self.throw_button.is_down then
			 self.thrown=true
				self.throw_hold_time+=1
				self.btn_cooldown+=1
				-- charge animation
				self:set_anim("charge")
			end

			-- pity timer so that if you release the aim directions it's still aiming that way for a bit
			if(btn(2))	self.up=8
			if(btn(3)) self.down=8
			if(btn(1)) self.right=8
			if(btn(0)) self.left=8

			if(self.left>0) self.left-=1
			if(self.right>0) self.right-=1
			if(self.up>0) self.up-=1
			if(self.down>0) self.down-=1

			-- throw code
			if self.thrown and not self.pulled_back and not self.throw_button.is_down then
				if not self.air
then -- release frame
					if self.throw_hold_time>self.max_hold_press then
						self.throw_hold_time=self.max_hold_press
					elseif self.throw_hold_time<self.min_hold_press then
						self.throw_hold_time=self.min_hold_press
					end
					self.last_held_time=self.throw_hold_time
					sfx(snd.throw)--new throw snd
				 self.air=true
					self.throw_hold_time=0
					if not pflip then
						self.forward=1 self:set_anim("airfw")
					else
						self.forward=-1 self:set_anim("airfw")
					end

					-- aim the hammer
					self.upward=0
					if self.up>0 or self.down>0 then
						if(self.up>0) self.upward=1 self:set_anim("held")
						if(self.down>0) self.upward=-1 self:set_anim("rev")
						if self.right>0 then
							self.forward=1
							if(self.up>0) self:set_anim("angle2")
							if(self.down>0) self:set_anim("angle3")
						elseif self.left>0 then
							self.forward=-1
							if(self.up>0) self:set_anim("angle2")
							if(self.down>0) self:set_anim("angle3")
						else
							self.forward=0
						end
					end
				end

				self.dx+=self.acc*self.forward*self.last_held_time/10
				self.dy-=self.acc*self.upward*self.last_held_time/10
				-- throw code
				self.btn_pressed=false
				self.held=false
			end

			-- btn press to start pulling
			-- if self.thrown and self.air and self.btn_pressed and self.btn_cooldown==0 then
			if self.thrown and self.air then
				if btnp(3) then
					self.pulled_back=true
					sfx(snd.pullback)
				elseif self.btn_pressed and self.btn_cooldown==0 then
					self.pulled_towards=true
					sfx(snd.pulltowards)
				end
			end

			if self.pulled_towards then
				self.dx-=self.dx/8
				self.dy-=self.dy/8
			end

			if self.pulled_back then
				self.btn_pressed=false
				if (px-self.x)>4 then
					self.dx+=self.air_acc -- *ratio
					if(h_collide_floor(self) or h_collide_roof(self)) self.dx+=2*self.air_acc
				elseif (px-self.x)<-4 then
					self.dx-=self.air_acc -- *ratio
					if(h_collide_floor(self) or h_collide_roof(self)) self.dx-=2*self.air_acc
				else
					self.dx=0
				end

				if (py-self.y)>2 then
					self.dy+=self.air_acc -- /ratio
					if(h_collide_x(self)) self.dy+=8*self.air_acc
				elseif (py-self.y)<-2 then
					self.dy-=self.air_acc -- /ratio
					if(h_collide_x(self)) self.dy-=8*self.air_acc
				else
					self.dy=0
				end

				-- set animation for hammer returning
				if self.x>px then
					self.flipx=false
				else
					self.flipx=true
				end

				if self.dy>0 and self.y<py then
					-- unless too far away, don't change animation
					if self.dx==0 or abs(self.x-px)<16 then
						self:set_anim("rev")
					else
						self:set_anim("angle1")
					end
				elseif self.dy<0 and self.y>py then
					if self.dx==0 or abs(self.x-px)<16 then
						self:set_anim("held")
					else
						self:set_anim("charge")
					end
				elseif self.dy==0 or abs(self.y-py)>16 then
					if self.flipx then
						if self.dx<0 then
							self:set_anim("airfw")
						else
							self:set_anim("airbw")
						end
					else
						if self.dx>0 then
							self:set_anim("airfw")
						else
							self:set_anim("airbw")
						end
					end
				end
			end

			if self.air and (self.pulled_back or self.pulled_towards) and abs(px-self.x)<8 and abs(py-self.y)<8 then
				self.dx=0
				self.dy=0
				self.held=true
				self.pulled_back=false
				self.pulled_towards=false
				self.thrown=false
				self.air=false
				self.btn_pressed=false
				sfx(snd.catch)
			end

			-- if (btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(5)) then
			-- 	if(h_collide_roof(self) and self.held) self.y+=2
			-- 	-- if(h_collide_x)
			-- end

			--collision
			h_collide_x(self)
			h_collide_floor(self)
			h_collide_roof(self)

			-- throw button update
			self.throw_button:update()

			--limit walk speed
			self.dx=mid(-self.max_dx,self.dx,self.max_dx)
			self.dy=mid(-self.max_dy,self.dy,self.max_dy)

			--move in x
			self.x+=self.dx
			self.y+=self.dy

			--anim tick
			self.animtick-=1
			if self.animtick<=0 then
				self.curframe+=1
				local a=self.anims[self.curanim]
				self.animtick=a.ticks--reset timer
				if self.curframe>#a.frames then
					self.curframe=1--loop
				end
			end

		end,

		--draw the hammer
		draw=function(self)
			local a=self.anims[self.curanim]
			local frame=a.frames[self.curframe]
			spr(frame,
				self.x-(self.w/2),
				self.y-(self.h/2),
				self.w/8,self.h/8,
				self.flipx,
				false)
		end,

	}

	return h
end

--make the camera.
function m_cam(target)
	local c=
	{
		tar=target,--target to follow.
		pos=m_vec(target.x,target.y),

		--how far from center of screen target must
		--be before camera starts following.
		--allows for movement in center without camera
		--constantly moving.
		pull_threshold=16,

		--min and max positions of camera.
		--the edges of the level.
		pos_min=m_vec(64,64),
		pos_max=m_vec(320,64),

		shake_remaining=0,
		shake_force=0,

		update=function(self)

			self.shake_remaining=max(0,self.shake_remaining-1)

			--follow target outside of
			--pull range.
			if self:pull_max_x()<self.tar.x then
				self.pos.x+=min(self.tar.x-self:pull_max_x(),4)
			end
			if self:pull_min_x()>self.tar.x then
				self.pos.x+=min((self.tar.x-self:pull_min_x()),4)
			end
			if self:pull_max_y()<self.tar.y then
				self.pos.y+=min(self.tar.y-self:pull_max_y(),4)
			end
			if self:pull_min_y()>self.tar.y then
				self.pos.y+=min((self.tar.y-self:pull_min_y()),4)
			end

			--lock to edge
			if(self.pos.x<self.pos_min.x)self.pos.x=self.pos_min.x
			if(self.pos.x>self.pos_max.x)self.pos.x=self.pos_max.x
			if(self.pos.y<self.pos_min.y)self.pos.y=self.pos_min.y
			if(self.pos.y>self.pos_max.y)self.pos.y=self.pos_max.y
		end,

		cam_pos=function(self)
			--calculate camera shake.
			local shk=m_vec(0,0)
			if self.shake_remaining>0 then
				shk.x=rnd(self.shake_force)-(self.shake_force/2)
				shk.y=rnd(self.shake_force)-(self.shake_force/2)
			end
			return self.pos.x-64+shk.x,self.pos.y-64+shk.y
		end,

		pull_max_x=function(self)
			return self.pos.x+self.pull_threshold
		end,

		pull_min_x=function(self)
			return self.pos.x-self.pull_threshold
		end,

		pull_max_y=function(self)
			return self.pos.y+self.pull_threshold
		end,

		pull_min_y=function(self)
			return self.pos.y-self.pull_threshold
		end,

		shake=function(self,ticks,force)
			self.shake_remaining=ticks
			self.shake_force=force
		end
	}

	return c
end

--game flow
--------------------------------

--reset the game to its initial
--state. use this instead of
--_init()
function reset()
	ticks=0
	p1=m_player(64,100)
	p1:set_anim("walk")
	cam=m_cam(p1)

	h1=m_hammer(66,103)
	h1:set_anim("held")
end

--p8 functions
--------------------------------

function _init()
	reset()
end

function _update()
	ticks+=1
	p1:update(h1.h_collided_x, h1.h_collided_y, h1.x, h1.y, h1.pulled_towards)
	h1:update(p1.x,p1.y,p1.flipx)
	cam:update()
	--demo camera shake
	-- if(btnp(4))cam:shake(15,2)
end

function _draw()

	cls(0)

	camera(cam:cam_pos())

	map(0,0,0,0,128,128)

	p1:draw()
	h1:draw()
	--hud
	camera(0,0)

	-- printc("adv. micro platformer",64,4,7,0,0)

	-- printc(tostring(h1.dx),64,4,7,0,0)
	-- printc(tostring(p1.jump_button.is_pressed),64,12,7,0,0)
	printc(tostring(p1.stuck_roof),64,12,7,0,0)
	-- printc(tostring(h1.throw_button.is_released),64,19,7,0,0)
end

__gfx__
01234567001115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
89abcdef011716000011150000011150000111500001115000011150011150000000000000000000000000000000000000000000000000000000000000000000
00700700717872600117160000117160001171600011716000117160017160000000000000000000000000000000000000000000000000000000000000000000
00077000061775000178725000178720001787200017872000178720078725000000000000000000000000000000000000000000000000000000000000000000
00077000006660000017760000017760000177600001776000017760017760000000000000000000000000000000000000000000000000000000000000000000
00700700009950000066600007666600076666000766660007666600076600000000000000000000000000000000000000000000000000000000000000000000
00000000000550000755560009555000005990000055500000555000995500000000000000000000000000000000000000000000000000000000000000000000
00000000000044000990440000904400004400000990440000440000044000000000000000000000000000000000000000000000000000000000000000000000
66600000000666006655556600666000000006660004400000000064460000000000000000000000000000000000000000000000000000000000000000000000
65600000005556006556655600655500000006560006600000000466664000000000000000000000000000000000000000000000000000000000000000000000
55500000055656006655556600656550000005550004400066606440044606660000000000000000000000000000000000000000000000000000000000000000
56546464656540000004400000045656464645650006600065546600006645560000000000000000000000000000000000000000000000000000000000000000
56546464655466000006600000664556464645650004400065654000000456560000000000000000000000000000000000000000000000000000000000000000
55500000666064400004400004460666000005556655556605565600006565500000000000000000000000000000000000000000000000000000000000000000
65600000000004660006600066400000000006566556655600555600006555000000000000000000000000000000000000000000000000000000000000000000
66600000000000640004400046000000000006666655556600066600006660000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011001100dddddddddddddd0000051dddd150000dddddddd000051dd00000000d1d5000000000000000000000000000000000000000000000000000000000000
1ff11ff1dd1d1d1dd1d1d1dd00051d1dd1115000d1d1d1d100511d1d00000000dd11500001100000000001000000000000000000000000000000000000000000
49944994d1d111111d1d1d1d000051dddd1500001d1d1d1d000511dd00005050d1d5000001100000000000000000000000000000000000000000000000000000
01100110dd111515515111dd05051d1dd11150505111151500511d1d05051510dd11500000000000000000000000000000000000000000000000000000000000
00000000d1d150500505111d515111dddd11151501515050000511dd51511115d1d1150000000100000000000000000000000000000000000000000000000000
00000000dd150000000051dd11111d1dd1d1d1d10505000000005d1dd1d1d1d1dd11500000000000000000000000000000000000000000000000000000000000
00000000d1d150000005111dd1d1d1dddd1d1d1d00000000000511dd1d1d1d1dd1d1150000100000000000100000000000000000000000000000000000000000
00000000dd150000000051ddddddddd00ddddddd0000000000005d1ddddddddddd15000000000000000000000000000000000000000000000000000000000000
000011d0d111000000000000000000000001111ddd1110000001111ddd1110000000111011110000000000000000000000000000000000000000000000000000
0011ddd0ddd101000000000000000000001ddd1000ddd100001ddd1000ddd1000011111011110100000000000000000000000000000000000000000000000000
001dddd0dddd0110000000000000000001d0000ee0000d1001d0000660000d100011111011110110000000000000000000000000000000000000000000000000
00000009000000000000000000000000000888800aaa0d100008888007770d100000000000000000000000000000000000000000000000000000000000000000
11dd0d9a9d0ddd10000000000000000010c0880cc0a0000010508807707000001111011111011110000000000000000000000000000000000000000000000000
11dd09aaa90dd1100000000000000000d0c0800cc00bbb00d0508007700555001111011000001110000000000000000000000000000000000000000000000000
11dd09a7a90dd1110000000000000000d00f0cc00cc0b0d1d0070770077050d11111010000000111000000000000000000000000000000000000000000000000
000000a7a00000000000000000000000d0ff0cc00cc000d1d0770770077000d10000000500050000000000000000000000000000000000000000000000000000
011dd0fff0dd0d11000000000000000000fff00cc008800000777007700880000111100000000111000000000000000000000000000000000000000000000000
011dd04f40dd0d1100000000000000001d0f090cc088800d1d0706077088800d0111100000000111000000000000000000000000000000000000000000000000
0011d04440dd011000000000000000000100090cc0880c0d010006077088070d0011101110110110000000000000000000000000000000000000000000000000
0000000440000000000000000000000001d09990c000c0d101d06660700070d10000000000000000000000000000000000000000000000000000000000000000
00110100401111000000000000000000001000000a00001000100000070000100011011110111100000000000000000000000000000000000000000000000000
0001011000111000000000000000000000110d00a01ddd1000110d00701ddd100001011110111000000000000000000000000000000000000000000000000000
00000111100000000000000000000000000101d0a0111100000101d0701111000000011110000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000111d000000000000111d00000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000500500500000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000900000000000550600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000009a90000000000605500000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000a7a0000000000600500000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000055500000000000009f90000000000000600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000555550000000000001400000000000000600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000050550005000000001400000335000000600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000555500055005000000100003555300000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037373737373737373737373737373737
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000037
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000007770770070700000000077707770077077700770000077707000777077707770077077707770777077700000000000000000000000
00000000000000000000007070707070700000000077700700700070707070000070707000707007007000707070707770700070700000000000000000000000
00000000000000000000007770707070700000000070700700700077007070000077707000777007007700707077007070770077000000000000000000000000
00000000000000000000007070707077700000000070700700700070707070000070007000707007007000707070707070700070700000000000000000000000
00000000000000000000007070777007000700000070707770077070707700000070007770707007007000770070707070777070700000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d11150000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000
00dd1500000000505000005050000050500000505000005050000050500000505000005050000050500000505001100000000050500000505000005050000050
00d11150500505151005051510050515100505151005051510050515100505151005051510050515100505151000000000050515100505151005051510050515
00dd1115155151111551511115515111155151111551511115515111155151111551511115515111155151111500000100515111155151111551511115515111
00d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d100000000d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
00dd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d001000001d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
000ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000dddddddddddddddddddddddddddddd
005005005000000000000000000000000000000000000000000000000050050050000000000000000050050050d1d50000000051dd0000000000000000000051
005506000000000000000000000000000000000000000000000000000055060000000000000000000055060000dd11500000511d1d000001000000900000511d
006055000000000000000000000000000000000000000000000000000060550000000000000000000060550000d1d50000000511dd000000000009a900000511
006005000000000000000000000000000000000000000000000000000060050000000000000000000060050000dd11500000511d1d00000000000a7a0000511d
000006000000000000000000000000000000000000000000000000000000060000000000000000000000060000d1d11500000511dd000000000009f900000511
000006000000000000000000000000000000000000000000000000000000060000000000000000000000060000dd11500000005d1d000000000001400000005d
000006000000000000000000000000000000000000000000000000000000060000000000000000000000060000d1d11500000511dd0000001000014000000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd15000000005d1d000000000000100000005d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000051dd0000000000000000000051
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d011000000000000000511d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000511dd0110000000000000000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d000000000000000000511d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd0000010000000000000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000005d1d000000000000000000005d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd0010000000000000000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd15000000005d1d000000000000000000005d
100110011001100110000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000051dd0000000000000000000051
f11ff11ff11ff11ff1000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d000000000000900000511d
944994499449944994000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000511dd000000000009a900000511
100110011001100110000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d00000000000a7a0000511d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd000000000009f900000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000005d1d000000000001400000005d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd0000000000014000000511
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd15000000005d1d000000000000100000005d
d0d111000000000000000000000000000001100110000000000110011000000000011001100000000001100110d1d50000000051dd0000000000000000000051
d0ddd101000000000000000000000000001ff11ff1000000001ff11ff1000000001ff11ff1000000001ff11ff1dd11500000511d1d000001000000000000511d
d0dddd011000000000000000000000000049944994000000004994499400000000499449940000000049944994d1d50000000511dd0000000000000000000511
090000000000000000000000000000000001100110000000000110011000000000011001100000000001100110dd11500000511d1d000000000000000000511d
9a9d0ddd1000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd0000000000000000000511
aaa90dd11000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000005d1d000000000000000000005d
a7a90dd11100000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd0000001000000000000511
a7a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd15000000005d1d000000000000000000005d
fff0dd0d1100000000000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000051dd0000000000000000000051
4f40dd0d1100000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d011000000000900000511d
4440dd011000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d50000000511dd011000000009a900000511
044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd11500000511d1d00000000000a7a0000511d
004011110000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d11500000511dd000001000009f900000511
100011100000000000000000000000000000000000000051110000000000000000000000000000000000000000dd11500000005d1d000000000001400000005d
111000000000000000000000000000000000000000000061711000000000000000000000000033500000000000d1d11500000511dd0010000000014000000511
000000000000000000000000000000000000000000000627871700000000000000000000000355530000000000dd15000000005d1d000000000000100000005d
00000000000000000000000000000000000000000000005771600000000dddddddddddddddddddddd000000000d1d50000000051dd0000000000000000000051
0000000000000000000000000000000000000000000000066600000000dd1d1d1dd1d1d1d1d1d1d1dd00000000dd11500000511d1d000000000000000000051d
0000000000000000000000000000000000000000000000059900000000d1d111111d1d1d1d1d1d1d1d00000000d1d50000000511dd0000505000005050000051
0000000000000000000000000000000000000000000000055000000000dd11151551111515515111dd00000000dd11500000511d1d050515100505151005051d
0000000000000000000000000000000000000000000000440000000000d1d15050015150500505111d00000000d1d11500000511dd5151111551511115515111
0000000000000000000000000000000000000000000000000000000000dd15000005050000000051dd00000000dd11500000005d1dd1d1d1d1d1d1d1d111111d
0000500000000000000000000000000000000000000000000000000000d1d15000000000000005111d00000000d1d11500000511dd1d1d1d1d1d1d1d1dd1d1d1
0005500500000000000000000000000000000000000000000000000000dd15000000000000000051dd00000000dd15000000005d1ddddddddddddddddddddddd
ddddddddd0000000000000000000000000000000000000000000000000d1d5000000000000000051dd00000000d1d50000000051dd5005005000000000000000
1dd1d1d1dd000000000000000000000000000000000000000000000000dd1150000110000000511d1d00000000dd11500000511d1d5506000000000000000000
111d1d1d1d000000000000000000000000000000000000000000000000d1d5000001100000000511dd00000000d1d50000000511dd6055000000000000000000
15515111dd000000000000000000000000000000000000000000000000dd1150000000000000511d1d00000000dd11500000511d1d6005000000000000000000
500505111d000000000000000000000000000000000000000000000000d1d1150000000100000511dd00000000d1d11500000511dd0006000000000000000000
00000051dd000000000000000000000000000000000000000000000000dd1150000000000000005d1d00000000dd11500000005d1d0006000000000000000000
000005111d000000000000000000000000000000000000000000000000d1d1150000100000000511dd00000000d1d11500000511dd0006000000000000000000
00000051dd000000000000000000000000000000000000000000000000dd1500000000000000005d1d00000000dd15000000005d1d0000000000000000000000
00000051dd000000000000000000000000000011d0d111000000000000d1d5000000000000000051dd01100110d1d50000000051dd0000000000000000000000
0000051d1d0000000000000000000000000011ddd0ddd1010000000000dd1150000000010000511d1d1ff11ff1dd11500000511d1d0000000000000000000000
00000051dd000000000000000000000000001dddd0dddd011000000000d1d5000000000000000511dd49944994d1d50000000511dd0000000000000000000000
5005051d1d000000000000000000000000000000090000000000000000dd1150000000000000511d1d01100110dd11500000511d1d0000000000000000000000
15515111dd00000000000000000000000011dd0d9a9d0ddd1000000000d1d1150000000000000511dd00000000d1d11500000511dd0000000000000000000000
d111111d1d00000000000000000000000011dd09aaa90dd11000000000dd1150000000000000005d1d00000000dd11500000005d1d0000000000000000000000
1dd1d1d1dd00000000000000000000000011dd09a7a90dd11100000000d1d1150000000010000511dd00000000d1d11500000511dd0000000000000000000000
ddddddddd0000000000000000000000000000000a7a000000000000000dd1500000000000000005d1d00000000dd15000000005d1d0000000000000000000000
0000000000000000000000000000000000011dd0fff0dd0d1100000000d1d5000000000000000051dd00000000d1d50000000051ddddddddd000000000000000
0000000000000000000000000000000000011dd04f40dd0d1100000000dd1150000110000000511d1d00000000dd11500000511d1dd1d1d1dd00000000000000
00000000000000000000000000000000000011d04440dd011000000000d1d5000001100000000511dd00000000d1d50000000511dd1d1d1d1d00000000000000
0000000000000000000000000000000000000000044000000000000000dd1150000000000000511d1d00000000dd11500000511d1d515111dd00000000000000
0000000000000000000000000000000000001101004011110000000000d1d1150000000100000511dd00000000d1d11500000511dd0505111d00000000000000
0000000000000000000000000000000000000101100011100000000000dd1150000000000000005d1d00000000dd11500000005d1d000051dd00000000000000
0000000000000000000000000000000000000001111000000000000000d1d1150000100000000511dd00000000d1d11500000511dd0005111d00000000000000
0000000000000000000000000000000000000000000000000000000000dd1500000000000000005d1d00000000dd15000000005d1d000051dd00000000000000
0000000000000000000000000000000000000000000000000000000000d1d5000000000000000051dd00000000d1d50000000051dd00000000ddddddd0000000
0000000000000000000000000000000000000000000000000000000000dd1150000000010000511d1d00000000dd11500000511d1d01100000d1d1d1dd000000
0000000000000000000000000000000000000000000000000000000000d1d5000000000000000511dd00000000d1d50000000511dd011000001d1d1d1d000000
0000000000000000000000000000000000000000000000000000000000dd1150000000000000511d1d00000000dd11500000511d1d00000000515111dd000000
0000000000000000000000000000000000000000000000000000000000d1d1150000000000000511dd00000000d1d11500000511dd000001000505111d000000
0000000000000000000000000000000000000000000000000000000000dd1150000000000000005d1d00000000dd11500000005d1d00000000000051dd000000
0000000000000000000000000000000000003350000050000000000000d1d1150000000010000511dd00000000d1d11500000511dd001000000005111d000000
0000000000000000000000000000000000035553000550050000000000dd1500000000000000005d1d00000000dd15000000005d1d00000000000051dd000000
000000000000000000000000000dddddddddddddddddddddd000000000d1d5000000000000000051dd00000000d1d50000000051dd0000000000000000dddddd
00000000000000000000000000dd1d1d1dd1d1d1d1d1d1d1dd00000000dd1150000110000000511d1d00000000dd11500000511d1d0000000000000100d1d1d1
00000000000000000000000000d1d111111d1d1d1d1d1d1d1d00000000d1d5000001100000000511dd00000000d1d50000000511dd00000000000000001d1d1d
00000000000000000000000000dd11151551111515515111dd00000000dd1150000000000000511d1d00000000dd11500000511d1d0000000000000000515111
00000000000000000000055500d1d15050015150500505111d00000000d1d1150000000100000511dd00000000d1d11500000511dd0000000000000000050511
00000000000000000000555550dd15000005050000000051dd00000000dd1150000000000000005d1d00000000dd11500000005d1d0000000000000000000051
00000000000000000000050550d1d15000000000000005111d00000000d1d1150000100000000511dd00000000d1d11500000511dd0000000000000010000511
00000000000000000000555500dd15000000000000000051dd00000000dd1500000000000000005d1d00000000dd15000000005d1d0000000000000000000051
0000000000000000000ddddddd0000000000000000000051dd00000000dd15000000000000000051dd01100110d1d50000000051dd0000000000000000000000
000000000000000000dd1d1d1d000001000000010000511d1d00000000d11150000000000000051d1d1ff11ff1dd11500000511d1d0000000000000000011000
000000000000000000d1d111110000000000000000000511dd00000000dd15000000005050000051dd49944994d1d50000000511dd0000000000000000011000
000000000000000000dd111515000000000000000000511d1d00000000d11150500505151005051d1d01100110dd11500000511d1d0000000000000000000000
000000000000000000d1d150500000000000000000000511dd00000000dd11151551511115515111dd00000000d1d11500000511dd0000000000000000000001
000000000000000000dd150000000000000000000000005d1d00000000d1d1d1d1d1d1d1d111111d1d00000000dd11500000005d1d0000000000000000000000
000000000000335000d1d150000000001000000010000511dd00000000dd1d1d1d1d1d1d1dd1d1d1dd00000000d1d11500000511dd0000000000000000001000
000000000003555300dd150000000000000000000000005d1d000000000dddddddddddddddddddddd000000000dd15000000005d1d0000000000000000000000
00000000000ddddddd000000000000000000000000000051dd0000000000000000500500500000000000000000d1d50000000051dd0000000000000000000000
0000000000dd1d1d1d01100000000000000110000000511d1d0000000000000000550600000000000000000000dd11500000511d1d0110000000000000000000
0000000000d1d11111011000000000000001100000000511dd0000000000000000605500000000000000000000d1d50000000511dd0110000000000000000000
0000000000dd11151500000000000000000000000000511d1d0000000000000000600500000000000000000000dd11500000511d1d0000000000000000000000
0000000000d1d15050000001000000000000000100000511dd0000000000000000000600000000000000000000d1d11500000511dd0000010000000000000000
0000000000dd15000000000000000000000000000000005d1d0000000000000000000600000000000000000000dd11500000005d1d0000000000000000000000
0000500000d1d15000001000000000000000100000000511dd0000000000335000000600000000000000335000d1d11500000511dd0010000000000000000000
0005500500dd15000000000000000000000000000000005d1d0000000003555300000000000000000003555300dd15000000005d1d0000000000000000000000
ddddddddddd1d50000000000000000000000000000000051dddddddddddddddddddddddddddddddddddddddddddddddddd00000000dddddddddddddddddddddd
d1d1d1d1d1dd11500000000000000001000000010000511d1dd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d100000000d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1dd1d50000000000000000000000000000000511dd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d000000001d1d1d1d1d1d1d1d1d1d1d
1551111515dd11500000000000000000000000000000511d1d511115155111151551111515511115155111151551111515000000005111151551111515511115
5001515050d1d11500000000000000000000000000000511dd015150500151505001515050015150500151505001515050000000000151505001515050015150
0005050000dd11500000000000000000000000000000005d1d050500000505000005050000050500000505000005050000000000000505000005050000050500
0000000000d1d11500000000000000001000000010000511dd000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dd15000000000000000000000000000000005d1d000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000001010000000100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
7171717171717171717171717171717171710000717171717171717171717171717171717171000000007171717171710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070704970707070704a49430000444747474747474747474749474747474743000000004447474747490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070704946770000770000000000007700007748464a75460000000000000000487549480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707049707070707070707070704a4600000000000000000000000000004846497146000000000000000048494a480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070704946404040404000000000000000000048460075460000000000000000487500480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070704a46000050510000004000400040004048464a71460000000000000000484a49480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070704a7070707070494600006061000000000000000076004846497546000000000000000048754a480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70704a70494a70707070704a7049704a46000076740000000000004145420048464747430000000000000000444747480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a47474747474747474747474747474946000041420000000000004849460048467700000000000000000000007700480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
467700000000000000007700000077484600004443000000505145484a464048460000005051000000005051000000480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4600000000000056570000000000004846000000000000006061454849460048464200006061000000006061000041480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460050510000006667000050510000484600000000000000764145484a46004846494200000000545500000000414a480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460060610000000000000060610000444300000000007341454245484946004846704a420000006465000000414970480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46000000000000737400000000000077000000000076414a4a460044474340484670704942000000000000414a7070480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4676000000007641420000000076000000000000744149704946007677007648464970704a4200737400414970704a480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49454545454545454545454545454545454545454548704a4a46454545454545004545454545454545454545454545000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00060000250512b051330513d05100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001c7501e75021750257502a7502c7502d7502e7502f7503175033750377503e7503f75039750317502a750227501a75010750087500375000750327002b70020700187001170009700027000070000700
000200003b750397503775034750327502e7502c7502c7502a75028750277502575023750217501e7501c750187501575013750107500b75008750077500575003750017501d7001d7001c7001b7001b7001b700
000100003a7503875035750337502e7502a75025750227501e7501b750187501675014750107500c7500875006750047500375002750027500075000750007500075001600016000260002600000000000000000
000100000675007750097500a7500b7500d7500e750107501275016750177501a7501b7501e75022750277502a7502d7502f750327503375035750367503775038750397503a7503a7503b7503b7503c7503c750
