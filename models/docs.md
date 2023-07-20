{% docs contact_type %}
[Endpoint](https://api.qualtrics.com/c4c0dbec83622-research-core-to-xm-directory-migration-guide) the contact came from (`directory` vs `core`).
{% enddocs %}

{% docs embedded_data %}
JSON of  Any extra information you would like recorded in addition to the question responses (from the `survey_embedded_data` source table).
{% enddocs %}

{% docs count_published_versions %}
Number of versions that have been published for this survey.
{% enddocs %}

{% docs count_questions %}
Total number of questions (does not include deleted ones) in the survey.
{% enddocs %}

{% docs avg_response_duration_in_seconds %}
On average, how long it took a respondent to finish a survey in seconds.
{% enddocs %}

{% docs avg_survey_progress_pct %}
On average, how far a respondent has progressed through a survey as a percentage out of 100.
{% enddocs %}

{% docs median_response_duration_in_seconds %}
The median of how long it took a respondent to finish a survey in seconds.
{% enddocs %}

{% docs median_survey_progress_pct %}
The median of how far a respondent has progressed through a survey as a percentage out of 100.
{% enddocs %}

{% docs count_survey_responses %}
Total number of survey responses.
{% enddocs %}

{% docs count_completed_survey_responses %}
Total number of _completed_ survey responses (ie `is_finished=true`).
{% enddocs %}

{% docs count_survey_responses_30d %}
Number of survey responses recorded in the past 30 days.
{% enddocs %}

{% docs count_completed_survey_responses_30d %}
Number of _completed_ survey responses recorded in the past 30 days.
{% enddocs %}

{% docs count_anonymous_survey_responses %}
Number of recorded survey responses distributed anonymously.
{% enddocs %}

{% docs count_anonymous_completed_survey_responses %}
Number of _completed_ recorded survey responses distributed anonymously.
{% enddocs %}

{% docs count_social_media_survey_responses %}
Number of recorded survey responses distributed via [social media](https://www.qualtrics.com/support/survey-platform/distributions-module/social-media-distribution/).
{% enddocs %}

{% docs count_social_media_completed_survey_responses %}
Number of _completed_ survey responses distributed via [social media](https://www.qualtrics.com/support/survey-platform/distributions-module/social-media-distribution/).
{% enddocs %}

{% docs count_personal_link_survey_responses %}
Number of recorded survey responses distributed via [personal links](https://www.qualtrics.com/support/survey-platform/distributions-module/email-distribution/personal-links/).
{% enddocs %}

{% docs count_personal_link_completed_survey_responses %}
Number of _completed_ survey responses distributed via [personal links](https://www.qualtrics.com/support/survey-platform/distributions-module/email-distribution/personal-links/).
{% enddocs %}

{% docs count_qr_code_survey_responses %}
Number of recorded survey responses distributed via [QR codes](https://www.qualtrics.com/support/survey-platform/distributions-module/web-distribution/qr-code/).
{% enddocs %}

{% docs count_qr_code_completed_survey_responses %}
Number of _completed_ survey responses distributed via [QR codes](https://www.qualtrics.com/support/survey-platform/distributions-module/web-distribution/qr-code/).
{% enddocs %}

{% docs count_email_survey_responses %}
Number of recorded survey responses distributed via [email](https://www.qualtrics.com/support/survey-platform/distributions-module/email-distribution/emails-overview/).
{% enddocs %}

{% docs count_email_completed_survey_responses %}
Number of _completed_ survey responses distributed via [email](https://www.qualtrics.com/support/survey-platform/distributions-module/email-distribution/emails-overview/).
{% enddocs %}

{% docs count_sms_survey_responses %}
Number of recorded survey responses distributed via [SMS invite](https://www.qualtrics.com/support/survey-platform/distributions-module/mobile-distributions/sms-surveys/).
{% enddocs %}

{% docs count_sms_completed_survey_responses %}
Number of _completed_ survey responses distributed via [SMS invite](https://www.qualtrics.com/support/survey-platform/distributions-module/mobile-distributions/sms-surveys/).
{% enddocs %}

{% docs count_uncategorized_survey_responses %}
Number of recorded survey responses not distributed via the default channels.
{% enddocs %}

{% docs count_uncategorized_completed_survey_responses %}
Number of _completed_ survey responses not distributed via the default channels.
{% enddocs %}

{% docs publisher_email %}
Email of the `USER` who published the latest survey version.
{% enddocs %}

{% docs creator_email %}
Email of the `USER` who created the survey.
{% enddocs %}

{% docs owner_email %}
Email of the `USER` who owns the survey.
{% enddocs %}

{% docs is_xm_directory_contact %}
Boolean representing whether the contact came from the XM Directory API endpoint (ie stored in the `directory_contact` table).
{% enddocs %}

{% docs is_research_core_contact %}
Boolean representing whether the contact came from the (to-be-deprecated) Research Core API endpoint (ie stored in the `core_contact` table).
{% enddocs %}

{% docs mailing_list_ids %}
Comma-separated list of mailing list IDs the record is associated with.
{% enddocs %}

{% docs count_surveys_sent_email %}
Distinct surveys sent to the contact via email invite.
{% enddocs %}

{% docs count_surveys_sent_sms %}
Distinct surveys sent to the contact via SMS invite.
{% enddocs %}

{% docs count_surveys_opened_email %}
Distinct surveys opened by the contact via email invite.
{% enddocs %}

{% docs count_surveys_opened_sms %}
Distinct surveys opened by the contact via SMS invite.
{% enddocs %}

{% docs count_surveys_started_email %}
Distinct surveys started by the contact via email invite.
{% enddocs %}

{% docs count_surveys_started_sms %}
Distinct surveys started by the contact via SMS invite.
{% enddocs %}

{% docs count_surveys_completed_email %}
Distinct surveys completed by the contact via email invite.
{% enddocs %}

{% docs count_surveys_completed_sms %}
Distinct surveys completed by the contact via SMS invite.
{% enddocs %}

{% docs total_count_surveys %}
Total distinct surveys distributed.
{% enddocs %}

{% docs total_count_completed_surveys %}
Total distinct surveys completed.
{% enddocs %}

{% docs last_survey_response_recorded_at %}
The most recent point in time when a survey response was recorded.
{% enddocs %}

{% docs first_survey_response_recorded_at %}
The earliest point in time when a survey response was recorded.
{% enddocs %}

{% docs count_mailing_lists_subscribed_to %}
Count of distinct mailing lists the contact is a member of and has not opted out of.
{% enddocs %}

{% docs count_mailing_lists_unsubscribed_from %}
Count of distinct mailing lists that the contact has opted out of receiving emails through.
{% enddocs %}

{% docs count_distinct_emails %}
Count of distinct email addresses in the directory.
{% enddocs %}

{% docs count_distinct_phones %}
Count of distinct phone numbers (stripped of any non-numeric characters) in the directory.
{% enddocs %}

{% docs total_count_contacts %}
Total number of contacts in the directory.
{% enddocs %}

{% docs total_count_unsubscribed_contacts %}
Total number of contacts who have unsubscribed from the directory.
{% enddocs %}

{% docs count_contacts_created_30d %}
Number of contacts created in the last 30 days (inclusive) in this directory.
{% enddocs %}

{% docs count_contacts_unsubscribed_30d %}
Number of contacts who have opted out of receiving communications through this directory in the last 30 days (inclusive).
{% enddocs %}

{% docs count_contacts_sent_survey_30d %}
Number of contacts in this directory who have been sent a survey in the past 30 days (inclusive).
{% enddocs %}

{% docs count_contacts_opened_survey_30d %}
Number of contacts in this directory who have been sent a survey in the past 30 days (inclusive) and opened it.

{% enddocs %}

{% docs count_contacts_started_survey_30d %}
Number of contacts in this directory who have been sent a survey in the past 30 days (inclusive)and started it.
{% enddocs %}

{% docs count_contacts_completed_survey_30d %}
Number of contacts in this directory who have been sent a survey in the past 30 days (inclusive) and completed it.
{% enddocs %}

{% docs count_surveys_sent_30d %}
Number of _distinct_ surveys sent to contacts in the past 30 days (inclusive).
{% enddocs %}

{% docs count_mailing_lists %}
Number of mailing lists the exist within the directory.
{% enddocs %}
