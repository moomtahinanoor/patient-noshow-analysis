options validvarname=v7;

proc import datafile="/home/u64631666/KaggleV2-May-2016.csv"
    out=work.appts_raw
    dbms=csv
    replace;
    guessingrows=max;
run;

proc contents data=work.appts_raw;
run;
data work.appts_clean;
    set work.appts_raw;

    sched_date = datepart(ScheduledDay);
    appt_date  = datepart(AppointmentDay);
    format sched_date appt_date yymmdd10.;

    lead_days = appt_date - sched_date;

    if No_show = "Yes" then noshow = 1;
    else noshow = 0;

    if Age >= 0 and lead_days >= 0;
run;

proc logistic data=work.appts_clean;
    where lead_days >= 3;
    class Gender (ref='F') / param=ref;
    model noshow(event='1') = SMS_received lead_days Age Gender
                              Scholarship Hipertension Diabetes Alcoholism;
run;
