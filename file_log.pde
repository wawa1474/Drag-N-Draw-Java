import java.util.Calendar;

final String[] weekName = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
final String[] weekNameFull = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
final String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
final String[] monthsFull = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
final String[] AMPM = {"AM", "PM"};

PrintWriter log;

void startLog(){
  log = createWriter("log.log");
  log.println("log started : " + dateTime()); // Write the time to the file
}

void logPrint(String in_, boolean dt_){
  if(dt_ == true){
    log.print(dateTime() + " : ");
  }
  log.print(in_);
}

void logPrintln(String in_, boolean dt_){
  if(dt_ == true){
    log.print(dateTime() + " : ");
  }
  log.println(in_);
}

void closeLog(){
  log.println("log closed  : " + dateTime()); // Write the time to the file
  log.flush(); // Writes the remaining data to the file
  log.close(); // Finishes the file
}

String dateTime(){
  Calendar cal = Calendar.getInstance();
  int second = cal.get(Calendar.SECOND);//0-59
  int minute = cal.get(Calendar.MINUTE);//0-59
  int hour = cal.get(Calendar.HOUR);//1-12
  int ampm = cal.get(Calendar.AM_PM);//0 = AM, 1 = PM
  int dayN = cal.get(Calendar.DAY_OF_WEEK);//1-7
  int day = cal.get(Calendar.DAY_OF_MONTH);//1-31
  int month = cal.get(Calendar.MONTH);//0-11
  int year = cal.get(Calendar.YEAR);//2019
  return (lz(hour) + ":" + lz(minute) + ":" + lz(second) + " " + AMPM[ampm] + " - " + weekNameFull[dayN] + ", " + monthsFull[month] + " " + lz(day) + ", " + year);
}

//String time(){
//  return hour() + ":" + minute() + ":" + second();
//}

//String date(String form_){
//  switch(form_){
//    case "MDY":
//      return month() + "/" + day() + "/" + year();
    
//    case "DMY":
//      return day() + "/" + month() + "/" + year();
//  }
//  return "unknown data form";
//}

String lz(int in_){//leading Zero
  return (in_ < 10 ? "0" : "") + str(in_);
}