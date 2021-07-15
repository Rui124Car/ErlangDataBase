-module(funs).
-import(lists, [sort/1]).
-compile(export_all).
-include_lib("stdlib/include/qlc.hrl").
-include("tables.hrl").


do(Q) ->
    F = fun() -> qlc:e(Q) end, 
    {atomic, Val} = mnesia:transaction(F),
    Val.

%% Dado um num_cc, responder com os livros requisitados por essa pessoa
books(Num_cc) ->
    sort(do(qlc:q([X#book.title || X <- mnesia:table(book),
                Y <- mnesia:table(request),
                Y#request.person_cc =:= Num_cc,
                X#book.code =:= Y#request.book_code]))).  



%% Dado um título, determina quem requisitou esse livro
loans(Title) ->
    sort(do(qlc:q([X#person.name || X <- mnesia:table(person),
        Y <- mnesia:table(request),
        Z <- mnesia:table(book),
        Z#book.title =:= Title,
        Z#book.code =:= Y#request.book_code,
        Y#request.person_cc =:= X#person.cc
]))). 

%% Dado um código de livro, determina se o livro está ou não requisitado (return bool)
request(Book_code) ->
    F = getTableRequest(Book_code),
    getValue(F).

getTableRequest(Book_code) ->
    do(qlc:q([X || X <- mnesia:table(request),
                X#request.book_code =:= Book_code
])).

getValue([]) -> false;
getValue([X]) -> true.


%% Dado um título do livro, retorna a lista de códigos de livros com esse título
codes(Book_title) -> 
    sort(do(qlc:q([X#book.code || X<-mnesia:table(book),
        X#book.title =:= Book_title]))).



%% Dado um num_cc, responde com o número de livros requisitado por essa pessoa
req_num(Num_cc) -> 
    F = do(qlc:q([X || X<-mnesia:table(request),
                X#request.person_cc =:= Num_cc])),
    getResult(F, 0).

getResult([], Num) -> Num;
getResult([X|R], Num) -> getResult(R, Num+1).


%% Dados os dados duma pessoa e o código dum livro, acrescenta o par {pessoa, livro} à BD
add({Cc, Name, Address, Phone}, Book_code) -> 
    F = fun() -> 
    mnesia:write({person, Cc, Name, Address, Phone}),
    mnesia:write({request, Book_code, Cc})
end,
mnesia:transaction(F).


 %% Dados num_cc e código de livro retira o par da BD
remove(Book_code) -> 
    F = fun() -> 
        mnesia:delete({request, Book_code})
end,
mnesia:transaction(F).

             





