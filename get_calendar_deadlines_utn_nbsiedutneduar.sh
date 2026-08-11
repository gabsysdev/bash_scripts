#!/bin/bash 
# Get the whole moodle calendar of events from assignments at the utn nb.sied.utn.edu.ar page.
# sesskey= & MoodleSession=  ($SESSKEY and $MOODLEKEY) from inspect>network>service as cURL when clicking "Mis materias" 

curl "https://nb.sied.utn.edu.ar/lib/ajax/service.php?sesskey=$SESSKEY&info=core_calendar_get_action_events_by_timesort" \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Content-Type: application/json' \
  -b "MoodleSession=$MOODLEKEY" \
  --data-raw '[{"index":0,"methodname":"core_calendar_get_action_events_by_timesort","args":{"timesortfrom":0,"limitnum":20,"limittononsuspendedevents":true}}]' > assessed

# All the info:
#cat assessed | jq '.[].data.events[]' | jq 'del(.course.courseimage)' | jq '[.course.id, .course.fullname, .name, .description, .activityname]'
# No courseimage fuzz:
# cat assessed | jq '.[].data.events[]' | jq 'del(.course.courseimage)'

# Grouped by .course.id:
#cat assessed | jq '  [.[].data.events[]]  | group_by(.course.id)  | map({  course_id: .[0].course.id, course_name: .[0].course.fullname, events: map({name, activityname, description}) })'

# Grouped and clean of html labels:
cat assessed | jq '  [.[].data.events[]]  | group_by(.course.id)  | map({  course_id: .[0].course.id, course_name: .[0].course.fullname, events: map({name, activityname, description: ( .description | gsub("<[^>]+>"; " ") | gsub("\r\n|\r"; "\n") | gsub("[ \t]+"; " ") | gsub("\n[ ]*"; "\n") | gsub("\n{3,}"; "\n\n") | ltrimstr(" ") | rtrimstr(" "))}) })'
