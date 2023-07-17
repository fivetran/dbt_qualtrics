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