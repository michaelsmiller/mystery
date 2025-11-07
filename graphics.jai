window : Window_Type;
window_height : s32 = 1000;
window_width  : s32 = 1000;


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

draw_text :: (font: *Simp.Dynamic_Font, text: string, x: float, y: float, time_ms: s64 = 0, color:=Colors.WHITE) {
  text_width := Simp.prepare_text(font, text);
  x_pt := cast(int)(window_width * x);
  y_pt := cast(int)(window_height * y);
  Simp.generate_quads_for_prepared_text(font, x_pt, y_pt, 0);

  t := cast(s16)(time_ms & 0b11111111111111);
  a :float64= 100.;
  w := 0.005;
  d := 0.25;

  for *quad, i: font.current_quads {
    theta : float64 = t * w + d * i;
    dy := cast(int)(a * Math.cos(theta));
    quad.p0.y += dy;
    quad.p1.y += dy;
    quad.p2.y += dy;
    quad.p3.y += dy;
  }
  Simp.draw_generated_quads(font, color);
}

draw_frame :: (time_ms: s64) {
  font_height := window_height / 10; // in px
  font := get_font("OpenSans-BoldItalic", font_height);
  draw_text(font, "Hello, World!", 0.1, 0.1, time_ms=time_ms, color=Colors.BLACK);
  Simp.swap_buffers(window);
}

get_font :: (name: string, height: int) -> *Simp.Dynamic_Font {
  filename := tprint("%.ttf", name);
  font := Simp.get_font_at_size("./fonts", filename, height);
  return font;
}



#scope_file

#import "Basic";
// #import "String";
#import "Window_Creation"; // Window creation/management

Simp  :: #import "Simp"; // rendering
Math :: #import "Math"; // mouse/keyboard/window resizing
