# COVID-19 South Korea

Public line list and summaries of the COVID-19 outbreak in South Korea. Translated and transcribed by Sang Woo Park.

Sources:
* KCDC press release: https://www.cdc.go.kr/board/board.es?mid=a20501000000&bid=0015  
* Official Website of the Seoul Metropolitan City Government: http://news.seoul.go.kr/welfare/archives/513105
* Official Website of the Busan Metropolitan City Government: http://www.busan.go.kr/corona/index.jsp
* Official Blog of Daegu Metropolitan City Government: https://blog.naver.com/daegu_news
* Official Website of the Gwangju Metropolitan City Government: https://www.gwangju.go.kr/
* Official Website of the Ulsan Metropolitan City Government: https://www.ulsan.go.kr
* Official Website of Gyeonggi Province Government: https://gnews.gg.go.kr/news/gongbo_main.do?s_code=S017&b_code=BO01&type_m=main

Contact:
* email: swp2@princeton.edu  
* Twitter: @sang_woo_park

# Spreadsheet

Google sheets: https://docs.google.com/spreadsheets/d/1nKRkOwnGV7RgsMnsYE6l96u4xxl3ZaNiTluPKEPaWm8/edit?usp=sharing

Regional reports: https://docs.google.com/spreadsheets/d/1TqawYd4GRok9NznY9i1xpCjkTwLwk6nd16c_Jwnh1nw/edit?usp=sharing

Last updated at 11:18 PM EST March 10, 2020 

### Sheet 1: Line list

* `case`: case identifier
* `hospital_city`: Hospital location (city)
* `lon`: Hospital location (longitude)
* `lat`: Hospital location (latitude)
* `nationality`: nationality
* `ncontact`: number of contactees
* `nquaratine`: number of contactees that are under quarantine
* `age`: age
* `year_of_birth`: year of birth
* `sex`: sex
* `date_contact_min`: the first date on which a patient could have been infected (e.g., after their infectors were imported, etc.)
* `date_contact_max`: the last date on which a patient could have been infected (e.g., before symptom onset, before self-quarantine, before their infectors were confirmed to be infected, etc.)
* `date_import`: date of import
* `date_onset`: date of symptom onset
* `date_onset_min`: the first date on which a patient could have had onset of symptoms
* `date_onset_min`: the last date on which a patient could have had onset of symptoms
* `date_hospitalized`: date hospitalized
* `date_self_qurantine`: the first date of self-quarantine
* `date_home_before_quarantine`: date on which a patient stayed home all day before they were quarantined; KCDC uses 'stayed home all day' with 'self-quarantine' interchangably in some cases.
* `date_confirm`: date confirmed
* `date_rehospitalized`: date re-hospitalized (case 25 was re-confirmed after being discharged)
* `date_report`: date reported (when date confirmed is unavailable; likely to have been confirmed on the same day or a day before)
* `source`: sources of infection
* `import_source`: sources of importation
* `date_discharged`: date on which a patient is discharched
* `symptoms`: symptoms reported prior to confirmation
* `preexisting_conditions`: preexisting conditions prior to infection
* `KCDC_no`: article number on the KCDC website
* `date_last_accessed`: date on which articles were last accessed and the information was modified
* `youtube`: links to the official press release video with Q&A session; sometimes contains more information than the KCDC website
* `time`: Youtube time stamp

### Sheet 2: Cumulative number of cases based on the daily press release at 4PM

* `date_report`: date reported
* `time_report`: time reported
* `suspected cases`: cumulative number of suspected cases
  * 2020-01-20 - 2020-01-25: anyone who develops fever or respiratory symptoms within 14 days of returning from Wuhan
  * 2020-01-26 - 2020-02-06: anyone who develops pneumonia (based on radiological evidence) within 14 days after returning from China
  * 2020-02-07 - ???:
    * Anyone who develops fever or respiratory symptoms within 14 days of returning from China
    * Anyone who develops fever or respiratory symptoms within 14 days of having a close contact with a confirmed case
    * Anyone suspected of COVID-19 by a clinician based on travel history and clinical symptoms
  * 2020-03-02 - now:
    * Anyone who develops fever or respiratory symptoms within 14 days of returning from countries with COVID-19
    * Anyone who develops fever or respiratory symptoms within 14 days of having a close contact with a confirmed case
    * Anyone who has pneumonia with unknown etiology or is suspected of COVID-19 by a clinician
* `positive`: cumulative number of reported positive cases (different from confirmed cases)
* `negative`: cumulative number of reported negative cases
* `unknown`: number of individuals still under a test
* `KCDC_no`: article number on the KCDC website

### Sheet 3: Reported number of confirmed cases by geographic region (based on 9AM and 4PM press releases)

* Based on the reported regions rather than residential regions; numbers may be subject to change

### Sheet 4: Important dates

* `date`: date
* `event`: event
* `note`: miscellaneous notes
* `KCDC_no`: article number on the KCDC website

### Sheet 5: Cumulative number of cases by age group (based on the official press releases)

### Sheet 6: Confirmed death

### Sheet 7: Discharged

* decided to keep track of them in a separate sheet because case numbers are missing for some of them

### Sheet 8: Community

* Cumulative incidence time series stratified by community (for sufficiently large communities)
