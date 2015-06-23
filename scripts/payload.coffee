# Description:
#   Payload specific code. All webhooks are secured with jwt queries, feel free
#   to use this code in your own projects. All under the AGPLv3 :grin:
#
# Notes:
#   This package is only meant to be used by #TeamPayload
#
#
# Configuration:
#   process.env.WEBHOOK_SECRET_JWT
#   process.env.WEBHOOK_SECRET_STATIC
#
# Author:
#   amingilani
#
logs = '#logs'
jwt = require 'jsonwebtoken'
jwtSecret = process.env.WEBHOOK_SECRET_JWT
webhooksec = process.env.WEBHOOK_SECRET_STATIC

# Paybot tells us when a new transaction happens
module.exports = (robot) ->
  robot.router.post '/payload/tx', (req, res) ->

    room = logs
    data = req.body
    token = req.query.token
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

    jwt.verify token, jwtSecret, (err, decoded) ->
      if err
        robot.messageRoom logs, "LOL: Some idiot tried forging a *tx*" +
        " webhook. The request IP was #{ip}"
        res.send 'LOL! Idiot. These webhooks are secure.'

      if decoded
        robot.messageRoom room, "Transaction: Recieved #{data.amount} BTC for" +
        " client #{data.client} at #{data.address}"
        res.send 'Done.'

# Paybot tells us when a new lead is generated
module.exports = (robot) ->
  robot.router.post '/leads/notify', (req, res) ->

    room = "#leads"
    data = req.body.payload
    reqsec = req.query.secret
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

    if (reqsec == webhooksec)
      robot.messageRoom room, "*Source:* #{data.source}\n" +
          "*Business:* #{data.business}\n" +
          "*Contact:* #{data.contact}\n" +
          "*Email:* #{data.email}\n" +
          "*Referral:* #{data.ref}\n\n" +
          "*Description:*\n #{data.description}"

      if (reqsec != webhooksec)
        robot.messageRoom logs, "LOL: Some idiot tried forging a *lead*" +
        " webhook. The request IP was #{ip}"
        res.send 'LOL! Idiot. These webhooks are secure.'
