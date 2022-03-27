@isTest
global class ProductAPIHttpCalloutMockError implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"Name":"BALL NUT FEM-E-B 40X40RX6-3","SKU":5656541}]');
        response.setStatusCode(502);
        return response; 
    }
}