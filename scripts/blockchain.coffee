# Description:
#   lookup BTCaddress - reponds with details for bitcoin addresses
#
# Notes:
#   None
#
# Author:
#   amingilani

module.exports = (robot) ->

  robot.respond /lookup\s([13][a-km-zA-HJ-NP-Z0-9]{26,33})/g, (msg) ->
    address = msg.match[0].split(" ")[2]

    msg.send "Gimme a moment"

    robot.http("https://bitcoin.toshi.io/api/v0/addresses/#{address}")
    .get() (err, res, body) ->

      body = JSON.parse(body)

      if err
        msg.send "Oh snap, I made an error : ( \n
                  #{err}"
        return

      if res.statusCode isnt 200
        msg.send "Weird, I didn't get a good response from https://tosh.io/"
        return

      msg.send "Address: #{address}\n"
      msg.send "Balance: #{body.balance/100000000}|#{(body.balance + body.unconfirmed_balance)/100000000} BTC\n"
      msg.send "Recieved: #{body.received/10000000}|#{(body.received + body.unconfirmed_received)/100000000} BTC\n"
      msg.send "Sent: #{body.sent/100000000}|#{(body.sent + body.unconfirmed_sent)/100000000} BTC\n"
      msg.send "Check it out at https://bitcoin.toshi.io/api/v0/addresses/#{address}"
      return
