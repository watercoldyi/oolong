IMGUI_OBJ =  src/imgui/imgui.o src/imgui/imgui_draw.o src/imgui/imgui_widgets.o src/imgui/imgui_demo.o

SDL2_OBJ = src/sdl2/common/array.o \
src/sdl2/common/common.o \
src/sdl2/common/rwops.o \
src/sdl2/common/surface.o \
src/sdl2/common/table.o \
src/sdl2/common/variant.o \
src/sdl2/common/video.o \
src/sdl2/audio.o \
src/sdl2/channel.o \
src/sdl2/clipboard.o \
src/sdl2/cpu.o \
src/sdl2/display.o \
src/sdl2/events.o \
src/sdl2/filesystem.o \
src/sdl2/gamecontroller.o \
src/sdl2/gl.o \
src/sdl2/haptic.o \
src/sdl2/joystick.o \
src/sdl2/keyboard.o \
src/sdl2/logging.o \
src/sdl2/mouse.o \
src/sdl2/platform.o \
src/sdl2/power.o \
src/sdl2/rectangle.o \
src/sdl2/renderer.o \
src/sdl2/SDL.o \
src/sdl2/texture.o \
src/sdl2/thread.o \
src/sdl2/timer.o \
src/sdl2/window.o 

OBJS = src/gl-render.o src/lua-imgui.o

oolong.dll: $(IMGUI_OBJ) $(OBJS) SDL.dll
	g++ -Wall --shared  -o $@ $^ -lglew32 -lopengl32 -llua

SDL.dll: $(SDL2_OBJ)
	gcc --shared -Wall -I/usr/local/include/SDL2 -L/usr/local/lib/SDL2 -o $@ $^ -lsdl2 -llua

$(OBJS): %.o : %.cc
	g++ -Wall -c -o $@ $<

$(IMGUI_OBJ): %.o : %.cpp
	g++ -Wall -c -o $@ $<

$(SDL2_OBJ): %.o : %.c
	gcc -Wall -I/usr/local/include/SDL2 -Isrc/sdl2 -c -o $@ $<

clean:
	-rm ./*.dll
	-rm ./*.a
	-rm src/sdl2/common/*.o
	-rm src/sdl2/*.o
	-rm src/imgui/*.o