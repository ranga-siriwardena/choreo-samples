import ballerina/graphql;
import ballerina/log;
import ballerina/uuid;

// Choreo detects configurables and lets you set them per environment.
configurable string libraryName = "Choreo Sample Library";

function init() {
    log:printInfo("Library GraphQL service starting", libraryName = libraryName, port = 9090);
}

@graphql:ServiceConfig {
    graphiql: {
        enabled: true // local testing at http://localhost:9090/graphiql
    },
    maxQueryDepth: 5
}
isolated service /graphql on new graphql:Listener(9090) {

    # + return - Name of the library (set via Choreo configurables)
    isolated resource function get libraryName() returns string => libraryName;

    # Lists books, optionally filtered.
    # + genre - Filter by genre
    # + authorId - Filter by author ID
    # + return - Matching books
    isolated resource function get books(Genre? genre, string? authorId) returns Book[] {
        return from var b in listBooks(genre, authorId)
            select new Book(b);
    }

    # + id - Book ID
    # + return - The book, or null if not found
    isolated resource function get book(string id) returns Book? {
        (BookData & readonly)? data = findBook(id);
        return data is () ? () : new Book(data);
    }

    # + return - All authors
    isolated resource function get authors() returns Author[] => listAuthors();

    # Adds a new book.
    # + input - Book details
    # + return - The created book, or an error if validation fails
    isolated remote function addBook(BookInput input) returns Book|error {
        string title = input.title.trim();
        if title.length() == 0 {
            return error("Book title must not be empty");
        }
        if findAuthor(input.authorId) is () {
            return error(string `Author '${input.authorId}' does not exist`);
        }
        BookData & readonly data = {
            id: uuid:createType4AsString(),
            title,
            publishedYear: input.publishedYear,
            genre: input.genre,
            authorId: input.authorId
        };
        addBookData(data);
        log:printInfo("Book added", id = data.id, title = title);
        return new Book(data);
    }

    # Deletes a book.
    # + id - Book ID
    # + return - The deleted book, or an error if it does not exist
    isolated remote function deleteBook(string id) returns Book|error {
        (BookData & readonly)? removed = removeBook(id);
        if removed is () {
            return error(string `Book '${id}' not found`);
        }
        log:printInfo("Book deleted", id = id);
        return new Book(removed);
    }
}
