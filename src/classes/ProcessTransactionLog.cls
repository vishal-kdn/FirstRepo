public class ProcessTransactionLog{
@future(callout=true)
    public static void ProcessTransaction(){
    List<user> lstuser=[Select id,name from user limit 25];
        for(integer i=0;i<10;i++){
            String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
            
            String url =  salesforceHost + '/services/data/v23.0/chatter/feeds/record/' + lstuser[math.round(math.random()*10)].id + '/feed-items';
                        
            HttpRequest req = new HttpRequest();
                        
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            String chatterAlert =' Hello ,it is a mention tag '+lstuser[math.round(math.random()*10)].name;
            req.setBody('{ "body" : { "messageSegments" : [ { "type": "mention", "id" : "' + UserInfo.getUserId()+ '" }, { "type": "text",  "text" : "' + ' ' + chatterAlert +  '" } ] } }');
            Http http = new Http();
              
            HTTPResponse res = http.send(req);
        
        }
    }
}