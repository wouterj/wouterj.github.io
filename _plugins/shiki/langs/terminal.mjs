import shellscript from '@shikijs/langs/shellscript';

export default [
    ...shellscript,
    {
        name: 'terminal',
        id: 'terminal',
        scopeName: 'source.terminal',
        embeddedLangs: ['shellscript'],
        patterns: [
            {
                begin: '^\\s*#',
                beginCaptures: {
                    0: { 'name': 'punctuation.definition.comment.shell' }
                },
                end: '$',
                name: 'comment.line.number-sign.shell'
            },
            {
                name: 'meta.command',
                begin: '^\\$\\s+|^[A-Z]:\\\\.+?>',
                end: '\\n',
                beginCaptures: {
                    0: { name: 'punctuation.prompt' }
                },
                patterns: [
                    { 'include': 'source.shell' }
                ]
            }
        ]
    }
];
