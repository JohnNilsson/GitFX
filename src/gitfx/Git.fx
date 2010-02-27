package gitfx;

public class Commit {

    public var parents: Commit[];
}

public function createRandomDAG(size: Integer) {
    var rand = new java.util.Random();
    var branches = [
                Commit {
                    parents: [];
                }
            ];
    for (i in [1..size]) {
        var op = rand.nextInt(10);
        if (op == 1) //Branch
        {
            def b = branches[rand.nextInt(branches.size())];
            def c = Commit { parents: [b] }
            insert c into branches;
        } else if (op == 2 and branches.size() >= 2) //Merge
        {
            def b1 = branches[rand.nextInt(branches.size())];
            def b2 = branches[rand.nextInt(branches.size())];
            def c = Commit { parents: [b1, b2] }
            delete b1 from branches;
            insert c into branches;
        } else {
            var b = branches[rand.nextInt(branches.size())];
            var c = Commit { parents: [b] }
            delete b from branches;
            insert c into branches;
        }
    }
    return branches;
}
