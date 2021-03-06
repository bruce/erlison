-module(article).

-export([parse/1]).

parse(Article) ->
    Lines = string:tokens(Article, "\r\n"),
    parse_lines(Lines).

parse_lines([]) -> {error, no_data};
parse_lines([[$=, $y, $b, $e, $g, $i, $n, $\s|Header]|Lines]) ->
    yenc:parse_data(Header, Lines);
parse_lines([[$b, $e, $g, $i, $n, $\s|Header]|Lines]) ->
    uuencode:parse_data(Header, Lines);
parse_lines([_|Lines]) -> parse_lines(Lines). 

-include_lib("eunit/include/eunit.hrl").

parse_test() ->
    {ok, Article} = file:read_file("../test/data/yenc/singlepart/00000005.ntx"),
    {ok, Expected} = file:read_file("../test/data/yenc/singlepart/testfile.txt"),
    {ok, _, Bin} = parse(binary_to_list(Article)),
    ?assertEqual(Bin, Expected).

