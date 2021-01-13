import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create("CopartLotChannel", {
  connected() {
    console.log("Connected...")
    chatChannel.send({ sent_by: "Paul", body: "This is a cool chat app." })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("Rcvd:" + data.body)
  }
});


