import { LightningElement, track, api, wire } from 'lwc';
import getEmployeeDetail from '@salesforce/apex/EmployeePortalDataController.getEmployeeDetail';

export default class EmployeePortalData extends LightningElement {


    records;
    columns;
    recordId;
    is_Single;
    id;
    @api dType;
    @api isSingle;
    @track DataTableResponseWrappper;
    @track finalSObjectDataList;

    @wire(getEmployeeDetail, { dataType: '$dType', isSingle: '$isSingle' })
    fetchRecords({ data, error }) {
        if (data) {
            this.records = data.records;
            this.columns = data.columns;
            this.is_Single = data.isSingle;
            this.recordId = data.recordId;
        }
    }
    
    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.' + key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }
}