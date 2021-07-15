-module(client).
-compile(export_all).

books(Server, Cc_number) ->
    Server ! {books, self(), Cc_number},
receive {response, Result} -> Result end.


loans(Server, Book_title) ->
    Server ! {loans, self(), Book_title},
receive {response, Result} -> Result end.


request(Server, Book_code) ->
    Server ! {request, self(), Book_code},
receive {response, Result} -> Result end.


codes(Server, Book_title) ->
    Server ! {codes, self(), Book_title},
receive {response, Result} -> Result end.


req_num(Server, Cc_number) ->
    Server ! {req_num, self(), Cc_number},
receive {response, Result} -> Result end.


add(Server, Person, Book_code) ->
    Server ! {add, self(), Person, Book_code},
receive {response, Result} -> Result end.


remove(Server, Cc_number, Book_code) ->
    Server ! {remove, self(), Cc_number, Book_code},
receive {response, Result} -> Result end.
