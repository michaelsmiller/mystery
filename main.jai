default_font_height : int;

window : Window_Type;
window_height : s32 = 1000;
window_width  : s32 = 1000;
quit := false;

debug_flag := true;

Color :: struct {
  r, g, b : float;
  a : float = 1;
  #place r;
  using #as vec: Math.Vector4;
}

Colors :: struct {
  // Normal colors
  WHITE :: Color.{1, 1, 1, 1};
  BLACK :: Color.{0, 0, 0, 1};
  CLEAR :: Color.{0.2, 0.2, 0.2, 1};
}

os_setup_nonsense :: () {
  #if OS == .WINDOWS {
    Windows :: #import "Windows";
    Windows.SetProcessDPIAware();
    Windows.timeBeginPeriod(1);
  }
}

get_font :: (name: string, height: int) -> *Simp.Dynamic_Font {
  filename := tprint("%.ttf", name);
  font := Simp.get_font_at_size("./fonts", filename, height);
  return font;
}

update_window_dimensions :: () {
  new_width, new_height := Simp.get_render_dimensions(window);
  dimensions_changed := !(new_width == window_width && new_height == window_height);
  window_width, window_height = new_width, new_height;
}

handle_input_this_frame :: () {
  for resize_event: Input.get_window_resizes()
    Simp.update_window(resize_event.window);
  Input.update_window_events();

  for event: Input.events_this_frame {
    if event.type == {
      case .QUIT; quit = true; return;
      case .KEYBOARD;
        if event.key_pressed && event.key_code == .ESCAPE {
          quit = true; return;
        }
        else if event.key_pressed && event.key_code == .SPACEBAR {
          debug_flag = !debug_flag;
          print("Debug flag: %\n", debug_flag);
        }
    }
  }
}

draw_text :: (font: *Simp.Dynamic_Font, text: string, x: float, y: float, color:=Colors.WHITE) {
  text_width := Simp.prepare_text(font, text);
  x_pt := cast(int)(window_width * x);
  y_pt := cast(int)(window_height * y);
  Simp.draw_prepared_text(font, x_pt, y_pt, color);
}

draw_frame :: () {
  font_height := window_height / 10; // in px
  font := get_font("OpenSans-BoldItalic", font_height);
  draw_text(font, "Hello, World!", 0.1, 0.1, color=Colors.BLACK);
  Simp.swap_buffers(window);
}

main :: () {
  os_setup_nonsense();

  msaa : s32 = 8;
  window = create_window(window_width, window_height, "Mystery", wanted_msaa=msaa);
  msaa = Simp.prepare_window(window, wanted_msaa=msaa);
  Simp.set_render_target(window);

  while !quit {
    c := Colors.CLEAR;
    update_window_dimensions();
    Simp.clear_render_target(c.r, c.g, c.b, c.a);

    handle_input_this_frame();
    draw_frame();


    reset_temporary_storage();
  }
}

#scope_file

#import "Basic";
#import "String";
#import "Window_Creation"; // Window creation/management

Simp  :: #import "Simp"; // rendering
Input :: #import "Input"; // mouse/keyboard/window resizing
Math :: #import "Math"; // mouse/keyboard/window resizing
