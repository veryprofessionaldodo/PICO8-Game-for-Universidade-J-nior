pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
incx = 0 -- movimento x suave
incy = 0 -- movimento y suave

-- para nao estar sempre a 
-- disparar

firecounter = 0 

function _init()
 ship = {x=64,y=64, lives=5,
		box={x1=0,x2=8,y1=0,y2=8},
		counter=30
 }
 t=0
 rnd_num = 0
 bullets={}
 enemies={}
 explosions={}
 stars={}
 
 -- usado para preencher 
 -- inicialmente as estrelas
 
 fill_stars()
 
end

function fill_stars()

	for i=0, 80 do
		local star = {
			x=i*1.6,
			y=flr(rnd(128)),
			sp = 0.5+rnd(5)
		}
		add(stars,star)
	end

end

function _draw()
 cls()  --para limpar o ecra
 
 -- numero aleatorio para 
 -- algumas sprites

 rnd_num=rnd_num+flr(rnd(3))+1
 t = t + 1
 
 -- a sprite da nave a utilizar
 
 shipsp=rnd_num%5
 
 -- se a nave estiver imortal
 -- fazer uma alternancia
 
 -- desenhar estrelas
 
 for star in all(stars) do

  -- cor base
  
 	col=13
 	
 	-- se andarem lentamente
 	-- usar outra cor
 	
 	if star.sp < 1.5 then
 	  rnd_num = rnd(1)
 	  if rnd_num < 0.75 then
 	  	col = 5
 	  end
 	  if rnd_num < 0.1 then
 	  	col= 1
 	  end
 	end
 	
 	if star.sp >= 1.5 then
 	  rnd_num = rnd(1)
 	  if rnd_num < 0.65 then
 	  	col = 6
 	  end 	  
 	end
 	
 	star.y = star.y+star.sp
 	
 	-- pintar com base na vel
 	-- da nave, pos da nave
 	-- e distancia da estrela
 	
 	pset(star.x
 		- (ship.x-64)*star.sp/35,
 		star.y
 			- (ship.y-64)*star.sp/35,col)
 
 	-- se sairem do ecra voltar
 	-- a entrar com vel aleatoria
 	if star.y > 140 then
 		star.y = -3 - rnd(10)
 		star.sp = 0.5+rnd(5)
 	end
 
 end
 
 if ship.counter > 0 then
 	if ship.counter%10>5 then
 		-- para ser intermitente
		 draw_shield() 
		end 
 end
 

 spr(shipsp,ship.x,ship.y) 

 -- desenhar as balas
 
 for b in all(bullets) do
		 rnd_num=rnd_num+flr(rnd(3))+1
		 bullsp=5+(rnd_num%4)
		 spr(bullsp,b.x,b.y)
 end
 
 -- desenhar inimigos
 
 for e in all(enemies) do
 	enemy_sp = t%60 / 30 + 9
 	spr(enemy_sp, e.x, e.y)
 end
 
 -- desenhar explosoes
 
 for e in all(explosions) do

 	-- incrementa o counter
 	-- das explosoes para avancar
 	-- na animacao
 
 	e.t = e.t + 1
 	
 	ex_sp = 17 + e.t/2
 	spr(ex_sp,e.x,e.y)
 	
 	if e.t > 20 then 
 		del(explosions, e)
 	end
 end
 
 -- desenhar vidas
 
 for i=1,ship.lives do
 	spr(11, 128-15-9*i,3)
 end
 
 if ship.lives < 5 then
 	for i=1, 5-ship.lives do
	 	spr(12, 128-15-9*(i+ship.lives),3)
 	end
 end
 
 	-- verifica o game over
	
	if ship.lives <= 0 then
		cls()
		col = (t/5)%15 + 1
		print('game over!!!', 32,32,col)
	end
 
end

function draw_shield()
	spr(28,ship.x-8,ship.y-8)
	spr(29,ship.x,ship.y-8)
	spr(30,ship.x+8,ship.y-8)

	spr(44,ship.x-8,ship.y)
	spr(46,ship.x+8,ship.y)

	spr(60,ship.x-8,ship.y+8)
	spr(61,ship.x,ship.y+8)
	spr(62,ship.x+8,ship.y+8)

end

function _update()

	-- diminuir o counter da nave
	
	ship.counter = ship.counter-1

	controls()
		
	-- atualizar balas
	
	update_bullets()
	
	-- atualizar inimigos
	
	update_enemies()
	
	-- verifica colisoes
	
	check_collisions()
	
end

function controls()

	-- se algum botao estiver a 
	-- ser premido, acelerar

	if btn(0) then incx = incx-1.2 end
	if btn(1) then incx = incx+1.2 end
	if btn(2) then incy = incy-1 end
	if btn(3) then incy = incy+1 end
	
	--para parar de acelerar
	
	incx = min(incx,5)
	incx = max(-5,incx)
	
	incy = min(incy,4)
	incy = max(incy,-4)	
	
	-- se nao estiver a clicar em
	-- nada, parar

	if not btn(0) and not btn(1) then			
		incx = incx / 2.5 -- parar x
	end
	
	if not btn(2) and not btn(3) then
		incy = incy / 2.5 -- parar y
	end
	
	ship.x = ship.x + incx
	ship.y = ship.y + incy
	
	-- para nao sair das bordas
	
	ship.x = min(ship.x, 120)
	ship.x = max(ship.x, 0)
	
	ship.y = min(ship.y, 120)
	ship.y = max(ship.y, 0)	
	
	if btn(4) and firecounter <=0 then 
		-- disparar
		firecounter = 3
		fire()
	end
	
end

function update_bullets() 
	for b in all(bullets) do
		b.y = b.y - b.sp
		b.sp = b.sp + 0.5
		b.sp = min(b.sp, 8)
		
		-- eliminar do ecra
		if b.y <= -8 then
			del(bullets, b)
		end
		
	end
	
	firecounter = firecounter - 1	
