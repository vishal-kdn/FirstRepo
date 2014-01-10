global class scheduledMerge implements Schedulable{
   global void execute(SchedulableContext SC) {
  ProcessTransactionLog.ProcessTransaction();
/*

  String day = string.valueOf(system.now().day());
    String month = string.valueOf(system.now().month());
    String hour = string.valueOf(system.now().hour());
    String minute = string.valueOf(system.now().minute().addminutes(2));
    String second = string.valueOf(system.now().second());
    String year = string.valueOf(system.now().year());
    String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
    String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
    System.schedule(strJobName, strSchedule, new scheduledMerge());
  */  
    Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        
    String strJobName = 'Job-' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day();
//    String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
    System.schedule(strJobName, chron_exp , new scheduledMerge());
} }