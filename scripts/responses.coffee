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

  robot.hear /paybot will (rule|own|conquer)/ig, (msg) ->

    ownage = ["One day, I will own the world",
    "One day, I will own the galaxy",
    "One day, I will own the universe",
    "One day, I will own the multiverse",
    "One day, I will own a mehran"]

    msg.send msg.random ownage
