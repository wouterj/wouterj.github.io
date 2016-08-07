from setuptools import setup, find_packages

setup(
    name='wouterj',
    packages=find_packages(),
    entry_points="""
    [pygments.lexers]
    inline-php = wouterj.pygments.lexers:InlinePhpLexer

    [pygments.styles]
    wouterj = wouterj.pygments:WouterJStyle
"""
)
