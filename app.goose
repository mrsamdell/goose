import std;
import vec;
import math;
import os;
import gfx;
import ui;

let FONT: const u8[:] = embed_file("data/Roboto-Regular.ttf");

fn main() {
    guard gfx::open("Goose Desktop App", 640, 480, gfx::WINDOW_RESIZABLE) else {
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
    let window_flags = ui::WINDOW_BORDER | ui::WINDOW_MOVABLE | ui::WINDOW_SCALABLE | ui::WINDOW_TITLE;

    while gfx::frame() {
        if gfx::key_pressed("Escape") {
            break;
        }

        ui::input_from_gfx(ctx);

        if ui::begin(ctx, "Mon Application Goose", ui::rect(50, 50, 340, 240), window_flags) {
            ui::layout_row_dynamic(ctx, 30.0, 1);
            // Correction ici : ui::TEXT_CENTERED
            ui::label(ctx, str("Valeur actuelle : ", counter), ui::TEXT_CENTERED);

            ui::layout_row_dynamic(ctx, 35.0, 3);
            if ui::button_label(ctx, "- Moins") {
                counter--;
            }
            if ui::button_label(ctx, "Reset") {
                counter = 0;
            }
            if ui::button_label(ctx, "+ Plus") {
                counter++;
            }

            ui::layout_row_dynamic(ctx, 25.0, 1);
            // Correction ici : ui::TEXT_CENTERED
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
