import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin';

export default class CommunityMemberPlanDetails extends OmniscriptBaseMixin(LightningElement) {

    @api products = [];
    keyLabelMap = new Map();
    //Declaring formater for money
    formatter = new Intl.NumberFormat('en-US', {
        style: 'decimal',
        currency: 'USD',
    });
    
    connectedCallback() {
        //Get Json Data
        var jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
        //Get Metadata attributes (keys and labels)
        jsonData.metadata.forEach(metadata => {
            var temp = JSON.parse(metadata);
            temp.records[0].productAttributes.records.forEach(item => {
                this.keyLabelMap.set(item.code, item.label);
            });
        });
        //Format Attributes
        jsonData.ProductDetails.forEach(product => {
            //Get attributes from obj as array
            if(product.selectedAttributes!=undefined && product.selectedAttributes!=null){
                var attributes = JSON.parse(product.selectedAttributes);
                var map = [];
                var disclaimer = null;
                Object.entries(attributes).forEach(([key, value]) => {
                    //Get disclaimer card and put it at the end
                    if(key.includes('DISCLAIMER')){
                        disclaimer = {'key': 'DISCLAIMER', 'value': value};
                    }else{
                        if(!isNaN(value)){
                            value = '$' + this.formatter.format(value);
                        }
                        map.push({'key': this.keyLabelMap.get(key), 'value': value});
                    }
                });         
                if(disclaimer != null){
                    //putting at the end of list 
                    map.push(disclaimer);
                }
                this.products.push({'name': product.productName, 'attributes' : map});
            }
        });
    }
}