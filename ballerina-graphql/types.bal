# Genre of a book.
public enum Genre {
    FICTION,
    NON_FICTION,
    SCIENCE,
    TECHNOLOGY,
    HISTORY
}

# An author in the library.
#
# + id - Unique author identifier
# + name - Full name of the author
# + country - Country of origin
public type Author record {|
    readonly string id;
    string name;
    string country;
|};

# Input used by the `addBook` mutation.
#
# + title - Book title
# + publishedYear - Year the book was first published
# + genre - Book genre
# + authorId - ID of an existing author
public type BookInput record {|
    string title;
    int publishedYear;
    Genre genre;
    string authorId;
|};

# Internal storage representation of a book (not exposed directly in the schema).
type BookData record {|
    readonly string id;
    string title;
    int publishedYear;
    Genre genre;
    string authorId;
|};

# A book in the library. Modelled as a service class so `author` is resolved lazily.
public isolated service class Book {
    private final BookData & readonly data;

    isolated function init(BookData & readonly data) {
        self.data = data;
    }

    # + return - Unique book identifier
    isolated resource function get id() returns string => self.data.id;

    # + return - Book title
    isolated resource function get title() returns string => self.data.title;

    # + return - Year the book was first published
    isolated resource function get publishedYear() returns int => self.data.publishedYear;

    # + return - Book genre
    isolated resource function get genre() returns Genre => self.data.genre;

    # + return - The author of the book (resolved only when requested)
    isolated resource function get author() returns Author? => findAuthor(self.data.authorId);
}
