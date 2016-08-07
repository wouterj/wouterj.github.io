from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace, Punctuation, Other, Literal

class WouterJStyle(Style):
    background_color = "#1b1f28"
    default_style = ""

    styles = {
        # No corresponding class for the following:
        #Text: "", # class: ''
        Whitespace: "underline #f8f8f8", # class: 'w'
        Error: "#a40000 border:#ef2929", # class: 'err'
        Other: "#c7c8d2", # class 'x'

        Comment: "#2e88fd", # class: 'c'

        Keyword: "#e5673d", # class: 'k'

        Operator: "#e5673d", # class: 'o'

        Punctuation: "#999999", # class: 'p'

        # because special names such as Name.Class, Name.Function, etc.
        # are not recognized as such later in the parsing, we choose them
        # to look the same as ordinary variables.
        Name: "#c7c8d2", # class: 'n'
        Name.Exception: "#cc0000", # class: 'ne'
        Name.Tag: "#e5673d", # class: 'nt' - like a keyword

        Number: "#ebdc39", # class: 'm'

        Literal: "#c7c8d2", # class: 'l'
        Literal.String.Doc: "noitalic #c7c8d2",# class: sd - phpdoc

        String: "#7cc64a", # class: 's'
        String.Doc: "italic #2e88fd", # class: 'sd' - like a comment

        Generic: "#c7c8d2", # class: 'g'
        Generic.Deleted: "bg:#e5413d", # class: 'gd'
        Generic.Emph: "italic #c7c8d2", # class: 'ge'
        Generic.Error: "#ef2929", # class: 'gr'
        Generic.Heading: "#000080", # class: 'gh'
        Generic.Inserted: "#00A000", # class: 'gi'
        Generic.Output: "#888", # class: 'go'
        Generic.Prompt: "#745334", # class: 'gp'
        Generic.Strong: "bold #c7c8d2", # class: 'gs'
        Generic.Subheading: "bold #800080", # class: 'gu'
        Generic.Traceback: "bold #a40000", # class: 'gt'
    }
