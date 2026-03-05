import fs from 'fs';
import path from 'path';
import { createHighlighter } from 'shiki';
import { transformerNotationFocus } from '@shikijs/transformers';
import { fileURLToPath } from 'url';

import terminalLang from './langs/terminal.mjs';
import gutterTransformer from './transformers/gutter.mjs';

const code = process.argv[2];
const lang = (process.argv[3] === 'none' ? false : process.argv[3]) || 'text';

(async function (code, lang) {
    try {
        const theme = JSON.parse(fs.readFileSync(path.join(import.meta.dirname, 'shiki-theme.json'), 'utf8'));
        const highlighter = await createHighlighter({
            themes: [theme],
            langs: [
                'bash', 'bat', 'c', 'css', 'diff', 'html', 'javascript', 'json', 'php', 'ruby', 'text', 'twig', 'yaml',
                ...terminalLang
            ],
        });

        let html = highlighter.codeToHtml(code.trimEnd(), {
            lang,
            theme: 'wouterj',
            transformers: [
                gutterTransformer(),
                transformerNotationFocus(),
            ]
        });;

        console.log(html);
    } catch (e) {
        console.error(e);
    }
})(code, lang);
