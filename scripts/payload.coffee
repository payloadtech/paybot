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
#   process.env.GITHUB_WEBHOOK_SECRET
#
# Author:
#   amingilani
#

# all the initial settings
logs = '#logs'
jwt = require 'jsonwebtoken'
jwtSecret = process.env.WEBHOOK_SECRET_JWT
webhookSec = process.env.WEBHOOK_SECRET_STATIC
githubSec = process.env.GITHUB_WEBHOOK_SECRET
crypto = require 'crypto'
bufferEq = require 'buffer-equal-constant-time'

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
    data = req.body
    reqsec = req.query.secret
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

    if (reqsec == webhooksec)
      robot.messageRoom room, "*Source:* #{data.source}\n" +
          "*Business:* #{data.business}\n" +
          "*Contact:* #{data.contact}\n" +
          "*Email:* #{data.email}\n" +
          "*Referral:* #{data.ref}\n" +
          "*Estimated PKR:* #{data.estimate}\n\n" +
          "*Description:*\n#{data.description}"
      res.send 'Done.'

    if (reqsec != webhooksec)
      robot.messageRoom logs, "LOL: Some idiot tried forging a *lead*" +
      " webhook. The request IP was #{ip}"
      res.send 'LOL! Idiot. These webhooks are secure.'

# Github webhooks
  robot.router.post "/github-in", (req, res) ->
    robot.logger.debug req
    ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
    # end if secret is not set
    if !process.env.GITHUB_WEBHOOK_SECRET
      messageRoom "rabbit-testing", "Please set GITHUB_WEBHOOK_SECRET for me" +
      "to secure webhooks"
      return res.end "ok"

    event = req.get('X-Github-Event')
    signature = req.get('X-Hub-Signature')
    payload = req.body
    hookHash = "sha1=" + crypto.createHmac('sha1', githubSec)
    .update(JSON.stringify(payload))
    .digest('hex')
    if bufferEq (new Buffer hookHash), (new Buffer signature)
      robot.emit "gh_#{event}", req.body
      res.end "ok"
    else
      robot.messageRoom logs, "LOL: Some idiot tried forging a *Github*" +
      " webhook. The request IP was #{ip}"
      res.send 'LOL! Idiot. These webhooks are secure.'

  robot.on "gh_pull_request", (data) ->
    robot.messageRoom logs, "#{data.action}: " +
    "#{data.pull_request.title}"

  robot.on "gh_push", (data) ->
    robot.messageRoom logs, ":pencil2: *New commits* in " +
    "#{data.repository.full_name} #{data.ref}\n" +
    "HEAD is now at #{data.head_commit.id.substring(0,8)} " +
    "by #{data.head_commit.author.name} <#{data.head_commit.author.email}>\n" +
    "_#{data.head_commit.message}_"

  robot.on "gh_deployment_status", (data) ->
    if data.deployment_status.state == "pending"
      robot.messageRoom logs, ":sparkles: *Deploying:* " +
      "#{data.repository.full_name} at " +
      "#{data.deployment.sha.substring(0,8)}"

    if data.deployment_status.state == "success"
      robot.messageRoom logs, ":star2: *Deployed:* " +
      "#{data.repository.full_name} at " +
      "#{data.deployment.sha.substring(0,8)}"
