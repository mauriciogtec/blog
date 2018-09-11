+++
title = "Use YAML!"
date = 2018-09-11T14:14:07-05:00
draft = false

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = []
categories = []

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
[header]
image = ""
caption = ""
+++

A common issue when starting a new project involving data is choosing a format in which to store the data.

The answer to the question of course depends on several aspects: the sources, the data types, the purpose, and its relational structure. 

While modern approaches in Big Data endorse the strategy of first extracting high volumes of raw data and worry about processing later; in here we shall be concerned with the opposite case, when data has to be captured manually by a human team, and we don't want to spend hours later trying to make it amenable for the computer to read.

I want to present a basic introduction to the YAML (yet-another-markup-language) approach to keeping data records. It's advantages is that
- it is machine-readable
- it is human-readable
- ergo, human-writable too
- used widely nowadays
- can be transfored to other common data serialization formats such as JSON

For my example I will use Python to 'parse' the YAML format. The idea is to show by example how a file stored in this format is readable by the machine.

Our task is to use YAML to serialize, records of annotated bibliography. Note that there are other forms recording bibliograhy, such bibtex, but I claim that YAML requires much less effort.

## A simple example

Below are the contents of a simple YAML file named `example_record.yaml`. This is a textfile, pretty much like a file ending with `.txt` which you have most likely used before and opened with the Notepad if you are a Windows user. This file can also be opened with the Notepad, but it ends with `.yaml` instead of `.txt`. Note that the colors are not part of the file, but of the display engine we are using here.

```yaml
# filename: example_record.yaml
# description: a simple yaml for annotated bibliography
key: "1,000Days_2018_What_We're_Watching_in_Congress" 
added_by: "John Doe"
title: "Congress is Back in Session: Here's What We're Watching"
author:  "1,000 Days"
publisher: "https://thousanddays.org/congress-is-back-in-session-heres-what-were-watching/"
publisher_type: "website" 
date: 2018-06-05 
accessed: 2018-09-08
keywords: 
  - "Congress"
  - "Farm Bill"
  - "Supplemental Nutrition Assistance Program"
  - "SNAP"
  - "The Special Supplemental Nutrition Program for Women"
  - "Infants and Children"
  - "WIC, 2020-2025 Dietary Guidelines for Americans"
  - "DGAs, Maternal Mortality"
  - "Children’s Health Insurance Program"
  - "CHIP, Medicaid"
  - "public charge"
summary: |
  This webpage produced by the advocacy group 1,000 Days provides a summary of Congressional items that the group is keeping an eye on during the summer of 2018. These items are:
  1)     Changes to SNAP in the Farm Bill
  a.    House of Representatives put forth a Farm Bill with significant reduction to SNAP that would reduce food security for low-income families in the US. The Senate has a more balanced bill that is set to be marked up on June 13
  2)     Funding for WIC
  a.    WIC is funded through the annual appropriation process. Both House and Senate appropriation bills include less FY19 WIC funding than FY18. Breastfeeding peer counselor funding in both bills remains at $60 million. 
  3)     New Dietary Guidelines
  a.    House and Senate support funding of $12.3 million to USDA to develop DGAs. 
  4)     Maternal Mortality Legislation
  a.    Both House and Senate have members who are introducing legislation on addressing high rates of maternal mortality in the US. The legislation will also focus on racial and ethnic disparities in maternal mortality rates in the US.
  5)     Proposed Cuts to CHIP
  a.    Trump has threatened to rescind $7 billion of funding to CHIP that was signed into law and passed by both the Senate and House. 
  6)     Threats to Immigrant Families
  a.    Public Charge, a proposed Dept. of Homeland Security rule that would limit immigrant access to benefits such as WIC and Medicaid is currently pending review.
  advocacy_facts: |
  In 2013, Congress mandated that the United States Department of Agriculture (USDA) and the United States Department of Health and Human Services (HHS) include pregnant women and young children as part of the 2020-2025 Dietary Guidelines for Americans (DGAs). The updated DGAs will inform federal nutrition programs that reach young children and their families, as well as serve as an important reference point for physicians, nutrition counselors, early childcare providers, among others.  – 1,000 Days
additional_sources: 
  - 'https://thousanddays.org/draft-house-farm-bill-will-harm-families-and-children/'
```

We now show Python code that reads the above file


```python
import yaml # library for YAML support in python
```


```python
with open("example.yaml", "r") as file:
    record = yaml.load(file)
```


```python
print(record['title'])
```

    Congress is Back in Session: Here's What We're Watching
    


```python
print(record['keywords'])
```

    ['Congress', 'Farm Bill', 'Supplemental Nutrition Assistance Program', 'SNAP', 'The Special Supplemental Nutrition Program for Women', 'Infants and Children', 'WIC, 2020-2025 Dietary Guidelines for Americans', 'DGAs, Maternal Mortality', 'Childrenâ€™s Health Insurance Program', 'CHIP, Medicaid', 'public charge']
    


