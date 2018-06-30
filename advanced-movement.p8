pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
incx = 0 -- movimento x suave
incy = 0 -- movimento y suave

function _init()
 ship = {x=64,y=64}
 t=0
 bullets={}
end

function _draw()
 cls()  --para limpar o ecra
 t=t+flr(rnd(3))+1
 sp=t%5
 spr(sp,ship.x,ship.y)
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
	
	-- disparar
	
	if btn(5)

end
__gfx__
00877800008778000087780000877800008778000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00866800008668000086680000866800008668000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09888890098888900988889009888890098888900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880088888800888888008888880088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02888820028888200288882002888820028888200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0209a020020aa020020aa020020aa020020a90200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000a0000000a90000009a0000009a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000900000000000000a0000000a9000000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
