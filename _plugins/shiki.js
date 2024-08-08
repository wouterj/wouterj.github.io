const shiki = require('shiki');
const path = require('path');
const fs = require('fs');

function renderToHtml(lines, options = {}) {
    const skipLines = options.skipLines || 0;
    let pre = '<pre class="shiki-code"><code>';
    let gutter = '<pre class="shiki-gutter">';

    let startLine = (options.startLine || 1) - skipLines;
    let lastLine = Object.keys(lines).length - skipLines;
    lines.forEach((line, lineIndex) => {
        const lineNumber = lineIndex + startLine;
        if (lineNumber > lastLine || lineIndex < skipLines) {
            return;
        }

        gutter += `${lineNumber}\n`;

        pre += `<span class="line" data-linenr="${lineNumber}">`;

        line.forEach(token => {
            const cssDeclarations = [`color: ${token.color || options.fg}`];
            if (token.fontStyle & shiki.FontStyle.Italic) {
                cssDeclarations.push('font-style: italic');
            }
            if (token.fontStyle & shiki.FontStyle.Bold) {
                cssDeclarations.push('font-weight: bold');
            }
            if (token.fontStyle & shiki.FontStyle.Underline) {
                cssDeclarations.push('text-decoration: underline');
            }
            pre += `<span style="${cssDeclarations.join('; ')}">${escapeHtml(token.content)}</span>`;
        });
        pre += `</span>\n`;
    });
    gutter += '</pre>';
    pre = pre.replace(/\n*$/, ''); // Get rid of final new lines
    pre += '</code></pre>';

    return `${gutter}${pre}`;
}
const htmlEscapes = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#39;'
}
function escapeHtml(html) {
    return html.replace(/[&<>"']/g, chr => htmlEscapes[chr])
}

const code = process.argv[2];
const lang = process.argv[3] || 'none';

if (lang == 'none') {
    console.log(`<pre class="shiki-gutter">1</pre><pre class="shiki-code"><code>${escapeHtml(code)}</code></pre>`);
} else {
    (async function (code, lang) {
        try {
            const t = await shiki.loadTheme(path.join(__dirname, 'shiki-theme.json'));
            const highlighter = await shiki.getHighlighter({
                theme: t,
                langs: [
                    ...shiki.BUNDLED_LANGUAGES,
                    {
                        id: 'terminal',
                        scopeName: 'source.terminal',
                        embeddedLangs: ['bash'],
                        path: path.join(__dirname, 'terminal.json')
                    }
                ]
            });
            let skipLines = 0;
            if (lang == 'php' && !code.includes('<?')) {
                code = `<?php\n${code}`;
                skipLines = 1;
            }

            let ast = highlighter.codeToThemedTokens(code.trimEnd(), lang);
            let html = renderToHtml(ast, { lang, skipLines });

            console.log(html);
        } catch (e) {
            console.log(e);
        }
    })(code, lang);
}
