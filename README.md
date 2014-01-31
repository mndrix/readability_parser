# Synopsis

    :- use_module(library(readability_parser)).
    ?- build_agent("f861ea4...", Agent),
       parse(Agent, 'http://foo.com/article.html', Response).
    Response = _{ author: "John Doe"
                , content: "A long time ago ..."
                , title: "A Fairy Tale"
                , word_count: 372
                ...
                }.

# Description

Access [Readability's parser API](https://www.readability.com/developers/api/parser) for extracting article content from an HTML page.

# Changes in this Version

  * Initial public release

# Installation

Using SWI-Prolog 7.1.5 or later:

    ?- pack_install(readability_parser).

This module uses [semantic versioning](http://semver.org/).

Source code available and pull requests accepted at
http://github.com/mndrix/readability_parser

@author Michael Hendricks <michael@ndrix.org>
@license BSD
