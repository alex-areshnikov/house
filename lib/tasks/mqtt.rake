desc "Listens to holodilnic sensors topic and writes data to database"
task :listen_holodilnic_mqtt_topic do
  Holodilnic::MqttListener.new.call

  while true
    # do not exit
    sleep 1 # wait one second
  end
end
