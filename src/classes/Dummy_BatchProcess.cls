global class Dummy_BatchProcess implements Schedulable,Database.Batchable < sObject >, Database.AllowsCallouts
{
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('Insidestart');
        return Database.getQueryLocator('select id, firstName, lastName, email, Username, ProfileId from user where IsActive = true AND email like \'%@passporttest%\' ORDER BY email ASC');
    }

    global void execute(Database.BatchableContext BC, List < sObject > batch)
    {
        for (SObject s: batch)
        {
            user u = (user)s;
            String sessionid=fetchOrgName(u.username,false);
            //system.debug('Opp name is' + o.name);
            integer randnum;
            List<user> lsusr=[select id, firstName, lastName, name, email, Username, ProfileId from user where IsActive = true AND email like '%@passporttest%' ORDER BY email ASC];
            for(Integer i=0;i<lsusr.size();i=i+5)
            {
                  randnum=math.round((math.random()*lsusr.size())-1);
                  randnum=randnum>0?randnum:(math.round(lsusr.size()/2));
                  system.debug('\n\n\n------Sessionid-----'+sessionid);
                ProcessTransaction(lsusr[i],lsusr[randnum],sessionid);
            }
        }
    }

    global void finish(Database.BatchableContext BC) {System.debug('\n\n\n---Finish called----');}
    
    //For schedule execute
    
    global void execute(SchedulableContext SC) {
  
          //Dummy_BatchProcess job = new Dummy_BatchProcess();
          //Database.ScheduleBatch(job, 'Passport data Create Job', 1, 1);

          //Database.executeBatch(job, 1);
          Datetime sysTime = System.now();
                sysTime = sysTime.addSeconds(20);
                String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
               
            String strJobName = 'Job-' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day();
            System.schedule(strJobName, chron_exp , new Dummy_BatchProcess());
    }
    
    
    //For session id
    
    public String fetchOrgName(String username, boolean isSandbox)
    {
        //String orgName = '';
        String jsonResponse = SAMLBearerAssertion.getOAuthToken(username, isSandbox);        
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        //LogUtils.log('Fetch Org Name : SAML Assertion Result: ' + result);
        String seesionid;
        System.debug('\n\n\n-----Result-------'+result);
        if((String)result.get('access_token')!=null)
        {
                seesionid=(String)result.get('access_token');
        }
        else
        {
            seesionid='No session';
        }
        return seesionid;     
    }
    
   
    public static void ProcessTransaction(user usrw,user usr,String sessionid){
    //List<user> lstuser=[Select id,name from user limit 25];
        for(integer i=0;i<1;i++){
            String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
            
            String url =  salesforceHost + '/services/data/v23.0/chatter/feeds/record/' + usrw.id + '/feed-items';
                        
            HttpRequest req = new HttpRequest();
                        
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'OAuth ' + sessionid);
            String chatterAlert =' Hello ,it is a mention tag for'+usr.name;
            req.setBody('{ "body" : { "messageSegments" : [ { "type": "mention", "id" : "' + usr.id + '" }, { "type": "text",  "text" : "' + ' ' + chatterAlert +  '" } ] } }');
            Http http = new Http();
              
            HTTPResponse res = http.send(req);
        
        }
    }
    
    
}