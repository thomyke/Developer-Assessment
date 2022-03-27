
 import { createElement } from 'lwc';
 import MyTestComponent from 'c/myTestComponent';
 import getProducts from '@salesforce/apex/ProductController.getProducts';
 
  
 // Mock realistic data
 const mockgetProducts = require('./data/findProducts.json');
   
 jest.mock(
  '@salesforce/apex/ProductController.getProducts',
  () => {
      const {
          createApexTestWireAdapter
      } = require('@salesforce/sfdx-lwc-jest');
      return {
          default: createApexTestWireAdapter(jest.fn())
      };
  },
  { virtual: true }
);

 describe('c-wire-l-d-s', () => {
   afterEach(() => {
     while (document.body.firstChild) {
       document.body.removeChild(document.body.firstChild);
     }
     jest.clearAllMocks();
   });
     
   describe('getProducts @wire data', () => {

    test('renders six records', () => {
      const inputValue = 'LALA';

      const element = createElement('c-my-test-component', {
        is: MyTestComponent
      });
      document.body.appendChild(element);   
 
      // Emit data from @wires
      getProducts.emit(mockgetProducts);
        
            expect(inputValue).toBe(mockgetProducts[0].StockKeepingUnit);
        
      
    });
   });
 });