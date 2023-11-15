+++
title = "Log No Log"
outputs = ["Reveal"]
[logo]
src = "arise_by_infinitas.png"
width = "8%"
+++

เรื่อง Log เรื่องเล็ก เรื่องไม่ Log เรื่องใหญ่

```
Pallat Anchaleechamaikorn

Technical Coach
Infinitas by KrungThai
Arise by Infinitas
```

---

The Ship's Log

![image](https://raw.githubusercontent.com/DXHeroes/knowledge-base-content/master/files/ship_log.jpg)

---

Is logging a requirement?

---

![image](https://www.l-tron.com/wp-content/uploads/2019/01/Crime-Scene-Documentation-iStock.jpg)

---

Let's focus on debug logging

---

Debug Logging Level

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'fontSize': '40px',
      'primaryColor': '#CE3262',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#7C0000',
      'lineColor': '#F8B229',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

graph RL
    Trace --> Debug
    Debug --> Info
    Info --> Warn
    Warn --> Error
    Error --> Fatal

    style Error fill:#C8647E
    style Warn fill:#D08096
    style Info fill:#D99BAD
    style Debug fill:#E2B4C0
    style Trace fill:#EBCAD4
```

---

{{< slide template="white" >}}
<style>
    th {
        background: #B5B2B3;
        word-wrap: break-word;
        text-align: center;
    }
    td:nth-child(1) { background: #FDDD00; }
</style>

| |FATAL|ERROR|WARN|INFO|DEBUG|TRACE|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|
| **OFF** |||||||
| **FATAL** | x ||||||
| **ERROR** | x |x|||||
| **WARN** | x |x|x||||
| **INFO** | x |x|x|x|||
| **DEBUG** | x |x|x|x|x||
| **TRACE** | x |x|x|x|x|x|

---

Choose the Right Log Level

- **{{< frag c="DEBUG" >}}** {{< frag c="Used in the development process" >}}
- **{{< frag c="INFO" >}}** {{< frag c="regular operation" >}}
- **{{< frag c="WARN" >}}** {{< frag c="system instability or connectivity issues" >}}
- **{{< frag c="ERROR" >}}** {{< frag c="runtime issues " >}}
- **{{< frag c="FATAL" >}}** {{< frag c="generally result in the shutdown" >}}

```
https://www.crowdstrike.com/cybersecurity-101/observability/debug-logging/
```

{{% note %}}
DEBUG: ใช้เฉพาะใน Dev En เพื่อวิเคราะห์แอป
INFO: ใช้แสดงว่าแอปทำงานได้ปกติหรือไม่ เช่น startup/shutdown
WARN: ปัญหา runtime ที่อาจจะไม่ส่งผลกระทบโดยตรง แต่อาจจะมีผลกระทบอื่นๆตามมา ส่วนมากเกี่ยวกับความเสภียร
ERROR:
FATAL: รุนแรงจนต้องระงับการทำงาน
{{% /note %}}

---

DEBUG

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#D99BAD',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#7C0000',
      'lineColor': '#F8B229',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

graph RL
    Trace --> Debug
    Debug --> Info
    Info --> Warn
    Warn --> Error
    Error --> Fatal

    style Debug fill:#CE3262
```

{{% fragment %}}
```js
console.log('==========');
```
{{% /fragment %}}

{{% fragment %}}

```js
console.log(err);
```

{{% /fragment %}}

{{% fragment %}}

```js
DEBUG: Fetching mailing list {"listid":14777}
```

{{% /fragment %}}

{{% fragment %}}
or

```js
TRACE: Fetching mailing list {"listid":14777}
```

{{% /fragment %}}

---

INFO

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#D99BAD',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#7C0000',
      'lineColor': '#F8B229',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

graph RL
    Trace --> Debug
    Debug --> Info
    Info --> Warn
    Warn --> Error
    Error --> Fatal

    style Info fill:#CE3262
```

{{% fragment %}}

```sh
level=INFO msg=Connecting to the server...
```

{{% /fragment %}}

{{% fragment %}}

```sh
level=INFO msg=No Content.
```

{{% /fragment %}}

---

WARN

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#D99BAD',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#7C0000',
      'lineColor': '#F8B229',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

graph RL
    Trace --> Debug
    Debug --> Info
    Info --> Warn
    Warn --> Error
    Error --> Fatal

    style Warn fill:#CE3262
```

{{% fragment %}}

```sh
level=WARN msg=WARNING WARNING WARNING
```

{{% /fragment %}}

{{% fragment %}}

```sh
level=WARN msg=context deadline exceeded
```

{{% /fragment %}}

{{% fragment %}}

or

```sh
level=ERROR msg=context deadline exceeded
```

{{% /fragment %}}

---

ERROR

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#D99BAD',
      'primaryTextColor': '#fff',
      'primaryBorderColor': '#7C0000',
      'lineColor': '#F8B229',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

graph RL
    Trace --> Debug
    Debug --> Info
    Info --> Warn
    Warn --> Error
    Error --> Fatal

    style Error fill:#CE3262
```

{{% fragment %}}

```sh
level=ERROR msg=Get "http://example.com/api": dial tcp: lookup example.co: no such host
```

{{% /fragment %}}

{{% fragment %}}

How about if it's ok but http status is 404

```xml
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head>
                <title>404 - Not Found</title>
        </head>
        <body>
                <h1>404 - Not Found</h1>
                <script type="text/javascript" src="//obj.ac.bcon.ecdns.net/ec_tpm_bcon.js"></script>
        </body>
</html>
```

{{% /fragment %}}

---

Common Mistakes

{{% fragment %}}

```go
slog.Error("not found")
```

{{% /fragment %}}

{{% fragment %}}

```
time=2023-11-14T21:41:20.632+07:00 level=ERROR source=handler.go:25 msg=not found
```

{{% /fragment %}}

{{% fragment %}}

```go
slog.Error("result failed")
```

{{% /fragment %}}

{{% fragment %}}

```
time=2023-11-14T21:41:20.632+07:00 level=ERROR source=handler.go:25 msg=result failed
```

{{% /fragment %}}

---

Make it better

{{% fragment %}}

```go
slog.Error("order not found", slog.String("id", id))
```

{{% /fragment %}}

{{% fragment %}}

```
time=2023-11-14T21:41:20.632+07:00 level=ERROR source=handler.go:25 msg=order not found id=C10000043
```

{{% /fragment %}}

---

10 Rules to Microservice Logging

```
https://medium.com/@sniederm/10-rules-to-microservice-logging-4d24f6dd7abb
```

- Rule 1: Write your logs to console, not files
- Rule 2: Use a logging framework
- Rule 3: Log in JSON format where possible
- Rule 4: Centralize and index your logs
- Rule 5: Treat logs like event streams
- **Rule 6: Do not log sensitive and privacy data**
- Rule 7: Use common log levels (DEBUG, INFO, WARN, ERROR)
- Rule 8: Use a correlation / trace ID
- Rule 9: Use a reporting tool
- Rule 10: Keep an eye on complexity and performance

---

Sesitive Data

- Personally Identifiable Information (PII)
- Financial Information
- Health and Medical Information
- Authentication Credentials
- Confidential Business Data
- Legal and Compliance Data
- Personal Communications
- Biometric Data

```
<https://betterstack.com/community/guides/logging/sensitive-data/>
```

---

Logging too much data can be distracting and a poor use of resources. Indeed, transferring, storing and parsing logs is expensive, so minimizing what the log files contains can minimize cost and resources. Still, logging is king, especially when it comes to traditional monolithic architectures

```
https://www.bmc.com/blogs/monitoring-logging-tracing/
```

---

consider

- Who is using the logs
- Costs
- Logging Level

---

Who cares about this kind of message?

```sh
level=INFO msg=PaymentService - Payment processed successfully for Order #12345
```

---

What's the log level in Production?

{{% fragment %}}
<font color=red>**ERROR**</font>
{{% /fragment %}}
{{% fragment %}}
<font color=brown>**WARN**</font>
{{% /fragment %}}
{{% fragment %}}
<font color=blue>**INFO**</font>
{{% /fragment %}}
{{% fragment %}}
<font color=green>**DEBUG**</font>
{{% /fragment %}}

---

Cloud Cost

<https://cloud.google.com/blog/products/devops-sre/cloud-logging-cost-management-best-practices>

---
