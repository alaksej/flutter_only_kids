import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const firestore = admin.firestore();

const region = 'europe-west1';

export const userExists = functions
  .region(region)
  .https
  .onCall(async (data, context) => {
    const email = data && data.email;
    if (!email) {
      throw new functions.https.HttpsError('invalid-argument',
        `The function must be called with "email" parameter`);
    }

    const usersSnapshot = await firestore.collection('users').where('email', '==', email).get();
    return { userExists: !usersSnapshot.empty };
  });
