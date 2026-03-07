export default function (startAt = 1) {
    let nrOfLines = 0;
    let lang;

    return {
        enforce: 'post',

        preprocess(code, options) {
            lang = options.lang;
        },

        code(node) {
            const lines = node.children.filter(e => e.type === 'element');
            for (const line of lines) {
                line.properties['data-linenr'] = startAt + nrOfLines;
                nrOfLines++;
            }
        },

        pre(node) {
            this.addClassToHast(node, 'shiki-code');
        },

        root(node) {
            const lineNumbers = [...Array(nrOfLines).keys()].map(i => startAt + i);

            return {
                type: 'element',
                tagName: 'div',
                children: [
                    {
                        type: 'element',
                        tagName: 'pre',
                        properties: {
                            className: 'shiki-gutter'
                        },
                        children: [
                            { type: 'text', value: lineNumbers.join("\n") }
                        ]
                    },
                    node
                ],
            };
        },
    };
};
