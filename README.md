# QR Reader for Mac

Ever come across a QR code on your MacBook and wished you could scan it directly without reaching for your phone? This app makes that possible.

## Features

- Scan QR codes using your MacBook’s built-in camera
- Keep a searchable history of scanned codes
- Enhanced support for:
  - Website links (open directly in your browser)
  - Contact data in **vCard** format

Future versions may include more data types — contributions are welcome!

## How It Works

Simply launch the app, point your MacBook’s camera at a QR code, and the app will recognize it instantly. Your scans are stored in your history so you can revisit them at any time.

*(A demo video will be added here soon.)*

## Contributing

If you’d like to add support for additional QR code data types:

1. Implement a new `HistoryItemData`
2. Add it to `QRCodeUtils.historyItemDataFromQRCode`
3. Create a view that extends `HistoryItemViewBase`
4. Integrate your view into `HistoryItemView`

We welcome pull requests and improvements from the community.

## Development

To run the project locally:

1. Clone the repository
2. Open the project in **Xcode**
3. Build and run

That’s it — you’re ready to go!
