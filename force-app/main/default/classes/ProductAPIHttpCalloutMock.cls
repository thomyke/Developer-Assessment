@isTest
global class ProductAPIHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"Name":"BALL NUT FEM-E-B 40X40RX6-3","SKU":"R150249063"},{"Name":"BALL NUT ZEM-E-S 16X5RX3-4","SKU":"R151201022"}]');
        response.setStatusCode(200);
        return response; 
    }
}