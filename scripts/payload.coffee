# Description:
#   Payload specific code. All webhooks are secured with jwt queries, feel free
#   to use this code in your own projects. All under the AGPLv3 :grin:
#
# Notes:
#   This package is only meant to be used by #TeamPayload
#
# Author:
#   amingilani
#

jwt = require 'jsonwebtoken'
secret = process.env.WEBHOOK_SECRET

# Paybot tells us when a new transaction happens
module.exports = (robot) ->
  robot.router.post '/payload/tx', (req, res) ->

    room = "#general"
    data = req.body
    token = req.query.token
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

    jwt.verify token, secret, (err, decoded) ->
      if err
        robot.messageRoom room, "LOL: Some idiot tried forging a transaction" +
        " webhook. The request IP was #{ip}"
        res.send 'LOL! Idiot. These webhooks are secure.'

      if decoded
        robot.messageRoom room, "Transaction: Recieved #{data.amount} BTC for" +
        " client #{data.client} at #{data.address}"
        res.send 'Done.'
