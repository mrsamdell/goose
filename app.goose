import std;
import vec;
import math;
import os;
import gfx;
import ui;

// Appel direct à l'API Windows kernel32
extern fn FreeConsole() -> i32;

let FONT: const u8[:] = embed_file("data/Roboto-Regular.ttf");

fn main() {
    // Ferme et détache la fenêtre console Windows immédiatement
    FreeConsole();

    // Ouverture de la vraie fenêtre graphique
    guard gfx::open("Mon Application Goose", 640, 480, gfx::WINDOW_RESIZABLE) else {
        write_stderr(str("Erreur gfx: ", gfx::error(), "\n"));
        return;
    }

    var ctx = ui::create_from_memory(FONT, 16.0);
    guard ctx.id != 0 else {
        write_stderr(str("Erreur ui: ", ui::error(), "\n"));
        return;
    }

    var counter = 0;
    var backdrop = ui::Colorf { 0.15, 0.18, 0.22, 1.0 };
    let window_flags = ui::WINDOW_NO_SCROLLBAR;

    while gfx::frame() {
        if gfx::key_pressed("Escape") {
            break;
        }

        ui::input_from_gfx(ctx);

        let size = gfx::screen_size();

        if ui::begin(ctx, "MainCanvas", ui::rect(0, 0, size.x as f32, size.y as f32), window_flags) {
            ui::layout_row_dynamic(ctx, 80.0, 1);
            ui::label(ctx, "", ui::TEXT_LEFT);

            ui::layout_row_dynamic(ctx, 35.0, 1);
            ui::label(ctx, str("Valeur actuelle : ", counter), ui::TEXT_CENTERED);

            ui::layout_row_dynamic(ctx, 20.0, 1);
            ui::label(ctx, "", ui::TEXT_LEFT);

            ui::layout_row_dynamic(ctx, 45.0, 5);
            ui::label(ctx, "", ui::TEXT_LEFT);

            if ui::button_label(ctx, "- Moins") {
                counter--;
            }
            if ui::button_label(ctx, "Reset") {
                counter = 0;
            }
            if ui::button_label(ctx, "+ Plus") {
                counter++;
            }

            ui::label(ctx, "", ui::TEXT_LEFT);

            ui::layout_row_dynamic(ctx, 50.0, 1);
            ui::label(ctx, "Application Windows native en Goose", ui::TEXT_CENTERED);
        }
        ui::end(ctx);

        gfx::begin_screen(float4 { backdrop.r, backdrop.g, backdrop.b, 1.0 });
        gfx::end_pass();
        
        ui::render(ctx);
    }

    ui::destroy(ctx);
    gfx::close();
}
