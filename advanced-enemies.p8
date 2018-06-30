pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
incx = 0 -- movimento x suave
incy = 0 -- movimento y suave

-- para nao estar sempre a 
-- disparar

firecounter = 0 

function _init()
 ship = {x=64,y=64, lives=5}
 t=0
 rnd_num = 0
 bullets={}
 enemies={}
end

function _draw()
 cls()  --para limpar o ecra
 
 -- numero aleatorio para 
 -- algumas sprites

 rnd_num=rnd_num+flr(rnd(3))+1
 t = t + 1
 
 -- a sprite da nave a utilizar
 
 shipsp=rnd_num%5
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
 
 -- desenhar vidas
 
 for i=0,ship.lives do
 	spr(11, 128-15-9*i,3)
 end
 
 if ship.lives < 5 then
 	for i=0, 5-ship.lives do
	 	spr(12, 128-15-9*(i+ship.lives),3)
 	end
 end
 
end

function _update()

	controlos()
	
	ship.x = ship.x + incx
	ship.y = ship.y + incy
	
	-- para nao sair das bordas
	
	ship.x = min(ship.x, 128)
	ship.x = max(ship.x, 0)
	
	ship.y = min(ship.y, 120)
	ship.y = max(ship.y, 0)
	
	-- atualizar balas
	
	update_bullets()
	
	-- atualizar inimigos
	
	update_enemies()

end

function controlos()

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
	
	
	if btn(5) and firecounter <=0 then 
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
	 
	 sp = 2.5 - incy
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
  m_x=i*16,
  m_y=60-i*8,
  x=-32,
  y=-32,
  r=12
		}
		add(enemies, enemy)
	end
end
__gfx__
00077000000770000007700000077000000770000006600000066000000660000006600000000000111001110000000000000000000000000000000000000000
00066000000660000006600000066000000660000006600000066000000660000006600011100111021221200092099000210220000000000000000000000000
00988900009889000098890000988900009889000006600000066000000660000006600002122120081111800982298202211222000000000000000000000000
00888800008888000088880000888800008888000006600000066000000660000006600008111180088228800888888202222221000000000000000000000000
0228822002288220022882200228822002288220000a90000009a000000aa000000aa00008822880022882200888882202222211000000000000000000000000
02daad2002daad2002daad2002daad2002daad20000aa000000a00000009a000000a900002288220002882000088882000222110000000000000000000000000
000a9000000a0000000a90000009a0000009a000000a000000000000000a00000000a00000288200000880000008820000022100000000000000000000000000
0000900000000000000a0000000a9000000090000000000000000000000000000000000000088000000000000000800000002000000000000000000000000000
