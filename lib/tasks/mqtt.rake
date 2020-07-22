namespace :mqtt do
  desc "Listens to holodilnic sensors topic and writes data to database"
  task listen_holodilnic_topic: :environment do
    Holodilnic::MqttListener.new.call

    while true
      # do not exit
      sleep 1 # wait one second
    end
  end
end
