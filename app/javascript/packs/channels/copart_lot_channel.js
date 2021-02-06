// import * as ActionCable from '@rails/actioncable'
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

// ActionCable.logger.enabled = true

const copartLotChannel = consumer.subscriptions.create("CopartLotChannel", {
  connected() {
    // console.log("Connected...")
    // copartLotChannel.send({ sent_by: "Paul", body: "This is a cool chat app." })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(`${data.lot_id} ${data.status}`)
    if(data.client_command === "reload") window.location.reload()
    // if(data.client_command === "update_lot") $(`#lot-${data.lot_id} .state-field`).text(data.status);
  }
});


