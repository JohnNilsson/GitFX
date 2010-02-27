package gitfx;

import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import gitfx.Git.*;
import gitfx.Model.*;

def colors = [
            Color.web("#7597B1"),
            Color.web("#657A89"),
            Color.web("#2D587A"),
            Color.web("#B7D3E9"),
            Color.web("#CEDDE9")
        ];

Stage {
    title: "GitFX"
    scene: Scene {
        width: 600
        height: 400
        fill: Color.BLACK
        content: DAG {
            branches: createRandomDAG(20);
        }
    }
}
