package gitfx;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.shape.Circle;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.Group;
import java.util.HashSet;

public class Vertex extends CustomNode {

    public var x: Number;
    public var y: Number;

    override protected function create(): Node {
        return Circle {
                    centerX: bind x;
                    centerY: bind y;
                    radius: 10;
                    fill: Color.BLUE;
                };
    }

}

public class Edge extends CustomNode {

    var v1: Vertex;
    var v2: Vertex;

    override protected function create(): Node {
        return Line {
                    startX: bind v1.x;
                    startY: bind v1.y;
                    endX: bind v2.x;
                    endY: bind v2.y;
                    opacity: 0.5;
                    stroke: Color.BLUE;
                    strokeWidth: 5;
                };
    }

}

public class Graph extends CustomNode {

    var content: Node[];
    def vertices = new HashSet;
    def edges = new HashSet;

    public function addVertex(v: Vertex) {
        insert v into content;
        vertices.add(v);
    }

    public function addEdge(v1: Vertex, v2: Vertex) {
        var e = Edge { v1: v1; v2: v2 };
        if (vertices.add(v1))
            insert v1 into content;
        if (vertices.add(v2))
            insert v2 into content;
        if (edges.add(e))
            insert e into content;
    }

    override protected function create(): Node {
        return Group {
                    content: bind content;
                }
    }
}
