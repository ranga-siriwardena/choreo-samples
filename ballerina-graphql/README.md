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

## Test with curl after deploying
Copy the invoke URL from **Test -> Console** in Choreo. It ends in `/v1.0`, for example:
`https://<org-id>-dev.<region>.choreoapis.dev/<project>/<component>/v1.0`

    export URL='<invoke-url-from-choreo-test-console>'
    export TOKEN='<test-key-from-choreo-test-console>'

    curl -s -X POST "$URL" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H "Test-Key: $TOKEN" \
      -d '{"query":"{ libraryName books { id title publishedYear genre author { name country } } }"}' | jq

Common mistakes:
- Use **POST**, not GET. The gateway returns 404 "The requested resource is not available" for GET.
- Don't append `/graphql` to the invoke URL; Choreo already maps it to the service's `/graphql` base path.
- Put the `Test-Key` header in double quotes so `$TOKEN` expands.
- Include `Content-Type: application/json`.

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
