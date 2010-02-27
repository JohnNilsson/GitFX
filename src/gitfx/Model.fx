package gitfx;

import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.scene.paint.*;
import javafx.scene.layout.*;
import javafx.util.Sequences.*;
import gitfx.Git.*;

public class CommitString extends CustomNode {

    var commits: Commit[];

    override function create(): Node {
        def strBox = HBox {
                    spacing: 10;
                    content: bind for (c in commits)
                        Circle {
                            radius: 10 fill: Color.BLUE
                        }
                };
        def internalLine = Line {
                    startX: bind strBox.translateX;
                    startY: bind strBox.translateY;
                    endX: bind strBox.translateX + strBox.width;
                    endY: bind strBox.translateY + strBox.height / 2;
                    fill: Color.BLUE;
                };
        return Group {
                    content: [internalLine, strBox]
                }
    }

    public function splitAt(commit: Commit) {
        def sp = indexOf(commits, commit);
        def s1 = CommitString {
                    commits: commits[0..sp]
                };
        def s2 = CommitString {
                    commits: commits[sp + 1..]
                };
        return [s1, s2];
    }

}

public function layoutDAG(branches: Commit[]) {
    def strings = new java.util.HashMap();
    var bs = branches;
    while (sizeof bs > 0) {
        var c = bs[0];
        delete  bs[0];
        var string: Commit[] = [];
        while (sizeof c.parents > 0 and not strings.containsKey(c)) {
            if (sizeof c.parents > 1)
                insert c.parents[1..] into bs;

            insert c into string;
            c = c.parents[0];
        }

        if (strings.containsKey(c)) //Fork
            for (s in (strings.get(c) as CommitString).splitAt(c))
                for (cm in s.commits)
                    strings.put(cm, s);

        def newString = CommitString {
                    commits: reverse string;
                }
        for (cm in newString.commits)
            strings.put(cm, newString);
    }
    return for (s in new java.util.HashSet(strings.values())) s as CommitString[]
}

class CommitNode extends CustomNode {

    public var parents: CommitNode[];
    public var x = 0;
    public var y = 0;
    //public def x:Number = bind (max([0.0,for(p in parents) p.x]) as Number);
    //public def y:Number = 10.0;

    override function create(): Node {
        return Circle {
                    centerX: bind x;
                    centerY: bind y;
                    radius: 10;
                    fill: Color.BLUE;
                };
    }

}

public class DAG extends CustomNode {

    public var branches: Commit[];
    var nodes: CommitNode[];

    function calculateLayout() {
    }

    override function create(): Node {
        def nodeMap = new java.util.HashMap();
        var bs = branches;
        while (sizeof bs > 0) {
            var c = bs[0];
            delete  bs[0];
            var cs: Commit[] = [];
            while (sizeof c.parents > 0 and not nodeMap.containsKey(c)) {
                if (sizeof c.parents > 1)
                    insert c.parents[1..] into bs;
                insert c into cs;
                c = c.parents[0];
            }

            if (sizeof c.parents == 0)
                nodeMap.put(c, CommitNode { });

            var cn: CommitNode = nodeMap.get(c) as CommitNode;
            for (ci in reverse cs) {
                def newCn = CommitNode {
                            parents: [cn];
                        }
                nodeMap.put(ci, newCn);
                cn = newCn;
            }
        }
        // Fix merges
        for (k in nodeMap.keySet()) {
            def ps = (k as Commit).parents;
            if (sizeof ps > 1) {
                (nodeMap.get(k) as CommitNode).parents =
                for (p in ps) {
                    nodeMap.get(p) as CommitNode
                }
            }
        }
        nodes = for (cn in nodeMap.values()) {
            cn as CommitNode
        };
        return Group { content: nodes }
    }

}
