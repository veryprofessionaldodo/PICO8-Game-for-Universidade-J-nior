pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
incx = 0 -- movimento x suave
incy = 0 -- movimento y suave

-- para nao estar sempre a 
-- disparar

firecounter = 0 

function _init()
 ship = {x=64,y=64}
 t=0
 bullets={}
end

function _draw()
 cls()  --para limpar o ecra
 t=t+flr(rnd(3))+1
 shipsp=t%5
 spr(shipsp,ship.x,ship.y)
 
 for b in all(bullets) do
		 t=t+flr(rnd(3))+1
		 bullsp=5+(t%4)
		 spr(bullsp,b.x,b.y)
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

end

function controlos()

	-- se algum botao estiver a 
	-- ser premido, acelerar

	if btn(0) then incx = incx-1 end
	if btn(1) then incx = incx+1 end
	if btn(2) then incy = incy-1 end
	if btn(3) then incy = incy+1 end
	
	--para parar de acelerar
	
	incx = min(incx,4)
	incx = max(-4,incx)
	
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

function updatebullets() 
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

__gfx__
00877800008778000087780000877800008778000006600000066000000660000006600000000000111001110000000000000000000000000000000000000000
00866800008668000086680000866800008668000006600000066000000660000006600011100111021221200000000000000000000000000000000000000000
09888890098888900988889009888890098888900006600000066000000660000006600002122120081111800000000000000000000000000000000000000000
08888880088888800888888008888880088888800006600000066000000660000006600008111180088228800000000000000000000000000000000000000000
0288882002888820028888200288882002888820000a90000009a000000aa000000aa00008822880022882200000000000000000000000000000000000000000
0209a020020aa020020aa020020aa020020a9020000aa000000a00000009a000000a900002288220002882000000000000000000000000000000000000000000
000aa000000a0000000a90000009a0000009a000000a000000000000000a00000000a00000288200000880000000000000000000000000000000000000000000
0000900000000000000a0000000a9000000090000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000
