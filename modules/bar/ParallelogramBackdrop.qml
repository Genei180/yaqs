import QtQuick

Item {
    id: root
    // Appearance
    property color fillColor: "#1a1a1a"
    property real radius: 8        // corner radius in px
    property real slant: 20        // px shift of the top edge to the right
    property bool slantForward: true    // if false, the bottom edge is slanted
    property bool slantStart: true
    property bool slantEnd: true

    // The injected item
    default property alias injectedItem: contentItem.data

    // Width = content width + padding + optional slants
    width: injectedItem[0].width
            + (root.slantStart ? root.slant : 0)
            + (root.slantEnd ? root.slant : 0)

    height: parent.height

    // Safety clamp so radii never fold the shape
    function clampRadius(r) {
        return Math.max(0, Math.min(r, Math.min(width, height) / 2));
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const w = width, h = height;
            const s = Math.max(0, Math.min(root.slant, w)); // slant clamped to width
            const r = clampRadius(root.radius);

            const A = {x: (root.slantStart)? s : 0   , y: 0};
            const B = {x: w, y: 0};

            // --- BOTTOM edge points ---
            const C = {x: (root.slantEnd)  ? w-s : w, y: h};
            const D = {x: (root.slantStart)? 0   : 0, y: h};

            const pts = [A, B, C, D];

            // Helper: point P moved "d" towards Q
            function moveToward(P, Q, d) {
                const dx = Q.x - P.x, dy = Q.y - P.y;
                const len = Math.hypot(dx, dy) || 1;
                const t = d / len;
                return { x: P.x + dx * t, y: P.y + dy * t };
            }

            const ctx = getContext("2d");
            ctx.reset();
            ctx.clearRect(0, 0, w, h);
            ctx.beginPath();

            // Build a rounded polygon by placing a quadratic curve at each corner.
            for (let i = 0; i < 4; i++) {
                const Pprev = pts[(i + 3) % 4];
                const P     = pts[i];
                const Pnext = pts[(i + 1) % 4];

                // Edge lengths to clamp local radius
                const prevLen = Math.hypot(P.x - Pprev.x, P.y - Pprev.y);
                const nextLen = Math.hypot(Pnext.x - P.x, Pnext.y - P.y);
                const rr = Math.min(r, prevLen / 2, nextLen / 2);

                const p1 = moveToward(P, Pprev, rr); // back along previous edge
                const p2 = moveToward(P, Pnext, rr); // forward along next edge

                if (i === 0) ctx.moveTo(p1.x, p1.y);
                else         ctx.lineTo(p1.x, p1.y);

                // Rounded corner at P
                ctx.quadraticCurveTo(P.x, P.y, p2.x, p2.y);
            }

            ctx.closePath();
            ctx.fillStyle = root.fillColor;
            ctx.fill();
        }

        // Repaint on property/size changes
        onWidthChanged:  requestPaint();
        onHeightChanged: requestPaint();
    }

    // where injected content goes
    Item {
        id: contentItem
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: (root.slantStart ? root.slant : 0)
        }
    }
}