module.exports = (robot)->
  robot.respond /checkin(\s(.*)|.*?)/i, (res) ->
    data = encodeURIComponent res.match[1]
    date = new Date();
    if !data
      #check in current user
      robot.brain.set res.message.user.name+'InDate',[date.getDate(), (date.getMonth() + 1), date.getFullYear()]
      robot.brain.set res.message.user.name+'InTime', [date.getHours()+5, date.getMinutes(), date.getSeconds()]
      res.send res.message.user.name+" checked in at "+robot.brain.get res.message.user.name+'InTime'
      
    else
      #check in the name of user specified
        robot.brain.set data+'InDate',[date.getDate(), (date.getMonth() + 1), date.getFullYear()]
        robot.brain.set data+'InTime', [date.getHours()+5, date.getMinutes(), date.getSeconds()]
      #[date.getFullYear(), (date.getMonth() + 1), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()]
        res.send data+" checked in at "+robot.brain.get data+'InDate'
       

    robot.respond /view(\s(.*)|.*?)/i, (res) ->
        data1 = robot.brain.get res.message.user.name+'InTime'
        data2 = robot.brain.get res.message.user.name+'InDate'
        res.reply data1+" on "+data2
