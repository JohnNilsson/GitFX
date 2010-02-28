package gitfx;

import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import gitfx.Git.*;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import gitfx.Graph;
import javafx.scene.layout.Panel;
import javafx.util.Math;
import gitfx.Graph.Vertex;
import javafx.scene.shape.Rectangle;

def width = 600;
def height = 400;
def colors = [
            Color.web("#7597B1"),
            Color.web("#657A89"),
            Color.web("#2D587A"),
            Color.web("#B7D3E9"),
            Color.web("#CEDDE9")
        ];
def graph = Graph { }
var dag = createRandomDAG(20);
def scene = Scene {
            width: width
            height: height
            fill: Color.BLACK
            content: [Rectangle {
                    width: width;
                    height: height;
                    onMouseClicked: function (e) {
                        println("Click");
                        var c = dag[0];
                        delete  dag[0];
                        insert c.parents into dag;

                        def v = Vertex {
                                    x: Math.random() * width;
                                    y: Math.random() * height;
                                }

                        for (p in c.parents) {
                            graph.addEdge(v, Vertex { x: Math.random()*width, y: Math.random()*height });
                        }

                    }
                }, graph]
        }

Stage {
    title: "GitFX"
    scene: scene
}

Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: KeyFrame {
        time: 40ms
        action: function () {
        }
    }
}.play()
