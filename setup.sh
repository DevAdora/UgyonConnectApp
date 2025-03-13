#!/bin/bash

echo "🚀 Setting up Ugyon Connect App..."

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Install Node.js dependencies
echo "📦 Installing Node.js backend dependencies..."
cd functions && npm install && cd ..

# Install Firebase CLI
echo "🔧 Setting up Firebase CLI..."
npm install -g firebase-tools
firebase login

echo "✅ Setup Complete!"
