vlocity.cardframework.registerModule
    .controller('viaLeftProfileController',
                ['$scope', '$rootScope', '$timeout', function($scope, $rootScope, $timeout) {
        var self = this;

        self.getPhotoUrl = function(obj) {
            console.log('acaaaaaa');
              return obj.PhotoUrl;
            if (obj.PhotoUrl) {
                 console.log('aca');
                if ($rootScope.instanceUrl) {
                    console.log('aca1');
                    return $rootScope.instanceUrl + obj.PhotoUrl;
                } else {
                     console.log('aca2');
                    return obj.PhotoUrl;
                }
            }
        };

        self.getSentiment = function(obj) {
            var nsPrefix = window.nsPrefix || window.ns || localStorage.getItem('nsPrefixDotNotation').replace('.', '__');
            if (nsPrefix) {
                if (nsPrefix.length > 1 && !/__$/.test(nsPrefix)) {
                    nsPrefix += '__';
                }
                if (obj[nsPrefix + 'CustomerSentiment__c']) {
                    return obj[nsPrefix + 'CustomerSentiment__c'].toLowerCase();
                }
            }
            // hide by default
            return 'ng-hide';
        };

    }]);