const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const cors = require("cors")({ origin: true });

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "YOUR_GMAIL@gmail.com",
    pass: "YOUR_APP_PASSWORD", // 🔥 Use App Password, NOT your Gmail password
  },
});

exports.sendOtpEmail = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const { email, otp } = req.body;

    if (!email || !otp) {
      return res.status(400).send("Missing required fields");
    }

    const mailOptions = {
      from: "YOUR_GMAIL@gmail.com",
      to: email,
      subject: "Your OTP Verification Code",
      text: `Your OTP code is: ${otp}. It will expire in 5 minutes.`,
      html: `
        <h2>OTP Verification</h2>
        <p>Your OTP code is: <strong>${otp}</strong></p>
        <p>This code will expire in <strong>5 minutes</strong>.</p>
      `,
    };

    try {
      await transporter.sendMail(mailOptions);
      return res.status(200).send("Email sent successfully");
    } catch (error) {
      console.error("Error sending email:", error);
      return res.status(500).send("Failed to send email");
    }
  });
});
