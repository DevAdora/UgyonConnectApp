// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCAGmw-D0ZPUkJajzooumqu0aMl1cAt6_0",
  authDomain: "ugyonconnectapp.firebaseapp.com",
  databaseURL: "https://ugyonconnectapp-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "ugyonconnectapp",
  storageBucket: "ugyonconnectapp.firebasestorage.app",
  messagingSenderId: "206650662788",
  appId: "1:206650662788:web:f7c11d87269db0190c07d1",
  measurementId: "G-C3MRFR8FYR"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);