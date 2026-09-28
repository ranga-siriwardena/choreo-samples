import ballerina/graphql;
import ballerina/test;

final graphql:Client testClient = check new ("http://localhost:9090/graphql");

@test:Config {}
function testBooksWithAuthor() returns error? {
    json result = check testClient->execute("{ books { title author { name } } }");
    json booksJson = check result.data.books;
    json[] books = check booksJson.ensureType();
    test:assertEquals(books.length(), 3);
}

@test:Config {dependsOn: [testBooksWithAuthor]}
function testAddBook() returns error? {
    string mutation = string `mutation {
        addBook(input: {title: "I, Robot", publishedYear: 1950, genre: FICTION, authorId: "a1"}) { id title }
    }`;
    json result = check testClient->execute(mutation);
    json title = check result.data.addBook.title;
    test:assertEquals(title, "I, Robot");
}

@test:Config {}
function testUnknownAuthorRejected() returns error? {
    string mutation = string `mutation {
        addBook(input: {title: "X", publishedYear: 2000, genre: SCIENCE, authorId: "nope"}) { id }
    }`;
    json result = check testClient->execute(mutation);
    json errors = check result.errors;
    test:assertTrue(errors is json[] && errors.length() > 0);
}
