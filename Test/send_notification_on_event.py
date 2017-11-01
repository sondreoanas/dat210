import pymysql
import smtplib
import time
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime, timedelta
from email.utils import formatdate
import notification_db as db

def convert_seconds(seconds, nowdate):
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 24)
    newdate = nowdate + timedelta(days=days, hours=hours, minutes=minutes, seconds=seconds)
    return newdate


def check_time(time, diff):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S") # To prevent milliseconds
    nowd = datetime.strptime(now, "%Y-%m-%d %H:%M:%S")
    timediff = time - nowd

    timediff = convert_seconds(timediff.total_seconds(), nowd)
    tdelta = nowd + timedelta(minutes=-diff)

    if timediff < tdelta:
        return True
    else:
        return False


def send_notification():
    checkfortime = db.get_notification_details()
    for item in checkfortime:
        keys = []
        for key in item[0]:
            keys.append(key)
        for key in item[1]:
            keys.append(key)
        for key in item[2]:
            keys.append(key)
        for key in item[3]:
            keys.append(key)
        for key in item[4]:
            keys.append(key)
        for key in item[5]:
            keys.append(key)
        for key in item[6]:
            keys.append(key)

        infouser = [] # structure: calendarname, email, eventname, calendarId, EventId
        infoevent = [] # structure: Start, notificationalerttime

        for key3, start in item[keys.index("Start")].items():
            infoevent.append(start)
            for key4, notificationalerttime in item[keys.index("Notificationalerttime")].items():
                infoevent.append(notificationalerttime)
                if check_time(start, notificationalerttime): # checking if the difference is less than user chosen limit
                    for key0, calendarname in item[keys.index("Calendarname")].items():
                        infouser.append(calendarname)
                    for key1, email in item[keys.index("Email")].items():
                        infouser.append(email)
                    for key2, eventname in item[keys.index("Eventname")].items():
                        infouser.append(eventname)
                    for key5, calendarId in item[keys.index("CalendarId")].items():
                        infouser.append(calendarId)
                    for key6, eventId in item[keys.index("EventId")].items():
                        infouser.append(eventId)


                    sender_user = 'dat210.calendar@gmail.com' # enter sender email-address
                    sender_password = 'Dat210calendar' # enter password for sender email-address

                    sent_from = sender_user
                    to = infouser[1]

                    # Create message container.
                    msg = MIMEMultipart('alternative')
                    msg['Subject'] = "Notification"
                    msg['Date'] = formatdate(localtime=True)
                    msg['From'] = "Calendar notification"
                    msg['To'] = to

                    # Create the body plain-text and html.
                    text = "This is a notification from calendar" + infouser[0] + " that the event " + infouser[2] + " is starting in " + str(infoevent[1]) + " minutes. Exact start time: " + str(infoevent[0])
                    html = """\
                    <html>
                      <head></head>
                      <body>
                        <p>Notification from calendar  %s<br>
                           Don't forget that your event %s is starting in %s minutes <br>
                           Exact start time: %s<br>
                        </p>
                      </body>
                    </html>
                    """ % (infouser[0], infouser[2], infoevent[1], infoevent[0])

                    # Record the MIME types of both parts - text/plain and text/html.
                    part1 = MIMEText(text, 'plain')
                    part2 = MIMEText(html, 'html',)

                    # Attach parts into message container.
                    # According to RFC 2046, the last part of a multipart message, in this case
                    # the HTML message, is best and preferred.
                    msg.attach(part1)
                    msg.attach(part2)

                    try:
                        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)  # Enter SSL configuration for domain
                        server.ehlo()
                        server.login(sender_user, sender_password)
                        server.sendmail(sent_from, to, msg.as_string())
                        server.close()


                        db.set_notification_sent(infouser[4], infouser[3])
                        print('Email sent!')
                    except:
                        print('Something went wrong...')
                else:
                    continue


def run_email_eventnotification():
    while True:
        send_notification()
        time.sleep(600) # Running every 10th min
