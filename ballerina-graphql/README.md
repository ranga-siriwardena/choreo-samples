# Library GraphQL Service (Ballerina 2201.13.6 on Choreo)

## Run locally
    bal run          # GraphQL at http://localhost:9090/graphql, GraphiQL at /graphiql
    bal test
    bal graphql -i service.bal -o .   # export the SDL schema (optional)

## Deploy to Choreo
1. Push this folder to a GitHub repo (it can be a subdirectory).
2. Choreo -> Create Component -> **Service**, pick the repo/branch, set **Buildpack = Ballerina**
   and **Project Directory** to this folder.
3. Choreo reads `.choreo/component.yaml` and creates a **GraphQL** endpoint on port 9090, base path `/graphql`.
4. **Build**, then **Deploy** to Development. Set the `libraryName` configurable if you want.
5. Test from the **Test -> GraphQL Console**, or publish via the Developer Portal and call it with a token.

## Sample operations
    query {
      libraryName
      books(genre: FICTION) { id title publishedYear author { name country } }
    }

    mutation {
      addBook(input: {title: "The Gods Themselves", publishedYear: 1972, genre: FICTION, authorId: "a1"}) {
        id title author { name }
      }
    }

Note: data is in-memory, so it resets on each restart/replica. Subscriptions are not included.
