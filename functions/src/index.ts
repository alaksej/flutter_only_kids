import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const firestore = admin.firestore();

const region = 'europe-west1';

export const userExists = functions
  .region(region)
  .https
  .onCall(async (data, context) => {
    const email: string | undefined = data && data.email;
    if (!email) {
      throw new functions.https.HttpsError('invalid-argument',
        `The function must be called with "email" parameter`);
    }

    const usersSnapshot = await firestore.collection('users').where('email', '==', email.toLowerCase()).get();
    return !usersSnapshot.empty;
  });

export const onAdminListWrite = functions
  .region(region)
  .firestore
  .document('metadata/admins')
  .onWrite((change, context) => {
    const getEmails = (from: 'before' | 'after') => {
      const data = change[from].data();
      const emails: string[] = (data && data.emails || []);
      const lowerCased = emails.map(email => email.toLowerCase());
      return lowerCased;
    }
    const beforeAdminEmails: string[] = getEmails('before');
    const afterAdminEmails: string[] = getEmails('after');

    const subtract = (fromArray: string[], what: string[]) => fromArray.filter(value => !what.includes(value));
    const emailsToAddToAdmins: string[] = subtract(afterAdminEmails, beforeAdminEmails);
    const emailsToRemoveFromAdmins: string[] = subtract(beforeAdminEmails, afterAdminEmails);

    const auth: admin.auth.Auth = admin.auth();

    const setAdminClaim = async (email: string, isAdmin: boolean) => {
      try {
        const user = await auth.getUserByEmail(email);
        if (user.emailVerified) {
          // Add custom claims for additional privileges.
          // This will be picked up by the user on token refresh or next sign in on new device.
          await auth.setCustomUserClaims(user.uid, { admin: isAdmin });
          console.log(`Claim set for the user: ${email} : admin: ${isAdmin}`)
        }
      } catch (e) {
        console.log(`Error setting claim for the user: ${email}, value: admin: ${isAdmin}`);
      }
    }

    emailsToRemoveFromAdmins.forEach(email => setAdminClaim(email, false));
    emailsToAddToAdmins.forEach(email => setAdminClaim(email, true));
  });
