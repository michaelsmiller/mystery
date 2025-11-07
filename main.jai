default_font_height : int;

total_time : Apollo_Time;
quit := false;

debug_flag := true;

os_setup_nonsense :: () {
  #if OS == .WINDOWS {
    Windows :: #import "Windows";
    Windows.SetProcessDPIAware();
    Windows.timeBeginPeriod(1);
  }
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

main :: () {
  os_setup_nonsense();

  msaa : s32 = 8;
  window = create_window(window_width, window_height, "Mystery", wanted_msaa=msaa);
  msaa = Simp.prepare_window(window, wanted_msaa=msaa);
  Simp.set_render_target(window);

  while !quit {
    total_time = current_time_monotonic();
    time_ms, _ := to_milliseconds(total_time);
    // Take the sine of this
    handle_input_this_frame();

    update_window_dimensions();
    c := Colors.CLEAR;
    Simp.clear_render_target(c.r, c.g, c.b, c.a);
    draw_frame(time_ms);


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

#import,file "graphics.jai";