```python
print(record['summary'])
```

    This webpage produced by the advocacy group 1,000 Days provides a summary of Congressional items that the group is keeping an eye on during the summer of 2018. These items are:
    1)     Changes to SNAP in the Farm Bill
    a.    House of Representatives put forth a Farm Bill with significant reduction to SNAP that would reduce food security for low-income families in the US. The Senate has a more balanced bill that is set to be marked up on June 13
    2)     Funding for WIC
    a.    WIC is funded through the annual appropriation process. Both House and Senate appropriation bills include less FY19 WIC funding than FY18. Breastfeeding peer counselor funding in both bills remains at $60 million. 
    3)     New Dietary Guidelines
    a.    House and Senate support funding of $12.3 million to USDA to develop DGAs. 
    4)     Maternal Mortality Legislation
    a.    Both House and Senate have members who are introducing legislation on addressing high rates of maternal mortality in the US. The legislation will also focus on racial and ethnic disparities in maternal mortality rates in the US.
    5)     Proposed Cuts to CHIP
    a.    Trump has threatened to rescind $7 billion of funding to CHIP that was signed into law and passed by both the Senate and House. 
    6)     Threats to Immigrant Families
    a.    Public Charge, a proposed Dept. of Homeland Security rule that would limit immigrant access to benefits such as WIC and Medicaid is currently pending review.
    advocacy_facts: |
    In 2013, Congress mandated that the United States Department of Agriculture (USDA) and the United States Department of Health and Human Services (HHS) include pregnant women and young children as part of the 2020-2025 Dietary Guidelines for Americans (DGAs). The updated DGAs will inform federal nutrition programs that reach young children and their families, as well as serve as an important reference point for physicians, nutrition counselors, early childcare providers, among others.  â€“ 1,000 Days
    
    


```python
record['date']
```




    datetime.date(2018, 6, 5)




```python
record['date'].year
```




    2018



## How does it work?

There are the things that can be input in a YAML:
- "*key: value*" pairs
- *lists*: denoted with brackets `[x1, x2, ..., xn]` or with indented dashes as `keywords` in the previous example.
- *value* can be atomic such as strings, numbers or dates, or it can be a list of these atomic elements, or even a list of "key: value" pairs

When a computer program such as Python reads YAML it maps each value to the correct type.

**Important note about keys**: A good citizenship practice is too **NEVER**:
- start with symbols or numbers
- include white spaces

```yaml
# filename: example2.yml
# description: example for data types
# comments are indicated  with pounds and ignored by compiler
anumber: 2
anothernumber: 3.1416
astring: "hello, world!"
anotherstring: noproblemhere # if there aren't spaces it works without quotation marks
adate: 2018-09-11 # yyyy-mm-dd best format!
alist:
  - these
  - is
  - a
  - list
  - with 
  - name
anotherlist = ['can', 'use', 'brackets']
adict: # watch the indentation!
  key1: value1
  key2: value2
  key3:
    - value31
    - value32
```


```python
with open("example2.yaml", "r") as file:
    record2 = yaml.load(file)
```


```python
display(record2)
```


    {'anumber': 2,
     'anothernumber': 3.1416,
     'astring': 'hello, world!',
     'anotherstring': 'noproblemhere',
     'adate': datetime.date(2018, 9, 11),
     'alist': ['these', 'is', 'a', 'list', 'with', 'name'],
     'anotherlist': ['can', 'use', 'brackets'],
     'adict': {'key1': 'value1', 'key2': 'value2', 'key3': ['value31', 'value32']}}


Let's the data types that Python assigns to the read objects.


```python
for key, val in record2.items():
    print(key, "has data type: ", type(val))
```

    anumber has data type:  <class 'int'>
    anothernumber has data type:  <class 'float'>
    astring has data type:  <class 'str'>
    anotherstring has data type:  <class 'str'>
    adate has data type:  <class 'datetime.date'>
    alist has data type:  <class 'list'>
    anotherlist has data type:  <class 'list'>
    adict has data type:  <class 'dict'>
    

## Long texts

There are two ways to deal with long texts. Collapsing lines, when the text is really a long line or paragraph', or respecting format. Here'a an example.

```yaml
# filename: example3.yml
# description: long strings
include_newlines: |
  exactly as you see
  will appear these three
  lines of poetry
fold_newlines: >
  this is really a
  single line of text
  despite appearances
```


```python
with open("example3.yaml", "r") as file:
    longstrings = yaml.load(file)
```


```python
print(longstrings['include_newlines'])
```

    exactly as you see
    will appear these three
    lines of poetry
    
    


```python
print(longstrings['fold_newlines'])
```

    this is really a single line of text despite appearances
    

### More than one record per file

For some applications it can be useufl to have one big file for different records. That's no problem for YAML. Just separate them with `---` lines.

```yaml
# filename: example4.yml
# description: a multi-record YAML
---
# starts record 1
key11: value11
key12: value12
---
# starts record 2
key21: value21
key22: value22
# no need to add ---- again
```


```python
with open("example4.yaml", "r") as file:
    multirecords = yaml.load_all(file)
    for i, record in enumerate(multirecords):
        print("This is record", i + 1)
        display(record)
```

    This is record 1
    


    {'key11': 'value11', 'key12': 'value12'}


    This is record 2
    


    {'key21': 'value21', 'key22': 'value22'}

