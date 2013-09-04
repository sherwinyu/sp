if (window.getSelection && document.createRange) {
    window.divSetCursor = function(containerEl, start, end) {
        var charIndex = 0, range = document.createRange();
        range.setStart(containerEl, 0);
        range.collapse(true);
        var nodeStack = [containerEl], node, foundStart = false, stop = false;

        while (!stop && (node = nodeStack.pop())) {
            if (node.nodeType == 3) {
                var nextCharIndex = charIndex + node.length;
                if (!foundStart && start >= charIndex && start <= nextCharIndex) {
                    range.setStart(node, start - charIndex);
                    foundStart = true;
                }
                if (foundStart && end >= charIndex && end <= nextCharIndex) {
                    range.setEnd(node, end - charIndex);
                    stop = true;
                }
                charIndex = nextCharIndex;
            } else {
                var i = node.childNodes.length;
                while (i--) {
                    nodeStack.push(node.childNodes[i]);
                }
            }
        }

        var sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
    };
} else if (document.selection) {
    window.divSetCursor = function(containerEl, start, end) {
        var textRange = document.body.createTextRange();
        textRange.moveToElementText(containerEl);
        textRange.collapse(true);
        textRange.moveEnd("character", end);
        textRange.moveStart("character", start);
        textRange.select();
    };
}