end

function fire()
	local b = {
	 x = ship.x,
	 y = ship.y - 8,
	 
	 -- velocidade tem agora em
	 -- conta a velocidade da nave
	 
	 sp = 2.5 - incy,
  box={x1=2,x2=5,y1=0,y2=7}
	}
	
	add(bullets,b)
end

function update_enemies()
	for e in all(enemies) do
  e.x = e.r*sin(t/50) + e.m_x
  e.y = e.r*cos(t/50) + e.m_y
 end
 if #enemies <= 0 then
		respawn()
	end
		

end

function respawn()
	num =	rnd(6) + 3
	for i = 0, num do
		local enemy = {
		sp=17,
  m_x=10+i*10,
  m_y=60-i*8,
  x=-32,
  y=-32,
  r=12,
  box={x1=0,x2=7,y1=0,y2=7}
		}
		add(enemies, enemy)
	end
end

function check_collisions()

	-- colisoes entre balas e inimigos
	
	for b in all(bullets) do
	  for e in all(enemies) do
	  	if is_colliding(b,e) then
	  	
	  	-- adiciona explosoes
	  		local ex = {
					x = e.x,
	  		y = e.y,
	  		t=0
	  		}
	  		
	  		-- se estao a colidir
	  		-- apaga los
	  		del(enemies, e)
	  		del(bullets, b)	  	
	  		
	  		add(explosions,ex)
	  		
	  	end
	  end
	end
	
	
	-- colisoes entre nave e inimigos
  for e in all(enemies) do
  	if is_colliding(e,ship) then
 		
	  		if ship.counter < 0 then
	 				ship.lives = ship.lives-1
	 				ship.counter = 30
	 			end	  	
	  		
	  	end
		end
end

-- verifica colisao entre
-- dois objetos, retorna verdadeiro
-- ou falso

function is_colliding(a,b)

	-- de acordo com o diagrama 
	-- dado, separamos os 9 casos
	-- em 3 ifs
	
	-- lado esquerdo
	if (a.x+a.box.x1<b.x+b.box.x1
		and a.x+a.box.x2>b.x+b.box.x1)
		
		or
		-- centro
	   (a.x+a.box.x1>b.x+b.box.x1
		and a.x+a.box.x2<b.x+b.box.x2)
		
		or
		-- lado direito
	   (a.x+a.box.x1<b.x+b.box.x2
		and a.x+a.box.x2>b.x+b.box.x2)
		
		then
			-- cima
		 if (a.y+a.box.y1<b.y+b.box.y2
		 and a.y+a.box.y2>b.y+b.box.y2)
		 
		 or 
		 -- centro
		    (a.y+a.box.y1>b.y+b.box.y1
		 and a.y+a.box.y2<b.y+b.box.y2)
		 
		 or 
		 
		 -- baixo
						(a.y+a.box.y1<b.y+b.box.y1
		 and a.y+a.box.y2>b.y+b.box.y1)
		 then
		 	
		 	-- se entra aqui e porque
		 	-- esta a colidir!
		 	
		 	return true
		 	
		 end
			
		end
		

	return false
end
__gfx__
00077000000770000007700000077000000770000006600000066000000660000006600000000000111001110000000000000000000000000000000090000000
00066000000660000006600000066000000660000006600000066000000660000006600011100111021221200092099000210220000000000009080000990900
00988900009889000098890000988900009889000006600000066000000660000006600002122120081111800982298202211222000009000009000009a9a900
00888800008888000088880000888800008888000006600000066000000660000006600008111180088228800888888202222221000000000099a00090aaa000
0228822002288220022882200228822002288220000a90000009a000000aa000000aa000088228800228822008888822022222110000a900090aa00090aaa090
02daad2002daad2002daad2002daad2002daad20000aa000000a00000009a000000a900002288220002882000088882000222110000000000000000000a00000
000a9000000a0000000a90000009a0000009a000000a000000000000000a00000000a00000288200000880000008820000022100000000000090000000999090
0000900000000000000a0000000a9000000090000000000000000000000000000000000000088000000000000000800000002000000000000000000009000099
90080000000000006000000600000000000900000009000090090900000900000009000900000009000009000000000000000000000000000000000000000000
009909a8700000070060000000000000000000a0000000a009000099090000990900009009000090009000000090000000000000000000000000000000000000
0989a909070000700000000000900900000a9a000a0a9a000a0a990a999990900a00900000000000000000000000000000000000000000000000000000000000
909a900000070700000aa000000aa00000a0aa0000aaaa9000aa9a9000a0009000000000900000000000000000000000000000000cccccc00000000000000000
90aaa0900000a0000000aa0000aaa9000000a9000a0a990a0909990a0900000a0000000a0000000a0900000000000000000000077c0000ccc000000000000000
0090000000070700060000000000a0000090a000009aaaa0009a9aa000009aa0000000000000000000000000000000000000007c00000000cc00000000000000
0099909000000070000000600000000000000000000a0000909a00909090009090000090900000000000000000000000000007c007bbb0000cc0000000000000
8908809907000000600000060000000000000000000009000a0009090a0099090a0009090a000000090000000000000000000c007b00000000c0000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00b007700b00cc000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000b0066000000c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00000988900000c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00000888800000c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00002288220030c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0b002daad200b0c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000000a9000000c000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00b000900000cc000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00b0000b30cc0000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00000000cc00000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc0000ccc000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccc00000000000000000
__sfx__
00010000187502b7502f7502a750157500d75000000000002105025070280502b0502c0502c0502c0702a070250501e0500e7200c7200c750000002e0503005033000330703d0103f00000000000000000000000
