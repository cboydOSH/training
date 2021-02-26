baseCtrl.prototype.setDocXIPScope = function(scp) {
    'use strict';
    
    var afterSlash = '/' + window.location.href.split('.com/')[1].split('/')[0];
    window.VlocOmniSI = scp;
    if (afterSlash === 'apex') {
        afterSlash = '';
    }
    scp.applyCallResp({
        urlPrefix: window.location.origin + afterSlash
    });
    //the loading finich in Checkbox thempolate in watch 
    // Themplate = omniNewport-vlcCheckboxModifyForDocusignEnroll
    // checkbox = NotSelfServiceCheckBox
    //baseCtrl.prototype.$scope.loading = true;
    window.bpTreeResponseSent = false;
    window.addEventListener('message', function(event) {
        
        if (event.data && event.data.constructor === Object && event.data.hasOwnProperty('docGenContentVersionId')) {
            baseCtrl.prototype.$scope.bpTree.response.isWordAttachDone = true;
            window.VlocOmniSI.applyCallResp(event.data);
            scp.aggregate(scp, scp.control.index, scp.control.indexInParent, true, -1);
            console.info("inside of docGenContentVersionId");
        }
        else if (event.data && event.data.constructor === Object && event.data.hasOwnProperty('pdfGenContentVersionId')) {
            baseCtrl.prototype.$scope.bpTree.response.isPDFAttachDone = true;
            window.VlocOmniSI.applyCallResp(event.data);
            //baseCtrl.prototype.$scope.loading = false;
            //baseCtrl.prototype.$scope.$apply();
            scp.aggregate(scp, scp.control.index, scp.control.indexInParent, true, -1);
            console.info("inside of pdfGenContentVersionId");
            
        }
        if (event.data && event.data.constructor === Object && event.data.hasOwnProperty('GET_BPTREE_RESPONSE')) {
            if (!window.bpTreeResponseSent) {
                var fContentWindow = document.getElementById('obj-doc-creation-docx-os-iframe').contentWindow;
                fContentWindow.postMessage({'clmDocxBpTreeResponse': baseCtrl.prototype.$scope.bpTree.response}, '*');
                window.bpTreeResponseSent = true;
                console.info("inside of GET_BPTREE_RESPONSE");
            }
        }
        //aseCtrl.prototype.$scope.$apply();
    }, false);
};