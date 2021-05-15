module Data exposing (aboutCayatex, docsNotFound, foo, notSignedIn)

import Document exposing (empty)


notSignedIn =
    { empty
        | title = "Not signed in"
        , author = "System"
        , username = "system"
        , content = notSigneInText
        , id = "sys0002"
    }


notSigneInText =
    """

[title Welcome!]

[blue [i Please sign in to create or work with your documents]]

[violet [i To sign out, click the left-most button above: the one with your username.]]

[fontRGB |100, 100, 100|  [b Note.] Export to LaTeX and create PDF features have been added.  This is a bleeding edge experimental feature which needs quite a bit of attention before it can be used for real work. Please do bear with us!]

[fontRGB |100, 100, 100| As an example, this document can be successfully converted to PDF, but the image apppears on the next page.]

[image |width: 400, placement: center|https://i.pinimg.com/originals/d4/07/a4/d407a45bcf3ade18468ac7ba633244b9.jpg]

"""


docsNotFound =
    { empty
        | title = "Oops!"
        , author = "System"
        , username = "system"
        , content = docsNotFoundText
        , id = "sys0001"
    }


docsNotFoundText =
    """
[title Oops!]

[i  Sorry, could not find your documents]

[i To create a document, press the [b New] button above, on left.]
"""


aboutCayatex =
    { empty
        | title = "Announcing CaYaTeX"
        , author = "James Carlson"
        , username = "jxxcarlson"
        , content = content
        , id = "aboutCYT"
    }


foo =
    { empty
        | title = "Foo"
        , author = "James Carlson"
        , username = "jxxcarlson"
        , content = "This is a test"
        , id = "foo222"
    }


