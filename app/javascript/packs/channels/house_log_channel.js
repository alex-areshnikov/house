// import * as ActionCable from '@rails/actioncable'
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

const houseLogChannel = consumer.subscriptions.create("HouseLogChannel", {
  connected() {
    // console.log("Connected...")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $("#logs-container").prepend(data)
  }
});


