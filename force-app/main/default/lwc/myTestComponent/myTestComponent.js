/** 
* @author: Tomas Bielik
* @date:   21.03.2022
* @description: show Toast notification for valid product2.SKU
*/

import { LightningElement, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Product_Object from '@salesforce/schema/Product2';
import SKU_Field from '@salesforce/schema/Product2.StockKeepingUnit';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import SuccessMessage from '@salesforce/label/c.SuccessMessage';
import ErrorMessage from '@salesforce/label/c.ErrorMessage';
import ErrorMessage2 from '@salesforce/label/c.ErrorMessage2';
import Label_Header from '@salesforce/label/c.Header';

export default class MyTestComponent extends LightningElement {

    labHeader = Label_Header;
    prodObj = Product_Object;
    skuField = SKU_Field;

    @track inputValue;
    @track areDetailsVisible = false;
        
    products;
    error;
    
    handleLoad(){
        this.areDetailsVisible = true;
    }

    @wire(getProducts, {searchKey: '$inputValue'})
        products2({ error, data }) {
            if (data) {
                this.products = data;
                this.error = undefined;
                console.log('Products: ' + JSON.stringify(data));
                console.log('searchKey: ' + this.inputValue);
            } else if (error) {
                this.error = error;
                this.products = undefined;
                console.log('Error: ' + this.error);
            }
    }

    handleSubmit(event){
        if(event.currentTarget.dataset.field === 'StockKeepingUnit'){
            this.inputValue = event.target.value;
            console.log('StockKeepingUnit: ' + this.inputValue);
        }
    }

    async validateAction(){
        if(!this.inputValue){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: ErrorMessage2,
                    variant: 'error'
            }))
        }
        else{
            this.submit();
        }
    }

    submit(){
        if(this.products.length === 0){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: ErrorMessage,
                        variant: 'error'
                }));
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: SuccessMessage + ' ' + this.products[0].Name,
                    variant: 'success'
                })
            )
        }
        
    }
}