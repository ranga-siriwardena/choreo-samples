// Thread-safe in-memory store. Replace with a database client for real use.

isolated table<Author> key(id) authorTable = table [
    {id: "a1", name: "Isaac Asimov", country: "USA"},
    {id: "a2", name: "Yuval Noah Harari", country: "Israel"},
    {id: "a3", name: "Martin Kleppmann", country: "UK"}
];

isolated table<BookData> key(id) bookTable = table [
    {id: "b1", title: "Foundation", publishedYear: 1951, genre: FICTION, authorId: "a1"},
    {id: "b2", title: "Sapiens", publishedYear: 2011, genre: HISTORY, authorId: "a2"},
    {id: "b3", title: "Designing Data-Intensive Applications", publishedYear: 2017, genre: TECHNOLOGY, authorId: "a3"}
];

isolated function findAuthor(string id) returns Author? {
    lock {
        return authorTable[id].clone();
    }
}

isolated function listAuthors() returns Author[] {
    lock {
        return authorTable.toArray().clone();
    }
}

isolated function listBooks(Genre? genre, string? authorId) returns (BookData & readonly)[] {
    lock {
        BookData[] result = from BookData b in bookTable
            where (genre is () || b.genre == genre) && (authorId is () || b.authorId == authorId)
            select b;
        return result.cloneReadOnly();
    }
}

isolated function findBook(string id) returns (BookData & readonly)? {
    lock {
        return bookTable[id].cloneReadOnly();
    }
}

isolated function addBookData(BookData & readonly data) {
    lock {
        bookTable.put(data);
    }
}

isolated function removeBook(string id) returns (BookData & readonly)? {
    lock {
        return bookTable.removeIfHasKey(id).cloneReadOnly();
    }
}
