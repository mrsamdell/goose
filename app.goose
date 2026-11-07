import std;
import vec;
import math;
import os;
import gfx;
import ui;

let FONT: const u8[:] = embed_file("data/Roboto-Regular.ttf");

fn main() {
    // 1. Le titre est défini ici sur la véritable fenêtre native du système
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

    // 2. Plus de titre interne, plus de bordure, plus de déplacement :
    //    On supprime BORDER, MOVABLE, SCALABLE et TITLE.
    let window_flags = ui::WINDOW_NO_SCROLLBAR;

    while gfx::frame() {
        if gfx::key_pressed("Escape") {
            break;
        }

        ui::input_from_gfx(ctx);

        // 3. Récupère la taille réelle de la fenêtre (s'adapte si on la redimensionne)
        let size = gfx::screen_size();

        // 4. La zone UI commence en (0, 0) et couvre 100% de la fenêtre native
        if ui::begin(ctx, "MainCanvas", ui::rect(0, 0, size.x as f32, size.y as f32), window_flags) {
            
            // Espaceur vertical pour aérer le haut
            ui::layout_row_dynamic(ctx, 80.0, 1);
            ui::label(ctx, "", ui::TEXT_LEFT);

            // Compteur centré
            ui::layout_row_dynamic(ctx, 35.0, 1);
            ui::label(ctx, str("Valeur actuelle : ", counter), ui::TEXT_CENTERED);

            // Espaceur entre le compteur et les boutons
            ui::layout_row_dynamic(ctx, 20.0, 1);
            ui::label(ctx, "", ui::TEXT_LEFT);

            // Boutons centrés (on découpe en 5 colonnes : marges à gauche et à droite)
            ui::layout_row_dynamic(ctx, 45.0, 5);
            ui::label(ctx, "", ui::TEXT_LEFT); // marge gauche

            if ui::button_label(ctx, "- Moins") {
                counter--;
            }
            if ui::button_label(ctx, "Reset") {
                counter = 0;
            }
            if ui::button_label(ctx, "+ Plus") {
                counter++;
            }

            ui::label(ctx, "", ui::TEXT_LEFT); // marge droite

            // Texte d'information en bas
            ui::layout_row_dynamic(ctx, 50.0, 1);
            ui::label(ctx, "Application Windows native en Goose", ui::TEXT_CENTERED);
        }
        ui::end(ctx);

        // Rendu
        gfx::begin_screen(float4 { backdrop.r, backdrop.g, backdrop.b, 1.0 });
        gfx::end_pass();
        
        ui::render(ctx);
    }

    ui::destroy(ctx);
    gfx::close();
}
