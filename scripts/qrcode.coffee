# Description:
#   Qrcode
#
# Commands:
#   paybot qr <data> - generates the qrcode for given data
#
# Author:
#   amingilani

module.exports = (robot) ->

  fool = [
    "How do you expect me make a code without data, read your mind?",
    "You mean, like making an omelette without eggs?",
    "Do you usually forget stuff, or is this an isolated incident?",
    "You're asking a chicken to fly",
    "ERRAWR, ERRAWR, forgot DATAWR."
    ]

  robot.respond /qr\s(.*)/i, (res) ->
    data = encodeURIComponent res.match[1]
    if !data
      res.reply res.random fool
    else
      res.reply "https://chart.googleapis.com/chart?cht=qr&chs=400x400&chl=" +
      "#{data}"

  robot.error (err, res) ->

    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"
