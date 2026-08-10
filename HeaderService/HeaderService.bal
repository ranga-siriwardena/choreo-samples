import ballerina/http;

listener http:Listener echoListener = new (9090);

service /headers on echoListener {

    // GET /headers/echo -> returns all incoming headers as JSON
    resource function get echo(http:Request req) returns json {
        map<json> headerMap = {};

        foreach var headerName in req.getHeaderNames() {
            string[]|error headerValues = req.getHeaders(headerName);
            if headerValues is string[] {
                // Return as array in case a header appears multiple times
                headerMap[headerName] = headerValues.length() == 1
                    ? headerValues[0]
                    : headerValues.map(v => v.toJson());
            }
        }

        return {
            "method": req.method,
            "path": req.rawPath,
            "headers": headerMap
        };
    }

    // Also support POST so you can test header behavior on request bodies too
    resource function post echo(http:Request req) returns json {
        map<json> headerMap = {};

        foreach var headerName in req.getHeaderNames() {
            string[]|error headerValues = req.getHeaders(headerName);
            if headerValues is string[] {
                headerMap[headerName] = headerValues.length() == 1
                    ? headerValues[0]
                    : headerValues.map(v => v.toJson());
            }
        }

        json|error payload = req.getJsonPayload();

        return {
            "method": req.method,
            "path": req.rawPath,
            "headers": headerMap,
            "body": payload is json ? payload : null
        };
    }
}
