from pygments.lexers.php import PhpLexer

# PHP lexer without <?php start tag
class InlinePhpLexer(PhpLexer):
    name = 'Inline PHP Lexer'
    aliases = ['inline-php']

    def __init__(self, **options):
        options['startinline'] = True

        PhpLexer.__init__(self, **options)
