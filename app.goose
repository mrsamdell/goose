import std;
import vec;
import math;
import os;
import gfx;
import ui;

// Goose permet d'incorporer directement un fichier de police (TrueType) 
// dans le binaire pour éviter d'avoir à distribuer des fichiers à part.
let FONT: const u8[:] = embed_file("data/Roboto-Regular.ttf");

fn main() {
    // 1. Ouverture de la fenêtre native Windows (640x480 pixels)
    guard gfx::open("Goose Desktop App", 640, 480, gfx::WINDOW_RESIZABLE) else {
        write_stderr(str("Erreur gfx: ", gfx::error(), "\n"));
        return;
    }

    // 2. Initialisation du contexte UI avec la police chargée (taille 16px)
    var ctx = ui::create_from_memory(FONT, 16.0);
    guard ctx.id != 0 else {
        write_stderr(str("Erreur ui: ", ui::error(), "\n"));
        return;
    }

    // État de l'application
    var counter = 0;
    var backdrop = ui::Colorf { 0.15, 0.18, 0.22, 1.0 };
    let window_flags = ui::WINDOW_BORDER | ui::WINDOW_MOVABLE | ui::WINDOW_SCALABLE | ui::WINDOW_TITLE;

    // 3. Boucle principale de l'application
    while gfx::frame() {
        // Quitter si l'utilisateur appuie sur Échap
        if gfx::key_pressed("Escape") {
            break;
        }

        // Transmettre les entrées (clavier, souris) capturées par SDL/gfx à l'UI
        ui::input_from_gfx(ctx);

        // Définition de l'interface en mode immédiat (recalculée à chaque frame)
        if ui::begin(ctx, "Mon Application Goose", ui::rect(50, 50, 340, 240), window_flags) {
            // Disposition : 1 ligne de hauteur 30px pour le label
            ui::layout_row_dynamic(ctx, 30.0, 1);
            ui::label(ctx, str("Valeur actuelle : ", counter), ui::TEXT_CENTER);

            // Disposition : 3 colonnes pour les boutons
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
            ui::label(ctx, "Application Windows native en Goose", ui::TEXT_CENTER);
        }
        ui::end(ctx);

        // 4. Rendu de l'arrière-plan et des widgets
        gfx::begin_screen(float4 { backdrop.r, backdrop.g, backdrop.b, 1.0 });
        gfx::end_pass();
        
        ui::render(ctx);
    }

    // Libération des ressources à la fermeture
    ui::destroy(ctx);
    gfx::close();
}