:- module(readability_parser, [ build_agent/2
                              , parse/3
                              , parse/4
                              ]).

:- use_module(library(http/http_open), [http_open/3]).
:- use_module(library(http/http_ssl_plugin)).
:- use_module(library(http/json), [json_read_dict/2]).
:- use_module(library(uri_qq)).

%% build_agent(+Token:string, -Agent)
%
%  Construct an agent for making API requests using your Readability
%  Parser Token.  Your token is available on your
%  [account settings](https://www.readability.com/settings/account)
%  page.
build_agent(Token, Agent) :-
    must_be(string, Token),
    agent_token(Agent, Token).

% private accessors for agent components
agent_token(agent(Token), Token).


%% parse(+Agent, +UrlOrId:atom, -Response:dict)
%
%  Like parse/4 but without extra options.
parse(Agent, UrlOrId, Response) :-
    parse(Agent, UrlOrId, Response, _{}).


%% parse(+Agent, +UrlOrId:atom, -Response:dict, +Options:dict)
%
%  Parse an article with Readability's Parser API. UrlOrId can be either
%  an article's URL or a Readability article ID.
%
%  Response is a dict representing Readability's raw response. In most
%  cases, you can just access this dict directly to find what you need.
parse(Agent, UrlOrID, Response, Options0) :-
    agent_token(Agent, Token),
    Options1 = Options0.put(token, Token),

    identifier_type(UrlOrID, Type),
    Options = Options1.put(Type, UrlOrID),

    parse(Options, Response).


% heuristic to distinguish URLs from Readability IDs
identifier_type(UrlOrId, Type) :-
    ( sub_atom(UrlOrId,0,4,_,http) -> Type = url; Type = id ).


% make request to Readability
parse(Args, Response) :-
    Url = {|uri||https://www.readability.com/api/content/v1/parser?$Args|},
    setup_call_cleanup( http_open(Url,Stream,[ cert_verify_hook(ssl_verify)
                                             , timeout(10)
                                             ]
                                 )
                      , ( set_stream(Stream, encoding(utf8))
                        , json_read_dict(Stream, Response)
                        )
                      , close(Stream)
                      ).

% accept all SSL certificates
ssl_verify( _SSL
          , _ProblemCertificate
          , _AllCertificates
          , _FirstCertificate
          , _Error
          ).