content =
    """


[title Announcing CaYaTeX]

By James Carlson and Nicholas Yang



[italic CaYaTeX, an experiment-in-progress, is a simple yet powerful markup language that
compiles to both LaTeX and Html. The implementation you see
here is written in Elm: [link |github.com/jxxcarlson/cayatex| https://github.com/jxxcarlson/cayatex]].

[i Credits and thanks to Matt Griffith and Rob Simmons whose error recovery work inspired what is done here.]

[i  Please do edit/delete/replace any of the text here. It won't be saved.]

[i  [c Of special importance: make syntax errors (missing brackets, extra brackets, etc.)
We are working to handle all errors gracefully and would like to know about the bugs, cases missed, etc.  Comments to jxxcarlson@gmail.com]]
[tableofcontents]

[i [fontRGB |60, 60, 60| Click on an item in the table of contents to go to the corresponding section.  Click on a section title
to return to the table of contents.]]

[section1 Design Goals]

The goals of the CaYaTeX project are for the language to be

[list |numbered|

[item [bold Small], hence easy to learn. [i To this end there are just two constructs: ordinary text and [code elements]].]

[item [b Powerful].  We borrow ideas from functional programming.
Elements have a Lisp-like syntax with brackets in place of parentheses.
An element has the basic form [code raw##[name |argument-list| body]##].
The parts [code raw##|argument-list|##] and [c body] may or may not be present.
The argument list is a comma-delimited sequence of
strings.  The body is an element.
The partial element [code name args] is a function [code Element -> Element].
Such functions can be composed, as in mathematics or as in languages such as Haskell and Elm.
]


[item [b Extensible] via macro definitions made in the source text.]

[item [b Multiple inputs and outputs.] Documents written in CaYaTeX can be compiled to LaTeX, Markdown, and HTML. Markdown documents can be compiled to CaYaTeX.]

[item [b Web-ready]. CaYaTeX has a differential compiler that makes it suitable for real-time editing, e.g.,  in a web app. ]

[item [b Kind and Helpful]. Displays friendly and informative error messages in real time in the rendered text; has hooks for highlighting the corresponding source text in a suitable IDE/editor.]

[item [b Modern]. Unicode compatible.]]


Certain tasks are particularly simple with cayatex: insertion of images referenced by URL, construction of tables, graphs, and plots from data given in a standard format such as CSV, and also inline compatations of statistical data. Examples of these are given below.

Our goal is to have a convenient  tool for writing technical documents that are immediately publishasble on the web while at the same time offering export to conventional formats such as LaTeX (and therefore also) PDF.


[b Note.] [fontRGB |50, 0, 200| The above are desiderata.  Among the missing items: compile to LaTeX and differential compilation, which is needed for snappy, real-time rendering of the source text while editing. Our first objectives
are a decent proof-of-concept and error-handling that is both robust and graceful. All in due time!]

[section1 Showcase]

Below are examples of what is currently possible with CaYaTeXs.

[section2 Mathematics]


Pythagoras says that [math a^2 + b^2 = c^2].
This is an [b [i extremely]] cool result. But just as cool is the below:

[mathblock \\sum_{n=1}^\\infty \\frac{1}{n} = \\infty,]

which goes back to the work of Nicole Oresme (1320–1382).  See the entry in the
[link |Stanford Encyclopedia of Philosophy| https://plato.stanford.edu/entries/nicole-oresme/].
You can also consult [link https://en.wikipedia.org/wiki/Nicole_Oresme].

We can also do some high-school math, with that beautifully curved integral sign
that attracts so many people to the subject:

[mathblock \\int_0^1 x^n dx = \\frac{1}{n+1}]

And of course, we can also do theorems:

[theorem There are infinitely many primes [math p \\equiv 1 \\text{ mod } 4.]]

[corollary |Euclid| There are infinitely many primes.]





[section2 Macros]

We have implemented a primitive version of macro expansion. To show how it works, begin by writing the macro definition

[cb raw#[macro [
    blue [ fontRGB |0, 80, 200| ]
]]#]

in the source text. Such a definition has the form

[cb raw#[macro [
  MACRO-NAME [ NAME |ARGS| ]
]]#]

where [c NAME] is the name of a standard element like [c fontRGB] and where
[c ARGS] is the actual list of arguments that the standard element will use.

When you add the macro definition, you will not see anything rendered. Now add this to the source "[c raw#[blue light blue bird's eggs]#]". You will see this:

[indent [blue light blue bird's eggs]]

[section3 Composability]


One can use macro instances pretty much as one uses elements.  Elements can be applied to macro instances, as with

[indent [i [blue light blue bird's eggs]]]

where the source text  is

[cb raw#[i [blue light blue bird's eggs]]#]

The body of a macro instance can also be an element:  [blue light [b blue] bird's eggs], where the source text is

[cb raw#[blue light [b blue] bird's eggs]#]

Finally, one can compose macro instances.  Make the definition

[cb raw#[macro [red [fontRGB |200, 0, 0| ]]]#]

and then say

[cb raw#[blue light blue with [red red spotted] bird's eggs]# ]

to obtain

[indent [blue light blue and [red red spotted] bird's eggs]]

[macro [blue [fontRGB |0, 80, 200| ]]]

[macro [red [fontRGB |200, 0, 0| ]]]




[section2 Color]

Example:  [highlightRGB |252, 178, 50| [fontRGB |23, 57, 156| [b What color is this?]]]

[code raw###[highlightRGB |252, 178, 50| [fontRGB |23, 57, 156| [b What color is this?]]]###]


Note the nesting of elements, aka function composition. When we have our macro facility up and running,  users can abbreviate constructs like
this one, e.g., just say [code raw##[myhighlight| What color is this?]##]


[section2 Variables]

One can set variables to be used elsewhere in the text.  For example, if we
say [c raw#[set [project = Gaia Unlimited, pi = 3.1416]#], we can later say
"my project is [c raw#[get project]#]," which will be rendered as "my project is [get project]."

The variable pi is also defined: pi = [get pi].  Here we said [c raw#pi = [get pi]#].

The [c set ...] statements can be placed anywhere in the document, for example, at the end.
Note that [c set ...] statements are not rendered in the text.  If you do want it to be rendered,
use [c set_ ...] instead.

[set project = Gaia Unlimited, pi = 3.1416]

[section2 Spreadsheets]

The below demonstrates the use
of a rudimentary spreadsheet element.  We plan a pop-up editor for
these spreadsheets.

[section3 Rendered spreadsheet]

[spreadsheet

[row 100.0, 1.1, row * 1 2 ]

[row 120.0, 1.4 ,row * 1 2 ]

[row 140.0, 0.9 ,row * 1 2]

[row -, col sum 1 3, col sum 1 3]

]



[section3 Source text]

[cb raw##
[spreadsheet

[row 100.0, 1.1, row * 1 2]

[row 120.0, 1.4 ,row * 1 2]

[row 140.0, 0.9 ,row * 1 2]

[row -, col sum 1 3, col sum 1 3]

]
##]

The entry [c row * 1 2] in the upper right-hand  cell means "In this row, multiply
the cells in columns 1 and 2; use that value to replace me."  Similarly, the entry
[c col sum 1 3] menas, "in the column where I am, compute sum of  the cell contents in rows 1 through 3; use that value to replace me.

[section2 Data]

One can design elements which manipulate data (numerical computations, visualization).  Here are some data computations:

[sum 1.2, 2, 3.4, 4]

[average 1.2, 2, 3.4, 4]

[stdev |precision:3| 1.2, 2, 3.4, 4]

In the numerical examples, the precision of the result has a default value of 2.  This can be changed, as one sees in the source of the third example, e.g., you can have

[codeblock raw##[stdev | 1.2, 2, 3.4, 4]## ]

or

[codeblock raw##[stdev |precision:3| 1.2, 2, 3.4, 4]## ]


[section2 Graphs]

Below are three simple data visualizations. We plan more, and more configurability of what you see here.

[section3 Bar graphs]

[bargraph |column:2, yShift: 0.2, caption: Global temperature anomaly 1880-1957|
1880,-0.12
1881,-0.07
1882,-0.07
1883,-0.15
1884,-0.21
1885,-0.22
1886,-0.21
1887,-0.25
1888,-0.15
1889,-0.10
1890,-0.33
1891,-0.25
1892,-0.30
1893,-0.31
1894,-0.28
1895,-0.22
1896,-0.09
1897,-0.12
1898,-0.26
1899,-0.12
1900,-0.07
1901,-0.14
1902,-0.25
1903,-0.34
1904,-0.42
1905,-0.29
1906,-0.22
1907,-0.37
1908,-0.44
1909,-0.43
1910,-0.38
1911,-0.43
1912,-0.33
1913,-0.31
1914,-0.14
1915,-0.07
1916,-0.29
1917,-0.31
1918,-0.20
1919,-0.20
1920,-0.21
1921,-0.14
1922,-0.22
1923,-0.21
1924,-0.24
1925,-0.14
1926,-0.06
1927,-0.14
1928,-0.17
1929,-0.29
1930,-0.09
1931,-0.07
1932,-0.11
1933,-0.24
1934,-0.10
1935,-0.14
1936,-0.11
1937,-0.01
1938,-0.02
1939,-0.01
1940,0.10
1941,0.19
1942,0.15
1943,0.16
1944,0.29
1945,0.17
1946,-0.01
1947,-0.05
1948,-0.06
1949,-0.06
1950,-0.17
1951,-0.01
1952,0.02
1953,0.09
1954,-0.12
1955,-0.14
1956,-0.20
1957,0.05
]

The bargraph code:

[codeblock raw##[bargraph |column:2,
    caption: Global temperature anomaly 1880-1957|
1880,-0.12
1881,-0.07
...]## ]

[section3 Line graphs]

[linegraph |caption: Global temperature anomaly 1880-1957|
1880,-0.12
1881,-0.07
1882,-0.07
1883,-0.15
1884,-0.21
1885,-0.22
1886,-0.21
1887,-0.25
1888,-0.15
1889,-0.10
1890,-0.33
1891,-0.25
1892,-0.30
1893,-0.31
1894,-0.28
1895,-0.22
1896,-0.09
1897,-0.12
1898,-0.26
1899,-0.12
1900,-0.07
1901,-0.14
1902,-0.25
1903,-0.34
1904,-0.42
1905,-0.29
1906,-0.22
1907,-0.37
1908,-0.44
1909,-0.43
1910,-0.38
1911,-0.43
1912,-0.33
1913,-0.31
1914,-0.14
1915,-0.07
1916,-0.29
1917,-0.31
1918,-0.20
1919,-0.20
1920,-0.21
1921,-0.14
1922,-0.22
1923,-0.21
1924,-0.24
1925,-0.14
1926,-0.06
1927,-0.14
1928,-0.17
1929,-0.29
1930,-0.09
1931,-0.07
1932,-0.11
1933,-0.24
1934,-0.10
1935,-0.14
1936,-0.11
1937,-0.01
1938,-0.02
1939,-0.01
1940,0.10
1941,0.19
1942,0.15
1943,0.16
1944,0.29
1945,0.17
1946,-0.01
1947,-0.05
1948,-0.06
1949,-0.06
1950,-0.17
1951,-0.01
1952,0.02
1953,0.09
1954,-0.12
1955,-0.14
1956,-0.20
1957,0.05
]

The linegraph code (CSV format):

[codeblock raw##[linegraph |caption: Global
temperature anomaly 1880-1957|
1880,-0.12
1881,-0.0]
##]

[section3 Scatter plots]

Use the same syntax as before, but with "scatterplot" in place of "linegraph."

[code raw##[scatterplot |x-axis:3,  y-axis:4
  , caption: Hubble's 1929 data| ...]##]

[scatterplot |x-axis:3,  y-axis:4, caption: Hubble's 1929 data|
object,ms,R (Mpc),v (km/sec),mt,Mt,"D from mt,Mt",,,,,,,,,
S.Mag.,..,0.032,170,1.5,-16.0,0.03,Slope when Intercept set to zero,423.901701290206,km/sec/Mpc,,,,,,
L.Mag.,..,0.03,290,0.5,-17.2,0.03,,,,,,,,,
N.G.C.6822,..,0.214,-130,9,-12.7,0.22,Slope,453.85999408475,km/sec/Mpc,,,,,,
598,..,0.263,-70,7,-15.1,0.26,Intercept,-40.4360087766413,km/sec,,,,,,
221,..,0.275,-185,8.8,-13.4,0.28,R Squared,0.623168376295362,,,,,,,
224,..,0.275,-220,5,-17.2,0.28,,,,,,,,,
5457,17,0.45,200,9.9,-13.3,0.44,,,,,,,,,
4736,17.3,0.5,290,8.4,-15.1,0.50,,,,,,,,,
5194,17.3,0.5,270,7.4,-16.1,0.50,,,,,,,,,
4449,17.8,0.63,200,9.5,-14.5,0.63,,,,,,,,,
4214,18.3,0.8,300,11.3,-13.2,0.79,,,,,,,,,
3031,18.5,0.9,-30,8.3,-16.4,0.87,,,,,,,,,
3627,18.5,0.9,650,9.1,-15.7,0.91,,,,,,,,,
4826,18.5,0.9,150,9,-15.7,0.87,,,,,,,,,
5236,18.5,0.9,500,10.4,-14.4,0.91,,,,,,,,,
1068,18.7,1,920,9.1,-15.9,1.00,,,,,,,,,
5055,19,1.1,450,9.6,-15.6,1.10,,,,,,,,,
7331,19,1.1,500,10.4,-14.8,1.10,,,,,,,,,
4258,19.5,1.4,500,8.7,-17.0,1.38,,,,,,,,,
4151,20,1.7,960,12,-14.2,1.74,,,,,,,,,
4382,..,2,500,10,-16.5,2.00,,,,,,,,,
4472,..,2,850,8.8,-17.7,2.00,,,,,,,,,
4486,..,2,800,9.7,-16.8,2.00,,,,,,,,,
4649,..,2,1090,9.5,-17.0,2.00,,,,,,,,,
Table 1,,,,,-15.5,,,,,,,,,,
]

[section2 Tables]

[data |title:Atomic weights, header|

N,  Symbol,  Name, W
1, H, Hydrogen,1.008
2, He, Helium, 4.002
3, Li, Lithium, 6.94
4, Be, Beryllium, 9.012
5, B, Boron, 10.81
6, C, Carbon, 12.011
7, N, Nitrogen, 14.007
8, O, Oxygen, 15.999
9, F, Fluorine, 18.998
10, Ne, Neon, 20.1797
11, Na, Sodium, 22.989
12, Mg, Magnesium, 24.305
13, Al, Aluminium, 26.981
14, Si, Silicon, 28.085
15, P, Phosphorus, 30.973
16, S, Sulfur, 32.06
17, Cl, Chlorine, 35.45
18, Ar, Argon, 39.948
19, K, Potassium, 39.0983
20, Ca, Calcium, 40.078

]


[section2 Table of contents]

A table contents is generated automatically if you place
the element [c raw#[tableofcontents]#] in the source text.
Entries in the table of contents are active links to the
indicated sections.  Conversely, section titles act
as active links back to the table of contents.

Sections up to six levels deep are available.


[section2 Unicode]

You can freely use unicode characters, as in this poetry element:

[poetry
А я иду, где ничего не надо,
Где самый милый спутник — только тень,
И веет ветер из глухого сада,
А под ногой могильная ступень.

— Анна Ахматова
]

[section2 Shortcuts]

[verbatim

raw###
Note that instead of saying [italic ...  ],
you can say [i .... ]

There are shortcuts for a few
other common elements:
[b ...] instead of [bold ... ]
[m ...] instead of [math ... ]
[mb ...] instead of [mathblock ... ]
###

]

[section2 Code]

Time for some code: [code raw##col :: Int -> Matrix a -> [a]##].
Do you recognize the language (ha ha)?

We can also do code blocks.  Syntax highlighting coming later.

[codeblock raw##
# For Sudoku 3x3 subsquare function

col :: Int -> Matrix a -> [a]
col k = fmap ( !! k)

cols :: Matrix a -> Matrix a
cols m =
    fmap (\\k -> col k m) [0..n]
       where n = length m - 1
##]


[i [highlight Note the use of Rust-like raw strings in the source text to avoid escaping all the brackets.]]




[section2 Images]

[image |caption: Rotkehlchen aufgeplustert, width: 200, placement: center|https://i.pinimg.com/originals/d4/07/a4/d407a45bcf3ade18468ac7ba633244b9.jpg]

[code raw##[image |caption: Rotkehlchen aufgeplustert, width: 200, placement: center| https://..jpg]##]


[section2 SVG]

[svg
<svg xmlns="http://www.w3.org/2000/svg"
 width="467" height="462">
  <rect x="80" y="60" width="250" height="250" rx="20"
      style="fill:#ff0000; stroke:#000000;stroke-width:2px;" />

  <rect x="140" y="120" width="250" height="250" rx="40"
      style="fill:#0000ff; stroke:#000000; stroke-width:2px;
      fill-opacity:0.7;" />
</svg>
]

[c raw##[svg <svg ... SVG CODE ... </svg> ]##]

[section2 Lists]

Note that lists can be nested and can be given a title if desired.  The symbol for "bulleted" lists is • by default, but can be specified by the user.
A numbered list has "numbered" as its first argument, as in the example below.

[list |numbered, title:Errands and other stuff|

    [item Bread, milk, O-juice]

    [item Sand paper, white paint]

    [list |none|

        [item A]

        [item B]

        [list |§, title:Greek symbols|

            [item [math \\alpha = 0.123]]

            [item  [math \\beta = 4.567]]

]]]



[section1 Road map]

[list | s: numbered |

[item Improve error handling.]

[item As with section numbering, implement theorem numbering, cross-references, etc.]

[item Implement export to LaTeX]

[item Integrate bracket-matching editor.]


[item Add CaYaTeX as a markup language option
for [link https://minilatex.lamdera.app]. Presently MiniLaTeX,
Math+Markdown, and plain text are supported.
]


]

[section1 Appendix: Technical Stuff]

Because CaYaTeX is so simple, the type of the AST is very small:

[codeblock
raw##type Element
    =   Text String Meta
      | Element String (List String) Element Meta
      | LX (List Element) Meta
##
]

The first variant, [code Text String] accounts for plain text.
The second is of the form [code Element name args body],
while the third shows how a list of elements combine to form an
element.  In particular, the body of an element can be
[code LX] of a list of elements.  The [code Meta] component tracks
location of the corresponding piece of text in the source code as well as
other metadata such as section numbering.

For more technical details, see the [c Design Notes] tab.

"""
