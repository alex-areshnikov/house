// import * as ActionCable from '@rails/actioncable'
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

// ActionCable.logger.enabled = true

const copartLotChannel = consumer.subscriptions.create("CopartLotChannel", {
  connected() {
    console.log("Connected...")
    // copartLotChannel.send({ sent_by: "Paul", body: "This is a cool chat app." })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("Rcvd:" + JSON.stringify(data))
    if(data.client_command === "reload") window.location.reload()
    else copartLotChannel.send(data)
  }
});


