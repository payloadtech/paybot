###
module.exports = (robot)->
  today = new Date
  if today.getHours() == 10
    if today.getMinutes() == 0 and today.getSeconds ==0
      robot.hear /./g ,(res) ->
        res.send "its 10 pm , stop working"
      ###

module.exports = (robot) ->
      cronJob = require('cron').CronJob
      tz = 'Pakistan/Islamabad'
      new cronJob('0 0 20 * * *', atTen, null, true, tz)           #fires at 10 pm everyday

      room = 'general'

      atTen = ->
         robot.messageRoom room, 'its 10 pm'
