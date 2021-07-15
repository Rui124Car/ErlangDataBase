-module(server).
-import('funs', [books/1, loans/1, request/1, codes/1, req_num/1, add/2, remove/1]).
-import ('dataBase', [init/0, start/0, start_tables/0, check_book_table/0, check_person_table/0, check_request_table/0]).
-compile(export_all).

start_server() -> 
    init(),
    start(),
    start_tables(),
    spawn(fun() -> loop() end).

loop() ->
    receive
        %% Dado um num_cc, responder com os livros requisitados por essa pessoa
        {books, From, Cc_number} ->
            From ! {response, books(Cc_number)},
            loop();

        %% Dado um título, determina quem requisitou esse livro
        {loans, From, Book_title} ->
            From ! {response, loans(Book_title)},
            loop();

        %% Dado um código de livro, determina se o livro está ou não requisitado (return bool)
        {request, From, Book_code} ->
            From ! {response, request(Book_code)},
            loop();

        %% Dado um título do livro, retorna a lista de códigos de livros com esse título
        {codes, From, Book_title} ->
            From ! {response, codes(Book_title)},
            loop();

        %% Dado um num_cc, responde com o número de livros requisitado por essa pessoa
        {req_num, From, Cc_number} ->
            From ! {response, req_num(Cc_number)},
            loop();

        %% Dados os dados duma pessoa e o código dum livro, acrescenta o par {pessoa, livro} à BD
        {add, From, Person, Book_code} ->
            From ! {response, add(Person, Book_code)},
            loop();

        %% Dados num_cc e código de livro retira o par da BD
        {remove, From, Cc_number, Book_code} ->
            From ! {response, remove(Book_code)},
            loop()
end.



