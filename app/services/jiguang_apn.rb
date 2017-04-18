class JiguangApn < Object

  def self.send_notification(tokens,msg,auth_key,link=nil,scheduled=nil)
    # Do something later
    url = URI(" https://api.jpush.cn/v3/push")

    send_object = {
      audience: {registration_id: tokens},
      platform: 'all',notification: {alert: msg,ios: {badge: 1,sound: 'default'},android: {title: 'DiningCity'}}
     apns_production: false
    }

    if link
      send_object[:notification][:ios][:extras]= {my_data: link}
      send_object[:notification][:android][:extras]= {my_data: link}
    end
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["authorization"] =  auth_key
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    request.body =send_object.to_json

    response = http.request(request)
    result = JSON(response.read_body)
    logger.info result
    unless result["meta"]["status"].to_s=='201'
      raise result
    end
  end
end
