const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('chats/{chatId}/messages/{messageId}') //??
    .onCreate((snap, context) => {
        console.log('-----sending notification------');

        const doc = snap.data();

        //doc should be of type MessageDto
        console.log(doc);

        const senderId = doc.uid1;
        const receiverId = doc.uid2;
        const contentMessage = doc.text;

        admin
            .firestore()
            .collection('users')
            .where('uid', '==', receiverId)
            .get()
            .then((snapshot) => {
                if (!snapshot.empty) {
                    var user = snaphot.first.data();

                    //todo: query db to find info about sender

                    if (user.pushToken != null) {

                        const payload = {
                            notification: {
                                title: `You have a new message from "${senderId}"`,
                                body: contentMessage,
                                badge: '1',
                                sound: 'default'
                            }
                        };

                        admin.messaging()
                            .sendToDevice(user.pushToken, payload)
                            .then(response => {
                                console.log('Successfully sent message:', response);
                            })
                            .catch(error => {
                                console.log('Error sending message:', error);
                            });
                    }
                    else {
                        console.log('Can not find pushToken target user');
                    }
                }
                else {
                    console.log('Can not find user');
                }
            });
        return null;
    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
