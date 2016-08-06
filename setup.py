from setuptools import setup

setup(
    name='wouterj',
    entry_points="""
    [pygments.lexers]
    inline-php = wouterj.pygments.lexers:InlinePhpLexer

    [pygments.styles]
    wouterj = wouterj.pygments:WouterJStyle
"""
)
