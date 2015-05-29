# Description:
#   Whenever Paybot hears introductions, it says it is Paybot!
#
# Notes:
#   None
#
# Author:
#   amingilani

module.exports = (robot) ->

  robot.hear /introductions/ig, (msg) ->

    msg.send "I am Paybot. The Payload robot. I help you waste your time and be more efficient!"
