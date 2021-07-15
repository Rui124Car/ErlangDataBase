-module(dataBase).
-import(lists, [sort/1]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("tables.hrl").

%% executar apenas 1 vez
init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(person,  [{attributes, record_info(fields, person)}]),
    mnesia:create_table(book,    [{attributes, record_info(fields, book)}]),
    mnesia:create_table(request, [{attributes, record_info(fields, request)}]),
    mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([person, book, request], 20000).

start_tables() -> 
    F = fun() ->
        mnesia:write({person, 0123456789, "Rui", "Rua do Monte Nº 11", 91352415}),
        mnesia:write({person, 2345678901, "RuiC", "Rua da Fantasia", 91901425}),
        mnesia:write({person, 1234567890, "Harry Potter", "Privet Drive Nº 4", 91234567}),
        mnesia:write({person, 3456789012, "Hermione Granger", "Somewhere in London", 92095472}),
        mnesia:write({person, 4567890123, "Ron Weasley", "The Burrow Nº7", 92854106}),
        mnesia:write({book, 0, "Harry Potter And The Philosophers Stone", "J.K. Rowling"}),
        mnesia:write({book, 1, "Harry Potter And The Chamber of Secrets", "J.K. Rowling"}),
        mnesia:write({book, 2, "Harry Potter And The Prisioner of Azkaban", "J.K. Rowling"}),
        mnesia:write({book, 3, "Harry Potter and the Goblet of Fire", "J.K. Rowling"}),
        mnesia:write({book, 4, "Harry Potter and the Order of the Phoenix", "J.K. Rowling"}),
        mnesia:write({book, 5, "Harry Potter and the Half-Blood Prince", "J.K. Rowling"}),
        mnesia:write({book, 6, "Harry Potter and the Deathly Hallows", "J.K. Rowling"}),
        mnesia:write({book, 7, "Harry Potter And The Philosophers Stone", "J.K. Rowling"}),
        mnesia:write({request, 0, 0123456789}),
        mnesia:write({request, 1, 1234567890}),
        mnesia:write({request, 3, 1234567890}),
        mnesia:write({request, 7, 1234567890}),
        mnesia:write({request, 2, 3456789012})

end,
mnesia:transaction(F).

check_book_table() ->
    sort(do(qlc:q([X || X <- mnesia:table(book)]))).

check_person_table() ->
    sort(do(qlc:q([X || X <- mnesia:table(person)]))).

check_request_table() ->
    sort(do(qlc:q([X || X <- mnesia:table(request)]))).
    

do(Q) ->
    F = fun() -> qlc:e(Q) end, 
    {atomic, Val} = mnesia:transaction(F),
    Val.         

    




    